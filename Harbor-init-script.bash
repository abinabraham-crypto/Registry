#!/bin/bash

echo "------Pre-req checking------"
echo ""

docker version
sleep 10

echo ""

docker-compose --version
sleep 10

echo ""

openssl version
sleep 10

echo ""
echo "------Pre-req checking finished !!!------"
echo ""

echo "------Installing docker compose------"
echo ""

mkdir -p /data/registry
cd /data/registry
wget https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64
sleep 20
mv docker-compose-linux-x86_64 docker-compose
chmod +x docker-compose
cp docker-compose /usr/local/bin/
sleep 10

echo ""
echo "------Checking installation status------"
echo ""

docker-compose --version
sleep 10

echo ""
echo "------Docker compose installation done------"
echo ""
sleep 10
echo "------Starting Harbor installation------"
echo ""
sleep 10
echo "------Downloading installation binary------"
echo ""

wget https://github.com/goharbor/harbor/releases/download/v2.3.3/harbor-offline-installer-v2.3.3.tgz
sleep 30

echo ""
echo "------Extracting installation binary------"
echo ""
tar xzvf harbor-offline-installer-v2.3.3.tgz
sleep 10
echo ""
echo "------Extraction completed------"
sleep 10
echo ""
echo "------Generating certificates------"

openssl genrsa -out ca.key 4096
sleep 10
openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/CN=harbor.vismaya.local" -key ca.key -out ca.crt
sleep 10
openssl genrsa -out harbor.vismaya.local.key 4096
sleep 10
openssl req -sha512 -new -subj "/CN=harbor.vismaya.local" -key harbor.vismaya.local.key -out harbor.vismaya.local.csr
sleep 10

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harbor.vismaya.local
DNS.2=harbor.vismaya
DNS.3=localhost
EOF

sleep 10
openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in harbor.vismaya.local.csr -out harbor.vismaya.local.crt
sleep 10
mkdir -p /data/cert
cp harbor.vismaya.local.crt /data/cert/
cp harbor.vismaya.local.key /data/cert/
openssl x509 -inform PEM -in harbor.vismaya.local.crt -out harbor.vismaya.local.cert
sleep 10
mkdir -p /etc/docker/certs.d/harbor.vismaya.local
cp harbor.vismaya.local.cert /etc/docker/certs.d/harbor.vismaya.local/
cp harbor.vismaya.local.key /etc/docker/certs.d/harbor.vismaya.local/
cp ca.crt /etc/docker/certs.d/harbor.vismaya.local/
systemctl restart docker
cp /data/registry/harbor/harbor.yml.tmpl /data/registry/harbor/harbor.yml
mkdir -p /var/log/harbor/
sleep 10
echo ""
echo "------Certificate generated------"
sleep 10
echo ""
echo "------Please continue to Harbor configuration------"