run on base_vm 
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

handy scripts

docker rm $(docker ps -a -q)

docker rmi $(docker images | grep "^<none>" | awk "{print $3}")