#!/bin/bash

target=$1

applu=();
ipcApplu=();
art=();
ipcArt=();
gzip=();
ipcGzip=();
mesa=();
ipcMesa=();
twolf=();
ipcTwolf=();

salida="$3"
config="./auto/config.txt"
params="$2"
echo "IPC; Miss_rate" > "$salida"

	
configIni=$(cat "$config")
echo "$configIni"


j=0
while IFS= read -r linea; do	
	echo "Iter: $j"
	let j+=1
	tempConfig=$(echo "$configIni" | grep -v "$1")
	echo "$tempConfig" > "$config"
	echo "$linea" >> "$config"
	cat "$config"

salidaTemp=$(./sim-outorder -config "$config" ../../Benchmark/applu/exe/applu.exe <  ../../Benchmark/applu/data/ref/applu.in 2>&1 > /dev/null)

echo "Completed Applu emulation"
#echo "IPC: $(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')" >> "$salida"
applu+=("$(echo "$salidaTemp" | grep "${target}.miss_rate" | awk '{print $2}')")
ipcApplu+=("$(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')")


salidaTemp=$(./sim-outorder -config "$config" ../../Benchmark/art/exe/art.exe -scanfile ../../Benchmark/art/data/ref/c756hel.in -trainfile1 ../../Benchmark/art/data/ref/a10.img -trainfile2 ../../Benchmark/art/data/ref/hc.img -stride 2 -startx 110 -starty 200 -endx 160 -endy 240 -objects 10 2>&1)

echo "Completed Art emulation"
#echo "IPC: $(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')" >> "$salida"
art+=("$(echo "$salidaTemp" | grep "${target}.miss_rate" | awk '{print $2}')")
ipcArt+=("$(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')")

salidaTemp=$(./sim-outorder -config "$config" ../../Benchmark/gzip/gzip/exe/gzip.exe ../../Benchmark/gzip/gzip/data/ref/control 2>&1 > /dev/null)

echo "Completed Gzip emulation"
#echo "IPC: $(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')" >> "$salida"
gzip+=("$(echo "$salidaTemp" | grep "${target}.miss_rate" | awk '{print $2}')")
ipcGzip+=("$(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')")


salidaTemp=$(./sim-outorder -config "$config" ../../Benchmark/mesa/exe/mesa.exe  -frames 10 -meshfile ../../Benchmark/mesa/data/ref/mesa.in -ppmfile ../../Benchmark/mesa/data/ref/mesa.ppm 2>&1 > /dev/null)


echo "Completed Mesa emulation"
#echo "IPC: $(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')" >> "$salida"
mesa+=("$(echo "$salidaTemp" | grep "${target}.miss_rate" | awk '{print $2}')")
ipcMesa+=("$(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')")


salidaTemp=$(./sim-outorder -config "$config" ../../Benchmark/twolf/exe/twolf.exe ../../Benchmark/twolf/data/ref/ref 2>&1 > /dev/null)

echo "Completed Twolf emulation"
#echo "IPC: $(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')" >> "$salida"
twolf+=("$(echo "$salidaTemp" | grep "${target}.miss_rate" | awk '{print $2}')")
ipcTwolf+=("$(echo "$salidaTemp" | grep "sim_IPC" | awk '{print $2}')")

done < "$params"

echo "$configIni" > "$config"

i=0
echo "APPLU:" >> "$salida"
for elem in "${applu[@]}"; do	
	echo "${ipcApplu[$i]} $elem" >> "$salida"
	let i+=1
done

i=0
echo "ART:" >> "$salida"
for elem in "${art[@]}"; do	
	echo "${ipcArt[$i]} $elem" >> "$salida"
	let i+=1
done

i=0
echo "GZIP:" >> "$salida"
for elem in "${gzip[@]}"; do
	echo "${ipcGzip[$i]} $elem" >> "$salida"
	let i+=1
done

i=0
echo "MESA:" >> "$salida"
for elem in "${mesa[@]}"; do
	echo "${ipcMesa[$i]} $elem" >> "$salida"
	let i+=1
done

i=0
echo "TWOLF:" >> "$salida"
for elem in "${twolf[@]}"; do	
	echo "${ipcTwolf[$i]} $elem" >> "$salida"
	let i+=1
done


