void add_loss(double *tensor, int Nk, int Nl)
{
#ifdef BASIS2
    for (int k1 = 0; k1 < Nk; k1++)
    {
        int sgn = 1;
        for (int k2 = 0; k2 < Nk; k2 += 2)
        {
            for (int l1 = 0; l1 < Nl; l1++)
                tensor[tensor_index(k1, k2, l1, 0, k1, Nk, Nl)] -=
                        sgn * 2 * M_PI;
            sgn = -sgn;
        }
    }
#else
    for (int k = 0; k < Nk; k++)
        for (int l = 0; l < Nl; l++)
            tensor[tensor_index(k, 0, l, 0, k, Nk, Nl)] -= M_PI;
#endif
}
