#!/usr/bin/perl

open (IN,$ARGV[0]);
die "not found $ARGV[0]\n" unless (-e $ARGV[0]);

while (<IN>) {
 if (/^>(\d+)\s/) {
	$idnew=$1;
	if (defined $seq) {blast_it ();}
	$id=$idnew;
 	undef $seq;
 } else {$seq.=$_;}
}
blast_it ();

sub blast_it {
 $seq=~s/\n//g;
 $i=$1 if ($id=~/^(\d)/);
 system ("mkdir -p ../data/pori/$i");
 open (OUT,">../data/pori/$i/seq.f");
 print OUT ">$id\n$seq\n";
 close OUT;
 system "cp ../data/pori/$i/seq.f ./";
 print "qssh.sh seq.f 3 ../data/pori/$i\n";

}
