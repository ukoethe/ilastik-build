// emulate some C99 functions that are missing in MSVC in terms of their C++ equivalents

#include <complex>
#include <cmath>

typedef struct { float re, im; }  fcomplex;
typedef struct { double re, im; } dcomplex;
typedef std::complex<float>       fc;
typedef std::complex<double>      dc;

extern "C" {

#ifdef TESTING
# define NAME(n) n##_  // change function name so that we can compare with their real C99 counterparts
#else
# define NAME(n) n
#endif

double NAME(trunc)( double t )
{
     return t >= 0.0
                ? std::floor(t + 0.5)
                : std::ceil(t - 0.5);
}

long NAME(lround)( double t )
{
     return t >= 0.0
                ? (long)std::floor(t + 0.5)
                : (long)std::ceil(t - 0.5);
}

float NAME(cabsf)(fcomplex x)
{
    return std::abs((fc const &)x);
}

fcomplex NAME(csqrtf)(fcomplex x)
{
    return *(fcomplex const *)&std::sqrt((fc const &)x);
}

dcomplex NAME(csqrt)(dcomplex x)
{
    return *(dcomplex const *)&std::sqrt((dc const &)x);
}

dcomplex NAME(cexp)(dcomplex x)
{
    return *(dcomplex const *)&std::exp((dc const &)x);
}

dcomplex NAME(clog)(dcomplex x)
{
    return *(dcomplex const *)&std::log((dc const &)x);
}

dcomplex NAME(ccos)(dcomplex x)
{
    return *(dcomplex const *)&std::cos((dc const &)x);
}

dcomplex NAME(csin)(dcomplex x)
{
    return *(dcomplex const *)&std::sin((dc const &)x);
}

dcomplex NAME(cpow)(dcomplex x, dcomplex y)
{
    return *(dcomplex const *)&std::pow((dc const &)x,(dc const &)y);
}

}
