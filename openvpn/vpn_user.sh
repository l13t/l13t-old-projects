#!/usr/local/bin/bash

OVPN="/usr/local/etc/openvpn"
BUILD_DIR="/usr/local/share/doc/openvpn/easy-rsa/2.0"
KEY_DIR=$BUILD_DIR"/keys/server"

U_NAME=$1
VPN_IP=$2

cd $BUILD_DIR
. ./vars
./vit.build-key vit.$U_NAME

cd $OVPN

mkdir ./users/bundles/$U_NAME
cp -R ./users/tpl/* ./users/bundles/$U_NAME
cp $KEY_DIR/vit.$U_NAME.* ./users/bundles/$U_NAME

cp ./users/bundles/$U_NAME/vit.ovpn ./users/bundles/$U_NAME/vit.ovpn.old
sed "s#\$USER#$U_NAME#g" ./users/bundles/$U_NAME/vit.ovpn.old > ./users/bundles/$U_NAME/vit.ovpn

tar cvf ./users/bundles/$U_NAME/ $U_NAME.tgz

echo "ifconfig-push $VPN_IP 255.255.255.0 192.168.200.254" > ./ccd/vit.$U_NAME

tar -pcvz $OVPN/$U_NAME.tgz ./users/bundles/$U_NAME