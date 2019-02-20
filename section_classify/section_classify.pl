#!/usr/bin/perl

#---------------------------------------------------------#
use strict;
use warnings;

my $sectionfile_exception = "section-title-all.sup";
my %secdic;

sub sec_type($);
sub is_abstract($);
sub is_intro($);
sub is_background($);
sub is_method($);
sub is_result($);
sub is_discussion($);
sub is_reference($);
sub is_acknowledge($);
sub is_appendix($);
sub read_sectitle_dic_sup();
sub read_sectitle_dic();

#------------------------------------------------------------------------#
sub
sec_type($)
{
    my $titlestr = shift(@_);

    if (!%secdic)
    {
	print STDERR "Read exceptional rules...\n";
	read_sectitle_dic_sup();
    }    

    $titlestr =~ s/^(\d+)\s*//;

    my $flag = "NOT_DEFINED";
    if (defined($secdic{$titlestr})) 
    { 
#	    print "$freq\t$titlestr\t$secdic{$titlestr}\n";
	$flag = $secdic{$titlestr};
    }
    elsif (is_abstract($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tabstract\n";
	$flag = "abstract";
    }
    elsif (is_intro($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tintroduction\n"; 
	$flag = "introduction";
    }
    elsif (is_appendix($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tappendix\n"; 
	$flag = "appendix";
    }
    elsif (is_acknowledge($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tacknowledge\n"; 
#	$flag = "acknowledgement";
	$flag = "appendix";
    }
    elsif (is_discussion($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tdiscussion\n"; 
	$flag = "discussion";
    }
    elsif (is_background($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tbackground\n"; 
	$flag = "background";
    }
    elsif (is_result($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tresult\n"; 
	$flag = "result";
    }
    elsif (is_method($titlestr)) 
    { 
#	    print "$freq\t$titlestr\tmethod\n"; 
	$flag = "method";
    }
    else 
    {
	$flag = "method-other";
    }
#    print "$titlestr\t$flag\n";

    $flag;
}

#------------------------------------------------------------------------#
sub
is_method($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if (($sentstr =~ m/^method/i) && ($sentstr !~ m/^method\w* and/i)) { $flag = 1; }
    elsif ($sentstr =~ m/^approach\b/i) { $flag = 1; }
    elsif ($sentstr =~ m/proposed/i) { $flag = 1; }
    elsif ($sentstr =~ m/^our/i) { $flag = 1; }
    elsif ($sentstr =~ m/the approach/i) { $flag = 1; }
    elsif ($sentstr =~ m/the framework/i) { $flag = 1; }
    elsif ($sentstr =~ m/formulation/i) { $flag = 1; }
    elsif ($sentstr =~ m/framework/i) { $flag = 1; } 
    elsif ($sentstr =~ m/^architecture/i) { $flag = 1; } 
    elsif ($sentstr =~ m/^system/i) { $flag = 1; } 
    elsif ($sentstr =~ m/definition/i) { $flag = 1; }
    elsif ($sentstr =~ m/^overview/i) { $flag = 1; }
    elsif ($sentstr =~ m/algorithm/i) { $flag = 1; }
    elsif ($sentstr =~ m/approach/i) { $flag = 1; }
    elsif ($sentstr =~ m/model/i) { $flag = 1; }
    elsif ($sentstr =~ m/method/i) { $flag = 1; }
    elsif ($sentstr =~ m/corpus/i) { $flag = 1; }
    elsif ($sentstr =~ m/corpora/i) { $flag = 1; }
    elsif ($sentstr =~ m/data/i) { $flag = 1; }
    elsif ($sentstr =~ m/resource/i) { $flag = 1; }
    elsif ($sentstr =~ m/preprocessing/i) { $flag = 1; }
    elsif ($sentstr =~ m/feature/i) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_result($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if ($sentstr =~ m/experiment/i) { $flag = 1; }
    elsif ($sentstr =~ m/evaluation/i) { $flag = 1; } # need to check
    elsif ($sentstr =~ m/^error analysis/i) { $flag = 1; }
    elsif ($sentstr =~ m/^analysis/i) { $flag = 1; }
    elsif ($sentstr =~ m/result/i) { $flag = 1; }
    elsif ($sentstr =~ m/implementation/i) { $flag = 1; }
    elsif ($sentstr =~ m/preparation/i) { $flag = 1; }
    elsif ($sentstr =~ m/performance/i) { $flag = 1; }
    elsif (($sentstr =~ m/demo\b/i) || ($sentstr =~ m/demos\b/i) ||
	   ($sentstr =~ m/demonstrat/i)) { $flag = 1; }
    elsif ($sentstr =~ m/baseline/i) { $flag = 1; }
    elsif (($sentstr =~ m/setup/i) 
	   || ($sentstr =~ m/set up/i) ) { $flag = 1; }
    elsif ($sentstr =~ m/example/i) { $flag = 1; }
    elsif ($sentstr =~ m/illustrat/i) { $flag = 1; }
    elsif ($sentstr =~ m/case study/i) { $flag = 1; }
    elsif ($sentstr =~ m/study/i) { $flag = 1; }
    elsif ($sentstr =~ m/studies/i) { $flag = 1; }
    elsif ($sentstr =~ m/validation/i) { $flag = 1; }
    elsif ($sentstr =~ m/observation/i)  { $flag = 1; }
    elsif ($sentstr =~ m/evaluat/i)  { $flag = 1; }
    elsif ($sentstr =~ m/statistics/i)  { $flag = 1; }
    elsif (($sentstr =~ m/comparison/i) 
		|| ($sentstr =~ m/qualitative/)
		|| ($sentstr =~ m/quantitative/)
		) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_intro($)
{
    my $sentstr = shift(@_);

    my $flag = 0;

    if ($sentstr =~ m/^introduction to/i) { $flag = 0; }
    elsif ($sentstr =~ m/^introduction of/i) { $flag = 0; }
    elsif ($sentstr =~ m/^introduction\s*:/i) { $flag = 0; }
    elsif ($sentstr =~ m/^introduction\b/i) { $flag = 1; }
    elsif ($sentstr =~ m/introduction/i) { $flag = 0; }
    elsif ($sentstr =~ m/^preliminaries$/i) { $flag = 1; } 
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_background($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if ($sentstr =~ m/^motivation/i) { $flag = 1; }
    elsif ($sentstr =~ m/^related/i) { $flag = 1; }
    elsif ($sentstr =~ m/^background/i) { $flag = 1; }
    elsif ($sentstr =~ m/^previous/i) { $flag = 1; }
    elsif ($sentstr =~ m/^prior/i) { $flag = 1; }
    elsif ($sentstr =~ m/^literature/i) { $flag = 1; }
    elsif ($sentstr =~ m/^state of the art$/i) { $flag = 1; }
    elsif ($sentstr =~ m/^existing/i) { $flag = 1; }
    elsif (($sentstr =~ m/related work/i)
		|| ($sentstr =~ m/previous work/i)
		|| ($sentstr =~ m/relevant work/i)
		|| ($sentstr =~ m/prior work/i)
		|| ($sentstr =~ m/ealier work/i)
		) { $flag = 1; }
    elsif (($sentstr =~ m/review of/i) 
		|| ($sentstr =~ m/review:/i)) { $flag = 1; }
    elsif ($sentstr =~ m/problem/i) { $flag = 1; }
    elsif ($sentstr =~ m/challenge/i) { $flag = 1; }
    elsif ($sentstr =~ m/motivating/i) { $flag = 1; }
    elsif ($sentstr =~ m/background/i)  { $flag = 1; }
    elsif ($sentstr =~ m/goal/i)  { $flag = 1; }
    elsif ($sentstr =~ m/survey/i)  { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_abstract($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if ($sentstr =~ m/^a\s*bstract[\.\:\s\*]*$/i) { $flag = 1; }

    $flag;
}

#------------------------------------------------------------------------#
sub
is_reference($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    ### tread this as exceptional
    if ($sentstr =~ m/^references\b/i) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_appendix($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
#    if ($sentstr =~ m/^acknowledg/i) { $flag = 1; }
    if ($sentstr =~ m/appendix/i) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_acknowledge($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if ($sentstr =~ m/^acknowledg/i) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
is_discussion($)
{
    my $sentstr = shift(@_);

    my $flag = 0;
    
    if ($sentstr =~ m/^conclusion/i) { $flag = 1; }
    elsif ($sentstr =~ m/^discussion/i) { $flag = 1; }
    elsif ($sentstr =~ m/discussion/i) { $flag = 1; }
    elsif ($sentstr =~ m/concluding/i) { $flag = 1; }
    elsif ($sentstr =~ m/^summary/i) { $flag = 1; }
    elsif ($sentstr =~ m/^perspective/i) { $flag = 1; }
    elsif ($sentstr =~ m/^outlook$/i) { $flag = 1; }
    elsif ($sentstr =~ m/^contributions/i) { $flag = 1; }
    elsif ($sentstr =~ m/future/i) { $flag = 1; }
    elsif ($sentstr =~ m/remaining/i) { $flag = 1; }
    elsif ($sentstr =~ m/limitation/i) { $flag = 1; }
    elsif ($sentstr =~ m/application/i) { $flag = 1; }
    elsif ($sentstr =~ m/use case/i) { $flag = 1; }
    elsif ($sentstr =~ m/findings/i) { $flag = 1; }
    elsif ($sentstr =~ m/implication/i) { $flag = 1; }
    elsif ($sentstr =~ m/lessons learned/i) { $flag = 1; }
    elsif ($sentstr =~ m/impact on/i) { $flag = 1; }
    elsif ($sentstr =~ m/impacts on/i) { $flag = 1; }
#
#    elsif ($sentstr =~ m/conclusion/i) { $flag = 1; }
#    elsif ($sentstr =~ m/perspective/i) { $flag = 1; }
#    elsif ($sentstr =~ m/remark/i) { $flag = 1; }
#    elsif ($sentstr =~ m/summary/i) { $flag = 1; }
#    elsif ($sentstr =~ m/further/i) { $flag = 1; }
    
    $flag;
}

#------------------------------------------------------------------------#
sub
read_sectitle_dic_sup()
{
    my $infile = "DATA/Section/section-title-all.sup";

    open(IN, "<$infile") || die "can't open $infile\n";
    print STDERR "Read from $infile.\n";
    while (my $read = <IN>)
    {
	my @elist = split(/\t|\n/, $read);
	my $freq = shift(@elist);
	my $titlestr = shift(@elist);
	my @seclabel = @elist;
	$secdic{$titlestr} = join("\t", @seclabel);
    }
    close(IN);

    if(0)
    {
    my $infile = "DATA/Section/section-title-method.sup";

    open(IN, "<$infile") || die "can't open $infile\n";
    while (my $read = <IN>)
    {
	my @elist = split(/\t|\n/, $read);
	my $freq = shift(@elist);
	my $titlestr = shift(@elist);
	my @seclabel = @elist;
	$secdic{$titlestr} = join("\t", @seclabel);
    }
    close(IN);
    }
}

#------------------------------------------------------------------------#
1;
