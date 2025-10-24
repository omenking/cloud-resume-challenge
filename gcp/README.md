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

## Install GCloud

```sh
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli
```

## Considerations for CDN

GCP requires you to run a Global External Load Balancer and it appears to be more
expensive then other providers. So even though using Cloud CDN would demostrate GCP
knowledge we'll implement a more cost effective solution.

> If you have only a single domain/site and low traffic, the fixed cost (~US $18/month) could dominate.

$18 for a personaal website just have CDN is not worth it we'll attempt to use CloudFlare instead.

## CloudFlare and GCP

GCP expects the header to be the same the domain for static website hosting.
If we turn of proxing for the record CNAME cloudflare we can server the domain
however we will not get benifits of Rules, Workers, TLS/SSL, DDoS etc... and we
would have create another GCS Bucket and upload a index.html that redirects.

To properly redirect we need to create rules within CloudFlare.
But we will need a worker to serve content from the bucket (its a js file)
think similar to CloudFront functions.

Deploy a Hello World worker template and the edit it. Use the `worker.js` to serve the buckets content.

## migrate Terraform state.

# Authenticate if needed
We can't use terraform login in Github Codespaces

mkdir -p ~/.terraform.d
cat > ~/.terraform.d/credentials.tfrc.json <<'EOF'
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR_TERRAFORM_CLOUD_TOKEN_HERE"
    }
  }
}
EOF

# Reconfigure backend and migrate state in one go
terraform init


## Terraform Cloud and Workspaces

- We need to remember to set the workspace directly on the task for terraform deploy or we'll get a mysterious error about TF_WORKSPACE

## Testing the function

Test our function before we package it.

```sh
bundle exec functions-framework --target hello_http --port 8080
```
