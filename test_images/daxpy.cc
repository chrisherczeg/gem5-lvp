#include <random>
#include <iostream>

#ifdef BENCHMARKING
#include "gem5/m5ops.h"
#endif

int main()
{
    const int N = 1000;
    double X[N];
    double Y[N];
    double alpha = 0.5;
    std::random_device rd; std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(1, 2);
    for (int i = 0; i < N; ++i)
    {
    X[i] = dis(gen);
    Y[i] = dis(gen);
    }
#ifdef BENCHMARKING
    m5_dump_reset_stats(0,0);
#endif
    // Start of daxpy loop
    for (int i = 0; i < N; ++i)
    {
        Y[i] = alpha * X[i] + Y[i];
    }
    // End of daxpy loop
#ifdef BENCHMARKING
    m5_dump_reset_stats(0,0);
#endif

    double sum = 0;
    for (int i = 0; i < N; ++i)
    {
        sum += Y[i];
    }
    std::cout << sum;
    return 0;
}