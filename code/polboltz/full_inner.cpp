void full_inner(stquad quad, int k, int q, int Nl, cdouble **inner_mx)
{
    fuzzymap map;

    // Loop over all pairs of points
    for (int i = 0; i < quad.npts; i++)
    {
        for (int j = 0; j < quad.npts; j++)
        {
            // Build a fuzzy key with the sum and difference
            stfuzzy key;
            key.vadiff = abs(quad.pts[i] - quad.pts[j]);
            cdouble vsum = quad.pts[i] + quad.pts[j];
            key.vasum = abs(vsum);

            // After we have found the integral, we have to multiply
            // with this quantity, to compensate for the transformation
            cdouble adjust = exp(arg(vsum) * 
                             q_to_l(k,q,Nl) * cdouble(0,1));

            if (map.find(key) == map.end())
            {
                // Not found, call inner and save the result
                double eval = inner(key.vadiff, key.vasum,
                                    quad, k, q, Nl);
                map[key] = eval;
                inner_mx[i][j] = adjust * eval;
            }
            else
                // Found, use the tabulated entry
                inner_mx[i][j] = adjust * map[key];
        }
    }
}
