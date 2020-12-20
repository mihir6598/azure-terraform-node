FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs)
COPY azure-cli.list /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update
RUN apt-get install azure-cli

RUN az extension add --name azure-iot
COPY  terraform_13_5 /usr/local/bin/terraform
RUN terraform --version

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
COPY msprod.list1 /etc/apt/sources.list.d/msprod.list
RUN apt-get update 
RUN ACCEPT_EULA=y DEBIAN_FRONTEND=noninteractive \
apt-get install -y --no-install-recommends mssql-tools unixodbc-dev
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# RUN source ~/.bashrc
ENV PATH="/opt/mssql-tools/bin/:${PATH}"
# RUN sqlcmd

RUN apt install nodejs -y
RUN apt install npm -y
RUN nodejs -v
RUN npm install -g @angular/cli