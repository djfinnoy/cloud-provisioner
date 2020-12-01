####################################################################################################
# base-linux
####################################################################################################

FROM centos:8 AS base-linux-centos8

# Versions
ENV VERSION_TERRAFORM="0.13.4"
ENV VERSION_TERRAGRUNT="v0.25.2"
ENV VERSION_KUBECTL="v1.19.0"
ENV VERSION_KUSTOMIZE="v3.8.7"
ENV VERSION_HELM="v3.4.1"

# Language
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install miscellaneous packages
RUN dnf -q -y install dnf-plugins-core \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
  wget unzip jq zsh git

# Install Oh My Zsh
RUN sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh stuff
COPY ./resources/zsh/.zshrc /root/.zshrc

# Install Neovim
RUN dnf config-manager --set-enabled PowerTools
RUN dnf install -q -y jemalloc neovim

# Install Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip -O /tmp/zip  && unzip /tmp/zip -d /usr/bin && rm /tmp/zip

# Install Terragrunt
RUN curl -sS -L  \
  https://github.com/gruntwork-io/terragrunt/releases/download/${VERSION_TERRAGRUNT}/terragrunt_linux_amd64 \
  -o /usr/bin/terragrunt \
  && chmod +x /usr/bin/terragrunt

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${VERSION_KUBECTL}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install kustomize
RUN wget -O /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${VERSION_KUSTOMIZE}/kustomize_${VERSION_KUSTOMIZE}_linux_amd64.tar.gz \
  && tar -C /usr/local/bin/ -xzvf /tmp/kustomize.tar.gz \
  && chmod +x /usr/local/bin/kustomize \
  && rm /tmp/kustomize.tar.gz

# Install Helm
RUN wget https://get.helm.sh/helm-${VERSION_HELM}-linux-amd64.tar.gz \
    && tar -xvf helm-${VERSION_HELM}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 helm-${VERSION_HELM}-linux-amd64.tar.gz

# Install Krew
RUN cd $HOME && mkdir tmp-krew && cd ./tmp-krew \
    && wget https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz \
    && tar zxvf krew.tar.gz \
    && ./krew-linux_amd64 install krew \
    && cd ../ && rm -rf tmp-krew
ENV PATH="/root/.krew/bin:$PATH"

# Install kubectl plugins with Krew
RUN kubectl krew update \
    && kubectl krew install ctx \
    && kubectl krew install ns \
    && kubectl krew install cert-manager \
    && kubectl krew install resource-capacity 

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
ENTRYPOINT /bin/zsh

