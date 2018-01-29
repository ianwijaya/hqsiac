
# Ansible Code for Deploying Hackazon and F5 WAAP in Multi-cloud Environment

## Intro
This repo contains Ansible code that can be used to automatically provision and configure Hackazon secure setup in multi-cloud environment. The objective of this work is to show how vulnerable application (Hackazon) can be attacked and compromised as well as to show how we can immediately secure it using F5 WAAP (Web Application and API protection) solution.

### Lab Topology
  ![Lab Topology](https://raw.githubusercontent.com/ianwijaya/hackazon-iac/master/README/lab-topology.png)

### Prerequisites
You need 1 machine to be provisoned as Ansible control/mgmt node (this can be your computer or another server).

#### Management Node
Operating system: Ubuntu-16.04

- Install Ansible version 2.5.0
```
pip install git+https://github.com/ansible/ansible.git@devel
```
- Install openssh-server
```
sudo apt-get update
sudo apt-get install openssh-server
```
- Create new user ('ansible') and new SSH key then copy SSH key to localhost
```
sudo adduser ansible
su - ansible
ssh-keygen
ssh-copy-id ansible@localhost
```
- Open /etc/ansible/ansible.cfg and enable/ change this line:
```
host_key_checking = False
forks= 20
```
- Allow "ansible" to "sudo" without password:
```
sudo visudo
#then append this line:
ansible  ALL=(ALL:ALL) NOPASSWD:ALL
```

#### Azure
1. Install ansible[azure]
```
pip install ansible[azure]
```

2. Credentials need to be provided. While there are many ways to do this, we're gonna use AD app and service principal ID.
There are 4 parameters need to be supplied:

***client_id***
Azure portal -> Azure Active Directory -> App Registration -> New (choose Web/API and enter arbitrary sing-on URL) -> copy application ID and use it as client_id

***secret***
From that menu, choose "Keys" menu -> fill Description and "never expires" -> save (copy the key right away or you will lose it ) -> use it as secret

***tenant***
Azure portal -> Azure Active Directory -> Properties -> Copy "Directory ID" as tenant

***subscription_id***
Azure portal -> more services , type subscription -> copy subscription ID

Don't forget to add your apps to a role by navigating to Subscription  -> IAM -> Add -> Role : Contributor/Owner, then type your app name on select box, then hit save.

```
[default]
client_id=xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx
secret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
tenant=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx
subscription_id=xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx
```

Save it to "~/.azure/credentials" (it has to be in home directory, pls create if it doesn't exist). Refer to this url for detail explanation:
https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal

3. F5 WAAP also need to be enabled for programmatic deployment. You need to acknowledge the subscription terms.
To do this, search "F5" in the marketplace, choose "F5 BIG-IP ADC+SEC BEST 25M Hourly" and click the link "want to deploy programmatically ?" hit enable and save.  

4. Edit vars.yml
Change these parameters

***ssh_key***
cat .ssh/id_rsa.pub then copy the value to this var

***admin_username***
change to desired username

***admin_password***
give the username a password

***storage_account***
must be unique ID (pick a unique string), all with lower case and no special character

***namespace***
Please pick global unique name

5. make azure_rm.py executable
```
chmod u+x inventory/azure_rm.py
```
6. Play it
```
$ansible-playbook main.yml
```
## Built with

* Ansible (https://www.ansible.com)
* Ubuntu (https://www.ubuntu.com/)
* Azure (https://azure.microsoft.com)
* Maxmind GeoLite(https://www.maxmind.com)
* Hackazon (https://github.com/rapid7/hackazon)
* F5 BIG-IP (https://www.f5.com)
* ELK (https://www.elastic.co)
* Atom (https://atom.io/)

## Versioning
Devel 1.0.2

## Authors
wijaya.ian@gmail.com
