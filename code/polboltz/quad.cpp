struct quad
{
    int npts_rad, npts_ang, npts;
    double *pts_rad, *wts_rad;
    double *pts_ang, *wts_ang;
    cdouble *pts;
    double *wts;
};
typedef struct quad stquad;

void init_quad_radial(double *pts, double *wts, int npts)
{
    // Load an npts-point Gauss-Laguerre quadrature into the
    // arrays pts and wts here, using whichever method preferable.

    // Transform the rule
    for (int i = 0; i < npts; i++)
    {
#ifdef BASIS2
        pts[i] = sqrt(2*pts[i]);
#else
        pts[i] = sqrt(pts[i]);
        wts[i] = wts[i] / 2;
#endif
    }
}

void init_quad_angular(double *pts, double *wts, int npts)
{
    for (int i = 0; i < npts; i++)
    {
        pts[i] = i * 2 * M_PI / npts;
        wts[i] = 2 * M_PI / npts;
    }
}

stquad init_quad(int npts)
{
    stquad quad;

    quad.npts_rad = npts;
    quad.npts_ang = npts;
    quad.npts = npts * npts;

    // Radial direction
    quad.pts_rad = (double *) malloc(npts * sizeof(double));
    quad.wts_rad = (double *) malloc(npts * sizeof(double));
    init_quad_radial(quad.pts_rad, quad.wts_rad, npts);

    // Angular direction
    quad.pts_ang = (double *) malloc(npts * sizeof(double));
    quad.wts_ang = (double *) malloc(npts * sizeof(double));
    init_quad_angular(quad.pts_ang, quad.wts_ang, npts);

    // Product
    quad.pts = (cdouble *) malloc(npts * npts * sizeof(cdouble));
    quad.wts = (double *) malloc(npts * npts * sizeof(double));

    int j = 0;
    for (int k = 0; k < npts; k++)
        for (int l = 0; l < npts; l++)
        {
            quad.pts[j] = quad.pts_rad[k] * 
                          exp(quad.pts_ang[l] * cdouble(0,1));
            quad.wts[j] = quad.wts_rad[k] * quad.wts_ang[l];
            j++;
        }

    return quad;
}
