source SetEnv.sh

declare -a array=("simple" "limit" "constant")

benchmark_dir="./benchmarks"
spec_se_py_dir="./configs/spec/"
se_py_dir="./configs/example/"

rm -rf $benchmark_dir
mkdir -p $benchmark_dir

for i in "${array[@]}"
do
   mkdir -p "$benchmark_dir/$i"

    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="matrix_transform_stats.out" "$se_py_dir/se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -c matrix_transform.out
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="namd_transform_stats.out" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b namd
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="lbm_transform_stats.out" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b lbm
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="milc_transform_stats.out" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b milc
    ./build/ECE565-X86/gem5.opt --outdir="$benchmark_dir/$i" --stats-file="sjeng_transform_stats.out" "$spec_se_py_dir/spec_se_$i.py" --cpu-type=O3CPU --caches --maxinsts=10000000 -b sjeng

done