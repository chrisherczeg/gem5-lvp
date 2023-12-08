#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "gem5/m5ops.h"

#define N 100 // size of the matrix
#define P 0.10 // probability of changing a value

// function to generate a random matrix of size N x N
void generate_matrix(int matrix[N][N])
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            matrix[i][j] = 0xC001C0DE; // generate a random value between 0 and 1
        }
    }
}

 __attribute__((optimize(0))) int constant_load_function(volatile int *load)
{
    int value;
    asm ("movl %1, %%eax" : "=a" (value) : "m" (*load));
    return value;
}

// function to transform a matrix of size N x N by changing 20% of its values
void transform_matrix(int matrix[N][N], volatile int *constant_val)
{
    srand(time(NULL)); // seed the random number generator
    for (int transform = 0; transform < N; transform++)
    {
        double r = (double)rand() / RAND_MAX; // generate a random value between 0 and 1
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
            {
                if (r < P)
                { // with probability P, change the value
                    matrix[i][j] = (double)rand() / RAND_MAX; // use random value stored in memory to force load from memory
                }
                else
                {
                    if (i != 0 && j != 0)
                        matrix[i][j] = constant_load_function(constant_val); // predicator should be able to capitalize on this
                }
            }
        }
    }
}

int main()
{
    int matrix[N][N]; // declare a matrix of size N x N
    volatile int const_val = 0xC001C0DE;
    generate_matrix(matrix); // generate a random matrix

    m5_dump_reset_stats(0,0);
    transform_matrix(matrix, &const_val); // measure the time taken by the transform function
    m5_dump_reset_stats(0,0);
    return 0;
}
