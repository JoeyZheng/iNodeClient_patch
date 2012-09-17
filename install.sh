#!/bin/sh

CURRENT=`pwd`

if [ ! -r "/etc/iNode" ]
then
mkdir /etc/iNode
fi

if [ ! -r "./clientfiles" ]
then
mkdir ./clientfiles
fi

if [ ! -r "./conf" ]
then
mkdir ./conf
fi

if [ ! -r "./log" ]
then
mkdir ./log
fi

INODE_CFG="/etc/iNode/inodesys.conf"
[ -r "$INODE_CFG" ] && . "${INODE_CFG}"
if [ -z "$INSTALL_DIR" ]; then
    echo INSTALL_DIR=$CURRENT >> /etc/iNode/inodesys.conf
fi

if [ ! -r "/usr/lib/libstdc++.so.5" ]
then
cp -fr ./libs/std/libstdc++.so.5 /usr/lib/
fi

if [ ! -r "/usr/lib/libstdc++.so.6" ]
then
cp -fr ./libs/std/libstdc++.so.6 /usr/lib/
fi

if [ ! -r "/usr/lib/libwx_base-2.8.so.0" ]
then
cp -fr ./libs/wxWidgets/* /usr/lib/
fi

if [ ! -r "/usr/lib/libACE-5.6.1.so" ]
then
cp -fr ./libs/ace/* /usr/lib/
fi

if [ ! -r "/usr/lib/libCoreUtils.so" ]
then
cp -fr ./libs/opswat/* /usr/lib/
fi

chmod 755 ./AuthenMngService
chmod 755 ./renew.ps
chmod 755 ./enablecards.ps

OS_UBUNTU=`cat /etc/issue | grep 'Ubuntu'`

if [ "$OS_UBUNTU" != "" ]
then
iNODE_SERVICE=`cat /etc/rc.local | grep 'iNodeAuthService'`
if [ "$iNODE_SERVICE" = "" ]
then
mv -f ./iNodeAuthService_ubuntu /etc/init.d/iNodeAuthService
chmod 755 /etc/init.d/iNodeAuthService
rm -f ./iNodeAuthService
cp -fr /etc/rc.local /etc/rc.local.bak
sed -e '/^exit 0$/d' /etc/rc.local > /etc/rc.temp
echo "/etc/init.d/iNodeAuthService start" >> /etc/rc.temp
echo "exit 0" >> /etc/rc.temp
mv -f /etc/rc.temp /etc/rc.local
chmod 755 /etc/rc.local
fi
if [ ! -r "/usr/lib/libtiff.so.3" ]
then
ln -s /usr/lib/libtiff.so.4 /usr/lib/libtiff.so.3
fi
> ./enablecards.ps
else
mv -f ./iNodeAuthService /etc/init.d
chmod 755 /etc/init.d/iNodeAuthService
rm -f ./iNodeAuthService_ubuntu
chkconfig --add iNodeAuthService
chkconfig --level 35 iNodeAuthService on
fi

service iNodeAuthService start