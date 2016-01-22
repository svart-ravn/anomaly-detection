#!/usr/bin/gnuplot

set terminal png size 800,600
set style fill transparent solid 0.5
set term png truecolor enhanced font "Times,15"
set key left

set term png
set output 'file.png'

unset colorbox

#plot 'data' using 1:2 with lines, 'data' using 1:3 with lines
%PLOT%    
