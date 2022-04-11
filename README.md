# Install and configure Hadoop & other components

### [install]
1. let's assume you have 3 hosts  hadoop001/hadoop002/hadoop003; 
and already configured access each other with ssh key.
2. download or clone this project in all 3 hosts, copy all files to /opt, which will be our destination folder; 
3. get into /opt, download packages by run ./download.sh;
download jdk-8u231-linux-x64.tar.gz manually and save to software folder;
4. run "./install.sh 1" on hadoop001, this action will install packages into /opt/module; <br/>
   run "./install.sh 2" on hadoop002;<br/>
   run "./install.sh 3" on hadoop003;<br/>
5. run "./start.sh" on hadoop001 to start all services on three hosts;
