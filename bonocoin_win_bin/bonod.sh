#!/bin/bash

echo "bonod"
echo $(
wine ./bin/bonocoind.exe -printtoconsole -conf=$PWD -datadir=$PWD/data
)
