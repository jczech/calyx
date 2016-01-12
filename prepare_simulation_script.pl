#!/bin/perl
#*****************************************************
# A simple model of a single AZ at the calyx of Held *
#                                                    *
# This script prepares a set of siumation scripts to *
# run a simulation with a specific set of parameters.*
#                                                    *
# Matthias Hennig                                    *
# mhennig@inf.ed.ac.uk                               *
#*****************************************************

# the Q_10 for AMPARs
@tf = (1, 2.4);

# number of gluatamate molecules in the vesicle
@n = (6000, 7000, 8000);

# final fusion pore diameter
@fpD = (0.009, 0.011);

# diffusion coefficient
@diffusion = (3, 4, 5, 6);

# position of the vesicle relative to central PSD
@vespositions = (0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0);

#################################


$af = 0;
$simid = 0;

# loop through the parameter space
# (increase the numbers to run multiple simulations)
# (note: these simulations were run on clusters using the condor environment)

for ( $vespos = 0; $vespos <1; $vespos++ ) {
for ( $diffc = 0; $diffc <1; $diffc++ ) {
for ( $fpDc = 0; $fpDc <1; $fpDc++ ) {
for ( $tfc = 0; $tfc <1; $tfc++ ) {
for ( $nc = 0; $nc <1; $nc++ ) {

  $simid = $simid + 1;

  $simidstr = sprintf("%03d", $simid);

  for ( $run = 1; $run <2; $run++ ) {  # number of runs for each parameter set

    $runstr = sprintf("%03d", $run);

    # build a parameter file
    open(H, "parameters.mdl");
    open(HT, ">run_parameters_$simidstr\_$runstr.mdl");
    while(<H>) {
      chomp;
      s/D\ =\ tfd\ \*\ 6.0/D\ =\ tfd\ \*\ @diffusion[$diffc]/;
      s/tf\ =\ \d+.\d+/tf\ =\ @tf[$tfc]/;
      s/n\ =\ \d+/n\ =\ @n[$nc]/;
      s/fpD\ =\ \d+.\d+/fpD\ =\ @fpD[$fpDc]/;
      s/AMPAR_number_far\ =\ \d+/AMPAR_number_far\ =\ $af/;
      s/simid\ =\ \d+/simid\ =\ $simid/;
      s/simrun\ =\ \d+/simrun\ =\ $run/; # this number is used to seed the random number generator
      print HT "$_\n";
    }
    print HT "vesicle_pos = @vespositions[$vespos]\n";
    close(H);
    close(HT);
    
    # insert appropriate file names into the simulation script
    open(H, "calyx.mdl");
    open(HT, ">calyx_$simidstr\_$runstr.mdl");
    while(<H>) {
      chomp;
      s/parameterfile/run_parameters_$simidstr\_$runstr/;
      s/outputfile/output_$simidstr\_$runstr/;
      print HT "$_\n";
    }
    close(H);
    close(HT);
    
    #  insert appropriate file names into the output script
    open(H, "output.mdl");
    open(HT, ">output_$simidstr\_$runstr.mdl");
    while(<H>) {
      chomp;
      s/simid/$simidstr\_$runstr/;
      print HT "$_\n";
    }
    close(H);
    close(HT);
    
  }
}
}
}
}
}

close(RUN);
