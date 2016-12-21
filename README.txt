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
  printing ROUGE-1, ROUGE-2, and ROUGE-4 recall (ordered by ROUGE-2).

System      R-1    R-2   R-4
Lead        31.46  6.13  0.62
LexRank     36.00  7.51  0.83
Centroid    36.42  7.98  1.20
FreqSum     35.31  8.12  1.00
TsSum       35.93  8.16  1.03
GreedyKL    38.03  8.56  1.27
CLASSY04    37.71  9.02  1.53
CLASSY11    37.21  9.21  1.48
Submodular  39.23  9.37  1.39
DPP         39.84  9.62  1.57
OCCAMS_V    38.50  9.75  1.33
RegSum      38.60  9.78  1.62
ICSISumm    38.44  9.81  1.74

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
