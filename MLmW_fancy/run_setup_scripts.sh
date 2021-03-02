#!/bin/bash


TEMP=288
PRES=1
MODEL='ML'
DIR="${TEMP}K"
LOG="${MODEL}_densities.log"


ICE_INPUT='in.setup_ice'
N_ice=4608   # Number of ice molecules

mkdir ${DIR}
cp in.setup_ice_template ${DIR}/${ICE_INPUT}
cd ${DIR}

# put temperature and pressure variable into ice script - lines 15 and 16, column 4

# set temperatures
sed -i -E "15 s/[0-9]+/${TEMP}/" ${ICE_INPUT}
# set pressure
sed -i -E "16 s/[0-9]+/${PRES}/" ${ICE_INPUT}

# Run ice setup
mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${ICE_INPUT}

# log density of the ice, lines 42 - 1042, volume is field 4
ICE_LOG="log.run_ice_${TEMP}K_${PRES}atm_${MODEL}"
ice_volume=`awk '{ if (NR > 42 && NR < 1042) sum += $4; n++ } END { if (n > 0) print sum / n; }' ${ICE_LOG}`
ice_density=$(expr ${N_ice} / ${ice_volume} )

echo "Ice density ${TEMP}K ${PRES}atm ${MODEL} : ${ice_volume}" >> ../${LOG}

# get y and z dims from line 7 and x 
# edit liquid inputs


ICE_FILE="data.ice_${TEMP}K_${PRES}atm_${MODEL}"

yz_lo=`awk 'FNR == 7 {print $1}' ${ICE_FILE}`
yz_hi=`awk 'FNR == 7 {print $2}' ${ICE_FILE}`
echo $yz_lo
echo $yz_hi

LIQ_INPUT='in.setup_liquid'
N_liq=4608   # Number of ice molecules

cp ../in.setup_liquid_template ${LIQ_INPUT}

# put temperature and pressure aand volume variable into liquid script - lines 11 and 12, column 4

# set temperatures
sed -i -E "11 s/[0-9]+/${TEMP}/" ${LIQ_INPUT}
# set pressure
sed -i -E "12 s/[0-9]+/${PRES}/" ${LIQ_INPUT}
# set x
sed -i -E "19 s/[0-9]+/${yz_lo}/" ${LIQ_INPUT}
# set yz
sed -i -E "20 s/[0-9]+/${yz_hi}/" ${LIQ_INPUT}


# Run ice setup
mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${LIQ_INPUT}

# log density of the ice, lines 42 - 1042, volume is field 4
LIQ_LOG="log.run_liq_${TEMP}K_${PRES}atm_${MODEL}"
#liq_volume=`awk '{ if (NR > 42 && NR < 1042) sum += $4; n++ } END { if (n > 0) print sum / n; }' ${ICE_LOG}`
#liq_density=$(expr ${N_ice} / ${ice_volume} )

#echo "Ice density ${TEMP}K ${PRES}atm ${MODEL} : ${ice_volume}" >> ../${LOG}


