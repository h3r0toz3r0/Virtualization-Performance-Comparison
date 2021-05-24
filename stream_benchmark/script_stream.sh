#!/bin/bash
 
# intro title
echo ""
echo "STREAM Benchmark"
echo ""

# specify default values
export N=10
export SYSTEM='system'

# include options
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package description: script that runs the STREAM benchmark."
      echo " "
      echo "$package useage: sudo ./script_stream.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-n, --number=NUMBER       specify number of experiments iterations (default 10)"
      echo "-s, --system=SYSTEM       specify docker or system (default system)"
      echo ""
      exit 0
      ;;
      -n|--number)
        shift
        if test $# -gt 0; then
            export N=$1
        else
            export N=10
        fi
        shift
      ;;
      -s|--system)
        shift
        if test $# -gt 0; then
            export SYSTEM=$1
        else
            export SYSTEM='system'
        fi
        shift
      ;;
  esac
done

# ensure running on sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root."
    echo "For help: ./script_stream.sh --help"
    echo ""
    exit
fi

echo $N 
echo $SYSTEM 

# clean system of linpack stuff
rm -rf stream*

# pull linpack script from website
wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c

# if running experiment on system
if [[ $SYSTEM = "system" ]]; then
    echo "running experiments for system..."
    echo ""

    # compile benchmark
    gcc -O3 stream.c -o stream

    # set up results
    rm -rf results_stream_system.csv
    echo "copy best rate (MB/s),average time,minimum time,maximum time,scale best rate (MB/s),average time,minimum time,maximum time,add best rate (MB/s),average time,minimum time,maximum time,triad best rate (MB/s),average time,minimum time,maximum time" > results_stream_system.csv

    # run iterations
    echo "running iterations..."
    num=$N          
    for i in  $( seq 1 $num )
    do
        echo "  ... iteration: $i"
        
        # run benchmark
        ./stream > run.txt

        # get statistics
        copy_rate=$(cat run.txt | awk 'FNR == 24 {print $2}')
        copy_avg=$(cat run.txt | awk 'FNR == 24 {print $3}')
        copy_min=$(cat run.txt | awk 'FNR == 24 {print $4}')
        copy_max=$(cat run.txt | awk 'FNR == 24 {print $5}')

        scale_rate=$(cat run.txt | awk 'FNR == 25 {print $2}')
        scale_avg=$(cat run.txt | awk 'FNR == 25 {print $3}')
        scale_min=$(cat run.txt | awk 'FNR == 25 {print $4}')
        scale_max=$(cat run.txt | awk 'FNR == 25 {print $5}')

        add_rate=$(cat run.txt | awk 'FNR == 26 {print $2}')
        add_avg=$(cat run.txt | awk 'FNR == 26 {print $3}')
        add_min=$(cat run.txt | awk 'FNR == 26 {print $4}')
        add_max=$(cat run.txt | awk 'FNR == 26 {print $5}')

        triad_rate=$(cat run.txt | awk 'FNR == 27 {print $2}')
        triad_avg=$(cat run.txt | awk 'FNR == 27 {print $3}')
        triad_min=$(cat run.txt | awk 'FNR == 27 {print $4}')
        triad_max=$(cat run.txt | awk 'FNR == 27 {print $5}')

        # add results to file
        echo "$copy_rate,$copy_avg,$copy_min,$copy_max,$scale_rate,$scale_avg,$scale_min,$scale_max,$add_rate,$add_avg,$add_min,$add_max,$triad_rate,$triad_avg,$triad_min,$triad_max" >> results_stream_system.csv

        # remove run file
        rm run.txt
    done
fi

# if running experiment on docker
if [[ $SYSTEM = "docker" ]]; then
    echo "running experiments for docker..."
    echo ""

    # build image
    echo "building container..."
    echo ""
    docker build . -t stream

    # set up results
    rm -rf results_stream_docker.csv
    echo "copy best rate (MB/s),average time,minimum time,maximum time,scale best rate (MB/s),average time,minimum time,maximum time,add best rate (MB/s),average time,minimum time,maximum time,triad best rate (MB/s),average time,minimum time,maximum time" > results_stream_docker.csv

    # run iterations
    echo "running iterations..."
    num=$N          
    for i in  $( seq 1 $num )
    do
        echo "  ... iteration: $i"
        
        # run container
        docker run stream > run.txt

        # get statistics
        copy_rate=$(cat run.txt | awk 'FNR == 24 {print $2}')
        copy_avg=$(cat run.txt | awk 'FNR == 24 {print $3}')
        copy_min=$(cat run.txt | awk 'FNR == 24 {print $4}')
        copy_max=$(cat run.txt | awk 'FNR == 24 {print $5}')

        scale_rate=$(cat run.txt | awk 'FNR == 25 {print $2}')
        scale_avg=$(cat run.txt | awk 'FNR == 25 {print $3}')
        scale_min=$(cat run.txt | awk 'FNR == 25 {print $4}')
        scale_max=$(cat run.txt | awk 'FNR == 25 {print $5}')

        add_rate=$(cat run.txt | awk 'FNR == 26 {print $2}')
        add_avg=$(cat run.txt | awk 'FNR == 26 {print $3}')
        add_min=$(cat run.txt | awk 'FNR == 26 {print $4}')
        add_max=$(cat run.txt | awk 'FNR == 26 {print $5}')

        triad_rate=$(cat run.txt | awk 'FNR == 27 {print $2}')
        triad_avg=$(cat run.txt | awk 'FNR == 27 {print $3}')
        triad_min=$(cat run.txt | awk 'FNR == 27 {print $4}')
        triad_max=$(cat run.txt | awk 'FNR == 27 {print $5}')

        # add results to file
        echo "$copy_rate,$copy_avg,$copy_min,$copy_max,$scale_rate,$scale_avg,$scale_min,$scale_max,$add_rate,$add_avg,$add_min,$add_max,$triad_rate,$triad_avg,$triad_min,$triad_max" >> results_stream_docker.csv


        # remove run file
        rm run.txt
    done
fi

# done
echo ""
echo "experiments complete"
echo "output: results_stream_$SYSTEM.csv"
echo "exiting..."
echo ""