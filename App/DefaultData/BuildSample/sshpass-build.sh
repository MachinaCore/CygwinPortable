tar xzvf sshpass-1.05.tar.gz
cp sshpass-1.05-1bl1.cygport sshpass-1.05/sshpass-1.05-1bl1.cygport
cp sshpass-1.05.tar.gz sshpass-1.05/sshpass-1.05.tar.gz
cygport ./sshpass-1.05/sshpass-1.05-1bl1.cygport all
cp sshpass-1.05/sshpass-1.05-1bl1.i686/build/sshpass.exe /bin/sshpass.exe
rm -rf sshpass-1.05
rm -rf sshpass-1.05-1bl1.i686