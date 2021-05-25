#!/bin/bash
 
# intro title
echo ""
echo "IOzone Benchmark"
echo ""

# configuration
reclen=16
sizes=( 64 512 4096 32768 )

# specify default values
export N=10
export SYSTEM='system'

# include options
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package description: script that runs the IOzone benchmark."
      echo " "
      echo "$package useage: sudo ./script_iozone.sh [options]"
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
    echo "For help: ./script_iozone.sh --help"
    echo ""
    exit
fi

# clean system of iozone stuff
rm -rf iozone*

# if running experiment on system
if [[ $SYSTEM = "system" ]]; then
    echo "running experiments for system..."
    echo ""

    # pull iozone script from website
    wget http://www.iozone.org/src/current/iozone3_491.tar
    tar xvf iozone*

    # compile benchmark
    cd iozone*/src/current/
    make linux-AMD64
    cd ../../..

    # set up results
    rm -rf results_iozone_system.csv
    echo "size,reclen,write,read" > results_iozone_system.csv

    # run all sizes
    for j in  "${sizes[@]}"   
    do
        # run iterations
        echo "running iterations for $j..."
        num=$N          
        for i in  $( seq 1 $num )
        do
            echo "  ... iteration: $i"
            
            # run benchmark
            ./iozone*/src/current/iozone -RaI -r $reclen -s $j -i 0 -i 1 > run.txt

            # get statistics
            write=$(cat run.txt | awk 'FNR == 31 {print $3}')
            read=$(cat run.txt | awk 'FNR == 31 {print $5}')

            # add results to file
            echo "$j,$reclen,$write,$read" >> results_iozone_system.csv

            # remove run file
            rm run.txt
        done
    done
fi

# if running experiment on docker
if [[ $SYSTEM = "docker" ]]; then
    echo "running experiments for docker..."
    echo ""

    # build image
    echo "building container..."
    echo ""
    docker build . -t iozone 

    # set up results
    rm -rf results_iozone_system.csv
    echo "size,reclen,write,read" > results_iozone_docker.csv

    # run all sizes
    for j in  "${sizes[@]}"   
    do
        # run iterations
        echo "running iterations..."
        num=$N          
        for i in  $( seq 1 $num )
        do
            echo "  ... iteration: $i"
            
            # run benchmark
            docker run --rm sultan/iozone ./iozone -RaI -r $reclen -s $j -i 0 -i 1 > run.txt

            # get statistics
            write=$(cat run.txt | awk 'FNR == 31 {print $3}')
            read=$(cat run.txt | awk 'FNR == 31 {print $5}')

            # add results to file
            echo "$j,$reclen,$write,$read" >> results_iozone_docker.csv

            # remove run file
            rm run.txt
        done
    done
fi

# done
echo ""
echo "experiments complete"
echo "output: results_iozone_$SYSTEM.csv"
echo "exiting..."
echo ""
