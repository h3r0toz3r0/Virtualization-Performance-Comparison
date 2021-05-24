#!/bin/bash
 
# intro title
echo ""
echo "LINPACK Benchmark"
echo ""

# specify default values
export N=10
export SYSTEM='system'

# include options
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package description: script that runs the LINPACK benchmark."
      echo " "
      echo "$package useage: sudo ./script_linpack.sh [options]"
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
    echo "For help: ./script_linpack.sh --help"
    echo ""
    exit
fi

echo $N 
echo $SYSTEM 

# clean system of linpack stuff
rm -rf linpack*

# pull linpack script from website
wget https://people.sc.fsu.edu/~jburkardt/c_src/linpack_bench/linpack_bench.c
mv linpack_bench.c linpack.c

# if running experiment on system
if [[ $SYSTEM = "system" ]]; then
    echo "running experiments for system..."
    echo ""

    # compile benchmark
    gcc -O3 linpack.c -o linpack

    # set up results
    rm -rf results_linpack_system.csv
    echo "norm_resid,resid,machep,x1,xN,factor,solve,total,mflops,unit,cray" > results_linpack_system.csv

    # run iterations
    echo "running iterations..."
    num=$N          
    for i in  $( seq 1 $num )
    do
        echo "  ... iteration: $i"
        
        # run benchmark
        ./linpack > run.txt

        # get statistics
        a=$(cat run.txt | awk 'FNR == 14 {print $1}')
        b=$(cat run.txt | awk 'FNR == 14 {print $2}')
        c=$(cat run.txt | awk 'FNR == 14 {print $3}')
        d=$(cat run.txt | awk 'FNR == 14 {print $4}')
        e=$(cat run.txt | awk 'FNR == 14 {print $5}')
        f=$(cat run.txt | awk 'FNR == 18 {print $1}')
        g=$(cat run.txt | awk 'FNR == 18 {print $2}')
        h=$(cat run.txt | awk 'FNR == 18 {print $3}')
        i=$(cat run.txt | awk 'FNR == 18 {print $4}')
        j=$(cat run.txt | awk 'FNR == 18 {print $5}')
        k=$(cat run.txt | awk 'FNR == 18 {print $6}')

        # add results to file
        echo "$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k" >> results_linpack_system.csv

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
    docker build . -t linpack 

    # set up results
    rm -rf results_linpack_docker.csv
    echo "norm_resid,resid,machep,x1,xN,factor,solve,total,mflops,unit,cray" > results_linpack_docker.csv

    # run iterations
    echo "running iterations..."
    num=$N          
    for i in  $( seq 1 $num )
    do
        echo "  ... iteration: $i"
        
        # run container
        docker run linpack > run.txt

        # get statistics
        a=$(cat run.txt | awk 'FNR == 14 {print $1}')
        b=$(cat run.txt | awk 'FNR == 14 {print $2}')
        c=$(cat run.txt | awk 'FNR == 14 {print $3}')
        d=$(cat run.txt | awk 'FNR == 14 {print $4}')
        e=$(cat run.txt | awk 'FNR == 14 {print $5}')
        f=$(cat run.txt | awk 'FNR == 18 {print $1}')
        g=$(cat run.txt | awk 'FNR == 18 {print $2}')
        h=$(cat run.txt | awk 'FNR == 18 {print $3}')
        i=$(cat run.txt | awk 'FNR == 18 {print $4}')
        j=$(cat run.txt | awk 'FNR == 18 {print $5}')
        k=$(cat run.txt | awk 'FNR == 18 {print $6}')

        # add results to file
        echo "$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k" >> results_linpack_docker.csv

        # remove run file
        rm run.txt
    done
fi

# done
echo ""
echo "experiments complete"
echo "output: results_linpack_$SYSTEM.csv"
echo "exiting..."
echo ""
