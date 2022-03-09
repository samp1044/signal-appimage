#!/bin/sh

# Clone official signal desktop repository

mkdir -p /repos/signal/
cd /repos/signal/ 
git clone https://github.com/signalapp/Signal-Desktop.git 
cd Signal-Desktop/

# Reinit nvm script 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]
\. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]
\. "$NVM_DIR/bash_completion"

# Extract expected node version from package.json and replace "target": "deb" with "target": "Appimage"

version=$(cat package.json | sed -n 's/.*"node": "\([0-9.]\+\)".*/\1/p')
sed ':a;N;$!ba;s/\n/$$$$/g' package.json | sed -n 's/\("target":\s*\[\$\$\$\$\s*\)"deb"/\1"Appimage"/p' | sed 's/\$\$\$\$/\n/g' > result.txt | mv result.txt package.json

# Set expected node version and install yarn for it

nvm install $version
nvm use $version

npm install yarn -g

# Build Signal Desktop client

yarn install --frozen-lockfile
yarn generate
yarn build-release

# Copy the finished Appimage to the release folder

cp /repos/signal/Signal-Desktop/release/Signal* /release/
