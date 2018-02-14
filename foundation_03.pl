#!/usr/bin/perl -w
use CGI qw(param);

print <<END_of_Start;
Content-type: text/html

<HTML>
<style>
span {
  display: inline-block;
  vertical-align: middle;
  line-height: 85px;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 24px;
        font-style: normal;
        font-variant: normal;
        font-weight: 500;
  padding-left: 40px;
}

li {
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-style: normal;
        font-variant: normal;
}


body {
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-style: normal;
        font-variant: normal;
}

/* for visual purposes */
#column-content {
  border: 1px solid red;
  position: relative;
}

.right {
    position: absolute;
    right: 0px;
    width: 864px;
    padding: 10px;
}

figure figcaption {
    text-align: justify;
}

</style>

<HEAD>
<TITLE>Foundation - Platypus Lab</TITLE>
</HEAD>
<BODY>
<h1><img src="lablogo.png" alt="lablogo" style="width:160px;height:89px;float:left;"><img src="logo.jpg" alt="CABD" style="width:160px;height:89px;float:left;"><span> Foundation: Protein sequence features visualizer</span></h1>
END_of_Start

my $nam=param("nam");
my $seq=param("seq");
my $rbl=param("mxrnd");

@seq=split/\n/,$seq;
$id=shift@seq;
$seqo=join"",@seq;
my $sz=$seqo=~tr/[a-zA-Z]//;

unless ($nam=~/[a-zA-Z0-9]/ && $id=~/^>/ && $seqo=~/[a-zA-Z]/ && $sz<=7500) {
print "Incorrect format, please check the identifier (should contain at least one
letter or number) and the fasta format (first line should begin with \">\"), no
stars or gaps in the sequence.<p>Size limit is 7500 residues (yours is $sz)<p>";
print "<a href=\"http://www.pvcbacteria.org/foundation/foundation_01.cgi\">back</a>";
die;
}

my $hom="/opt/lampp/htdocs/foundation/data";
#$ndir="prg";
while (-d "$hom/$ndir") {$ndir=int(rand(1000));}

$dir=$hom."/$ndir";
system "mkdir $dir\n";
system "cd $dir\n";
print "Your protein: (size $sz):<p>\n$seq<p>Your job is running, wait a moment, please.<br>";
print "Your files will be available <a href=\"http://www.pvcbacteria.org/foundation/data/$ndir/foundation_$nam.html\">here</a>";
print "<meta http-equiv=\"refresh\" content=\"30;url=http://www.pvcbacteria.org/foundation/data/$ndir/foundation_$nam.html\"/>\n";

open (RES,">$ndir/foundation_$nam.html");
print RES "<HTML>\n<HEAD>\n<TITLE>Foundation - Compact and Complete Linear representation of protein sequence features</TITLE>\n</HEAD>\n<BODY>\n<H1>Foundation - Compact and Complete Linear representation of protein sequence features</H1>\n<p>\nif nothing appear, just wait a moment. This page will refresh in 60s.<p>\n";
print RES "<meta http-equiv=\"refresh\" content=\"30\"/>\n</BODY>\n</HTML>\n";
close RES;

open (OUT,">$dir/seq.f");print OUT "$seq\n";close OUT;
system "cp ./qpsipred_cgi_02.sh ./a3m2ps_cgi.pl ./foundation_msover.pl $dir/\n";
system "$dir/qpsipred_cgi_02.sh seq.f $rbl $dir $nam >$dir/qpsipred.out\n";

open (RES,">$dir/foundation_$nam.html");
print RES "<HTML>\n<style>\nli {\n\tfont-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;\n\tfont-style: normal;\n\tfont-variant: normal;\n}\nbody {\n\tfont-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;\nfont-style: normal;\nfont-variant: normal;\n}\nspan {\n\tdisplay: inline-block;\n\tvertical-align: middle;\n\tline-height: 85px;\n\tfont-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;\n\tfont-size: 24px;\n\tfont-style: normal;\n\tfont-variant: normal;\n\tfont-weight: 500;\t\npadding-left: 40px;\n}</style>\n<HEAD>\n<TITLE>Foundation - Platypus Lab</TITLE>\n</HEAD>\n<BODY>\n<h1><img src='http://pvcbacteria.org/mywiki/pipeline-tables\/lablogo.png' alt='lablogo' style='width:160px;height:89px;float:left;'><img src='http://pvcbacteria.org/mywiki/pipeline-tables\/logo.jpg' alt='CABD' style='width:160px;height:89px;float:left;'><span>Foundation: Protein sequence features visualizer</span></h1>\n<p>\n<p>\n";

print RES "Your results are available here and will be kept for 7 days:\n<p>\n<p>";

print RES "<a href=\"http://www.pvcbacteria.org/foundation/data/$ndir/foundation_$nam\_msover.html\">Interactive zooming map</a><br>\n";
print RES "<a href=\"http://www.pvcbacteria.org/foundation/data/$ndir/foundation_$nam\_sml.png\">.png file</a><br>\n";
print RES "<a href=\"http://www.pvcbacteria.org/foundation/data/$ndir/foundation_$nam\_sml.ps\">.ps file</a><br>\n";
print RES "a <a href=\"http://www.pvcbacteria.org/foundation/data/$ndir/$nam.tar.gz\">compressed tar file</a> containing all raw output\n";
print RES "<p><a href=\"http://www.pvcbacteria.org/foundation/prg/foundation_01.cgi\">Back to the main page</a>\n</BODY>\n</HTML>";
