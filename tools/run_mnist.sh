#!/bin/bash

res_dir=$1
ln_sigma=$2
suffix=$3

cd "$(dirname "$0")"/..
abs_path="`pwd`"

cd release/src/server

SERVER_PID=0

trap "kill $SERVER_PID; exit" INT

echo "**** Running mnist with ln_sigma=$ln_sigma, suffix=$suffix"

for seed in {1,}; do
    #for i in {2000,2200,2400,2600,2800,3000,3200,3400,3600,3800,4000}; do
    for i in {200,}; do
        taskset -c 4 ./server server 1000000 1 &
        sleep 5

        #../../tests/client/test_client_concurrent_run_latencies_fixed_num_multi server $i $ln_sigma 50 3000 0 mnist${suffix}.txt tmp2.txt mnist${suffix}_profile_$i mnist${suffix}_timeline${i}.txt $seed "${abs_path}/release/jobs/tvm_mnist/libjob_tvm_mnist.so" 1 50
        ../../tests/client/test_client_concurrent_run_latencies_fixed_num_multi server $i $ln_sigma 3 3000 0 mnist${suffix}.txt tmp2.txt mnist${suffix}_profile_$i mnist${suffix}_timeline${i}.txt $seed "${abs_path}/release/jobs/tvm_mnist/libjob_tvm_mnist.so" 1 3
        wait
    done
done
