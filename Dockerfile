FROM ubuntu:20.04

# Set up envs
ENV GOROOT="/opt/go"
ENV GORBIN="/opt/go/bin"
ENV PATH=/opt/ses/bin:$PATH
ENV PATH=$PATH:/opt/go/bin
ENV PATH=$PATH:/root/go/bin
ENV DEBIAN_FRONTEND=noninteractive

# Install main deps
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential groff less gcc make git unzip python3-pip ruby bzip2 wget curl libfreetype6 libxrender1 libfontconfig1 && apt-get clean

# Create install dir for delete it after install
RUN mkdir install
WORKDIR /root/install

# Install golang
RUN wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz && tar -C /opt -xzf go1.17.3.linux-amd64.tar.gz

# Install goembehelp
RUN go get github.com/borchevkin/goembehelp@latest

# Upgrade and set up the pip
RUN pip3 install --upgrade pip
RUN export LC_ALL=C.UTF-8
RUN export LANG=C.UTF-8

# Install Segger Embedded Studio 4.52
RUN wget https://dl.segger.com/files/embedded-studio/Setup_EmbeddedStudio_ARM_v542b_linux_x64.tar.gz -O ses_install.tar.gz && tar -xzf ses_install.tar.gz
RUN /bin/sh -c '/bin/echo -e "yes\n" | ./arm_segger_embedded_studio_542b_linux_x64/install_segger_embedded_studio --copy-files-to /opt/ses'

# Install aws-cli and boto3
RUN pip3 install awscli boto3

# Install command - line tools
RUN wget -c https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-12-1/nRFCommandLineTools10121Linuxamd64.tar.gz && tar -xf nRFCommandLineTools10121Linuxamd64.tar.gz && dpkg -i nRF-Command-Line-Tools_10_12_1_Linux-amd64.deb

# Install nRF Util
RUN pip3 install nrfutil

# Install Ceedling
RUN gem install ceedling

# Clean pip cache
RUN pip3 cache purge

# Clean install files
WORKDIR /root
RUN rm -r -f /root/install/

