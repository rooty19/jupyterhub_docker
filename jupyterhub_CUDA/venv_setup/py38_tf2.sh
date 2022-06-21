#!/bin/bash

pyEXEC=python3.8
venvname=py38_tf2

packages=("tensorflow==2.4.0" \
         "japanize-matplotlib" \
         "matplotlib" \
         "pandas" \
         "opencv-python" \
         "ipykernel")

links=("https://download.pytorch.org/whl/torch_stable.html")

if [ ! -d /opt/venv/${venvname} ]; then
    mkdir -p /opt/venv/${venvname}
fi

${pyEXEC} -m venv /opt/venv/${venvname}
source /opt/venv/${venvname}/bin/activate
chmod 777 /opt/venv/${venvname}/bin/activate

fline=" "
for url in ${links[@]}; do
    fline=${fline}"-f "${url}" "
done

${pyEXEC} -m pip install --upgrade pip
pip install wheel
pip install "${packages[@]}" ${fline} 
ipython kernel install --name=${venvname}
sed -i -e "s/include-system-site-packages = false/include-system-site-packages = true/" /opt/venv/${venvname}/pyvenv.cfg

deactivate

echo ${fline}
