#!/bin/bash
OTM=libbrew.otm
SRC=src/example.odin

build_success(){
	mv -f ./src/*.exe ./build
	echo Build Success
	rm -f src/*.ll
	rm -f src/*.bc
	rm -f src/*.obj
	otime.exe -end $OTM $ERR
}

build_failed(){
	echo Build Failed
	otime.exe -end $OTM $ERR
}

if [ ! -d "build" ]; then
	mkdir build
fi

otime.exe -begin $OTM
echo Compiling with opt=$1...
odin.exe build $SRC -opt=$1
ERR=$?
if [ $ERR -eq 0 ]; then
	build_success
else
	build_failed
fi