#!/usr/bin/gnuplot

set terminal png size 800,600
set style fill transparent solid 0.5
set term png truecolor enhanced font "Times,15"
set key left

set term png
set output 'file.png'

unset colorbox

#plot 'data' using 1:2 with lines, 'data' using 1:3 with lines
plot  '/home/svart/work/golang/anomaly-detection/scripts/tmp/tmp.file.data' using 1:2 w filledcurves above y1=0.0 ls 2,  '/home/svart/work/golang/anomaly-detection/scripts/tmp/tmp.file.data' using 1:3 w filledcurves above y1=0.0 ls 3    
