void evaluate_bfun(int k, int q, int Nl, cdouble *pts, cdouble *out, 
                   cdouble *tempa, cdouble *tempb, 
                   int npts, bool apply_weight)
{
    // Evaluate Laguerre polynomial (symmetric or antisymmetric)
    if (k % 2 == 0)
        laguerre_evaluate_zero(k/2, pts, out, tempa, npts);
    else
    {
        laguerre_evaluate_one((k-1)/2, pts, out, tempa, tempb, npts);
        for (int i = 0; i < npts; i++)
            out[i] *= abs(pts[i]);
    }

    // Get the angular index and apply it
    int l = q_to_l(k, q, Nl);
    for (int i = 0; i < npts; i++)
        out[i] *= exp(-arg(pts[i]) * l * cdouble(0,1));

    // Multiply by exponential weight if needed
    if (apply_weight)
        for (int i = 0; i < npts; i++)
#ifdef BASIS2
            out[i] *= exp(-0.5*abs(pts[i])*abs(pts[i]));
#else
            out[i] *= exp(-abs(pts[i])*abs(pts[i]));
#endif

    // Apply normalization 1/sqrt(k+1) if antisymmetric
    if (k % 2 == 1)
    {
        double r = sqrt(2.0/(k+1));
        for (int i = 0; i < npts; i++)
            out[i] *= r;
    }
}
