#!/bin/bash
#
# Set up new folder for running simulations
# Input working_dir, temp, pressure, model


# Check for correct number of input arguments
if [ $# -ne 4 ]
then
  echo
  echo "  Usage: $0 dir temp pressure model"
  echo "   e.g.: $0 1atm 288 1 ML"
  echo 
  exit ${E_ARGS}
fi


W_DIR=$1 #directory where trials are being stored
T_DIR="/data/emrosky-sim/Freezing_Simulations/Melting/MLmW_fancy" # directory with templates
TEMP=$2
PRES=$3
MODEL=$4
DIR="${W_DIR}/${TEMP}K"


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
#mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${ICE_INPUT}


# get y and z dims from line 7 and x 
# edit liquid inputs


ICE_FILE="data.ice_${TEMP}K_${PRES}atm_${MODEL}"

yz_lo=`awk 'FNR == 7 {print $1}' ${ICE_FILE}`
yz_hi=`awk 'FNR == 7 {print $2}' ${ICE_FILE}`
x_hi=`awk 'FNR == 7 {print $2}' ${ICE_FILE}`
echo $yz_lo
echo $yz_hi
echo $x_hi

LIQ_INPUT='in.setup_liquid'
N_liq=4608   # Number of ice molecules

cp ${T_DIR}/in.setup_liquid_template ${LIQ_INPUT}

# put temperature and pressure aand volume variable into liquid script - lines 11 and 12, column 4

# set temperatures
sed -i -E "11 s/[0-9]+/${TEMP}/" ${LIQ_INPUT}
# set pressure
sed -i -E "12 s/[0-9]+/${PRES}/" ${LIQ_INPUT}
# set x
sed -i -E "19 s/[0-9]+/${yz_lo}/" ${LIQ_INPUT}
# set yz
sed -i -E "20 s/[0-9]+/${yz_hi}/" ${LIQ_INPUT}


# Run liquid setup
#mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${LIQ_INPUT}


## Setting up liquid ice coexistence file
CO_INPUT="in.coexistence"
cp ${T_DIR}/in.coexistence_template ${CO_INPUT}

# Add volume variables to coexistence setup
# set temperatures
sed -i -E "8 s/[0-9]+/${TEMP}/" ${CO_INPUT}
# set pressure
sed -i -E "9 s/[0-9]+/${PRES}/" ${CO_INPUT}
# set x
sed -i -E "20 s/[0-9]+/${yz_lo}/" ${CO_INPUT}
# set yz
sed -i -E "21 s/[0-9]+/${x_hi}/" ${CO_INPUT}

# run setup
#mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${CO_INPUT}

CO_DATA="data.coexist_${TEMP}K_${PRES}atm_${MODEL}"


# Run final simulation
MELT_INPUT="in.melt_test"
cp ${T_DIR}/in.melt_test_template ${MELT_INPUT}

# Add volume variables to coexistence setup
# set temperatures
sed -i -E "9 s/[0-9]+/${TEMP}/" ${MELT_INPUT}
# set pressure
sed -i -E "10 s/[0-9]+/${PRES}/" ${MELT_INPUT}

# run melt test
mpirun -n 6 ~/LAMMPS_Source/lammps/src/lmp_mpi -in ${MELT_INPUT}




