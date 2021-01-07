#!/bin/bash
#
# extract data from dump files using the ice_ratio.awk, running_avg.ask, find_freezing_temp.py, and make_gnuplots.sh scripts

START=289
END=290
PRESSURE=1

./ice_ratio.awk ../1_atm/prod.warm_1atm_1K_longseed-289-290.dump > ../1_atm/analysis/ice_ratio_longseed_1K.dat

# make plot of ice ratio, raw data
gnuplot -e "set terminal png size 1000,600; \
    set output '../1_atm/analysis/ice_ratio_longseed_1K.png'; \
    set title 'Ice Ratio vs. Temperature, ML-mW, $PRESSURE atm - raw data'; \
    set ylabel 'N ice / N total'; \
    set xlabel 'Temp (K)'; \
    set style data lines; \
    set xrange [$START:$END] ; \
    set xtics $START,0.25; \
    plot '../1_atm/analysis/ice_ratio_longseed_1K.dat' using 3:7"
	
# get running average of ice_ratio
#running_avg.awk analysis/run_$VARIABLE/ice_ratio.dat > analysis/run_$VARIABLE/ice_ratio_smooth.dat

# plot ice ratio
#python3 ~/Freezing_Simulations/Bulk_Water_Homogeneous/ML_mW/find_melt_temp.py analysis/run_$VARIABLE/
