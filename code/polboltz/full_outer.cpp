void full_outer(stquad quad, double *tensor, int k, int q,
                int Nk, int Nl, int oldNk, int oldNl)
{
    // Allocate and compute inner integral
    cdouble **inner_mx = (cdouble**) malloc(sizeof(cdouble*)*quad.npts);
    for (int i = 0; i < quad.npts; i++)
        inner_mx[i] = (cdouble *) malloc(sizeof(cdouble)*quad.npts);
    full_inner(quad, k, l, Nl, inner_mx);

    // Allocate temporary arrays
    cdouble *tempa = (cdouble *) malloc(quad.npts * sizeof(cdouble));
    cdouble *tempb = (cdouble *) malloc(quad.npts * sizeof(cdouble));
    cdouble *left  = (cdouble *) malloc(quad.npts * sizeof(cdouble));
    cdouble *right = (cdouble *) malloc(quad.npts * sizeof(cdouble));

    // Iteration bounds
    int l = q_to_l(k, q, Nl);
    int l1_min = max(-Nl, l-Nl+1);
    int l1_max = min(Nl-1, l+Nl);

    // Iterate over all l1
    for (int l1 = l1_min; l1 <= l1_max; l1++)
    {
        int l2 = l - l1; // l = l1 + l2 always!

        // Iterate over all k1, ensure parity condition is satisfied
        for (int k1 = (l1+Nl) % 2; k1 < Nk; k1 += 2)
        {
            // Initialize k2, ensure parity condition is satisfied
            // Only iterate from k2 >= k1 (symmetry)
            int k2 = k1;
            if ((k2 + l2 + Nl) % 2 == 1)
                k2++;

            // Iterate over all k2
            for (; k2 < Nk; k2 += 2)
            {
                // Check if this value falls within
                // the new part of the tensor
                if (oldNk < 0 || oldNl < 0 ||
                         k1 >= oldNk ||      k2 >= oldNk || k >= oldNk ||
                         l1 < -oldNl ||      l1 >= oldNl ||
                         l2 < -oldNl ||      l2 >= oldNl ||
                    l1 + l2 < -oldNl || l1 + l2 >= oldNl)
                {
                    // Store the value (note symmetry in k1 and k2)
                    int ind1 = tensor_index(k1, k2, l_to_q(k1,l1,Nl),
                                            l_to_q(k2,l2,Nl), k, Nk, Nl);
                    int ind2 = tensor_index(k2, k1, l_to_q(k2,l2,Nl), 
                                            l_to_q(k1,l1,Nl), k, Nk, Nl);

                    tensor[ind1] = outer(quad, inner_mx, k1, k2, 
                                         l_to_q(k1,l1,Nl),
                                         l_to_q(k2,l2,Nl),
                                         Nl, tempa, tempb, left, right);
                    tensor[ind2] = tensor[ind1];
                }
            }
        }
    }

    // Free memory
    free(tempa);
    free(tempb);
    free(left);
    free(right);

    for (int i = 0; i < quad.npts; i++)
        free(inner_mx[i]);
    free(inner_mx);
}
