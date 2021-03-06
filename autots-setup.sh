#!/bin/bash

#Set up directories: conf_opt  conf_search  input  lowest_ts  ts_guess  utilities
workdir=`pwd`
if test -f input/ts_guess-list.txt
    then
   # rm input/ts_guess-list.txt
    sed -i '1,/#local workflow variables/!d' utilities/config.py
   # find ./ -name "*energies.txt" -delete
   # find ./ -name "*-resubmit.txt" -delete
   # find ./ -name "*-tier*txt" -delete
  #  find ./ -name "LOWEST_TS_NOTFOUNDBYCREST" -delete
  #  find ./ -name "*complete" -delete
  #  find ./ -name "freqonly" -delete
  #  find ./ -name "*output.txt" -delete
elif compgen -G "*log" > /dev/null 
    then
    mkdir utilities
    mkdir input
    mkdir ts_guess
    mkdir conf_search
    mkdir conf_opt
    mkdir lowest_ts
    mv *log input/
    rename "tier" "TIER" input/*log
    rename "tier" "TIER" input/*xyz
    rename "conf" "CONF" input/*log
    rename "conf" "CONF" input/*xyz
    for i in input/*log 
        do
        echo -e "$workdir/$i V1 175 R1   90 R2   0\n$workdir/$i V1 175 R1   90 R2 180\n$workdir/$i V1 175 R1  180 R2  90\n$workdir/$i V1 175 R1  180 R2 180\n$workdir/$i V1 175 R1  -90 R2   0\n$workdir/$i V1 175 R1  -90 R2  90" >> input/ts_guess-list.txt
        echo -e "$workdir/$i V2 175 R1   90 R2   0\n$workdir/$i V2 175 R1   90 R2 180\n$workdir/$i V2 175 R1  180 R2  90\n$workdir/$i V2 175 R1  180 R2 180\n$workdir/$i V2 175 R1  -90 R2   0\n$workdir/$i V2 175 R1  -90 R2  90" >> input/ts_guess-list.txt

done

elif compgen -G "*xyz" > /dev/null
    then
    mkdir utilities
    mkdir input
    mkdir ts_guess
    mkdir conf_search
    mkdir conf_opt
    mkdir lowest_ts
    mv *xyz input/
    rename "tier" "TIER" input/*log
    rename "tier" "TIER" input/*xyz
    rename "conf" "CONF" input/*log
    rename "conf" "CONF" input/*xyz
    for i in input/*xyz
        do
        echo -e "$workdir/$i V1 175 R1   90 R2   0\n$workdir/$i V1 175 R1   90 R2 180\n$workdir/$i V1 175 R1  180 R2  90\n$workdir/$i V1 175 R1  180 R2 180\n$workdir/$i V1 175 R1  -90 R2   0\n$workdir/$i V1 175 R1  -90 R2  90" >> input/ts_guess-list.txt
        echo -e "$workdir/$i V2 175 R1   90 R2   0\n$workdir/$i V2 175 R1   90 R2 180\n$workdir/$i V2 175 R1  180 R2  90\n$workdir/$i V2 175 R1  180 R2 180\n$workdir/$i V2 175 R1  -90 R2   0\n$workdir/$i V2 175 R1  -90 R2  90" >> input/ts_guess-list.txt
done

else
    echo "AUTOS"
    echo " "
    echo "Error while setting up autots"
    echo "There is no log file or existing autots in this directory"
    echo " "
    exit 1

fi

cp /home/$USER/autots/config.py  utilities/
cp /home/$USER/autots/generate-inputs.py utilities/
cp /home/$USER/autots/get-lowest.sh utilities/
cp /home/$USER/autots/start.sh ./
cp /home/$USER/autots/xyz2com.py utilities/
cp /home/$USER/autots/orca2xyz.py utilities/

echo "maindir='$workdir'" >> utilities/config.py
echo "utilities='$workdir/utilities'" >> utilities/config.py
echo "ts_guess='$workdir/ts_guess'" >> utilities/config.py
echo "conf_search='$workdir/conf_search'" >> utilities/config.py
echo "lowest_ts='$workdir/lowest_ts'" >> utilities/config.py
echo "conf_opt='$workdir/conf_opt'" >> utilities/config.py
echo "inputdir='$workdir/input'" >> utilities/config.py

cd input
python3 ../utilities/generate-inputs.py -l ts_guess-list.txt $1
