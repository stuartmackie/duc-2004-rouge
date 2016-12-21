#!/usr/bin/env perl
use v5.14;
use open qw{ :encoding(UTF-8) :std };
use Encode qw{ encode decode };
# $chars = decode("UTF-8",$bytes);
# $bytes = encode("UTF-8",$chars);

#
# Prepare ROUGE models.
# 
# @author  Stuart Mackie (s.mackie.1@research.gla.ac.uk).
# @version December 2016.

use File::Slurp;
use Lingua::Sentence;

my @topics = (
  "d30001","d30002","d30003","d30005","d30006","d30007","d30008","d30010","d30011","d30015",
  "d30017","d30020","d30022","d30024","d30026","d30027","d30028","d30029","d30031","d30033",
  "d30034","d30036","d30037","d30038","d30040","d30042","d30044","d30045","d30046","d30047",
  "d30048","d30049","d30050","d30051","d30053","d30055","d30056","d30059","d31001","d31008",
  "d31009","d31013","d31022","d31026","d31031","d31032","d31033","d31038","d31043","d31050"
);

my %duc2004 = (
   "d30001" => ["d30001.m.100.t.a","d30001.m.100.t.b","d30001.m.100.t.c","d30001.m.100.t.d"],
   "d30002" => ["d30002.m.100.t.a","d30002.m.100.t.b","d30002.m.100.t.c","d30002.m.100.t.e"],
   "d30003" => ["d30003.m.100.t.a","d30003.m.100.t.b","d30003.m.100.t.c","d30003.m.100.t.f"],
   "d30005" => ["d30005.m.100.t.a","d30005.m.100.t.b","d30005.m.100.t.c","d30005.m.100.t.g"],
   "d30006" => ["d30006.m.100.t.a","d30006.m.100.t.b","d30006.m.100.t.c","d30006.m.100.t.h"],
   "d30007" => ["d30007.m.100.t.a","d30007.m.100.t.b","d30007.m.100.t.d","d30007.m.100.t.e"],
   "d30008" => ["d30008.m.100.t.a","d30008.m.100.t.b","d30008.m.100.t.d","d30008.m.100.t.g"],
   "d30010" => ["d30010.m.100.t.a","d30010.m.100.t.b","d30010.m.100.t.d","d30010.m.100.t.h"],
   "d30011" => ["d30011.m.100.t.a","d30011.m.100.t.b","d30011.m.100.t.e","d30011.m.100.t.f"],
   "d30015" => ["d30015.m.100.t.a","d30015.m.100.t.b","d30015.m.100.t.e","d30015.m.100.t.h"],
   "d30017" => ["d30017.m.100.t.a","d30017.m.100.t.b","d30017.m.100.t.f","d30017.m.100.t.g"],
   "d30020" => ["d30020.m.100.t.a","d30020.m.100.t.c","d30020.m.100.t.d","d30020.m.100.t.e"],
   "d30022" => ["d30022.m.100.t.a","d30022.m.100.t.c","d30022.m.100.t.d","d30022.m.100.t.f"],
   "d30024" => ["d30024.m.100.t.a","d30024.m.100.t.c","d30024.m.100.t.d","d30024.m.100.t.g"],
   "d30026" => ["d30026.m.100.t.a","d30026.m.100.t.c","d30026.m.100.t.d","d30026.m.100.t.h"],
   "d30027" => ["d30027.m.100.t.a","d30027.m.100.t.c","d30027.m.100.t.e","d30027.m.100.t.g"],
   "d30028" => ["d30028.m.100.t.a","d30028.m.100.t.c","d30028.m.100.t.f","d30028.m.100.t.g"],
   "d30029" => ["d30029.m.100.t.a","d30029.m.100.t.c","d30029.m.100.t.f","d30029.m.100.t.h"],
   "d30031" => ["d30031.m.100.t.a","d30031.m.100.t.d","d30031.m.100.t.e","d30031.m.100.t.f"],
   "d30033" => ["d30033.m.100.t.a","d30033.m.100.t.d","d30033.m.100.t.e","d30033.m.100.t.g"],
   "d30034" => ["d30034.m.100.t.a","d30034.m.100.t.d","d30034.m.100.t.f","d30034.m.100.t.g"],
   "d30036" => ["d30036.m.100.t.a","d30036.m.100.t.d","d30036.m.100.t.f","d30036.m.100.t.h"],
   "d30037" => ["d30037.m.100.t.a","d30037.m.100.t.d","d30037.m.100.t.g","d30037.m.100.t.h"],
   "d30038" => ["d30038.m.100.t.a","d30038.m.100.t.e","d30038.m.100.t.f","d30038.m.100.t.h"],
   "d30040" => ["d30040.m.100.t.a","d30040.m.100.t.e","d30040.m.100.t.g","d30040.m.100.t.h"],
   "d30042" => ["d30042.m.100.t.b","d30042.m.100.t.c","d30042.m.100.t.d","d30042.m.100.t.f"],
   "d30044" => ["d30044.m.100.t.b","d30044.m.100.t.c","d30044.m.100.t.d","d30044.m.100.t.g"],
   "d30045" => ["d30045.m.100.t.b","d30045.m.100.t.c","d30045.m.100.t.e","d30045.m.100.t.f"],
   "d30046" => ["d30046.m.100.t.b","d30046.m.100.t.c","d30046.m.100.t.e","d30046.m.100.t.h"],
   "d30047" => ["d30047.m.100.t.b","d30047.m.100.t.c","d30047.m.100.t.f","d30047.m.100.t.h"],
   "d30048" => ["d30048.m.100.t.b","d30048.m.100.t.c","d30048.m.100.t.g","d30048.m.100.t.h"],
   "d30049" => ["d30049.m.100.t.b","d30049.m.100.t.d","d30049.m.100.t.e","d30049.m.100.t.g"],
   "d30050" => ["d30050.m.100.t.b","d30050.m.100.t.d","d30050.m.100.t.e","d30050.m.100.t.h"],
   "d30051" => ["d30051.m.100.t.b","d30051.m.100.t.d","d30051.m.100.t.f","d30051.m.100.t.h"],
   "d30053" => ["d30053.m.100.t.b","d30053.m.100.t.e","d30053.m.100.t.f","d30053.m.100.t.g"],
   "d30055" => ["d30055.m.100.t.b","d30055.m.100.t.e","d30055.m.100.t.f","d30055.m.100.t.h"],
   "d30056" => ["d30056.m.100.t.b","d30056.m.100.t.e","d30056.m.100.t.g","d30056.m.100.t.h"],
   "d30059" => ["d30059.m.100.t.b","d30059.m.100.t.f","d30059.m.100.t.g","d30059.m.100.t.h"],
   "d31001" => ["d31001.m.100.t.c","d31001.m.100.t.d","d31001.m.100.t.e","d31001.m.100.t.g"],
   "d31008" => ["d31008.m.100.t.c","d31008.m.100.t.d","d31008.m.100.t.e","d31008.m.100.t.h"],
   "d31009" => ["d31009.m.100.t.b","d31009.m.100.t.c","d31009.m.100.t.f","d31009.m.100.t.g"],
   "d31013" => ["d31013.m.100.t.c","d31013.m.100.t.d","d31013.m.100.t.g","d31013.m.100.t.h"],
   "d31022" => ["d31022.m.100.t.c","d31022.m.100.t.e","d31022.m.100.t.f","d31022.m.100.t.g"],
   "d31026" => ["d31026.m.100.t.c","d31026.m.100.t.e","d31026.m.100.t.f","d31026.m.100.t.h"],
   "d31031" => ["d31031.m.100.t.c","d31031.m.100.t.f","d31031.m.100.t.g","d31031.m.100.t.h"],
   "d31032" => ["d31032.m.100.t.d","d31032.m.100.t.e","d31032.m.100.t.f","d31032.m.100.t.g"],
   "d31033" => ["d31033.m.100.t.d","d31033.m.100.t.e","d31033.m.100.t.f","d31033.m.100.t.h"],
   "d31038" => ["d31038.m.100.t.d","d31038.m.100.t.e","d31038.m.100.t.g","d31038.m.100.t.h"],
   "d31043" => ["d31043.m.100.t.d","d31043.m.100.t.f","d31043.m.100.t.g","d31043.m.100.t.h"],
   "d31050" => ["d31050.m.100.t.e","d31050.m.100.t.f","d31050.m.100.t.g","d31050.m.100.t.h"]
);

for my $topic (sort keys %duc2004) {

  for my $goldstds ($duc2004{$topic}) {

    for my $goldstd (@$goldstds) {

      my $goldtxt   = read_file("models-txt/$goldstd");

      my $sentences = Lingua::Sentence->new("en");
      my @sentences = $sentences->split_array($goldtxt);

      open my $MODEL,">","models/$goldstd.html";

      print $MODEL "<html>\n<head>\n<title>$goldstd</title>\n</head>\n<body bgcolor=\"white\">\n";

      my $line = 1;
      for my $sentence (@sentences) {
        print $MODEL "<a name=\"$line\">[$line]</a> <a href=\"#$line\" id=$line>$sentence</a>\n";
        $line++;
      }

      print $MODEL "</body>\n</html>\n";
      close $MODEL;
    }
  }
}


## 
