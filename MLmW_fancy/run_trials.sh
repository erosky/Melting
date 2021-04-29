#!/bin/bash
# 


TEMPERATURES_1=(286 287 288 289 290 291 292 293)
#TEMPERATURES_500=(289 290 291 292 293 294 295 296)
#TEMPERATURES_1000=(292 293 294 295 296 297 298 299)
WORKING_DIR=/data/emrosky-sim/Freezing_Simulations/Melting/MLmW_fancy

# Run simulation for 1 atm
for temp in "${TEMPERATURES_1[@]}"; do
    echo $temp
    ./run_setup_scripts.sh 1atm $temp 1 ML
    cd ${WORKING_DIR}
done


# Run simulation for -500 atm
for temp in "${TEMPERATURES_500[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/500atm"
    ./run_setup_scripts.sh 500atm $temp -500 ML
    cd ${WORKING_DIR}
done


# Run simulation for -1000 atm
for temp in "${TEMPERATURES_1000[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/1000atm"
    ./run_setup_scripts.sh 1000atm $temp -1000 ML
    cd ${WORKING_DIR}
done



# once complete, run auto_analysis.sh
