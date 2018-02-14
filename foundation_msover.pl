#!/usr/bin/perl -w

$home="/opt/lampp/htdocs/foundation";
open (OUT,">./foundation_$ARGV[0]_msover.html");

@chdir=split/\//,$ARGV[1];
$ndir=pop @chdir;

open (IN,"../../tmpl/foundation_tmpl_msovr.html");
while (<IN>) {print;
 s/tttt/$ARGV[0]/;
 s/dddd/$ndir/;
 print OUT;print;
}
print "handle is ./foundation_$ARGV[0]_msover.html\n";

