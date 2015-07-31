## Written by: Tiffany A. Timbers, Ph.D.
## April 23, 2015
## Modified by Catrina Loucks May 20, 2015 to take zip files as input (instead of folders with MWT data)

## This is the driver script that will call modulars scripts to attack each chunk
## of the problem: this software will allow you to plot habituation probability graphs and 
## generate statistical comparisons between groups (if there are multiple groups) using 
## data from the Multi-worm tracker (Swierczek et al., 2011). 
##
##
## Set working directory to project's root directory
##
## Requires the following input from the user:
##		$1: absolute path to chore.jar (offline analys program Choreography)
##		$2: gigabytes of memory to be used to run Choreography (dependent upon
##			the machine you are using
##      $3: stimulus (e.g. tap)
##		$4:	directory that data is in 


## Call choreography to analyze the MWT data. This must be done for each plate (i.e. 
## each .zip folder). Choreography output options here ask for 
## reversals occurring within 0.5 s of a stimulus and speed over the duration of the 
## entire experiment (averaged over all the worms on the plate).
cd $4
for zipfolder in *.zip; do java -Xmx$2g -jar $1 --shadowless -p 0.027 -M 2 -t 20 -S -o s --plugin Reoutline::despike --plugin Respine --plugin MeasureReversal::tap::collect=0.5 $zipfolder; done

## need to create a large file containing all data files with 
## data, plate name and strain name in each row
##grep -r '[0-9]' $(find ./data -name '*.dat') > merged.file
for filename in $(find . -name '*.rev'); do grep -H '[0-9]' $filename >> data.srev; done
cd ../..

## create figure (Reversal probability versus stimulus number, plotting 95% confidence 
## interval) and do stats (Logistic regression comparing initial reversal probability and
## final reversal probability between groups).
rscript bin/habituation_probability_plotNstats.R $4

