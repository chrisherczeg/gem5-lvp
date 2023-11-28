#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 100 // size of the matrix
#define P 0.2 // probability of changing a value

// function to generate a random matrix of size N x N
void generate_matrix(double matrix[N][N])
{
    srand(time(NULL)); // seed the random number generator
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            matrix[i][j] = (double)rand() / RAND_MAX; // generate a random value between 0 and 1
        }
    }
}

// function to transform a matrix of size N x N by changing 20% of its values
void transform_matrix(double matrix[N][N], double *random_assigned_value)
{
    srand(time(NULL)); // seed the random number generator
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            double r = (double)rand() / RAND_MAX; // generate a random value between 0 and 1
            if (r < P)
            { // with probability P, change the value
                matrix[i][j] = *random_assigned_value; // use random value stored in memory to force load from memory
            }
        }
    }
}

int main()
{
    double random_assigned_value = (double)rand() / RAND_MAX;
    double matrix[N][N]; // declare a matrix of size N x N
    generate_matrix(matrix); // generate a random matrix
    transform_matrix(matrix, &random_assigned_value); // measure the time taken by the transform function
    return 0;
}
