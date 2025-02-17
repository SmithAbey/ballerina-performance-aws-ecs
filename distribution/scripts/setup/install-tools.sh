#!/bin/bash -e
# Copyright (c) 2020, WSO2 Inc. (http://wso2.org) All Rights Reserved.
#
# WSO2 Inc. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# ----------------------------------------------------------------------------
# Script to install tools required.
# ----------------------------------------------------------------------------

# Make sure the script is running as root.
if [ "$UID" -ne "0" ]; then
    echo "You must be root to run $0. Try following"
    echo "sudo $0"
    exit 9
fi

# Install AWS CLI
awscli_url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
curl $awscli_url -o $DOWNLOADS_DIR/awscliv2.zip
bsdtar -C $HOME_DIR -xvf $DOWNLOADS_DIR/awscliv2.zip
$HOME_DIR/aws/install
aws --version

# Install Maven
if ! command -v mvn >/dev/null 2>&1; then
    apt -y install maven
fi
mvn -v
