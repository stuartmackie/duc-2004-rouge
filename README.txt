==============
duc-2004-rouge
==============

Scripts to run a ROUGE[1] evaluation, over DUC 2004 Task 2,
  http://duc.nist.gov/duc2004/tasks.html.

Evaluate the baselines and state-of-the-art from SumRepo[2],
  and also the DUC 2004 Task 2 Lead baseline, which was the
  "... first 665 bytes of the TEXT of the most recent document".

Requires ROUGE-1.5.5.tgz, from www.berouge.com.

Run "rouge.sh" to execute the evaluation pipeline,
  printing results ordered by ROUGE-2.

System      R-1    R-2
Lead        31.46  6.13
LexRank     36.00  7.51
Centroid    36.42  7.98
FreqSum     35.31  8.12
TsSum       35.93  8.16
GreedyKL    38.03  8.56
CLASSY04    37.71  9.02
CLASSY11    37.21  9.21
Submodular  39.23  9.37
DPP         39.84  9.62
OCCAMS_V    38.50  9.75
RegSum      38.60  9.78
ICSISumm    38.44  9.81

Statistical significance testing:

./rouge-5-statsig.pl | column -t


[1] LIN (2004).
    ROUGE: a Package for Automatic Evaluation of Summaries.
    In Proc. of ACL '04.

[2] HONG, CONROY, FAVRE, KULESZA, LIN, and NENKOVA (2014).
    A Repository of State of the Art and Competitive Baseline Summaries for Generic News Summarization.
    In Proc. of LREC '14.


-- 
Stuart Mackie
s.mackie.1@research.gla.ac.uk
