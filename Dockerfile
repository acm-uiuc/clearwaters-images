FROM aarch64/ubuntu
# In case the main package repositories are down, use the alternative base image:
# FROM gliderlabs/alpine:3.4

MAINTAINER Tanishq Dubey <tdubey3@illinois.edu>

#### INSTALL MPICH ####
RUN apt-get update
RUN apt-get install mpich -y

#### INSTALL SSH ####
RUN apt-get install openssh-server -y
RUN apt-get install ssh -y
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#### SET ROOT PASSWORD ####
RUN echo 'root:root' | chpasswd

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

CMD ["/usr/sbin/sshd", "-D"]
