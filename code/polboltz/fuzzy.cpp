// Inverse accuracy of fuzzy float matching
#define FUZZY 1000000

// Pair of doubles, with a less than operator so it can be
// used in a std::map. The comparison is fuzzy, with accuracy 
// given by FUZZY.
struct fuzzyfloatpair
{
    double vadiff, vasum;

    bool operator<(const fuzzyfloatpair &ffp) const
    {
        int mydiff = rint(FUZZY * this->vadiff);
        int otdiff = rint(FUZZY * ffp.vadiff);
        return (mydiff < otdiff) || ((mydiff == otdiff) &&
                rint(FUZZY * this->vasum) < rint(FUZZY * ffp.vasum));
    }
};
typedef struct fuzzyfloatpair stfuzzy;
typedef map<stfuzzy, double> fuzzymap;
