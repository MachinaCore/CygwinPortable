MACHINE_TYPE=`uname -m`
echo $MACHINE_TYPE

tar xzvf sshpass-1.06.tar.gz
cp sshpass-1.06-1bl1.cygport sshpass-1.06/sshpass-1.06-1bl1.cygport
cp sshpass-1.06.tar.gz sshpass-1.06/sshpass-1.06.tar.gz
cygport ./sshpass-1.06/sshpass-1.06-1bl1.cygport all
cp sshpass-1.06/sshpass-1.06-1bl1.$MACHINE_TYPE/build/sshpass.exe /bin/sshpass.exe
rm -rf sshpass-1.06
rm -rf sshpass-1.06-1bl1.$MACHINE_TYPE