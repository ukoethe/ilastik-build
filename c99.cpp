#include <stdexcept>
#include <complex>
#include <cmath>

typedef struct { float re, im; }  fcomplex;
typedef struct { double re, im; } dcomplex;

extern "C" {

int ___chkstk_ms()
{
    return 0; // FIXME: this is a terrible hack
}

double trunc( double t )
{
     return t >= 0.0
                ? std::floor(t + 0.5)
                : std::ceil(t - 0.5);
}

long lround( double t )
{
     return t >= 0.0
                ? (long)std::floor(t + 0.5)
                : (long)std::ceil(t - 0.5);
}

float cabsf(fcomplex x)
{
    return std::abs(reinterpret_cast<std::complex<float> const &>(x));
}

fcomplex csqrtf(fcomplex x)
{
    return reinterpret_cast<fcomplex const &>(std::sqrt(reinterpret_cast<std::complex<float> const &>(x)));
}

dcomplex csqrt(dcomplex x)
{
    return reinterpret_cast<dcomplex const &>(std::sqrt(reinterpret_cast<std::complex<double> const &>(x)));
}

dcomplex cexp(dcomplex x)
{
    return reinterpret_cast<dcomplex const &>(std::exp(reinterpret_cast<std::complex<double> const &>(x)));
}

dcomplex clog(dcomplex x)
{
    return reinterpret_cast<dcomplex const &>(std::log(reinterpret_cast<std::complex<double> const &>(x)));
}

dcomplex ccos(dcomplex x)
{
    return reinterpret_cast<dcomplex const &>(std::cos(reinterpret_cast<std::complex<double> const &>(x)));
}

dcomplex csin(dcomplex x)
{
    return reinterpret_cast<dcomplex const &>(std::sin(reinterpret_cast<std::complex<double> const &>(x)));
}

dcomplex cpow(dcomplex x, dcomplex y)
{
    return reinterpret_cast<dcomplex const &>(std::pow(reinterpret_cast<std::complex<double> const &>(x),reinterpret_cast<std::complex<double> const &>(y)));
}

}
