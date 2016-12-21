#!/usr/bin/env perl
use v5.14;
use open qw{ :encoding(UTF-8) :std };
use Encode qw{ encode decode };
# $chars = decode("UTF-8",$bytes);
# $bytes = encode("UTF-8",$chars);

#
# Statistical significance testing.
# 
# @author  Stuart Mackie (s.mackie.1@research.gla.ac.uk).
# @version December 2016.

use Statistics::R;

my @systems = (
  "Lead",
  "FreqSum","TsSum","Centroid","LexRank","GreedyKL",
  "CLASSY04","CLASSY11","DPP","ICSISumm","OCCAMS_V","RegSum","Submodular"
);

my @topics = (
  "d30001","d30002","d30003","d30005","d30006","d30007","d30008","d30010","d30011","d30015",
  "d30017","d30020","d30022","d30024","d30026","d30027","d30028","d30029","d30031","d30033",
  "d30034","d30036","d30037","d30038","d30040","d30042","d30044","d30045","d30046","d30047",
  "d30048","d30049","d30050","d30051","d30053","d30055","d30056","d30059","d31001","d31008",
  "d31009","d31013","d31022","d31026","d31031","d31032","d31033","d31038","d31043","d31050"
);

my %scores;

open my $RESULTS,"<","rouge.res";

while (my $line = <$RESULTS>) {
  chomp $line;
  next unless $line =~ m/ROUGE-[1,2,4] Eval/;
  my ($system,$rougen,$eval,$topic,$recall,$precision,$fscore) = split(/\s/, $line);
  ($topic,my $null) = split(/\./,$topic);
  (my $null,$recall) = split(/\:/,$recall);
  $scores{$system}{$topic}{$rougen} = $recall;
}

close $RESULTS;

my %profiles;

for my $system (@systems) {
  my @rouge1;
  my @rouge2;
  my @rouge4;
  open my $PROFILES,">","pertopic/$system";
  for my $topic (@topics) {
    my $rouge1 = $scores{$system}{$topic}{'ROUGE-1'};
    my $rouge2 = $scores{$system}{$topic}{'ROUGE-2'};
    my $rouge4 = $scores{$system}{$topic}{'ROUGE-4'};
    push @rouge1,$rouge1;
    push @rouge2,$rouge2;
    push @rouge4,$rouge4;
    print $PROFILES "$topic\t$rouge1\t$rouge2\t$rouge4\n";
  }
  $profiles{$system}{"ROUGE-1"} = \@rouge1;
  $profiles{$system}{"ROUGE-2"} = \@rouge2;
  $profiles{$system}{"ROUGE-4"} = \@rouge4;
  close $PROFILES;
}

#
# ROUGE-1
#

my @lead_r1       = @{$profiles{"Lead"}{"ROUGE-1"}};
my @freqsum_r1    = @{$profiles{"FreqSum"}{"ROUGE-1"}};
my @tssum_r1      = @{$profiles{"TsSum"}{"ROUGE-1"}};
my @centroid_r1   = @{$profiles{"Centroid"}{"ROUGE-1"}};
my @lexrank_r1    = @{$profiles{"LexRank"}{"ROUGE-1"}};
my @greedykl_r1   = @{$profiles{"GreedyKL"}{"ROUGE-1"}};
my @classy04_r1   = @{$profiles{"CLASSY04"}{"ROUGE-1"}};
my @classy11_r1   = @{$profiles{"CLASSY11"}{"ROUGE-1"}};
my @dpp_r1        = @{$profiles{"DPP"}{"ROUGE-1"}};
my @icsisumm_r1   = @{$profiles{"ICSISumm"}{"ROUGE-1"}};
my @occamsv_r1    = @{$profiles{"OCCAMS_V"}{"ROUGE-1"}};
my @regsum_r1     = @{$profiles{"RegSum"}{"ROUGE-1"}};
my @submodular_r1 = @{$profiles{"Submodular"}{"ROUGE-1"}};

say "R1 Lead FreqSum TsSum Centroid LexRank GreedyKL CLASSY04 CLASSY11 DPP ICSISumm OCCAMS_V RegSum Submodular";
say "Lead"       . " " . sttest(\@lead_r1,\@lead_r1)       . " " . wilcox(\@freqsum_r1,\@lead_r1)       . " " . wilcox(\@tssum_r1,\@lead_r1)       . " " . wilcox(\@centroid_r1,\@lead_r1)       . " " . wilcox(\@lexrank_r1,\@lead_r1)       . " " . wilcox(\@greedykl_r1,\@lead_r1)       . " " . wilcox(\@classy04_r1,\@lead_r1)       . " " . wilcox(\@classy11_r1,\@lead_r1)       . " " . wilcox(\@dpp_r1,\@lead_r1)       . " " . wilcox(\@icsisumm_r1,\@lead_r1)       . " " . wilcox(\@occamsv_r1,\@lead_r1)       . " " . wilcox(\@regsum_r1,\@lead_r1)       . " " . wilcox(\@submodular_r1,\@lead_r1)       ;
say "FreqSum"    . " " . sttest(\@lead_r1,\@freqsum_r1)    . " " . sttest(\@freqsum_r1,\@freqsum_r1)    . " " . wilcox(\@tssum_r1,\@freqsum_r1)    . " " . wilcox(\@centroid_r1,\@freqsum_r1)    . " " . wilcox(\@lexrank_r1,\@freqsum_r1)    . " " . wilcox(\@greedykl_r1,\@freqsum_r1)    . " " . wilcox(\@classy04_r1,\@freqsum_r1)    . " " . wilcox(\@classy11_r1,\@freqsum_r1)    . " " . wilcox(\@dpp_r1,\@freqsum_r1)    . " " . wilcox(\@icsisumm_r1,\@freqsum_r1)    . " " . wilcox(\@occamsv_r1,\@freqsum_r1)    . " " . wilcox(\@regsum_r1,\@freqsum_r1)    . " " . wilcox(\@submodular_r1,\@freqsum_r1)    ;
say "TsSum"      . " " . sttest(\@lead_r1,\@tssum_r1)      . " " . sttest(\@freqsum_r1,\@tssum_r1)      . " " . sttest(\@tssum_r1,\@tssum_r1)      . " " . wilcox(\@centroid_r1,\@tssum_r1)      . " " . wilcox(\@lexrank_r1,\@tssum_r1)      . " " . wilcox(\@greedykl_r1,\@tssum_r1)      . " " . wilcox(\@classy04_r1,\@tssum_r1)      . " " . wilcox(\@classy11_r1,\@tssum_r1)      . " " . wilcox(\@dpp_r1,\@tssum_r1)      . " " . wilcox(\@icsisumm_r1,\@tssum_r1)      . " " . wilcox(\@occamsv_r1,\@tssum_r1)      . " " . wilcox(\@regsum_r1,\@tssum_r1)      . " " . wilcox(\@submodular_r1,\@tssum_r1)      ;
say "Centroid"   . " " . sttest(\@lead_r1,\@centroid_r1)   . " " . sttest(\@freqsum_r1,\@centroid_r1)   . " " . sttest(\@tssum_r1,\@centroid_r1)   . " " . sttest(\@centroid_r1,\@centroid_r1)   . " " . wilcox(\@lexrank_r1,\@centroid_r1)   . " " . wilcox(\@greedykl_r1,\@centroid_r1)   . " " . wilcox(\@classy04_r1,\@centroid_r1)   . " " . wilcox(\@classy11_r1,\@centroid_r1)   . " " . wilcox(\@dpp_r1,\@centroid_r1)   . " " . wilcox(\@icsisumm_r1,\@centroid_r1)   . " " . wilcox(\@occamsv_r1,\@centroid_r1)   . " " . wilcox(\@regsum_r1,\@centroid_r1)   . " " . wilcox(\@submodular_r1,\@centroid_r1)   ;
say "LexRank"    . " " . sttest(\@lead_r1,\@lexrank_r1)    . " " . sttest(\@freqsum_r1,\@lexrank_r1)    . " " . sttest(\@tssum_r1,\@lexrank_r1)    . " " . sttest(\@centroid_r1,\@lexrank_r1)    . " " . sttest(\@lexrank_r1,\@lexrank_r1)    . " " . wilcox(\@greedykl_r1,\@lexrank_r1)    . " " . wilcox(\@classy04_r1,\@lexrank_r1)    . " " . wilcox(\@classy11_r1,\@lexrank_r1)    . " " . wilcox(\@dpp_r1,\@lexrank_r1)    . " " . wilcox(\@icsisumm_r1,\@lexrank_r1)    . " " . wilcox(\@occamsv_r1,\@lexrank_r1)    . " " . wilcox(\@regsum_r1,\@lexrank_r1)    . " " . wilcox(\@submodular_r1,\@lexrank_r1)    ;
say "GreedyKL"   . " " . sttest(\@lead_r1,\@greedykl_r1)   . " " . sttest(\@freqsum_r1,\@greedykl_r1)   . " " . sttest(\@tssum_r1,\@greedykl_r1)   . " " . sttest(\@centroid_r1,\@greedykl_r1)   . " " . sttest(\@lexrank_r1,\@greedykl_r1)   . " " . sttest(\@greedykl_r1,\@greedykl_r1)   . " " . wilcox(\@classy04_r1,\@greedykl_r1)   . " " . wilcox(\@classy11_r1,\@greedykl_r1)   . " " . wilcox(\@dpp_r1,\@greedykl_r1)   . " " . wilcox(\@icsisumm_r1,\@greedykl_r1)   . " " . wilcox(\@occamsv_r1,\@greedykl_r1)   . " " . wilcox(\@regsum_r1,\@greedykl_r1)   . " " . wilcox(\@submodular_r1,\@greedykl_r1)   ;
say "CLASSY04"   . " " . sttest(\@lead_r1,\@classy04_r1)   . " " . sttest(\@freqsum_r1,\@classy04_r1)   . " " . sttest(\@tssum_r1,\@classy04_r1)   . " " . sttest(\@centroid_r1,\@classy04_r1)   . " " . sttest(\@lexrank_r1,\@classy04_r1)   . " " . sttest(\@greedykl_r1,\@classy04_r1)   . " " . sttest(\@classy04_r1,\@classy04_r1)   . " " . wilcox(\@classy11_r1,\@classy04_r1)   . " " . wilcox(\@dpp_r1,\@classy04_r1)   . " " . wilcox(\@icsisumm_r1,\@classy04_r1)   . " " . wilcox(\@occamsv_r1,\@classy04_r1)   . " " . wilcox(\@regsum_r1,\@classy04_r1)   . " " . wilcox(\@submodular_r1,\@classy04_r1)   ;
say "CLASSY11"   . " " . sttest(\@lead_r1,\@classy11_r1)   . " " . sttest(\@freqsum_r1,\@classy11_r1)   . " " . sttest(\@tssum_r1,\@classy11_r1)   . " " . sttest(\@centroid_r1,\@classy11_r1)   . " " . sttest(\@lexrank_r1,\@classy11_r1)   . " " . sttest(\@greedykl_r1,\@classy11_r1)   . " " . sttest(\@classy04_r1,\@classy11_r1)   . " " . sttest(\@classy11_r1,\@classy11_r1)   . " " . wilcox(\@dpp_r1,\@classy11_r1)   . " " . wilcox(\@icsisumm_r1,\@classy11_r1)   . " " . wilcox(\@occamsv_r1,\@classy11_r1)   . " " . wilcox(\@regsum_r1,\@classy11_r1)   . " " . wilcox(\@submodular_r1,\@classy11_r1)   ;
say "DPP"        . " " . sttest(\@lead_r1,\@dpp_r1)        . " " . sttest(\@freqsum_r1,\@dpp_r1)        . " " . sttest(\@tssum_r1,\@dpp_r1)        . " " . sttest(\@centroid_r1,\@dpp_r1)        . " " . sttest(\@lexrank_r1,\@dpp_r1)        . " " . sttest(\@greedykl_r1,\@dpp_r1)        . " " . sttest(\@classy04_r1,\@dpp_r1)        . " " . sttest(\@classy11_r1,\@dpp_r1)        . " " . sttest(\@dpp_r1,\@dpp_r1)        . " " . wilcox(\@icsisumm_r1,\@dpp_r1)        . " " . wilcox(\@occamsv_r1,\@dpp_r1)        . " " . wilcox(\@regsum_r1,\@dpp_r1)        . " " . wilcox(\@submodular_r1,\@dpp_r1)        ;
say "ICSISumm"   . " " . sttest(\@lead_r1,\@icsisumm_r1)   . " " . sttest(\@freqsum_r1,\@icsisumm_r1)   . " " . sttest(\@tssum_r1,\@icsisumm_r1)   . " " . sttest(\@centroid_r1,\@icsisumm_r1)   . " " . sttest(\@lexrank_r1,\@icsisumm_r1)   . " " . sttest(\@greedykl_r1,\@icsisumm_r1)   . " " . sttest(\@classy04_r1,\@icsisumm_r1)   . " " . sttest(\@classy11_r1,\@icsisumm_r1)   . " " . sttest(\@dpp_r1,\@icsisumm_r1)   . " " . sttest(\@icsisumm_r1,\@icsisumm_r1)   . " " . wilcox(\@occamsv_r1,\@icsisumm_r1)   . " " . wilcox(\@regsum_r1,\@icsisumm_r1)   . " " . wilcox(\@submodular_r1,\@icsisumm_r1)   ;
say "OCCAMS_V"   . " " . sttest(\@lead_r1,\@occamsv_r1)    . " " . sttest(\@freqsum_r1,\@occamsv_r1)    . " " . sttest(\@tssum_r1,\@occamsv_r1)    . " " . sttest(\@centroid_r1,\@occamsv_r1)    . " " . sttest(\@lexrank_r1,\@occamsv_r1)    . " " . sttest(\@greedykl_r1,\@occamsv_r1)    . " " . sttest(\@classy04_r1,\@occamsv_r1)    . " " . sttest(\@classy11_r1,\@occamsv_r1)    . " " . sttest(\@dpp_r1,\@occamsv_r1)    . " " . sttest(\@icsisumm_r1,\@occamsv_r1)    . " " . sttest(\@occamsv_r1,\@occamsv_r1)    . " " . wilcox(\@regsum_r1,\@occamsv_r1)    . " " . wilcox(\@submodular_r1,\@occamsv_r1)    ;
say "RegSum"     . " " . sttest(\@lead_r1,\@regsum_r1)     . " " . sttest(\@freqsum_r1,\@regsum_r1)     . " " . sttest(\@tssum_r1,\@regsum_r1)     . " " . sttest(\@centroid_r1,\@regsum_r1)     . " " . sttest(\@lexrank_r1,\@regsum_r1)     . " " . sttest(\@greedykl_r1,\@regsum_r1)     . " " . sttest(\@classy04_r1,\@regsum_r1)     . " " . sttest(\@classy11_r1,\@regsum_r1)     . " " . sttest(\@dpp_r1,\@regsum_r1)     . " " . sttest(\@icsisumm_r1,\@regsum_r1)     . " " . sttest(\@occamsv_r1,\@regsum_r1)     . " " . sttest(\@regsum_r1,\@regsum_r1)     . " " . wilcox(\@submodular_r1,\@regsum_r1)     ;
say "Submodular" . " " . sttest(\@lead_r1,\@submodular_r1) . " " . sttest(\@freqsum_r1,\@submodular_r1) . " " . sttest(\@tssum_r1,\@submodular_r1) . " " . sttest(\@centroid_r1,\@submodular_r1) . " " . sttest(\@lexrank_r1,\@submodular_r1) . " " . sttest(\@greedykl_r1,\@submodular_r1) . " " . sttest(\@classy04_r1,\@submodular_r1) . " " . sttest(\@classy11_r1,\@submodular_r1) . " " . sttest(\@dpp_r1,\@submodular_r1) . " " . sttest(\@icsisumm_r1,\@submodular_r1) . " " . sttest(\@occamsv_r1,\@submodular_r1) . " " . sttest(\@regsum_r1,\@submodular_r1) . " " . sttest(\@submodular_r1,\@submodular_r1) ;

#
# ROUGE-2
#

my @lead_r2       = @{$profiles{"Lead"}{"ROUGE-2"}};
my @freqsum_r2    = @{$profiles{"FreqSum"}{"ROUGE-2"}};
my @tssum_r2      = @{$profiles{"TsSum"}{"ROUGE-2"}};
my @centroid_r2   = @{$profiles{"Centroid"}{"ROUGE-2"}};
my @lexrank_r2    = @{$profiles{"LexRank"}{"ROUGE-2"}};
my @greedykl_r2   = @{$profiles{"GreedyKL"}{"ROUGE-2"}};
my @classy04_r2   = @{$profiles{"CLASSY04"}{"ROUGE-2"}};
my @classy11_r2   = @{$profiles{"CLASSY11"}{"ROUGE-2"}};
my @dpp_r2        = @{$profiles{"DPP"}{"ROUGE-2"}};
my @icsisumm_r2   = @{$profiles{"ICSISumm"}{"ROUGE-2"}};
my @occamsv_r2    = @{$profiles{"OCCAMS_V"}{"ROUGE-2"}};
my @regsum_r2     = @{$profiles{"RegSum"}{"ROUGE-2"}};
my @submodular_r2 = @{$profiles{"Submodular"}{"ROUGE-2"}};

say "R2 Lead FreqSum TsSum Centroid LexRank GreedyKL CLASSY04 CLASSY11 DPP ICSISumm OCCAMS_V RegSum Submodular";
say "Lead"       . " " . sttest(\@lead_r2,\@lead_r2)       . " " . wilcox(\@freqsum_r2,\@lead_r2)       . " " . wilcox(\@tssum_r2,\@lead_r2)       . " " . wilcox(\@centroid_r2,\@lead_r2)       . " " . wilcox(\@lexrank_r2,\@lead_r2)       . " " . wilcox(\@greedykl_r2,\@lead_r2)       . " " . wilcox(\@classy04_r2,\@lead_r2)       . " " . wilcox(\@classy11_r2,\@lead_r2)       . " " . wilcox(\@dpp_r2,\@lead_r2)       . " " . wilcox(\@icsisumm_r2,\@lead_r2)       . " " . wilcox(\@occamsv_r2,\@lead_r2)       . " " . wilcox(\@regsum_r2,\@lead_r2)       . " " . wilcox(\@submodular_r2,\@lead_r2)       ;
say "FreqSum"    . " " . sttest(\@lead_r2,\@freqsum_r2)    . " " . sttest(\@freqsum_r2,\@freqsum_r2)    . " " . wilcox(\@tssum_r2,\@freqsum_r2)    . " " . wilcox(\@centroid_r2,\@freqsum_r2)    . " " . wilcox(\@lexrank_r2,\@freqsum_r2)    . " " . wilcox(\@greedykl_r2,\@freqsum_r2)    . " " . wilcox(\@classy04_r2,\@freqsum_r2)    . " " . wilcox(\@classy11_r2,\@freqsum_r2)    . " " . wilcox(\@dpp_r2,\@freqsum_r2)    . " " . wilcox(\@icsisumm_r2,\@freqsum_r2)    . " " . wilcox(\@occamsv_r2,\@freqsum_r2)    . " " . wilcox(\@regsum_r2,\@freqsum_r2)    . " " . wilcox(\@submodular_r2,\@freqsum_r2)    ;
say "TsSum"      . " " . sttest(\@lead_r2,\@tssum_r2)      . " " . sttest(\@freqsum_r2,\@tssum_r2)      . " " . sttest(\@tssum_r2,\@tssum_r2)      . " " . wilcox(\@centroid_r2,\@tssum_r2)      . " " . wilcox(\@lexrank_r2,\@tssum_r2)      . " " . wilcox(\@greedykl_r2,\@tssum_r2)      . " " . wilcox(\@classy04_r2,\@tssum_r2)      . " " . wilcox(\@classy11_r2,\@tssum_r2)      . " " . wilcox(\@dpp_r2,\@tssum_r2)      . " " . wilcox(\@icsisumm_r2,\@tssum_r2)      . " " . wilcox(\@occamsv_r2,\@tssum_r2)      . " " . wilcox(\@regsum_r2,\@tssum_r2)      . " " . wilcox(\@submodular_r2,\@tssum_r2)      ;
say "Centroid"   . " " . sttest(\@lead_r2,\@centroid_r2)   . " " . sttest(\@freqsum_r2,\@centroid_r2)   . " " . sttest(\@tssum_r2,\@centroid_r2)   . " " . sttest(\@centroid_r2,\@centroid_r2)   . " " . wilcox(\@lexrank_r2,\@centroid_r2)   . " " . wilcox(\@greedykl_r2,\@centroid_r2)   . " " . wilcox(\@classy04_r2,\@centroid_r2)   . " " . wilcox(\@classy11_r2,\@centroid_r2)   . " " . wilcox(\@dpp_r2,\@centroid_r2)   . " " . wilcox(\@icsisumm_r2,\@centroid_r2)   . " " . wilcox(\@occamsv_r2,\@centroid_r2)   . " " . wilcox(\@regsum_r2,\@centroid_r2)   . " " . wilcox(\@submodular_r2,\@centroid_r2)   ;
say "LexRank"    . " " . sttest(\@lead_r2,\@lexrank_r2)    . " " . sttest(\@freqsum_r2,\@lexrank_r2)    . " " . sttest(\@tssum_r2,\@lexrank_r2)    . " " . sttest(\@centroid_r2,\@lexrank_r2)    . " " . sttest(\@lexrank_r2,\@lexrank_r2)    . " " . wilcox(\@greedykl_r2,\@lexrank_r2)    . " " . wilcox(\@classy04_r2,\@lexrank_r2)    . " " . wilcox(\@classy11_r2,\@lexrank_r2)    . " " . wilcox(\@dpp_r2,\@lexrank_r2)    . " " . wilcox(\@icsisumm_r2,\@lexrank_r2)    . " " . wilcox(\@occamsv_r2,\@lexrank_r2)    . " " . wilcox(\@regsum_r2,\@lexrank_r2)    . " " . wilcox(\@submodular_r2,\@lexrank_r2)    ;
say "GreedyKL"   . " " . sttest(\@lead_r2,\@greedykl_r2)   . " " . sttest(\@freqsum_r2,\@greedykl_r2)   . " " . sttest(\@tssum_r2,\@greedykl_r2)   . " " . sttest(\@centroid_r2,\@greedykl_r2)   . " " . sttest(\@lexrank_r2,\@greedykl_r2)   . " " . sttest(\@greedykl_r2,\@greedykl_r2)   . " " . wilcox(\@classy04_r2,\@greedykl_r2)   . " " . wilcox(\@classy11_r2,\@greedykl_r2)   . " " . wilcox(\@dpp_r2,\@greedykl_r2)   . " " . wilcox(\@icsisumm_r2,\@greedykl_r2)   . " " . wilcox(\@occamsv_r2,\@greedykl_r2)   . " " . wilcox(\@regsum_r2,\@greedykl_r2)   . " " . wilcox(\@submodular_r2,\@greedykl_r2)   ;
say "CLASSY04"   . " " . sttest(\@lead_r2,\@classy04_r2)   . " " . sttest(\@freqsum_r2,\@classy04_r2)   . " " . sttest(\@tssum_r2,\@classy04_r2)   . " " . sttest(\@centroid_r2,\@classy04_r2)   . " " . sttest(\@lexrank_r2,\@classy04_r2)   . " " . sttest(\@greedykl_r2,\@classy04_r2)   . " " . sttest(\@classy04_r2,\@classy04_r2)   . " " . wilcox(\@classy11_r2,\@classy04_r2)   . " " . wilcox(\@dpp_r2,\@classy04_r2)   . " " . wilcox(\@icsisumm_r2,\@classy04_r2)   . " " . wilcox(\@occamsv_r2,\@classy04_r2)   . " " . wilcox(\@regsum_r2,\@classy04_r2)   . " " . wilcox(\@submodular_r2,\@classy04_r2)   ;
say "CLASSY11"   . " " . sttest(\@lead_r2,\@classy11_r2)   . " " . sttest(\@freqsum_r2,\@classy11_r2)   . " " . sttest(\@tssum_r2,\@classy11_r2)   . " " . sttest(\@centroid_r2,\@classy11_r2)   . " " . sttest(\@lexrank_r2,\@classy11_r2)   . " " . sttest(\@greedykl_r2,\@classy11_r2)   . " " . sttest(\@classy04_r2,\@classy11_r2)   . " " . sttest(\@classy11_r2,\@classy11_r2)   . " " . wilcox(\@dpp_r2,\@classy11_r2)   . " " . wilcox(\@icsisumm_r2,\@classy11_r2)   . " " . wilcox(\@occamsv_r2,\@classy11_r2)   . " " . wilcox(\@regsum_r2,\@classy11_r2)   . " " . wilcox(\@submodular_r2,\@classy11_r2)   ;
say "DPP"        . " " . sttest(\@lead_r2,\@dpp_r2)        . " " . sttest(\@freqsum_r2,\@dpp_r2)        . " " . sttest(\@tssum_r2,\@dpp_r2)        . " " . sttest(\@centroid_r2,\@dpp_r2)        . " " . sttest(\@lexrank_r2,\@dpp_r2)        . " " . sttest(\@greedykl_r2,\@dpp_r2)        . " " . sttest(\@classy04_r2,\@dpp_r2)        . " " . sttest(\@classy11_r2,\@dpp_r2)        . " " . sttest(\@dpp_r2,\@dpp_r2)        . " " . wilcox(\@icsisumm_r2,\@dpp_r2)        . " " . wilcox(\@occamsv_r2,\@dpp_r2)        . " " . wilcox(\@regsum_r2,\@dpp_r2)        . " " . wilcox(\@submodular_r2,\@dpp_r2)        ;
say "ICSISumm"   . " " . sttest(\@lead_r2,\@icsisumm_r2)   . " " . sttest(\@freqsum_r2,\@icsisumm_r2)   . " " . sttest(\@tssum_r2,\@icsisumm_r2)   . " " . sttest(\@centroid_r2,\@icsisumm_r2)   . " " . sttest(\@lexrank_r2,\@icsisumm_r2)   . " " . sttest(\@greedykl_r2,\@icsisumm_r2)   . " " . sttest(\@classy04_r2,\@icsisumm_r2)   . " " . sttest(\@classy11_r2,\@icsisumm_r2)   . " " . sttest(\@dpp_r2,\@icsisumm_r2)   . " " . sttest(\@icsisumm_r2,\@icsisumm_r2)   . " " . wilcox(\@occamsv_r2,\@icsisumm_r2)   . " " . wilcox(\@regsum_r2,\@icsisumm_r2)   . " " . wilcox(\@submodular_r2,\@icsisumm_r2)   ;
say "OCCAMS_V"   . " " . sttest(\@lead_r2,\@occamsv_r2)    . " " . sttest(\@freqsum_r2,\@occamsv_r2)    . " " . sttest(\@tssum_r2,\@occamsv_r2)    . " " . sttest(\@centroid_r2,\@occamsv_r2)    . " " . sttest(\@lexrank_r2,\@occamsv_r2)    . " " . sttest(\@greedykl_r2,\@occamsv_r2)    . " " . sttest(\@classy04_r2,\@occamsv_r2)    . " " . sttest(\@classy11_r2,\@occamsv_r2)    . " " . sttest(\@dpp_r2,\@occamsv_r2)    . " " . sttest(\@icsisumm_r2,\@occamsv_r2)    . " " . sttest(\@occamsv_r2,\@occamsv_r2)    . " " . wilcox(\@regsum_r2,\@occamsv_r2)    . " " . wilcox(\@submodular_r2,\@occamsv_r2)    ;
say "RegSum"     . " " . sttest(\@lead_r2,\@regsum_r2)     . " " . sttest(\@freqsum_r2,\@regsum_r2)     . " " . sttest(\@tssum_r2,\@regsum_r2)     . " " . sttest(\@centroid_r2,\@regsum_r2)     . " " . sttest(\@lexrank_r2,\@regsum_r2)     . " " . sttest(\@greedykl_r2,\@regsum_r2)     . " " . sttest(\@classy04_r2,\@regsum_r2)     . " " . sttest(\@classy11_r2,\@regsum_r2)     . " " . sttest(\@dpp_r2,\@regsum_r2)     . " " . sttest(\@icsisumm_r2,\@regsum_r2)     . " " . sttest(\@occamsv_r2,\@regsum_r2)     . " " . sttest(\@regsum_r2,\@regsum_r2)     . " " . wilcox(\@submodular_r2,\@regsum_r2)     ;
say "Submodular" . " " . sttest(\@lead_r2,\@submodular_r2) . " " . sttest(\@freqsum_r2,\@submodular_r2) . " " . sttest(\@tssum_r2,\@submodular_r2) . " " . sttest(\@centroid_r2,\@submodular_r2) . " " . sttest(\@lexrank_r2,\@submodular_r2) . " " . sttest(\@greedykl_r2,\@submodular_r2) . " " . sttest(\@classy04_r2,\@submodular_r2) . " " . sttest(\@classy11_r2,\@submodular_r2) . " " . sttest(\@dpp_r2,\@submodular_r2) . " " . sttest(\@icsisumm_r2,\@submodular_r2) . " " . sttest(\@occamsv_r2,\@submodular_r2) . " " . sttest(\@regsum_r2,\@submodular_r2) . " " . sttest(\@submodular_r2,\@submodular_r2) ;

#
# ROUGE-4
#

my @lead_r4       = @{$profiles{"Lead"}{"ROUGE-4"}};
my @freqsum_r4    = @{$profiles{"FreqSum"}{"ROUGE-4"}};
my @tssum_r4      = @{$profiles{"TsSum"}{"ROUGE-4"}};
my @centroid_r4   = @{$profiles{"Centroid"}{"ROUGE-4"}};
my @lexrank_r4    = @{$profiles{"LexRank"}{"ROUGE-4"}};
my @greedykl_r4   = @{$profiles{"GreedyKL"}{"ROUGE-4"}};
my @classy04_r4   = @{$profiles{"CLASSY04"}{"ROUGE-4"}};
my @classy11_r4   = @{$profiles{"CLASSY11"}{"ROUGE-4"}};
my @dpp_r4        = @{$profiles{"DPP"}{"ROUGE-4"}};
my @icsisumm_r4   = @{$profiles{"ICSISumm"}{"ROUGE-4"}};
my @occamsv_r4    = @{$profiles{"OCCAMS_V"}{"ROUGE-4"}};
my @regsum_r4     = @{$profiles{"RegSum"}{"ROUGE-4"}};
my @submodular_r4 = @{$profiles{"Submodular"}{"ROUGE-4"}};

say "R4 Lead FreqSum TsSum Centroid LexRank GreedyKL CLASSY04 CLASSY11 DPP ICSISumm OCCAMS_V RegSum Submodular";
say "Lead"       . " " . sttest(\@lead_r4,\@lead_r4)       . " " . wilcox(\@freqsum_r4,\@lead_r4)       . " " . wilcox(\@tssum_r4,\@lead_r4)       . " " . wilcox(\@centroid_r4,\@lead_r4)       . " " . wilcox(\@lexrank_r4,\@lead_r4)       . " " . wilcox(\@greedykl_r4,\@lead_r4)       . " " . wilcox(\@classy04_r4,\@lead_r4)       . " " . wilcox(\@classy11_r4,\@lead_r4)       . " " . wilcox(\@dpp_r4,\@lead_r4)       . " " . wilcox(\@icsisumm_r4,\@lead_r4)       . " " . wilcox(\@occamsv_r4,\@lead_r4)       . " " . wilcox(\@regsum_r4,\@lead_r4)       . " " . wilcox(\@submodular_r4,\@lead_r4)       ;
say "FreqSum"    . " " . sttest(\@lead_r4,\@freqsum_r4)    . " " . sttest(\@freqsum_r4,\@freqsum_r4)    . " " . wilcox(\@tssum_r4,\@freqsum_r4)    . " " . wilcox(\@centroid_r4,\@freqsum_r4)    . " " . wilcox(\@lexrank_r4,\@freqsum_r4)    . " " . wilcox(\@greedykl_r4,\@freqsum_r4)    . " " . wilcox(\@classy04_r4,\@freqsum_r4)    . " " . wilcox(\@classy11_r4,\@freqsum_r4)    . " " . wilcox(\@dpp_r4,\@freqsum_r4)    . " " . wilcox(\@icsisumm_r4,\@freqsum_r4)    . " " . wilcox(\@occamsv_r4,\@freqsum_r4)    . " " . wilcox(\@regsum_r4,\@freqsum_r4)    . " " . wilcox(\@submodular_r4,\@freqsum_r4)    ;
say "TsSum"      . " " . sttest(\@lead_r4,\@tssum_r4)      . " " . sttest(\@freqsum_r4,\@tssum_r4)      . " " . sttest(\@tssum_r4,\@tssum_r4)      . " " . wilcox(\@centroid_r4,\@tssum_r4)      . " " . wilcox(\@lexrank_r4,\@tssum_r4)      . " " . wilcox(\@greedykl_r4,\@tssum_r4)      . " " . wilcox(\@classy04_r4,\@tssum_r4)      . " " . wilcox(\@classy11_r4,\@tssum_r4)      . " " . wilcox(\@dpp_r4,\@tssum_r4)      . " " . wilcox(\@icsisumm_r4,\@tssum_r4)      . " " . wilcox(\@occamsv_r4,\@tssum_r4)      . " " . wilcox(\@regsum_r4,\@tssum_r4)      . " " . wilcox(\@submodular_r4,\@tssum_r4)      ;
say "Centroid"   . " " . sttest(\@lead_r4,\@centroid_r4)   . " " . sttest(\@freqsum_r4,\@centroid_r4)   . " " . sttest(\@tssum_r4,\@centroid_r4)   . " " . sttest(\@centroid_r4,\@centroid_r4)   . " " . wilcox(\@lexrank_r4,\@centroid_r4)   . " " . wilcox(\@greedykl_r4,\@centroid_r4)   . " " . wilcox(\@classy04_r4,\@centroid_r4)   . " " . wilcox(\@classy11_r4,\@centroid_r4)   . " " . wilcox(\@dpp_r4,\@centroid_r4)   . " " . wilcox(\@icsisumm_r4,\@centroid_r4)   . " " . wilcox(\@occamsv_r4,\@centroid_r4)   . " " . wilcox(\@regsum_r4,\@centroid_r4)   . " " . wilcox(\@submodular_r4,\@centroid_r4)   ;
say "LexRank"    . " " . sttest(\@lead_r4,\@lexrank_r4)    . " " . sttest(\@freqsum_r4,\@lexrank_r4)    . " " . sttest(\@tssum_r4,\@lexrank_r4)    . " " . sttest(\@centroid_r4,\@lexrank_r4)    . " " . sttest(\@lexrank_r4,\@lexrank_r4)    . " " . wilcox(\@greedykl_r4,\@lexrank_r4)    . " " . wilcox(\@classy04_r4,\@lexrank_r4)    . " " . wilcox(\@classy11_r4,\@lexrank_r4)    . " " . wilcox(\@dpp_r4,\@lexrank_r4)    . " " . wilcox(\@icsisumm_r4,\@lexrank_r4)    . " " . wilcox(\@occamsv_r4,\@lexrank_r4)    . " " . wilcox(\@regsum_r4,\@lexrank_r4)    . " " . wilcox(\@submodular_r4,\@lexrank_r4)    ;
say "GreedyKL"   . " " . sttest(\@lead_r4,\@greedykl_r4)   . " " . sttest(\@freqsum_r4,\@greedykl_r4)   . " " . sttest(\@tssum_r4,\@greedykl_r4)   . " " . sttest(\@centroid_r4,\@greedykl_r4)   . " " . sttest(\@lexrank_r4,\@greedykl_r4)   . " " . sttest(\@greedykl_r4,\@greedykl_r4)   . " " . wilcox(\@classy04_r4,\@greedykl_r4)   . " " . wilcox(\@classy11_r4,\@greedykl_r4)   . " " . wilcox(\@dpp_r4,\@greedykl_r4)   . " " . wilcox(\@icsisumm_r4,\@greedykl_r4)   . " " . wilcox(\@occamsv_r4,\@greedykl_r4)   . " " . wilcox(\@regsum_r4,\@greedykl_r4)   . " " . wilcox(\@submodular_r4,\@greedykl_r4)   ;
say "CLASSY04"   . " " . sttest(\@lead_r4,\@classy04_r4)   . " " . sttest(\@freqsum_r4,\@classy04_r4)   . " " . sttest(\@tssum_r4,\@classy04_r4)   . " " . sttest(\@centroid_r4,\@classy04_r4)   . " " . sttest(\@lexrank_r4,\@classy04_r4)   . " " . sttest(\@greedykl_r4,\@classy04_r4)   . " " . sttest(\@classy04_r4,\@classy04_r4)   . " " . wilcox(\@classy11_r4,\@classy04_r4)   . " " . wilcox(\@dpp_r4,\@classy04_r4)   . " " . wilcox(\@icsisumm_r4,\@classy04_r4)   . " " . wilcox(\@occamsv_r4,\@classy04_r4)   . " " . wilcox(\@regsum_r4,\@classy04_r4)   . " " . wilcox(\@submodular_r4,\@classy04_r4)   ;
say "CLASSY11"   . " " . sttest(\@lead_r4,\@classy11_r4)   . " " . sttest(\@freqsum_r4,\@classy11_r4)   . " " . sttest(\@tssum_r4,\@classy11_r4)   . " " . sttest(\@centroid_r4,\@classy11_r4)   . " " . sttest(\@lexrank_r4,\@classy11_r4)   . " " . sttest(\@greedykl_r4,\@classy11_r4)   . " " . sttest(\@classy04_r4,\@classy11_r4)   . " " . sttest(\@classy11_r4,\@classy11_r4)   . " " . wilcox(\@dpp_r4,\@classy11_r4)   . " " . wilcox(\@icsisumm_r4,\@classy11_r4)   . " " . wilcox(\@occamsv_r4,\@classy11_r4)   . " " . wilcox(\@regsum_r4,\@classy11_r4)   . " " . wilcox(\@submodular_r4,\@classy11_r4)   ;
say "DPP"        . " " . sttest(\@lead_r4,\@dpp_r4)        . " " . sttest(\@freqsum_r4,\@dpp_r4)        . " " . sttest(\@tssum_r4,\@dpp_r4)        . " " . sttest(\@centroid_r4,\@dpp_r4)        . " " . sttest(\@lexrank_r4,\@dpp_r4)        . " " . sttest(\@greedykl_r4,\@dpp_r4)        . " " . sttest(\@classy04_r4,\@dpp_r4)        . " " . sttest(\@classy11_r4,\@dpp_r4)        . " " . sttest(\@dpp_r4,\@dpp_r4)        . " " . wilcox(\@icsisumm_r4,\@dpp_r4)        . " " . wilcox(\@occamsv_r4,\@dpp_r4)        . " " . wilcox(\@regsum_r4,\@dpp_r4)        . " " . wilcox(\@submodular_r4,\@dpp_r4)        ;
say "ICSISumm"   . " " . sttest(\@lead_r4,\@icsisumm_r4)   . " " . sttest(\@freqsum_r4,\@icsisumm_r4)   . " " . sttest(\@tssum_r4,\@icsisumm_r4)   . " " . sttest(\@centroid_r4,\@icsisumm_r4)   . " " . sttest(\@lexrank_r4,\@icsisumm_r4)   . " " . sttest(\@greedykl_r4,\@icsisumm_r4)   . " " . sttest(\@classy04_r4,\@icsisumm_r4)   . " " . sttest(\@classy11_r4,\@icsisumm_r4)   . " " . sttest(\@dpp_r4,\@icsisumm_r4)   . " " . sttest(\@icsisumm_r4,\@icsisumm_r4)   . " " . wilcox(\@occamsv_r4,\@icsisumm_r4)   . " " . wilcox(\@regsum_r4,\@icsisumm_r4)   . " " . wilcox(\@submodular_r4,\@icsisumm_r4)   ;
say "OCCAMS_V"   . " " . sttest(\@lead_r4,\@occamsv_r4)    . " " . sttest(\@freqsum_r4,\@occamsv_r4)    . " " . sttest(\@tssum_r4,\@occamsv_r4)    . " " . sttest(\@centroid_r4,\@occamsv_r4)    . " " . sttest(\@lexrank_r4,\@occamsv_r4)    . " " . sttest(\@greedykl_r4,\@occamsv_r4)    . " " . sttest(\@classy04_r4,\@occamsv_r4)    . " " . sttest(\@classy11_r4,\@occamsv_r4)    . " " . sttest(\@dpp_r4,\@occamsv_r4)    . " " . sttest(\@icsisumm_r4,\@occamsv_r4)    . " " . sttest(\@occamsv_r4,\@occamsv_r4)    . " " . wilcox(\@regsum_r4,\@occamsv_r4)    . " " . wilcox(\@submodular_r4,\@occamsv_r4)    ;
say "RegSum"     . " " . sttest(\@lead_r4,\@regsum_r4)     . " " . sttest(\@freqsum_r4,\@regsum_r4)     . " " . sttest(\@tssum_r4,\@regsum_r4)     . " " . sttest(\@centroid_r4,\@regsum_r4)     . " " . sttest(\@lexrank_r4,\@regsum_r4)     . " " . sttest(\@greedykl_r4,\@regsum_r4)     . " " . sttest(\@classy04_r4,\@regsum_r4)     . " " . sttest(\@classy11_r4,\@regsum_r4)     . " " . sttest(\@dpp_r4,\@regsum_r4)     . " " . sttest(\@icsisumm_r4,\@regsum_r4)     . " " . sttest(\@occamsv_r4,\@regsum_r4)     . " " . sttest(\@regsum_r4,\@regsum_r4)     . " " . wilcox(\@submodular_r4,\@regsum_r4)     ;
say "Submodular" . " " . sttest(\@lead_r4,\@submodular_r4) . " " . sttest(\@freqsum_r4,\@submodular_r4) . " " . sttest(\@tssum_r4,\@submodular_r4) . " " . sttest(\@centroid_r4,\@submodular_r4) . " " . sttest(\@lexrank_r4,\@submodular_r4) . " " . sttest(\@greedykl_r4,\@submodular_r4) . " " . sttest(\@classy04_r4,\@submodular_r4) . " " . sttest(\@classy11_r4,\@submodular_r4) . " " . sttest(\@dpp_r4,\@submodular_r4) . " " . sttest(\@icsisumm_r4,\@submodular_r4) . " " . sttest(\@occamsv_r4,\@submodular_r4) . " " . sttest(\@regsum_r4,\@submodular_r4) . " " . sttest(\@submodular_r4,\@submodular_r4) ;

#
# Statistical test:
#

sub sttest() {

  my ($aref,$bref) = @_;
  my @a = @{$aref};
  my @b = @{$bref};

  my $R = Statistics::R->new();

  $R->set('a', \@a);
  $R->set('b', \@b);

  $R->run(q`p = t.test(a,b,alternative="two.sided",paired=TRUE,conf.level=0.95)$p.value`);

  my $pvalue = $R->get('p');

  $R->stop();

  return "Y" if $pvalue <= 0.05;
  return "N" if $pvalue >  0.05;
  return "-";
}

sub wilcox() {

  my ($aref,$bref) = @_;
  my @a = @{$aref};
  my @b = @{$bref};

  my $R = Statistics::R->new();

  $R->set('a', \@a);
  $R->set('b', \@b);

  $R->run(q`p = wilcox.test(a,b,alternative="two.sided",paired=TRUE,conf.level=0.95)$p.value`);

  my $pvalue = $R->get('p');

  $R->stop();

  return "Y" if $pvalue <= 0.05;
  return "N" if $pvalue >  0.05;
  return "-";
}


## 
