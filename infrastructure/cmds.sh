#!/bin/bash

if [[ -z ${1} ]]; then
  echo 'Add an option using the following format: ./script option'
  echo '1. Add User.'
  echo '2. Remove User.'
  echo '3. Build Docker Image.'
  exit
fi

# Use input to run the respective case. 
case ${1} in
# User Add Case
1 | add)
if [[ -z ${2} ]]; then
  echo 'No Username Specified'
  exit
fi
cat << EOF > /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
client
proto udp
explicit-exit-notify
remote vpn.tattva.network 1194
dev tun1
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
verify-x509-name server_UZRWId2a81LLgsXf name
auth SHA256
auth-nocache
cipher AES-128-GCM
tls-client
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
ignore-unknown-option block-outside-dns
setenv opt block-outside-dns # Prevent Windows 10 DNS leak
verb 3
EOF

easyrsa build-client-full ${2} nopass
echo "<ca>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
cat /etc/openvpn/easy-rsa/pki/ca.crt >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "</ca>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "<cert>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
awk "/-----BEGIN CERTIFICATE-----/,EOF" /etc/openvpn/easy-rsa/pki/issued/${2}.crt >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "</cert>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "<key>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
cat /etc/openvpn/easy-rsa/pki/private/${2}.key >> /etc/openvpn/easy-rsa/vpn_users${2}.ovpn
echo "</key>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "<tls-crypt>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
cat /etc/openvpn/easy-rsa/tls-crypt.key >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
echo "</tls-crypt>" >> /etc/openvpn/easy-rsa/vpn_users/${2}.ovpn
;;
 
# User Remove Case
2 | remove) 
if [[ -z ${2} ]]; then
  echo 'No Username Specified'
  exit
fi
echo "====Revoking User===="
echo yes | easyrsa revoke ${2}
echo "====Generating CRL and copying to infrastructure===="
easyrsa gen-crl
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/server/
;;

# Build Case
3 | build)  echo "Building...";
set -ue
master_key=${MASTER_KEY_PATH? "Set environment variable MASTER_KEY_PATH"};
input=${1? "Param missing for Docker Image Tag"};
git clone https://github.com/tattva-network/vpn.tattva.network.git rails_app
cp ${master_key} rails_app/config/
docker build -t ${1} .
rm -rf ./rails_app
set +ue
;;

# Invalid Option Case
*) echo "Invalid Option. Please see valid options below: ";
  echo '1. Add User.'
  echo '2. Remove User.'
  echo '3. Build Docker Image.'
exit
;;

esac;