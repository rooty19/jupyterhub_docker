#!/bin/sh

cp /conf/ldap.conf /etc/ldap.conf
cp /conf/sssd.conf /etc/sssd/sssd.conf
chown root:root /etc/ldap.conf
chown root:root /etc/sssd/sssd.conf 
chmod 600 /etc/sssd/sssd.conf

if [ -e /var/run/sssd.pid ]; then
    rm /var/run/sssd.pid
fi

/etc/init.d/sssd start
/etc/init.d/ssh start

echo "Waiting SSSD..."
sleep 3
  
cat <<EOF >> /opt/jupyterhub_config.py
c.PAMAuthenticator.admin_groups = {'ADMIN-LDAP', 'ADMIN-GPU'}
EOF

if [ $DEBUG == 1 ]; then
    useradd -m --uid 10001 --groups sudo test && echo test:0000 | chpasswd
    mkdir /home/test/notebook && chown test:test /home/test/notebook && chsh -s /bin/bash test 
    echo 'c.Authenticator.admin_users = {"test"}' >> /opt/jupyterhub_config.py
fi

echo '#!/bin/sh' > /opt/jupyterhub_docker.sh
echo 'export PS1="\[\e[1;32m\]\u@Docker\[\e[1;36m\]\[\e[m\]:\[\e[1;36m\][ \w ]\[\e[m\]:\$ "' >> /opt/jupyterhub_docker.sh
echo 'echo "Info: 1. You are in Docker Container, your custom venv may be discarded."' >> /opt/jupyterhub_docker.sh
echo 'echo "      2. to Activate vertual env, type: source /opt/venv/<vertualenv>/bin/activate"' >> /opt/jupyterhub_docker.sh
chmod a+x /opt/jupyterhub_docker.sh

exec "$@"
