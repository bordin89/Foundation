#!/usr/bin/perl

$ENV{"IUPred_PATH"} = "/home/programs/iupred-1.0/";


$name=$ARGV[1];
$name=~s/\n//g;
$name=~s/\s//g;
$tmp_fil="tmp_$ARGV[0]_secstr.out";
$sub=$ARGV[0];
$sub=~s/\.f//;
$sub=~s/\.a3m//;

open (IN,$ARGV[0]);
while (<IN>) {
if (/^>ss_pred PSIPRED /) {$ok++;
 while (<IN>) {
	last if (/^>/);
	push @{$pred{$sub}},$_;
 }
}
if (/^>ss_conf PSIPRED /) {$ok++;
 while (<IN>) {
	last if (/^>/);
	push @{$conf{$sub}},$_;
 }
}
if (/^>/ && $ok==2) {
 while (<IN>) {
	last if (/^>/);
	push @{$iuseq{$sub}},$_;
 }
}
last if (/>/ && $ok==2);
}

print "@{$conf{$sub}}\n@{$pred{$sub}}\n";

$nof=0;
%cseq=%fseq;
open (OUT,">$tmp_fil");
foreach $k (keys %conf) {
	undef $out;
	$totpred++;
#	$s=join "",@{$seq{$k}};
#	$s=~s/\n//g;
	$c=join "",@{$conf{$k}};
	$c=~s/\n//g;
	$p=join "",@{$pred{$k}};
	$p=~s/\n//g; 
#		print "$k is ";
		$out.= ">$k\n";
		$out.= "CONF\t$c\n";
		$out.= "Pred\t$p\n";
#		$out.= "SEQ\t$k\t1\n$s\n";
		$out.= "\/\/\n";
		print OUT $out;

#print "$p is $s\n vs $fst{$p}\n" if ($p eq "NUP188");
}

#print "$ttof total fsta\nno seq for $nof out of $totpred\n";
foreach $n (keys %cseq) {
print "$n missing\n";$m++;
}print "$m missings\n";
close OUT;

# color codes
#@fgcolor=qw(orange green blue yellow red pink);
@fgcolor=("0 .5 0", "0 1 0", "0 0 1", "1 1 0", "1 0 0", "1 .75 0");
@fgtxt=qw(SAFGxPSFG PSFG SAFG GLFG FxFG FG);

# color code for sec str
# 0 is H (magenta-like), 1 is E (blue-like)
#@rgb_sscolor=(".92 .13 .92",".24 .6 .88");
#@cmyk_sscolor=("0 100 15 0","100 18 0 0");
@sscolor=("1 0 1","0 1 1");
@sstxt=qw (alpha-helix beta-sheet);

@tmhcolor=("0 1 0");
@tmhtxt=qw (TMH);

@coilcolor=("1 0 0");
@coiltxt=qw(COILS);

@segcolor=("0 0 1");
@segtxt=qw(SEG);

$disohigh=18;
@discolor=("0 0 0");
@distxt=qw(Disorder);

open (SIF,$tmp_fil);
print "opening $tmp_fil\n";
while (<SIF>) {
	if (/^>(\S+)/) {
#		$name=$1;
			while (<SIF>) {
				if (/^\/\//) {plot_it($name);last}
#>yal035w
	$coil=$1 if (/^COILS\t\d+\t\d+\t(\S+)/);
#COILS   2       137     87-147,170-245
	$htm=$1 if (/^TMH\t\d+\t\S+\t(\S+)/);
#PHDHTM  2       in      29-46,381-398
#so far we don't use the in/out state (to be implemented)
	$prof=$1 if (/^PROF\t(\S+)/);
	$prof=$1 if (/^Pred\t(\S+)/);
#PROF    LLLLLLLLLHHHHLLHHHHHEE
	$conf=$1 if (/^CONF\t(\d+)/);
#CONF    000000000725598322234
	$seg=$1 if (/^SEG\t\d+\t(\S+)/);
#SEG     48      171-186,334-353,538-549
	$nors=$1 if (/^NORS\t\d+\t(\S+)/);
#NORS    1       646-783
	$diso=$1 if (/^DISO\t(\S+)/);
# SEQ
	if (/^SEQ/) {
		$seq=<SIF>;$seq=~s/\t//;chomp $seq;
	}
	if (/^\s\sAA: (\S+)$/) {$seq=$1;#print "seq $name is $1*\n";
	}
	$model=$1 if (/^MODEL\t(\S+)/);
			}
	}
}

iupred();
tmh();
bigseq();
legend();

print SML "grestore\nshowpage\n";
print BIG "\nshowpage\n";

#system ("rm $tmp_fil");

sub plot_it {
$name=~s/PSIPRED_//;
$name=~s/\.a3m$//;
$name=~s/\.fa$//;
$name=~s/seqinf\.//;
$name=~s/seqinf\_//;
print "plotting $name\n";

open (SML,">foundation_${name}_sml.ps");
open (BIG,">foundation_${name}_big.ps");
open (TPS,"../../tmpl/seqinf2ps_tpl.ps");
while (<TPS>) {print SML;}
open (TPB,"../../tmpl/seqinf2ps_tpl10.ps");
while (<TPB>) {print BIG;}

$tr=550;
$tr-=70;
print SML "\n%name $name\n-100 5 moveto\n\/Helvetica-bold findfont\n25 scalefont\nsetfont\n0 0 0 setcolor\n($name) show\n";
print BIG "\n%name $name\n-100 5 moveto\n\/Helvetica-bold findfont\n25 scalefont\nsetfont\n($name) show\n";


if ($prof) {
	if ($conf) {
		@cnf=split//,$conf;
		@s=split //,$prof;
		$lgt=$#s;
		print SML "%start\n1 setlinewidth\n";
		print BIG "%start\n1 setlinewidth\n";
		$cnt=-1;
		foreach $s (@s) {
			$cnt++;
			if ($cnf[$cnt]>=1) {
				$sz=30*$cnf[$cnt]/10;
				print SML "$sz $cnt alp sstr\n" if ($s eq "H");
				print SML "$sz $cnt bta sstr\n" if ($s eq "E");
				print BIG "$sz $cnt alp sstr\n" if ($s eq "H");
				print BIG "$sz $cnt bta sstr\n" if ($s eq "E");
			}
		}
	} else {
		@s=split //,$prof;
		$lgt=$#s;
		print SML "%lgt\n0 0 moveto\n$lgt 0 rlineto\nstroke\n1 setlinewidth\n";
		print BIG "%lgt\n0 0 moveto\n$lgt 0 rlineto\nstroke\n1 setlinewidth\n";
		$cnt=-1;
		foreach $s (@s) {
			$cnt++;
			$sz=30;
			print SML "$sz $cnt $sscolor[0] sstr\n" if ($s eq "H");
			print SML "$sz $cnt $sscolor[1] sstr\n" if ($s eq "E");
			print BIG "$sz $cnt $sscolor[0] sstr\n" if ($s eq "H");
			print BIG "$sz $cnt $sscolor[1] sstr\n" if ($s eq "E");
		}
	}
}

}

sub iupred {
open (IU,">tmp.f");
$iuseq=join "",@{$iuseq{$sub}};
$iuseq=~s/\n//g;
$iuseq=~s/\s//g;
print IU ">tmp\n$iuseq\n";
close IU;
print SML "gsave\n0 -2 translate\n.5 setlinewidth\n0 setgray\n1 2.5 scale\n";
print BIG "gsave\n0 -2 translate\n.5 setlinewidth\n0 setgray\n1 2.5 scale\n";
open (IU,"/home/programs/iupred-1.0/iupred ./tmp.f long |");
while (<IU>) {
 next if (/^#/);print;
 @l=split /\s+/,$_;#print "$l[0]=$l[1]=$l[2]=$l[3]\n";
if ($iup) {
 $iup=-$l[3]*10;
 $xiup=$l[1]-1;
 print SML "$xiup $iup lineto\n";
 print BIG "$xiup $iup lineto\n";
 } else {
 $iup=-$l[3]*10;
 print SML "0 $iup moveto\n";
 print BIG "0 $iup moveto\n";
 }
# print "$l[1] $iup lineto\n";
# print  "$l[1] $iup lineto\n";
$last=$l[1]-1;
}
print SML "0 0 moveto\n$last 0 lineto\nstroke\n";
#print BIG "-.5 0 moveto\ntmhmm-2.0c/bin$last.5 0 lineto\nstroke\n";
}

sub tmh {
undef $prtmh;
open (TMH,"/home/programs/tmhmm-2.0c/bin/tmhmm seq.f |");
#open (TMH,"/g/bork3/bin/tmhmm tmp.f |"); # local
#open (TMH,"/g/bork3/x86_64/bin/tmhmm tmp.f |"); # on the cluster
while (<TMH>) {
 if (/TMhelix\s+(\d+)\s+(\d+)$/) {
  $prtmh.= "$1 $2 @tmhcolor seq_block\n";
 }
}
if (defined $prtmh) {
	print SML "grestore\n$prtmh\nstroke\n";
	print BIG "grestore\n$prtmh\nstroke\n";
}

}

sub bigseq {
print BIG "stroke\ngrestore\n%sequence\n-.5 -1.5 moveto\n/Courrier-Bold findfont\n1.66666666666665 scalefont\n0 0 0 setcolor\nsetfont\n";
print BIG "($iuseq) show\n";
}

sub legend {

}
