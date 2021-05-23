# Virtualization Performance Comparison

## Overview
Experiments for the IEEE HPEC 2021 conference paper "Performance Evaluation Comparison Between Docker and Hypervisor Virtualization." 
Paper Link : X

## Useage 
```
chmod u+x script_<benchmark>_<native/docker/vm>.sh
sudo ./script_<benchmark>_<native/docker/vm>.sh
    
Output: results_<benchmark>_<native/docker/vm>.csv
```

## Content
1) iozone_benchmark
    - Dockerfile
    - script_iozone_docker.sh
    - script_iozone_native.sh
    - script_iozone_vm.sh
2) linpack_benchmark
    - Dockerfile
    - linpack.c
    - script_linpack_docker.sh
    - script_linpack_native.sh
    - script_linpack_vm.sh
3) netperf_benchmark
    - Dockerfile
4) stream_benchmark
    - Dockerfile
    - script_stream.sh
    - script_stream_results.py 
5) results_figures
    - benchmark_results.xlsm
    - iozone_figure_read.png
    - iozone_figure_write.png
    - linpack_figure.png
    - netperf_figure.png
    - stream_figure.png
