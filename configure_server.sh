#!/bin/bash

network(){

public_eth=eth0
openvpn_tunnel=tun1
openvpn_subnet=10.8.0.0/24

#Enable IP forward
echo 1 > /proc/sys/net/ipv4/ip_forward #runtime
sed -i "s/*.net.ivp4.ip_forward.*/net.ipv4.ip_forward = 1/" /etc/sysctl.conf #permanent

#IPTABLES: default rules
iptable_rules="iptables -A INPUT -p tcp --dport 443,80 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -P INTPUT DROP
iptables -P FORWARD DROP"

#IPTABLES: ADD RULES: first see if the iptable rule exists before adding the rule (avoid duplicate rules).
for rule in "${iptable_rules}"; do
  if `echo "${rule}" | sed -e "s/-A/-C/" | xargs`; then
    echo "IPTABLES: RULE EXIST: ${rule}"
  else
    echo "${rule}" | xargs
  fi
done

#IPTABLES: OpenVPN rules
iptables -A FORWARD -i $public_eth -o $openvpn_tunnel -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s $openvpn_subnet -o $public_eth -j ACCEPT
iptables -t nat -A POSTROUTING -s $openvpn_subnet -o $public_eth -j MASQUERADE
}

# Install packages
yum_install_packages(){
  yum --assumeyes install \
    patch \
    autoconf \
    jq \
    unzip \
    wget \
    vim \
    nginx \
    certbot \
    openvpn \
    nc \
    tcpdump \
    git \
    fail2ban \
    whois \
    tree \
    tmux 
}

yum_add_repo(){
  yum install --assumeyes epel-release yum-utils
  yum repolist
  
  yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo
}

install_docker(){
  yum --assumeyes install  docker-ce docker-ce-cli containerd.io
}

install_node(){
  node_version="node-v14.8.0-linux-x64.tar.xz"
  wget -O /tmp/${node_version} https://nodejs.org/dist/v14.8.0/${node_version}
  tar -C /usr/ --strip-components=1 -xf ${node_version%.tar.xz}/bin \
                                        ${node_version%.tar.xz}/lib \
                                        ${node_version%.tar.xz}/share
}

install_yarn(){
  npm install -g yarn
}

systemd_services(){
  systemctl {enable,start} docker
  systemctl {enable,start} nginx
}

usage(){
  echo 'Add an option using the following format: ./script option'
  echo '1. Add User.'
  echo '2. Remove User.'
  echo '3. Build.'
  echo '4. Run Initial Setup.'
  exit
}

while [[ $# -gt 0 ]]; do
    arg_1="$1"
    arg_2="$2"
    case $arg_1 in
        --configure-everything)
        configure_everything=true
        ;;
        --configure-iptables)
        configure_iptables=true
        ;;
        --yum-install-packages)
        yum_install_packages=true
        ;;
    esac

    case $arg_2 in
    config)
    echo test
    ;;
    esac
    shift

done

if [ $configure_everything ]; then
  yum_add_repo
  yum_install_packages
  install_docker
  install_node
  install_yarn
  systemd_services
  network
fi


if [ $configure_iptables ]; then
  network
fi

if [ $yum_install_packages ]; then
  yum_install_packages
fi
