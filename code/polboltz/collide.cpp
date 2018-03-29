void collide(double *tensor, cdouble *vec, cdouble *out,
             int tensNk, int tensNl, int vecNk, int vecNl,
             int aNl, stjoballoc jall)
{
    // Initialize output vector
    for (int k = 0; k < vecNk; k++)
    for (int l = 0; l < vecNl; l++)
        out[vector_index(k,l,vecNl)] = cdouble(0,0);

    // Declare all the necessary variables
    int tid, j, k1, k2, l1, l2, q1, q2, k, l, q, l1mn, l1mx;
    int tidx_v, tidx_v1, tidx_v2, tidx_t;

    // Parallell section
    #pragma omp parallel private(tid,j,k1,k2,l1,l2,q1,q2,
                                 k,l,q,q1mn,q1mx) 
                         shared(tensor,vec,out,jall,tensNk,tensNl,
                                vecNk,vecNl,aNl)
    {
        // Get thread ID
        tid = omp_get_thread_num();

        // Loop through all jobs associated with this thread
        for (j = jall.start[tid]; j < jall.end[tid]; j++)
        {
            k = jall.jobs[j].first;
            q = jall.jobs[j].second;
            l = q_to_l(k, q, vecNl);

            // Compute bounds
            l1mn = max(-aNl, l-aNl+1);
            l1mx = min(aNl-1, l+aNl);

            // Loop over all l1
            for (l1 = l1mn; l1 <= l1mx; l1++)
            {
                l2 = l - l1; // l1 + l2 = l always!

                // Loop over all k1
                for (int k1 = (l1+tensNl) % 2; k1 < vecNk; k1 += 2)
                    // Loop over all k2
                    for (int k2 = (l2+tensNl) % 2; k2 < vecNk; k2 += 2)
                    {
                        tidx_v = vector_index(k,q,vecNl);
                        tidx_v1 = 
                            vector_index(k1,l_to_q(k1,l1,vecNl),vecNl);
                        tidx_v2 =
                            vector_index(k2,l_to_q(k2,l2,vecNl),vecNl);
                        tidx_t = 
                            tensor_index(k1,k2,
                                         l_to_q(k1,l1,tensNl),
                                         l_to_q(k2,l2,tensNl),
                                         k,tensNk,tensNl);
                        out[tidx_v] += vec[tidx_v1] *
                                       vec[tidx_v2] *
                                       tensor[tidx_t];
                    }
            }
        }
    }
}
