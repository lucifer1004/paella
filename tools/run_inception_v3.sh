#!/bin/bash

res_dir=$1
ln_sigma=$2
suffix=$3

cd ..
abs_path="`pwd`"
cd -

cd ../release/src/server

SERVER_PID=0

trap "kill $SERVER_PID; exit" INT

for seed in {1,}; do
    #for i in {2000,2200,2400,2600,2800,3000,3200,3400,3600,3800,4000}; do
    #for i in {30000,}; do
    for i in {0,}; do
        taskset -c 4 ./server server 1000000 1 &
        sleep 5

        #../../tests/client/test_client_concurrent_run_latencies_fixed_num_multi server $i $ln_sigma 50 3000 0 inception_v3${suffix}.txt tmp2.txt inception_v3${suffix}_profile_$i inception_v3${suffix}_timeline${i}.txt $seed "${abs_path}/release/jobs/tvm_inception_v3/libjob_tvm_inception_v3.so" 1 50
        ../../tests/client/test_client_concurrent_run_latencies_fixed_num_multi server $i $ln_sigma 1 3000 0 inception_v3${suffix}.txt tmp2.txt inception_v3${suffix}_profile_$i inception_v3${suffix}_timeline${i}.txt $seed "${abs_path}/release/jobs/tvm_inception_v3/libjob_tvm_inception_v3.so" 1 1
        wait
    done
done
