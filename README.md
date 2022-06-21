# jupyterhub-on-docker-ldap-nfs
jupyterhub-on-docker-ldap-nfs provides jupyterhub using LDAP-based authentication and /home via nfs.　<br>
certificate is disabled, so run only test enviroment

![overview](/picture/overview.svg)

# Run
1. modify sssd.conf and ldap.conf in conf/
2. edit c.PAMAuthenticator.admin_groups in entrypoint.sh
3. jupyter kernels setup script is in jupyterhub_CUDA/venv_setup/*.sh (skel is py38_blank.sh)
4. docker-compose up -d