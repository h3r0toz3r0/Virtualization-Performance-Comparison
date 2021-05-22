#!/bin/bash
# useage: 	chmod u+x script_stream.sh
#			sudo ./script_stream.sh

if [ $# -eq 0 ]; then
    echo -e "Usage:\n    bulk_benchmark.sh {docker, system}\n"
    echo "Set the environment variable N to control number of runs. Default: 10"
    exit 1
fi

if [ -z "$N" ]; then
    N=10
fi

if [ $1 == "docker" ]; then
    RESULTS_FILE='results_stream_docker.txt'
	docker build . -t stream
    cmd="docker run stream"
elif [ $1 == "system" ]; then
    RESULTS_FILE='results_stream_system.txt'
    cmd="./stream"
else
    echo "Invalid argument: $1"
    exit 1
fi


if [ -f "$RESULTS_FILE" ]; then
    rm "$RESULTS_FILE"
fi

echo "Running '$cmd' $N times... "
for i in $(seq "$N"); do
    echo "#$i"
    eval "$cmd" >>"$RESULTS_FILE"
done
echo "Done"

echo "Analyzing results for $RESULTS_FILE"
echo "-----------------------------------"
python script_stream_results.py "$RESULTS_FILE"
