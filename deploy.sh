#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"

# if ! [ -n "$GITHUB_API_KEY" ]; then
#     echo "No API key given, skipping deploy"
#     exit 0
# fi

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
# if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
#     echo "Skipping deploy"
#     exit 0
# fi

echo "Starting deploy"

# Decrypt the private key using travis encrypted file service
openssl aes-256-cbc -K $encrypted_961cdb62d58f_key -iv $encrypted_961cdb62d58f_iv -in deploykey.enc -out deploykey -d
chmod 600 deploykey

# Start an ssh session and add the private key
eval `ssh-agent -s`
ssh-add deploykey

# Clone the existing repo into out/
git clone git@github.com:haskell-tools/haskell-tools.github.io out

# Clean out existing contents
rm -rf out/**/* || exit 0

# Copy generated haddock documentation
cp -r .stack-work/install/x86_64-linux/nightly-2016-09-10/8.0.1/doc out/api
cd out

git config user.name "Travis CI"
git config user.email "nboldi@elte.hu"
git config push.default simple

git add .
git commit -m "Updating the API documentation"



git push -f