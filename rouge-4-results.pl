#!/usr/bin/env perl
use v5.14;
use open qw{ :encoding(UTF-8) :std };
use Encode qw{ encode decode };
# $chars = decode("UTF-8",$bytes);
# $bytes = encode("UTF-8",$chars);

#
# Parse ROUGE evaluation.
# 
# @author  Stuart Mackie (s.mackie.1@research.gla.ac.uk).
# @version November 2016.

my @systems = (
  "Lead",
  "FreqSum","TsSum","Centroid","LexRank","GreedyKL",
  "CLASSY04","CLASSY11","DPP","ICSISumm","OCCAMS_V","RegSum","Submodular"
);

my %results;

open my $RESULTS,"<","rouge.res";

while (my $line = <$RESULTS>) {
  chomp $line;
  next if $line =~ m/---------------------------------------------/;
  next if $line =~ m/\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\./;
  next if $line =~ m/Average_P/;
  next if $line =~ m/Average_F/;
  next if $line =~ m/Eval/;
  my ($system,$rougen,$metric,$value,$conf) = split(/\s/, $line);
  $results{$system}{$rougen} = $value;
}

close $RESULTS;

say "System\tR-1\tR-2";

for my $system (@systems) {
  my $rouge1 = sprintf "%.2f", $results{$system}{'ROUGE-1'} * 100;
  my $rouge2 = sprintf "%.2f", $results{$system}{'ROUGE-2'} * 100;
  say "$system\t$rouge1\t$rouge2"
}


## 
