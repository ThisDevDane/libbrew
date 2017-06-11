#!/bin/bash
pushd build > /dev/null
echo Running...
echo ------------
./example.exe
echo ------------
echo Ending...
popd > /dev/null