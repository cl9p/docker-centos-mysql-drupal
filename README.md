Directions
==========

1. Create a virtual machine and install docker on it: [CloudCounselor Install Guide](http://cloudcounselor.com/2013/12/05/docker-0-7-redhat-centos-6-5/)
2. Install Git

        yum install git

3. Change to your users home directory

		cd {$HOME}
		
4. Clone the repository

		git clone https://github.com/cl9p/docker-centos-mysql-drupal.git
		
5. Run the Dockerfile

		docker build -t {$USER}/drupal-mysql .
		
6. Run **supervisord**

		docker run -p 80:80 -t -i {$USER}/drupal-mysql supervisord
		
7. From the base VM, make sure you open up port 80

		iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
		
8. Check you VMs IP_ADDR

		ifconfig -a
		
9. Open a browser to your VMs IP_ADDR and you should see the screens for setting up drupal

Notes
=====

* The drupal database server is called **drupaldb** and the username is **drupal** and the password is **drupal**
* When you shut down the container, all of your data will be lost.  To learn how to modify the Dockerfile to enable local filesystem access, check out this link: [Docker VOLUME](http://docs.docker.io/en/latest/use/builder/#volume).  When you do this, you will also need to modify the mysql configuration at ``/etc/my.cnf``.

Handy Scripts
=============

Should you run into issues setting up your container and image, use these scripts to automatically remove them so you can test your Dockerfile

* Remove all containers
		
		docker rm $(docker ps -a -q)

* Remove all images

		docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
