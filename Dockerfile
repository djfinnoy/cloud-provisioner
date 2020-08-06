####################################################################################################
# base-linux
####################################################################################################

FROM centos:8 AS base-linux-centos8

# Install miscellaneous tools
RUN dnf -q -y install dnf-plugins-core \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
  wget unzip jq zsh git

# Download Terraform
#RUN wget -q https://releases.hashicorp.com/terraform/0.13.0-beta2/terraform_0.13.0-beta2_linux_amd64.zip -O /tmp/zip  && unzip /tmp/zip -d /usr/bin && rm /tmp/zip
RUN wget -q https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip -O /tmp/zip  && unzip /tmp/zip -d /usr/bin && rm /tmp/zip

# Download Terragrunt
RUN curl -sS -L  \
  https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.31/terragrunt_linux_amd64 \
  -o /usr/bin/terragrunt \
  && chmod +x /usr/bin/terragrunt

# Download Oh My Zsh
RUN sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Neovim
RUN dnf config-manager --set-enabled PowerTools
RUN dnf install -q -y jemalloc neovim

# Init
ENTRYPOINT /bin/zsh

####################################################################################################
# gcp-provisioner: A container for working with Google Cloud Platform
####################################################################################################

FROM base-linux-centos8 AS gcp-provisioner

# Install Google Cloud SDK
COPY ./resources/gcp/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN yum install -y google-cloud-sdk

# Init
COPY ./resources/gcp/gcp-init.sh /usr/local/bin/gcp-init.sh
ENTRYPOINT . gcp-init.sh && /bin/zsh
