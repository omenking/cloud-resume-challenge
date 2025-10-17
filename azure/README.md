## Checking Updated Nameservers

After I changed the nameservers for my third-party domain
I checked to make sure they were updated using the whois command:

```sh
sudo apt install whois
whois andrewbrownresume.net | grep "Name Server"
```

## Install Azure Bicep

We could use Terraform but then we would have to manage
the statefile, and if a company only uses Azure they 
lean towards using Azure Bicep. 

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Login to azure

```sh
az login
```

### Install Ansible

Althought we dont need anisble to run azure bicep we want to do various
configuration changes like uploading our web site files so lets use anisble
because its more flexible than bash or power shell scripings.


```sh
pipx install --include-deps ansible
```

## Install Deps for Ansible

```sh
cd azure
ansible-galaxy collection install -r requirements.txt
```


> fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to import the required Python library (ansible[azure] (azure >= 2.0.0)) on codespaces-058957's Python /usr/local/py-utils/venvs/ansible/bin/python. Please read the module documentation and install it in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter"}

We need directly install the deps into the venv

```sh
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade pip
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade "ansible[azure]"
```

> Apparently ansible[ansible] no longer exists, we need to ensure our collection is installed in the venv

```sh
/usr/local/py-utils/venvs/ansible/bin/python -m pip install -r \
/workspaces/cloud-resume-challenge/azure/requirements.txt
```
> This above is not working lets direct install

```sh
ansible-galaxy collection install azure.azcollection
```

## Legacy Issue

azure[ansible] says its required but its actually a stale error
and we need to manually install the Azure SDK into the python env.

/usr/local/py-utils/venvs/ansible/bin/python -m pip install \
  azure-identity \
  azure-mgmt-resource \
  azure-mgmt-storage \
  azure-mgmt-network \
  azure-mgmt-authorization \
  azure-mgmt-core \
  msrest msrestazure azure-common

## Resolving Install Issues with azure.azcollection

It turns out the the collection is not install the deps correctly.
So I created an `azure-requirements.txt` and then install it manually:

```sh
/usr/local/py-utils/venvs/ansible/bin/python -m pip install -r azure-requirements.txt
```

https://github.com/ansible-collections/azure/issues/1463#issuecomment-1964924662
https://github.com/ansible-collections/azure/blob/dev/requirements.txt


## IaC or Configuration Management for Container

In AWS a bucket should clearly be managed by IaC.
In Azure a Storage Account would be managed by IaC
but whether a container should be managed by IaC is uncertain.

We observed that Azure Bicep when renaminig our container didn't
remove the previous name one making me think that maybe containers
just like object files should be handle by ansible if containers
are not going to act idopodement within Azure Bicep