# Virtualization Performance Comparison

## Overview
Experiments for the IEEE HPEC 2021 conference paper "Performance Evaluation Comparison Between Docker and Hypervisor Virtualization." 
(Paper Link)

## Authors
- Anna DeVries
- Shane Conaboy
- Mark Tiburu
- Li Wang

Department of Electrical and Computer Engineering

Northeastern University

Boston, MA

## Useage 
```
chmod u+x script_<benchmark>.sh
sudo ./script_<benchmark>.sh [options]

options:
-h, --help                show brief help
-n, --number=NUMBER       specify number of experiments iterations (default 10)
-s, --system=SYSTEM       specify docker or system (default system) 

Example useage:
sudo ./script_linpack.sh -s docker # will run 10 iterations of linpack with docker containers 
sudo ./script_netperf.sh -n 20 -s system # will run 20 iterations of netperf on the system
```

## Benchmark
### IOzone
I/O Disk Performance Metric

reference: https://www.iozone.org/

### LINPACK
CPU Performance Metric

reference: http://www.netlib.org/linpack/

### Netperf
Network Throughput Performance Metric

reference: https://hewlettpackard.github.io/netperf/

### STREAM
Memory Bandwidth Performance Metric

reference: https://www.cs.virginia.edu/stream/

## Content
1) iozone_benchmark
    - Dockerfile
    - script_iozone.sh
2) linpack_benchmark
    - Dockerfile
    - script_linpack.sh
3) netperf_benchmark
    - Dockerfile
    - script_netperf.sh
4) stream_benchmark
    - Dockerfile
    - script_stream.sh
5) results_figures
    - benchmark_results.xlsm
    - iozone_figure_read.png
    - iozone_figure_write.png
    - linpack_figure.png
    - netperf_figure.png
    - stream_figure.png
