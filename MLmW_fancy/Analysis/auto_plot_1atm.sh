#!/bin/bash


TEMPERATURES=(286 287 288 289 290 291 292 293)

WORKING_DIR=~/Freezing_Simulations/Melting/MLmW_fancy/Analysis
LOG_FILE=${WORKING_DIR}/auto_plot.log
DATETIME=$(date +"%Y-%m-%d_%H:%M:%S")
TRIAL='0'


# Log date and time
echo "${DATETIME}" >> ${LOG_FILE}

for temp in "${TEMPERATURES[@]}"; do
    data_file="../1atm/${temp}K/run_melt_${temp}K_1atm_ML.dat"
    if [ -f ${data_file} ]; then
        echo "$temp input file found: Ready to copy $temp data" >> ${LOG_FILE}
        cp ${data_file} ${WORKING_DIR}/run_melt_${temp}K_1atm_ML.dat
    else
        echo "Input file does not exist for $temp simulation" >> ${LOG_FILE}
    fi
done

mkdir 1atm

# Plot and save Pot Energy
gnuplot -e "set terminal png; \
            set output '1atm/Tmelt_PE_${TRIAL}.png';
            set title 'Potential Energy'; \
            set ylabel 'kJ/mol'; \
            set xlabel 'Time (ns)'; \
            set key outside ; \
            set key right top ; \
            set style data lines; \
            plot for [i=286:293] 'run_melt_'.i.'K_1atm_ML.dat' using 1:7 title ''.i.'K'; "

# Plot and save Total Energy
gnuplot -e "set terminal png; \
            set title 'Total Energy'; \
            set ylabel 'kJ/mol'; \
            set xlabel 'Time (ns)'; \
            set key outside ; \
            set key right top ; \
            set style data lines; \
            plot for [i=286:293] 'run_melt_'.i.'K_1atm_ML.dat' using 1:5 title ''.i.'K'" > ${WORKING_DIR}/1atm/Tmelt_TE_${TRIAL}.png

# Plot and save Mean square disp
gnuplot -e "set terminal png; \
            set title 'Mean Square Displacement'; \
            set ylabel 'Angstroms'; \
            set xlabel 'Time (ns)'; \
            set key outside ; \
            set key right top ; \
            set style data lines; \
            plot for [i=286:293] 'run_melt_'.i.'K_1atm_ML.dat' using 1:8 title ''.i.'K'" > ${WORKING_DIR}/1atm/Tmelt_MSD_${TRIAL}.png

# Plot and save Volume
gnuplot -e "set terminal png; \
            set title 'Box Volume'; \
            set ylabel 'Cubic Angstroms'; \
            set xlabel 'Time (ns)'; \
            set key outside ; \
            set key right top ; \
            set style data lines; \
            plot for [i=286:293] 'run_melt_'.i.'K_1atm_ML.dat' using 1:4 title ''.i.'K'" > ${WORKING_DIR}/1atm/Tmelt_VOL_${TRIAL}.png


for temp in "${TEMPERATURES[@]}"; do
    if [ -f ${WORKING_DIR}/run_melt_${temp}K_1atm_ML.dat ]; then
        echo "$temp input file found: Ready to remove $temp data" >> ${LOG_FILE}
        rm ${WORKING_DIR}/run_melt_${temp}K_1atm_ML.dat
    else
        echo "Data file was not created for $temp simulation" >> ${LOG_FILE}
    fi
done
