double outer(stquad quad, cdouble **inner_mx,
             int k1, int k2, int q1, int q2,
             int Nl, cdouble *tempa, cdouble *tempb,
             cdouble *left, cdouble *right)
{
    // Evaluate the integrands over v and v_*
    evaluate_bfun(k1, q1, Nl, quad.pts, left,
                  tempa, tempb, quad.npts, false);
    evaluate_bfun(k2, q2, Nl, quad.pts, right,
                  tempa, tempb, quad.npts, false);

    // Premultiply with quadrature weights
    for (int i = 0; i < quad.npts; i++)
    {
        left[i] *= quad.wts[i];
        right[i] *= quad.wts[i];
    }

    // Integrate
    cdouble sum = 0.0;
    for (int i = 0; i < quad.npts; i++)
        for (int j = 0; j < quad.npts; j++)
            sum += left[i] * right[j] * inner_mx[i][j];

    return real(sum) / 2.0 / M_PI / M_PI;
}
