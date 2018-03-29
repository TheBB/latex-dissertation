int adapt_check(cdouble *vec, int vecNk, int vecNl, int aNl)
{
    while (aNl > 2)
    {
        // Check the coefficients for most extreme l-values
        for (int k = 0; k < vecNk; k++)
        {
            // If any of them are above the threshold, return immediately
            if (abs(vec[vector_index(k,aNl/2-1,vecNl)]) > THRESHOLD)
                return aNl;
            if (abs(vec[vector_index(k,vecNl-aNl/2,vecNl)]) > THRESHOLD)
                return aNl;
        }

        // All entries were below threshold, reduce coefficient set
        aNl -= 2;
    }

    // aNl <= 2
    return aNl;
}
