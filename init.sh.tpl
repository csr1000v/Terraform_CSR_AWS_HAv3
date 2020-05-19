#!/bin/bash
cat <<EOF >> csr.pem
${ssh_key}
EOF
chmod 600 csr.pem 
rm csr1_status_file
until cat csr1_status_file | grep 'RUNNING'; do 
  echo 'Attempting to enable guestshell in CSRV1. Please wait, could take several minutes'
  ssh -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -i csr.pem ec2-user@${node1_public_ip} 'guestshell enable' > csr1_status_file
done
rm csr1_status_file

ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node1_public_ip} << EOF
configure terminal 
interface GigabitEthernet2 
no shutdown 
ip address ${node1_eth1_private} 255.255.255.0 
end
EOF


ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node1_public_ip} << EOF
configure terminal
crypto isakmp policy 1
encr aes 256
authentication pre-share
crypto isakmp key cisco address 0.0.0.0
echo
end

configure terminal
crypto ipsec transform-set uni-perf esp-aes 256 esp-sha-hmac
mode tunnel
end

configure terminal
crypto ipsec profile vti-1
set security-association lifetime kilobytes disable
set security-association lifetime seconds 86400
set transform-set uni-perf
set pfs group2
end

configure terminal
interface Tunnel1
ip address ${node1_tunnel1_ip_and_mask}
load-interval 30
tunnel source GigabitEthernet1
tunnel mode ipsec ipv4
tunnel destination ${node2_public_ip} 
tunnel protection ipsec profile vti-1
bfd interval 100 min_rx 100 multiplier 3
end

configure terminal
router eigrp 1
network ${tunnel1_subnet_ip_and_mask}
bfd all-interfaces
end
EOF

rm csr2_status_file
until cat csr2_status_file | grep 'RUNNING'; do 
  echo 'Attempting to enable guestshell in CSRV2. Please wait, could take several minutes'
  ssh -o ServerAliveInterval=3 -o StrictHostKeyChecking=no -i csr.pem ec2-user@${node2_public_ip} 'guestshell enable' > csr2_status_file
done
rm csr2_status_file

ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node2_public_ip} << EOF

configure terminal 
interface GigabitEthernet2 
no shutdown 
ip address ${node2_eth1_private} 255.255.255.0 
end

EOF


ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node2_public_ip} << EOF
configure terminal
interface GigabitEthernet2
no shutdown
ip address ${node2_eth1_private} 255.255.255.0
end

configure terminal
crypto isakmp policy 1
encr aes 256
authentication pre-share
crypto isakmp key cisco address 0.0.0.0
end

configure terminal
crypto ipsec transform-set uni-perf esp-aes 256 esp-sha-hmac
mode tunnel
end

configure terminal
crypto ipsec profile vti-1
set security-association lifetime kilobytes disable
set security-association lifetime seconds 86400
set transform-set uni-perf
set pfs group2
end

configure terminal
interface Tunnel1
ip address ${node2_tunnel1_ip_and_mask}
load-interval 30
tunnel source GigabitEthernet1
tunnel mode ipsec ipv4
tunnel destination ${node1_public_ip} 
tunnel protection ipsec profile vti-1
bfd interval 100 min_rx 100 multiplier 3
end

configure terminal
router eigrp 1
network ${tunnel1_subnet_ip_and_mask}
bfd all-interfaces
end
EOF

### BFD Configure on Router 1 after Router2 goes throgh initial
ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node1_public_ip} << EOF

configure terminal
redundancy
cloud-ha bfd peer ${node2_eth1_private}
end
EOF

ssh -i csr.pem -o StrictHostKeyChecking=no ec2-user@${node2_public_ip} << EOF
configure terminal
redundancy
cloud-ha bfd peer ${node1_eth1_private}
end
EOF

