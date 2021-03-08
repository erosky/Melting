#!/bin/bash
# 


TEMPERATURES_1=(270 271 272 273 274 275 276 277)
TEMPERATURES_500=(271 272 273 274 275 276 277 278)
TEMPERATURES_1000=(272 273 274 275 276 277 278 279)
WORKING_DIR=/data/emrosky-sim/Freezing_Simulations/Melting/mW_fancy

# Run simulation for 1 atm
for temp in "${TEMPERATURES_1[@]}"; do
    echo $temp
    mkdir "${WORKING_DIR}/1atm"
    ./run_setup_scripts.sh 1atm $temp 1 mW
    cd ${WORKING_DIR}
done


# Run simulation for -500 atm
for temp in "${TEMPERATURES_500[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/500atm"
    ./run_setup_scripts.sh 500atm $temp -500 mW
    cd ${WORKING_DIR}
done


# Run simulation for -1000 atm
for temp in "${TEMPERATURES_1000[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/1000atm"
    ./run_setup_scripts.sh 1000atm $temp -1000 mW
    cd ${WORKING_DIR}
done



# once complete, run auto_analysis.sh
