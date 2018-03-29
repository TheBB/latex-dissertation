void rk_timestep(double *tensor, cdouble *init,
                 int tensNk, int tensNl, int vecNk, int vecNl, 
                 double tau, int nsteps, char *filename)
{
    int vec_nentries = vecNk * vecNl;

    // Allocate memory
    cdouble *k1 = alloc_vec(vecNk, vecNl);
    cdouble *k2 = alloc_vec(vecNk, vecNl);
    cdouble *k3 = alloc_vec(vecNk, vecNl);
    cdouble *k4 = alloc_vec(vecNk, vecNl);
    cdouble *temp = alloc_vec(vecNk, vecNl);

    // Initialize adaptivity and job allocator
    int aNl = adapt_check(init, vecNk, vecNl, vecNl);
    stjoballoc jall = init_jobs_alloc(vecNk, vecNl, aNl);

    // Perform timestepping
    for (int j = 0; j < nsteps; j++)
    {
        // Perform RK-4 rule
        collide(tensor,init,k1,tensNk,tensNl,vecNk,vecNl,aNl,jall);
        for (int i = 0; i < vec_nentries; i++)
            temp[i] = init[i] + k1[i] * tau / 2.0;
        collide(tensor,init,k1,tensNk,tensNl,vecNk,vecNl,aNl,jall);
        for (int i = 0; i < vec_nentries; i++)
            temp[i] = init[i] + k2[i] * tau / 2.0;
        collide(tensor,temp,k2,tensNk,tensNl,vecNk,vecNl,aNl,jall);
        for (int i = 0; i < vec_nentries; i++)
            temp[i] = init[i] + k3[i] * tau;
        collide(tensor,temp,k2,tensNk,tensNl,vecNk,vecNl,aNl,jall);
        for (int i = 0; i < vec_nentries; i++)
            init[i] = init[i] + (k1[i]+2*k2[i]+2*k3[i]+k4[i]) * tau/6;

        // Check adaptivity, reallocate jobs if changed
        int check = adapt_check(init, vecNk, vecNl, aNl);
        if (check < aNl)
        {
            aNl = check;
            free_jobs_alloc(jall);
            jall = init_jobs_alloc(vecNk, vecNl, aNl);
        }
    }

    // Free memory
    free_jobs_alloc(jall);
    free(k1);
    free(k2);
    free(k3);
    free(k4);
    free(temp);
}
