## Install Terraform

We are going use terraform for IaC with GCP because
that is the recommended way to do IaC on GCP despite there
being Deployment Manager. We should be abel to manage 
terraform state file with Infrastructure Manater

```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```

### Terraform and GCP Authenication

In GCP we create a new service account and give it
Infrastructure Adminstrator which for now should be enough
permissions to create the resources wants.

We need to set the following env var and this will allow
Terraform to authenicate to GCP.
```sh
export GOOGLE_APPLICATION_CREDENTIALS=/workspaces/cloud-resume-challenge/gcp/gcp-key.json
```

To persist this we should add to our `.bash_profile` or `.bashrc`

edit and reload our bash file
```sh
vi ~/.bashrc
source ~/.bashrc
env | grep GOOGLE
```

## Install Ansible

```sh
pipx install --include-deps ansible
```

## Setup Vault with GCP Credentails

We'll need store the contents of the gcp key in our vault.

eg.

```sh
gcp_sa_key_json: |
  {
    "type": "service_account",
    "project_id": "cloud-resume-challenge-475514",
    "private_key_id": "XXXX",
    "private_key": "-----BEGIN PRIVATE KEY-----\nXXXX\n-----END PRIVATE KEY-----\n",
    "client_email": "terraform-ci@cloud-resume-challenge-475514.iam.gserviceaccount.com",
    "client_id": "XXXX",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/terraform-ci%40cloud-resume-challenge-475514.iam.gserviceaccount.com"
  }
```

```sh
cd aws
ansible-vault create playbooks/vaults/prod.yml
ansible-vault edit playbooks/vaults/prod.yml
ansible-vault view playbooks/vaults/prod.yml
```

## Install Deps for Ansible

```sh
ansible-galaxy collection install -r requirements.txt
```