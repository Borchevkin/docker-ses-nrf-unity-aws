FROM ubuntu:20.04

WORKDIR /root/

# Install main deps
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential git unzip python3-pip ruby bzip2 wget curl libfreetype6 libxrender1 libfontconfig1 && apt-get clean
RUN mkdir install && cd install

# Upgrade and set up the pip
RUN pip3 install --upgrade pip
RUN export LC_ALL=C.UTF-8
RUN export LANG=C.UTF-8

# Install Segger Embedded Studio 4.52
RUN wget https://dl.segger.com/files/embedded-studio/Setup_EmbeddedStudio_ARM_v542b_linux_x64.tar.gz -O ses_install.tar.gz && tar -xzf ses_install.tar.gz
RUN /bin/sh -c '/bin/echo -e "yes\n" | ./arm_segger_embedded_studio_542b_linux_x64/install_segger_embedded_studio --copy-files-to /opt/ses'

# Install aws-cli and boto3
RUN wget -c -q "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
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
RUN cd /root
RUN rm -r -f install/

# Set up PATH
ENV PATH=/opt/ses/bin:$PATH