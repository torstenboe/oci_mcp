### Tenant details oscemea005
tenancy                 = "oscemea005"
tenancy_ocid            = "..."
### User
user_ocid               = "..."
### Compartment Name
compartment_ocid        = "..."
### API Fingerprint
fingerprint             = "..."
### Path to private API key
private_key_path        = "/Users/User/.oci/your_api_key.pem"
### Region we work in
region                  = "eu-frankfurt-1"
### Authorized public IPs ingress
### you can limit access by assigning e.g. 90.119.107.2/32
### considering that this IP is your current public IP
### you can validate your current public IP by opening http://iplocation.net in your browser
### if you put above example only you woudl be able to ssh in after deployment
authorized_ips          = "0.0.0.0/0"
### Variables for VM Creation
#BootStrapFile_ol7       = "userdata/bootstrap_ol7"
ssh_public_key     = "/Users/User/.ssh/yourkey.pub)"
ssh_private_key    = "/Users/User/.ssh/yourkey)"
