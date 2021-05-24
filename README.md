# Virtualization Performance Comparison

## Overview
Experiments for the IEEE HPEC 2021 conference paper "Performance Evaluation Comparison Between Docker and Hypervisor Virtualization." 
Paper Link : X

## Useage 
```
chmod u+x script_<benchmark>.sh
sudo ./script_<benchmark>.sh [options]

options:
-h, --help                show brief help
-n, --number=NUMBER       specify number of experiments iterations (default 10)
-s, --system=SYSTEM       specify docker or system (default system)   
```

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
