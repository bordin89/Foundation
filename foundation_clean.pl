#!/usr/bin/perl -w

opendir (FDT,"../data/");@d=readdir FDT;closedir FDT;
foreach $d (@d) {
 next unless (-d "../data/$d" && $d=~/\d/);
 $age=int(-M "../data/$d");
# print "$d is directory form $age\n";
if ($age>7) {
#  if ($age<7) {
 print ("rm -r data/$d\n");
 system ("rm -r ../data/$d");
 }
}
