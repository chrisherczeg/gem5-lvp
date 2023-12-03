#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "gem5/m5ops.h"

#define N 100 // size of the matrix
#define P 0 // probability of changing a value

// function to generate a random matrix of size N x N
void generate_matrix(double matrix[N][N], double matrix_copy[N][N])
{
    srand(time(NULL)); // seed the random number generator
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            matrix[i][j] = 0xC001C0DE; // generate a random value between 0 and 1
            matrix_copy[i][j] = matrix[i][j];
        }
    }
}

// function to transform a matrix of size N x N by changing 20% of its values
void transform_matrix(double matrix[N][N], double matrix_copy[N][N])
{
    srand(time(NULL)); // seed the random number generator
    for (int transform = 0; transform < N; transform++)
    {
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
            {
                double r = (double)rand() / RAND_MAX; // generate a random value between 0 and 1
                if (r < P)
                { // with probability P, change the value
                    matrix[i][j] = (double)rand() / RAND_MAX; // use random value stored in memory to force load from memory
                }
                else
                {
                    if (i != 0 & j != 0)
                        matrix[i][j] = matrix_copy[i-1][j-1]; // predicator should be able to capitalize on this
                }
            }
        }
    }
}

int main()
{
    double matrix[N][N]; // declare a matrix of size N x N
    double matrix_copy[N][N];
    generate_matrix(matrix, matrix_copy); // generate a random matrix

    m5_dump_reset_stats(0,0);
    transform_matrix(matrix, matrix_copy); // measure the time taken by the transform function
    m5_dump_reset_stats(0,0);
    return 0;
}
