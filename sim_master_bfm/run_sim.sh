#! /bin/sh

rm -rf a.out
iverilog -f sim.f $1 
./a.out
