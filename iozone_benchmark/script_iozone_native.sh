#!/bin/bash

# configuration
reclen=64
sizes=( 64 512 4096 32768)

# intro title
echo ""
echo "IOzone Benchmark"
echo ""

# compile iozone
sudo rpm -e iozone
rm -rf iozone*
sudo wget http://www.iozone.org/src/current/iozone-3-491.x86_64.rpm
sudo rpm -ivh iozone-3-491.x86_64.rpm

# run 10 iterations of benchmark
echo ""
echo "running iterations..."
echo "size,reclen,write,read" > results_iozone_native.csv
num=10
for j in  "${sizes[@]}"   
do
    for i in  $( seq 1 $num )
    do
        # run iozone
        /opt/iozone/bin/iozone -RaI -r $reclen -s $j -i 0 -i 1 > tmp.out

        write=$(cat tmp.out | awk 'FNR == 30 {print $3}')
        read=$(cat tmp.out | awk 'FNR == 30 {print $5}')
        rm tmp.out 

        echo "$j,$reclen,$write,$read" >> results_iozone_native.csv

    done
done 

# done
echo ""
echo "exiting..."
echo ""