double inner(double vdiff, double vsum, stquad quad, 
             int k, int q, int Nl)
{
    double sum = 0.0;

    // Construct points on the circle for integration
    cdouble *pts = (cdouble *) malloc(quad.npts_ang * sizeof(cdouble));
    for (int i = 0; i < quad.npts_ang; i++)
        pts[i] = (vsum + vdiff * exp(cdouble(0,1) * quad.pts_ang[i]))/2;

    // Allocate temporary arrays needed by evaluate_bfun
    cdouble *tempa = (cdouble*) malloc(quad.npts_ang * sizeof(cdouble));
    cdouble *tempb = (cdouble*) malloc(quad.npts_ang * sizeof(cdouble));
    cdouble *fval  = (cdouble*) malloc(quad.npts_ang * sizeof(cdouble));

    // Evaluate
#ifdef BASIS2
    evaluate_bfun(k, q, Nl, pts, fval, tempa, tempb,
                  quad.npts_ang, true);
#else
    evaluate_bfun(k, q, Nl, pts, fval, tempa, tempb,
                  quad.npts_ang, false);
#endif

    // Sum according to quadrature rule
    for (int i = 0; i < quad.npts_ang; i++)
        sum += real(fval[i]) * quad.wts_ang[i];

    // Free allocated memory
    free(pts);
    free(tempa);
    free(tempb);
    free(fval);

    return sum;
}
