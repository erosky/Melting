#!/bin/bash


TEMPERATURES=('289K' '290K' '291K' '292K' '293K' '294K' '295K' '296K')
WORKING_DIR=~/Freezing_Simulations/Melting/Tmelt_500atm
LOG_FILE=${WORKING_DIR}/auto_run.log
DATETIME=$(date +"%Y-%m-%d_%H:%M:%S")

# Log date and time
echo "${DATETIME}" >> ${LOG_FILE}

# Run simulation in each temperature directory
for temp in "${TEMPERATURES[@]}"; do
    echo $temp
    cd "${WORKING_DIR}/$temp" && \
    # Check that input file exists before running simulation
    if [ -f in.melt_test_AUTO ]; then
        echo "$temp input file found: Ready to run $temp simulation" >> ${LOG_FILE}
        # Run simulation, direct errors into log file
        mpirun -np 4 ../lmp_mpi -in in.melt_test_AUTO 2> ${LOG_FILE}
        wait
        # Print run time into log file
        tail -1 log.run_Tmelt_${temp}_AUTO >> ${LOG_FILE}
    else
        echo "Input file does not exist for $temp simulation" >> ${LOG_FILE}
    fi
done

# once complete, run auto_analysis.sh
