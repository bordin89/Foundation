#!/usr/bin/perl
use CGI qw(:cgi);
print <<EndOfHTML;
Content-type: text/html

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
    position: static;
    right: 0px;
    width: 864px;
    padding: 10px;
}

img {
	max-width:100%;
height: auto;
width: auto\9;
}

figure figcaption {
    text-align: justify;
}

</style>

<HTML>
 <HEAD>
  <TITLE>Foundation - Platypus Lab</TITLE>
 </HEAD>

 <BODY>
     <h1><img src="lablogo.png" alt="lablogo" style="width:160px;height:89px;float:left;"><img src="logo.jpg" alt="CABD" style="width:160px;height:89px;float:left;"><span> Foundation: Protein sequence features visualizer</span></h1>
<FORM  METHOD="POST"  ACTION="http://www.pvcbacteria.org/foundation/prg/foundation_03.pl">
<li>Job name<p><textarea name="nam"  rows="1" cols="10" id="seq_text">MySeq</textarea>

 (Default identifier)</li><figure style="float:right;max-width=860px;">
  <img src="foundation_examples.png" alt="Foundation examples" style="float:right;width:860">
  <figcaption align:right><br>Foundation visualization of Q91G88,Q6GZW6 and P05067.<p> Fuchsia: Alpha helix<br>Cyan: Beta sheet<br> Green: TMH <br> Line underneath: Disorder prediction</figcaption>
</figure>

<div class="row"> 
 <li> Max. PSI-BLAST iterations. <br></br></li>
 Warning: More rounds will results in longer processing time and might lead to divergence of the profile. <br></br> This leads to a difference in secondary structure predictions (as can be seen in this <a href="../tmpl/profdivrg.gif">example</a>).<br></br> Use with caution.
 <br></br>
  <div class="formw"><select name="mxrnd" onchange="" size="1">
<option value="1" selected="selected">1</option> 
<option value="2" >2</option> 
<option value="3" >3</option> 
<option value="4" >4</option> 
<option value="5" >5</option> 
<option value="6" >6</option> 
<option value="8" >8</option>
</select></div> 
	
</div> 
<br></br>
<li>Sequence in <a href="http://en.wikipedia.org/wiki/FASTA_format">FASTA format</a>:</p><textarea name="seq"  rows="10" cols="50" id="seq_text"></textarea><br></br></li> 
     <INPUT TYPE="submit">
  </FORM>
<FORM  METHOD="POST"  ACTION="http://www.pvcbacteria.org/foundation/prg/foundation_01.cgi">
     <INPUT type="submit" name=".defaults" value="Reset">
     <br/> 
  </FORM>
Foundation uses:<br> 
PSIPRED for Secondary Structure Prediction<br>
IUPred for Disorder Prediction<br>
and TMHMM for Transmembrane helices prediction<p>


 </BODY>

</HTML>
EndOfHTML

