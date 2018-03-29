void compute(double *tensor, int Nk, int Nl, 
             int oldNk, int oldNl, int npts)
{
    // Initialize quadrature and job allocation
    stquad quad = init_quad(npts);
    stjobqueue jall = init_jobs_queue(Nk, Nl, Nl);

    // Initialize other variables needed in the parallell section
    int tid, j; // Thread ID and current job
    omp_lock_t write_lock; // Lock for modifying jall
    omp_init_lock(&write_lock);

    // Parallell section
    #pragma omp parallel private(tid, j) 
                         shared(quad, tensor, jall, Nk, Nl,
                                write_lock, prevlen)
    {
        // Get thread ID
        tid = omp_get_thread_num();

        while (true)
        {
            // Check if there are any more jobs
            if (jall.next >= jall.njobs)
                break;

            // Claim the next job
            omp_set_lock(&write_lock);
            j = jall.next;
            jall.next += 1;
            omp_unset_lock(&write_lock);

            // Perform it
            full_outer(quad, tensor, 
                       jall.jobs[j].first, jall.jobs[j].second,
                       Nk, Nl, oldNk, oldNl);
        }
    }

    // Clean up
    omp_destroy_lock(&write_lock);
}
