#!/bin/bash

WORKING_DIR=~/Freezing_Simulations/Melting/mW_fancy/Analysis
LOG_FILE=${WORKING_DIR}/auto_analysis.log
DATETIME=$(date +"%Y-%m-%d_%H:%M:%S")

# Log date and time
echo "${DATETIME}" >> ${LOG_FILE}

TEMPERATURES_1=(270 271 272 273 274 275 276 277)
TEMPERATURES_500=(271 272 273 274 275 276 277 278)
TEMPERATURES_1000=(272 273 274 275 276 277 278 279)

# Run analysis for 1 atm files
for temp in "${TEMPERATURES_1[@]}"; do
    cd "${WORKING_DIR}/../1atm/${temp}K" && \
    # Check that input file exists before running analysis
    if [ -f log.run_melt_${temp}K_1atm_mW ]; then
        echo "$temp input file found: Ready to analyze $temp simulation" >> ${LOG_FILE}
        # Run script, direct errors into log file
        ${WORKING_DIR}/auto_analysis_run.sh log.run_melt_${temp}K_1atm_mW run_melt_${temp}K_1atm_mW $temp $pres       
    else
        echo "Input file does not exist for $temp simulation" >> ${LOG_FILE}
    fi
done


# Run analysis for -500 atm files
for temp in "${TEMPERATURES_500[@]}"; do
    cd "${WORKING_DIR}/../500atm/${temp}K" && \
    # Check that input file exists before running analysis
    if [ -f log.run_melt_${temp}K_-500atm_mW ]; then
        echo "$temp input file found: Ready to analyze $temp simulation" >> ${LOG_FILE}
        # Run script, direct errors into log file
        ${WORKING_DIR}/auto_analysis_run.sh log.run_melt_${temp}K_-500atm_mW run_melt_${temp}K_500atm_mW $temp $pres       
    else
        echo "Input file does not exist for $temp simulation" >> ${LOG_FILE}
    fi
done


# Run analysis for 1 atm files
for temp in "${TEMPERATURES_1000[@]}"; do
    cd "${WORKING_DIR}/../1000atm/${temp}K" && \
    # Check that input file exists before running analysis
    if [ -f log.run_melt_${temp}K_-1000atm_mW ]; then
        echo "$temp input file found: Ready to analyze $temp simulation" >> ${LOG_FILE}
        # Run script, direct errors into log file
        ${WORKING_DIR}/auto_analysis_run.sh log.run_melt_${temp}K_-1000atm_mW run_melt_${temp}K_1000atm_mW $temp $pres       
    else
        echo "Input file does not exist for $temp simulation" >> ${LOG_FILE}
    fi
done

