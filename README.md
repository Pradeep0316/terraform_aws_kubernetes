# terraform_aws_kubernetes
----------------------Terraform_Kubernetes_AWS----------------------------

###Steps to follow
--Configure aws credentials---(Used us-east-1 region)
1. git clone 
2. cd terraform_aws_kubernetes && cd compute 
3. create a key pair with the name of terraform-keys2 (ssh-keygen -f terraform-keys2 ) 
4. terraform init (/root/terraform_aws_kubernetes/) -------`Change the Path if youre not running from /root directory`
5. terraform plan (/root/terraform_aws_kubernetes/) . - `please change private Key location in compute/main.tf if youre nt running from /root directory`
6. terraform apply -auto-approve (/root/terraform_aws_kubernetes/)
7. Login to AWS console and get Master IP and do ssh -i "terraform-keys2" ubuntu@master-publicip and changes to root
8. Check the statuus by (kubectl get nodes )
9. Run pods from busy box image ( kubectl run busybox --image=busybox --command -- sleep 3600)
------------------------------
10 check pods status ( kubectl get pods -l run=busybox)


---To cleanup---
terraform destroy -auto-approve- (From /root/terraform_aws_kubernetes/)
