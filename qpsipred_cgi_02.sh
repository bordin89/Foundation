#!/bin/sh

#fnd_home="/home/devos/public_html/project/apache/cgi-bin/foundation/"

cd $3
/home/programs/blast-2.2.10/bin/blastpgp -i $1 -d /home/db/Blast/swissprot_db -j $2 -h 0.001 -o $1.bla
echo lolololololol
#echo "/g/bork3/bin/blastpgp -i $1 -d /g/bork2/devos/db/nr.fa -/j $2 -h 0.001 -o $1.bla"
#/g/bork3/bin/blastpgp -i $1 -d /g/bork2/devos/db/nr.fa -j $2 -h 0.001 -o $1.bla
#/g/bork3/bin/blastpgp -i $1 -d /g/bork2/devos/db/uniref50.fasta-1106 -j $2 -h 0.001 -o $1.bla
/opt/lampp/htdocs/foundation/prg/alignblast.pl $1.bla $1.a2m -Q $1
echo lolololololol2
/opt/lampp/htdocs/foundation/prg/addpsipred.pl $1.a2m
echo lolololololol3
cp $1 tmp.f

/opt/lampp/htdocs/foundation/prg/a3m2ps_cgi.pl $1.a3m $4

ps2pdf foundation_$4_sml.ps foundation_$4_sml.pdf
ps2pdf foundation_$4_big.ps foundation_$4_big.pdf
convert foundation_$4_sml.ps foundation_$4_sml.png
convert foundation_$4_big.ps foundation_$4_big.png
./foundation_msover.pl $4 $3

tar -cf $4.tar ./*
gzip $4.tar

rm tmp.f
#rm ./qpsipred_cgi_02.sh ./a3m2ps_cgi.pl ./foundation_msover.pl
