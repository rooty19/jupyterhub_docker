FROM nvidia/cuda:11.0-base

LABEL maintainer="rooty19 <rooty19@outlook.com>" \
      version="cuda-11.0-2206"

USER root

ENV DEBIAN_FRONTEND noninteractive

# GPG key update: https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/
RUN apt-key del 7fa2af80 \
 && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub \
 && apt-get update \
 && apt-get install -yq locales \
 && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
 && apt-get install -yq software-properties-common \
 && add-apt-repository ppa:deadsnakes/ppa \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    ca-certificates \
    python3-dev \
    python3-pip \
    python3-pycurl \
    libgl1-mesa-dev \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-wheel \
    python3.6 \
    python3.6-venv \
    wget \
    neofetch \
    sssd \
    libpam-sss \
    libnss-sss \
    curl\
    cmake \
    pkg-config \
    git \
    python-is-python3 \
    openssh-server \
    cracklib-runtime \
    x11-apps \
    sl \
    screen \
 # jupyter-matplotlib requires >=nodejs-12.0
 && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt install nodejs \
 && npm install -g npm \
 && npm install -g configurable-http-proxy \
 && python3 -m pip install --upgrade setuptools pip wheel \
 && pip install jupyterhub jupyterlab jupyterlab_nvdashboard ipympl\
 && jupyter labextension install @jupyter-widgets/jupyterlab-manager && jupyter labextension install jupyter-matplotlib \
# Python3.6's Pip on Ubuntu20.04: https://qiita.com/todotani/items/6589b0184ef0ba9f3e6f
 && wget http://archive.ubuntu.com/ubuntu/pool/main/p/python3-stdlib-extensions/python3-distutils_3.6.5-3_all.deb \
 && dpkg -x python3-distutils_3.6.5-3_all.deb / \
 && ln -s /usr/lib/python3/dist-packages/apt_pkg.cpython-38-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so \
 && echo "dash dash/sh boolean false" | debconf-set-selections \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# venvs install
COPY venv_setup/ /tmp/venv_setup/
RUN for e in `ls /tmp/venv_setup/ | grep -e .sh\$`; do chmod +x /tmp/venv_setup/${e} && /tmp/venv_setup/${e} ; done

# jupyterhub settings
RUN if [ ! -d /usr/local/share/jupyter/lab/settings ];then mkdir /usr/local/share/jupyter/lab/settings; fi \
 && echo -e '{\n\
  "@jupyterlab/apputils-extension:themes": {\n\
    "theme": "JupyterLab Dark"\n\
  }\n\
}\n'> /usr/local/share/jupyter/lab/settings/overrides.json \
&& cd /opt/ && jupyterhub jupyterhub --generate-config \
&& echo -e "c.Spawner.default_url = 'lab' \n\
c.Spawner.notebook_dir = '/home/{username}' \n" > /opt/jupyterhub_config.py

# sshd/pam settings
RUN   sed -i 's!^#Port.*!Port 8022!' /etc/ssh/sshd_config \
  &&  sed -i 's!^#PubkeyAuthentication!PubkeyAuthentication!' /etc/ssh/sshd_config \
  &&  sed -i 's!^#AuthorizedKeysCommandUser!AuthorizedKeysCommandUser!' /etc/ssh/sshd_config \
  &&  sed -i 's!^#AuthorizedKeysCommand.*!AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys!' /etc/ssh/sshd_config \
  &&  sed -i 's!^#PasswordAuthentication.*!PasswordAuthentication no!' /etc/ssh/sshd_config \
  &&  sed -i 's!^#AuthorizedKeysFile.*!AuthorizedKeysFile none!' /etc/ssh/sshd_config \
  &&  echo "session required pam_mkhomedir.so skel=/home/skel/ umask=0022" >> /etc/pam.d/common-session \
  &&  mkdir /conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

WORKDIR /opt/
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh" ]
CMD ["jupyterhub"]
