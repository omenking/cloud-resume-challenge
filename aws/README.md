## Using CloudFormation

We have multiple options for IaC:
- CloudFormation
- CDK
- Terraform

We are going to use CloudFormation because its dead simple to use.

## Install Ansible

```sh
pipx install boto3 botocore
pipx install --include-deps ansible
ansible-galaxy collection install amazon.aws
```

## Edit Vault

We are going to store all of our configuration in a vault.
We don't have to, but just for learning we'll use a vault even for non-sensentive information


```sh
cd aws
ansible-vault create playbooks/vaults/prod.yml
ansible-vault edit playbooks/vaults/prod.yml
ansible-vault view playbooks/vaults/prod.yml
```

## Consideration with boto3

When trying to deploy the cloudformation template I had complaints about boto3 not being installed despite running `pip install boto3`.

It looks as though ansible creates their own Python virtual environment.

> [WARNING]: Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg. [DEPRECATION WARNING]: Param 'template' is deprecated. See the module docs for more information. This feature will be removed from collection 'amazon.aws' in a release after 2026-05-01. [ERROR]: Task failed: Module failed: Failed to import the required Python library (botocore and boto3) on codespaces-058957's Python /usr/local/py-utils/venvs/ansible/bin/python. Please read the module documentation and install it in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter Origin: /workspaces/cloud-resume-challenge/aws/playbooks/deploy.yml:13:7

We'll attempt to install directly against the ansible venv and see that resolves our issue.

```sh
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade pip
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade botocore boto3
```

## Install Deps for Ansible

```sh
ansible-galaxy collection install -r requirements.txt
```