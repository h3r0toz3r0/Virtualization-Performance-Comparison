FROM centos:7

RUN yum -y update
RUN yum install -y bash wget build-essential make gcc time hdparm sudo
RUN wget 'http://www.iozone.org/src/current/iozone3_490.tar' 
RUN tar -xf iozone3_490.tar
WORKDIR /iozone3_490/src/current/
RUN make linux-AMD64
RUN useradd -ms /bin/bash docker && echo "docker:docker" | chpasswd
RUN echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/docker && chmod 0440 /etc/sudoers.d/docker
USER docker
CMD bash
