#!/bin/bash
SEC_GROUP=$(aws ec2 describe-security-groups --output=json | jq '.SecurityGroups | .[] | select(.GroupName=="cloudflare-whitelist") | .GroupId' | cut -d '"' -f2)

# Download new list and compare with existing, if differs update the rules
curl -s https://www.cloudflare.com/ips-v4 | sort > /tmp/new_cloudflare_ip.list

aws ec2 describe-security-groups | jq '.SecurityGroups | .[] | select(.GroupName=="cloudflare-whitelist") | .IpPermissions' | grep CidrIp | awk -F"\"" '!a[$4]++{print $4}' | sort > cloudflare_ip.list

diff -iwB /tmp/new_cloudflare_ip.list cloudflare_ip.list > /tmp/cloudflare_ip_diff.list

if [ "$(wc -l /tmp/cloudflare_ip_diff.list)" != "0" ]; then
  mv /tmp/new_cloudflare_ip.list cloudflare_ip.list

  awk -v SEC_GROUP=$SEC_GROUP '{
    if ($1 == "<") {
      printf "aws ec2 authorize-security-group-ingress --group-id %s --protocol tcp --port 80 --cidr %s\n", SEC_GROUP, $2;
      printf "aws ec2 authorize-security-group-ingress --group-id %s --protocol tcp --port 443 --cidr %s\n", SEC_GROUP, $2
    }
    if ($1 == ">") {
      printf "aws ec2 revoke-security-group-ingress --group-id %s --protocol tcp --port 80 --cidr %s\n", SEC_GROUP, $2
      printf "aws ec2 revoke-security-group-ingress --group-id %s --protocol tcp --port 443 --cidr %s\n", SEC_GROUP, $2
    }
  }' /tmp/cloudflare_ip_diff.list | /bin/bash > /dev/null

  echo "There are next changes: "
  grep -e "^<" /tmp/cloudflare_ip_diff.list | sed "s#^<#Added:   #g"
  grep -e "^>" /tmp/cloudflare_ip_diff.list | sed "s#^>#Removed: #g"

else
  exit
fi

