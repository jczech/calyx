#!/bin/perl
#*****************************************************
# A simple model of a single AZ at the calyx of Held *
#                                                    *
# This script runs one simulation                    *
# and can be passed to individual nodes in           *
# simulations using condor.                          *
#                                                    *
# This script takes two parameters, the first is the *
# identification number of the simulation ($simid    *
# in prepare_simulation_script.pl) and the second    *
# the random seed for the current simulation         * 
# ($run in prepare_simulation_script.pl)             * 
#                                                    *
#                                                    *
# Matthias Hennig                                    *
# mhennig@inf.ed.ac.uk                               *
#*****************************************************

print "running simulation: @ARGV[0], @ARGV[1]\n";

system "/bin/rm", "-f", "chkpt_pos";

$simid = @ARGV[0];
$run = @ARGV[1];

# prepare the file that contains the fusion pore dimension
open(PS, ">pore_scale");
print PS "check_time = 5\n";
print PS "abs_time = 5\n";
close(PS);

# adjust this:
$prg = "/home/mhennig/bin/mcell";

# the gradual opening of the fusion pore is approximated by changing the diamater
# every 5\mu s
for ( $chk = 1; $chk <= 1; $chk++) {  

  system $prg, "-seed $run", "calyx_@ARGV[0]\_@ARGV[1].mdl";

  # adist the pore if time < 300\mu s
  if ( $chk < 60 ) {
    open(PS, ">pore_scale");
    print PS "check_time = 5\n";
    $at = $chk*5+5;
    print PS "abs_time = $at\n";
    close(PS);
  } else {       # or run the rest of the simulation with a constant maximal pore diameter
    open(PS, ">pore_scale");
    print PS "check_time = 3000\n";
    print PS "abs_time = 3000\n";
    close(PS);
  }
}
