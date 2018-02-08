# Conaway & Kurtz (2017)

This repo contains the data and code from [this paper in PBR](https://link.springer.com/article/10.3758/s13423-016-1208-1).

I copied these files into one place and only cleaned things up a little bit. The code is as messy and disorganized as you might expect. Do not hesitate to get in touch for clarification/context. I have exported the data into a tidy format  (SV files in the top level directory), if you want something missing then you're going to have to munge through the code.

Every experiment's code can be separated into the following components:

1. Behavioral experiment (psychopy).
2. Analysis of behavioral data (MATLAB).

Each experiment is in a directory, and the psychopy experiment is in a subdirectory called "reference". Raw subject data is in subdirectory called "subjects". I called the psychopy directory "reference" because you'll need to reference it to make any use of the raw data.
