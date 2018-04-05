#keys
for i in $hosts; do ssh-copy-id $i; done
for i in $hosts; do scp /etc/hosts $i:/etc/hosts; done

#repos
for i in $hosts; do scp /etc/apt/sources.list.d/sources.list $i:/etc/apt/sources.list.d/sources.list; done
for i in $hosts; do scp /etc/apt/sources.list.d/alt.list $i:/etc/apt/sources.list.d/alt.list; done
for i in $hosts; do ssh $i apt-get update; done

#update
for i in $hosts; do ssh $i apt-get dist-upgrade -y; done
for i in $hosts; do ssh $i update-kernel; done
for i in $hosts; do ssh $i init 6; done
for i in $hosts; do ssh $i uname -r; done

#ntp
for i in $hosts; do ssh $i apt-get install ntpd -y; done
for i in $hosts; do ssh $i chkconfig ntpd on; done
for i in $hosts; do scp /etc/ntpd.conf $i:/etc/ntdp.conf; done
for i in $hosts; do ssh $i service ntpd start; done

#zabbix
for i in $hosts; do ssh $i apt-get install zabbix-agent -y; done
for i in $hosts; do ssh $i chkconfig zabbix_agentd on; done
for i in $hosts; do ssh $i sed -i 's/^Server=127.0.0.1/Server=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/^ServerActive=127.0.0.1/ServerActive=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/.localdomain//g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i service zabbix_agentd start; done

#postgres
#for i in $dbs; do scp /etc/apt/sources.list.d/pgpro.list $i:/etc/apt/sources.list.d/pgpro.list; done
for i in $dbs; do ssh $i apt-get update; done
for i in $dbs; do ssh $i apt-get update; done

#tablespaces
for i in $dbs; do ssh mkdir /var/lib/pgsql/9.6/pts/{fdc_pts_big_ind,fdc_pts_big_tab,fdc_pts_ind,fdc_pts_tab} -p; done
for i in $dbs; do ssh $i mkdir /var/lib/pgsql/9.6/pts/{fdc_trans_ind,fdc_trans_tab} -p; done
for i in $dbs; do ssh $i chown postgres.postgres /var/lib/pgsql/9.6/pts -R; done

#tomcat
for i in $apps; do ssh $i useradd tomcat; done
for i in $apps; do ssh $i mkdir /root/distr /u01; done
for i in $apps; do scp /root/distr/jdk-8u161-linux-x64.tar.gz  $i:/root/distr/jdk-8u161-linux-x64.tar.gz; done
for i in $apps; do scp /root/distr/apache-tomcat-8.5.29.tar.gz  $i:/root/distr/apache-tomcat-8.5.29.tar.gz; done
for i in $apps; do ssh $i tar -xf /root/distr/jdk-8u161-linux-x64.tar.gz -C /u01; done
for i in $apps; do ssh $i tar -xf /root/distr/apache-tomcat-8.5.29.tar.gz -C /u01; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/jdk1.8.0_161 -R; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/apache-tomcat-8.5.29 -R; done
for i in $apps; do ssh $i mkdir /u01/apache-tomcat-8.5.29/logs -p; done
for i in $apps; do scp /root/distr/tomcat_users  $i:/u01/apache-tomcat-8.5.29/conf/tomcat-users.xml; done
for i in $apps; do scp /root/distr/tomcat.service  $i:/etc/systemd/system/tomcat.service; done
for i in $apps; do scp /root/distr/manager_context  $i:/u01/apache-tomcat-8.5.29/webapps/manager/META-INF/context.xml; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/apache-tomcat-8.5.29/webapps/manager/META-INF/context.xml; done