## Checking Updated Nameservers

After I changed the nameservers for my third-party domain
I checked to make sure they were updated using the whois command:

```sh
sudo apt install whois
whois andrewbrownresume.net | grep "Name Server"
```