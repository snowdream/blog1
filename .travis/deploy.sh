#!/bin/bash
# stop executing if any errors occur
# stop executing if an unset variable is encountered
set -o errexit -o nounset
echo "1"
# Decrypt the private key
# openssl aes-256-cbc -K $encrypted_b9113630a4c4_key -iv $encrypted_b9113630a4c4_iv
#   -in id_rsa.enc -out ~/.ssh/id_rsa -d
  echo "2"
  
# Set the permission of the key
chmod 600 ~/.ssh/id_rsa
echo "3"

# Start SSH agent in the background
eval "$(ssh-agent -s)"
echo "4"

# Add the private key to the ssh-agent
# Enter passphrase automatically
expect >/dev/null 2>&1 << EOF
  set timeout 10
  spawn ssh-add "${HOME}/.ssh/id_rsa"
  expect {
    "Enter passphrase for" {
      send "$ssh_pass\r"
    }
  }
  expect {
    timeout { exit 1 }
    "denied" { exit 1 }
    eof { exit 0 }
  }
EOF
echo "5"

# Copy SSH config and known_hosts
cp .travis/ssh_config ~/.ssh/config
# cp .travis/ssh_known_hosts ~/.ssh/known_hosts
echo "6"
# Set Git config
git config --global user.name 'snowdream'
git config --global user.email yanghui1986527@gmail.com 
echo "7"
# Deploy with Hexo
# Hide any sensitive credential data that might otherwise be exposed
# In case of debugging you should remove those redirections to /dev/null
expect >/dev/null 2>&1 << EOF
  set timeout 600
  spawn hexo clean && hexo d -g
  expect {
    "Enter passphrase for" {
      send "$ssh_pass\r"
    }
  }
  expect {
    timeout { exit 1 }
    "denied" { exit 1 }
    eof { exit 0 }
  }
EOF
echo "8"
