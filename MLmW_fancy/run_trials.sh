#!/bin/bash
# 


TEMPERATURES_1=('286K' '287K' '288K' '289K' '290K' '291K' '292K' '293K')
TEMPERATURES_500=('289K' '290K' '291K' '292K' '293K' '294K' '295K' '296K')
TEMPERATURES_1000=('292K' '293K' '294K' '295K' '296K' '297K' '298K' '299K')
WORKING_DIR=~/Freezing_Simulations/Melting/MLmW_fancy

# Run simulation for 1 atm
for temp in "${TEMPERATURES_1[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/1atm"
    ./run_setup_scripts.sh 1atm $temp 1 ML
done


# Run simulation for -500 atm
for temp in "${TEMPERATURES_500[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/500atm"
    ./run_setup_scripts.sh 500atm $temp -500 ML
done


# Run simulation for -1000 atm
for temp in "${TEMPERATURES_1000[@]}"; do
    echo $temp 
    mkdir "${WORKING_DIR}/1000atm"
    ./run_setup_scripts.sh 1000atm $temp -1000 ML
done



# once complete, run auto_analysis.sh
