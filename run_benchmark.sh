source SetEnv.sh

build_x86

declare -a array=("simple" "limit" "constant")

benchmark_dir="./benchmarks"
spec_se_py_dir="./configs/spec/"
se_py_dir="./configs/example/"

rm -rf $benchmark_dir
mkdir -p $benchmark_dir

for i in "${array[@]}"
do
    mkdir -p "$benchmark_dir/$i"

    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="namd_stats.txt" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b namd
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="lbm_stats.txt" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b lbm
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="milc_stats.txt" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b milc
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="sjeng_stats.txt" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b sjeng

    pushd . > /dev/null
    cd "$benchmark_dir/$i/"
    rm *.out
    rm *.stdout
    rm *.ini
    rm *.json
    rm fs/ -rf
    popd > /dev/null

done