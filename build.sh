#!/bin/sh

echo ----------------------------------------------------
echo Creating testfile in output dir ./release
echo Please verify that the file is visible!
echo Otherwise the output of this script will likely be 
echo discarded.
echo ----------------------------------------------------

rm /release/if_you_see_me_everything_works.txt
touch /release/if_you_see_me_everything_works.txt

# Clone official signal desktop repository

echo ----------------------------------------------------
echo Cloning the signal repo ...
echo ----------------------------------------------------

mkdir -p /repos/signal/
cd /repos/signal/ 
git clone https://github.com/signalapp/Signal-Desktop.git 
cd Signal-Desktop/

# Checkout latest tag that is not beta

LATEST_TAG=$(git tag | sort -V | grep -v beta | tail -n 1)

echo ----------------------------------------------------
echo Building version $LATEST_TAG
echo ----------------------------------------------------

git checkout tags/$LATEST_TAG

# Reinit nvm script 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]
\. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]
\. "$NVM_DIR/bash_completion"

# Extract expected node version from package.json and replace "target": "deb" with "target": "Appimage"

version=$(cat package.json | sed -n 's/.*"node": "\([0-9.]\+\)".*/\1/p')
abiversion=$(cat package.json | sed -n 's/.*"electron": "\([0-9.]\+\)".*/\1/p')
sed ':a;N;$!ba;s/\n/$$$$/g' package.json | sed -n 's/\("target":\s*\[\$\$\$\$\s*\)"deb"/\1"Appimage"/p' | sed 's/\$\$\$\$/\n/g' > result.txt | mv result.txt package.json

echo ----------------------------------------------------
echo Expected Nodeversion: $version
echo Expected abi-version: $abiversion
echo ----------------------------------------------------
echo Content of package.json:
cat package.json

# Set expected node version and install yarn for it

echo ----------------------------------------------------
echo nvm install $version
echo ----------------------------------------------------
nvm install $version

echo ----------------------------------------------------
echo nvm use $version
echo ----------------------------------------------------
nvm use $version

echo ----------------------------------------------------
echo npm install yarn -g
echo ----------------------------------------------------
npm install yarn -g

# Install npm packages

echo ----------------------------------------------------
echo npm install
echo ----------------------------------------------------

npm install --force

# Build Signal Desktop client

echo ----------------------------------------------------
echo yarn install --frozen-lockfile
echo ----------------------------------------------------
yarn install --frozen-lockfile

echo ----------------------------------------------------
echo yarn generate
echo ----------------------------------------------------
yarn generate

echo ----------------------------------------------------
echo yarn build-release
echo ----------------------------------------------------
yarn build-release

# Copy the finished Appimage to the release folder

echo ----------------------------------------------------
echo Finished! File build: 
echo ----------------------------------------------------

ls -al /repos/signal/Signal-Desktop/release

echo ----------------------------------------------------
echo Copying release build to output directory ./release
echo ----------------------------------------------------

cp --verbose /repos/signal/Signal-Desktop/release/Signal* /release/
