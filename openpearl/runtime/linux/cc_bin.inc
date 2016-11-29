g++ -DTARGET=1 -Wall -g  -fstack-protector -pthread -fno-non-call-exceptions -I . -I ../common -DTARGET=1  -I "/usr/local"/include $fn.cc -o $fn "/usr/local"/lib/libOpenPEARLlinux.a -pthread -lrt
