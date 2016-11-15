#!/bin/sh

#
# ROUGE Evaluation.
# 
# @author  Stuart Mackie (s.mackie.1@research.gla.ac.uk).
# @version November 2016.

# Models:
rm -rf models
mkdir models
./rouge-1-models.pl

# Peers:
rm -rf peers
mkdir peers
./rouge-2-peers.pl

# Config:
./rouge-3-xmlconf.pl

# ROUGE:
ROUGE_EVAL_HOME=./RELEASE-1.5.5/data perl ./RELEASE-1.5.5/ROUGE-1.5.5.pl -n 2 -x -m -l 100 -p 0.5 -c 95 -r 1000 -f A -t 0 -a -d rouge.xml > rouge.res

  # ROUGE parameters:

  # -n 2       ## ROUGE-N.
  # -x         ## Skip ROUGE-L.

  # -m         ## Porter stemming.
  # -l         ## Trim to 100 words.

  # -p 0.5     ## R/P f-score balance.
  # -c 95      ## Confidence interval.
  # -r 1000    ## Bootstrap re-sampling.
  # -f A       ## Scoring by model average.
  # -t 0       ## Sentences as counting unit.

  # -a         ## Evaluate all systems.
  # -d         ## Print per-topic scores.
  # rouge.xml  ## Configuration file.

# Results:
./rouge-4-results.pl | sort -n -k3,3 | column -t


## 
