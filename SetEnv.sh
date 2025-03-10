## usage: source SetEnv.sh
## then: ex. build_arm

export LD_LIBRARY_PATH="/package/gcc/8.3.0/lib64"
export PATH="/package/gcc/8.3.0/bin:$PATH"

build_x86()
{
    scons-3 USE_HDF5=0 -j 40 ./build/ECE565-X86/gem5.opt
}

build_arm()
{
    scons-3 USE_HDF5=0 -j `nproc` ./build/ECE565-ARM/gem5.opt
}

run_hello_world()
{
    ./build/ECE565-X86/gem5.opt configs/example/se.py -c tests/test-progs/hello/bin/x86/linux/hello
}

daxpy_build()
{
    /usr/bin/g++ -O2 -std=gnu++11 test_images/daxpy.cc $1

    if [ -f a.out ];
    then
        mv a.out daxpy.out
    fi
}

matrix_transform_build()
{
    /usr/bin/g++ -O0 -std=gnu++11 -I include/ -L util/m5/build/x86/out/ test_images/matrix_transform.cc -lm5 $1

    if [ -f a.out ];
    then
        mv a.out matrix_transform.out
    fi
}

matrix_transform_run()
{
    ./build/ECE565-X86/gem5.opt $1 configs/example/se.py --cpu-type=O3CPU -c matrix_transform.out --caches --maxinsts=$2

    mv m5out/stats.txt m5out/matrix_transform.txt
}

daxpy_run()
{
    ./build/ECE565-X86/gem5.opt configs/example/se.py --cpu-type=O3CPU -c daxpy.out --caches

    mv m5out/stats.txt m5out/daxpy_stats.txt
}

m5ops_build()
{
    pushd . > /dev/null
    cd util/m5
    scons-3 build/x86/out/m5
    popd > /dev/null
}

daxpy_m5_build()
{
    /usr/bin/g++ -O2 -std=gnu++11 -I include/ -L util/m5/build/x86/out/ test_images/daxpy.cc -lm5 $1
    if [ -f a.out ];
    then
        mv a.out daxpy_m5.out
    fi
}

daxpy_m5_run()
{
    ./build/ECE565-X86/gem5.opt configs/example/se.py -c daxpy_m5.out
    
    mv m5out/stats.txt m5out/daxpy_m5_stats.txt
}

arm_run_minor_cpu()
{
    ./build/ECE565-ARM/gem5.opt configs/example/se.py --cpu-type=MyMinorCPU \
    --maxinsts=1000000 --l1d_size=64kB --l1i_size=16kB --caches --l2cache \
    -c assignment3/daxpy-armv7-binary
}

arm_run_benchmark()
{
    ./build/ECE565-ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU \
    --maxinsts=1000000 --l1d_size=64kB --l1i_size=16kB --caches --l2cache \
    -b $1
}

main()
{
    echo "Updating submodules..."
    git submodule update --init --recursive
}

main

export -f build_x86
export -f build_arm
export -f run_hello_world
export -f daxpy_build
export -f daxpy_run
export -f m5ops_build
export -f daxpy_m5_build
export -f daxpy_m5_run
export -f arm_run_minor_cpu