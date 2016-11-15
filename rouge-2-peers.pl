#!/usr/bin/env perl
use v5.14;
use open qw{ :encoding(UTF-8) :std };
use Encode qw{ encode decode };
# $chars = decode("UTF-8",$bytes);
# $bytes = encode("UTF-8",$chars);

#
# Prepare ROUGE peers.
# 
# @author  Stuart Mackie (s.mackie.1@research.gla.ac.uk).
# @version November 2016.

use File::Slurp;
use Lingua::Sentence;

my @topics = (
  "d30001","d30002","d30003","d30005","d30006","d30007","d30008","d30010","d30011","d30015",
  "d30017","d30020","d30022","d30024","d30026","d30027","d30028","d30029","d30031","d30033",
  "d30034","d30036","d30037","d30038","d30040","d30042","d30044","d30045","d30046","d30047",
  "d30048","d30049","d30050","d30051","d30053","d30055","d30056","d30059","d31001","d31008",
  "d31009","d31013","d31022","d31026","d31031","d31032","d31033","d31038","d31043","d31050"
);

my @systems = (
  "Lead",
  "FreqSum","TsSum","Centroid","LexRank","GreedyKL",
  "CLASSY04","CLASSY11","DPP","ICSISumm","OCCAMS_V","RegSum","Submodular"
);

for my $system (@systems) {

  for my $topic (@topics) {

    my $peertext  = read_file("peers-txt/$topic.$system");

    my $sentences = Lingua::Sentence->new("en");
    my @sentences = $sentences->split_array($peertext);

    open my $PEER,">","peers/$topic.$system.html";

    print $PEER "<html>\n<head>\n<title>$topic.$system</title>\n</head>\n<body bgcolor=\"white\">\n";

    my $line = 1;
    for my $sentence (@sentences) {
      print $PEER "<a name=\"$line\">[$line]</a> <a href=\"#$line\" id=$line>$sentence</a>\n";
      $line++;
    }

    print $PEER "</body>\n</html>\n";
    close $PEER;
  }
}


## 
