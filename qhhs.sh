#!/bin/sh

#fnd_home="/home/devos/public_html/project/apache/cgi-bin/foundation/"

cd $3
#/usr/bin/blastpgp -i ./$1 -d /g/bork2/devos/db/nr.fa -j $2 -h 0.001 -o $1.bla
echo "/home/programs/blast-2.2.10/bin/blastpgp -query $1 -db /home/db/Blast/swissprot_db -num_iterations $2 -evalue 0.001 -out $1.bla"

#/g/bork3/bin/blastpgp -i $1 -d /g/bork2/devos/db/nr.fa -j $2 -h 0.001 -o $1.bla
/home/programs/blast-2.2.10/bin/blastpgp -query $1 -db /home/db/Blast/swissprot_db -num_iterations $2 -evalue 0.001 -out $1.bla
/home/programs/hhs/alignblast.pl $1.bla $1.a2m -Q $1
/home/programs/hhs/addpsipred.pl $1.a2m


rm tmp.f seq.f
rm ./qpsipred_cgi_02.sh ./a3m2ps_cgi.pl ./foundation_msover.pl
