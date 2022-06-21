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
/etc/init.d/sshd start
/etc/init.d/ssh start

echo "Waiting SSSD..."
sleep 3
  
cat <<EOF >> /opt/jupyterhub_config.py
c.PAMAuthenticator.admin_groups = {'ADMIN-LDAP', 'ADMIN-GPU'}
EOF

echo '#!/bin/sh' > /opt/jupyterhub_docker.sh
echo 'export PS1="\[\e[1;32m\]\u@Docker\[\e[1;36m\]\[\e[m\]:\[\e[1;36m\][ \w ]\[\e[m\]:\$ "' >> /opt/jupyterhub_docker.sh
echo 'echo "Info: 1. You are in Docker Container, your custom venv may be discarded."' >> /opt/jupyterhub_docker.sh
echo 'echo "      2. to Activate vertual env, type: source /opt/venv/<vertualenv>/bin/activate"' >> /opt/jupyterhub_docker.sh
chmod a+x /opt/jupyterhub_docker.sh

exec "$@"
