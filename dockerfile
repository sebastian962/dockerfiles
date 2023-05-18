FROM ubuntu:23.04
# Provision Container 

WORKDIR /app
COPY $PWD/provision /app
RUN apt-get update && apt-get install -y curl unzip apt-transport-https ca-certificates gnupg lsb-release wget
# add helm kubeclt1.26
################################
# Install AWS CLI 
################################

RUN	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install \
    && rm awscliv2.zip \
    && rm -rf aws

################################
# Install Gcloud
################################

# Add the Google Cloud SDK repository
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
 tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
 curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
 gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Install the Google Cloud SDK

RUN apt-get update && \
 apt-get install -y google-cloud-sdk

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip \
    && unzip terraform_0.11.11_linux_amd64.zip \
    && rm terraform_0.11.11_linux_amd64.zip \
    && mv terraform /usr/local/bin/

################################
# Install helm and kubectl
################################
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x get_helm.sh && ./get_helm.sh \
    && rm get_helm.sh

ENTRYPOINT ["/app/provision"]
