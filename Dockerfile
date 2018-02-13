FROM aarch64/ubuntu
# In case the main package repositories are down, use the alternative base image:
# FROM gliderlabs/alpine:3.4

MAINTAINER Tanishq Dubey <tdubey3@illinois.edu>

#### INSTALL MPICH ####
RUN apt-get update
RUN apt-get install mpich -y

#### ADD DEFAULT USER ####
ARG USER=mpi
ENV USER ${USER}
RUN adduser --disabled-password --gecos "" ${USER} \
      && echo "${USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV USER_HOME /home/${USER}
RUN chown -R ${USER}:${USER} ${USER_HOME}

#### CREATE WORKING DIRECTORY FOR USER ####
ARG WORKDIR=/project
ENV WORKDIR ${WORKDIR}
RUN mkdir ${WORKDIR}
RUN chown -R ${USER}:${USER} ${WORKDIR}

WORKDIR ${WORKDIR}
USER ${USER}

CMD ["/bin/bash"]
