FROM ubuntu:latest
MAINTAINER Amit Bakshi <ambakshi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yy -q
RUN apt-get install -yy -q python-software-properties software-properties-common
RUN apt-add-repository -y ppa:ubuntu-wine/ppa
RUN dpkg --add-architecture i386
RUN apt-get update -yy -q
RUN apt-get install -yy -q wine
RUN apt-get install -yy -q wine1.7 winetricks xvfb


ENV XDG_DATA_DIR /usr/local/share:/usr/share

RUN useradd -m -s /bin/bash wine
ENV HOME /home/wine
ENV XDG_DATA_HOME /home/wine/.local

ADD ./VCForPython27.msi ./ 
RUN chmod 0777 /VCForPython27.msi

USER wine
RUN mkdir -p /home/wine/.wine/drive_c
WORKDIR /home/wine/.wine/drive_c
RUN wget "http://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi"
RUN /usr/bin/wine -a msiexec /a C:/VCForPython27.msi /quiet /qn /log C:/install.log

ENTRYPOINT ["/bin/bash","-l"]
