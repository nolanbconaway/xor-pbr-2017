from psychopy import visual, event, core
import os, sys
import numpy as np
from misc import *
from socket import gethostname
from operator import itemgetter
from time import strftime
from os.path import join as pj
import itertools as it
execfile('instructions.py')

MODE = "REAL" #"DEMO" or "REAL"


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#-----------GET EXPERIMENT INFO------------
experimentname = os.path.split(os.path.split(__file__)[0])[-1]
conditions = [1]
categories, isi, numtrainingblocks =  ['Alpha', 'Beta'], 0.5, 12
fontopts = dict(
	height = 22,
	font = 'Consolas',
	color = [-1, -1, -1]
)

# set up stimulus grid on physical values
featureorder, stimulusspace = ['Size','Color'], [7,7]
sizevalues  = np.linspace(  75, 200, num = stimulusspace[0])
shadevalues = np.linspace(-0.8, 0.8, num = stimulusspace[1])
coordinates = np.array(list(it.product(sizevalues,shadevalues)))
featurelabels = [
		['Smaller','Bigger'],
		['Darker','Lighter']
		]


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
##Specify directories
subjectsfolder       = pj(os.getcwd(), 'subjects')
logdir               = pj(os.getcwd(), 'logfiles')
    
## get subject information
checkdirectory(subjectsfolder)
[subjectid,condition,subjectfile] = getsubjectinfo( experimentname,conditions,subjectsfolder)
# subjectid,condition,subjectfile = 1,1, pj(os.getcwd(), 'subjects','DEMO-1-1.csv')

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# CREATE WINDOW AND SET LOGGING OPTIONS
if gethostname() not in ['klab1','klab2','klab3']:
    win=visual.Window([1440,900],units='pix',color=[1,1,1])
else:
    win=visual.Window(fullscr=True,units='pix',color=[1,1,1])
    checkdirectory(logdir)
    logfile = pj(logdir, str(subjectid) + '-logfile.txt')
    while os.path.exists(logfile):
        logfile+='_dupe.txt'
    logfile=open(logfile,'w')
    sys.stdout, sys.stderr = logfile, logfile

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# GET COUNTERBALANCE INFO, PRINT TO LOG.

##determine counterbalance information
balancecondition=np.random.choice(6)
balanceinfo=getcounterbalance(stimulusspace,balancecondition)
[imageassignments, flipdims, assigndims] = balanceinfo

# adjust feature strings for counterbalance
featureorder=[ featureorder[i] for i in assigndims]
featurelabels = [ featurelabels[i] for i in assigndims]
[featurelabels[i].reverse() for i in range(len(featurelabels)) if flipdims[i]]

##get current date and time
starttime=strftime("%d %b %Y %X")

# get running computer
pc=gethostname()

print '\n SUBJECT INFORMATION:'
print ['Start Time: ', starttime]
print ['PC: ', pc]
print ['ID: ', subjectid]
print ['Condition: ', condition]
print ['Counterbalance condition', balancecondition]
print ['Flipped Dimensions', flipdims]
print ['Feature Order',featureorder]
print ['File: ',subjectfile]

# initalize a data list                    
subjectdata=[	[starttime],
				[pc,subjectid,condition],
				[balancecondition,featurelabels]
		]
# --------SET UP THE INITAL CATEGORY
 # 42 43 44 45 46 47 48
 # 35 36 37 38 39 40 41
 # 28 29 30 31 32 33 34
 # 21 22 23 24 25 26 27
 # 14 15 16 17 18 19 20
 #  7  8  9 10 11 12 13
 #  0  1  2  3  4  5  6
# ----------------------------------

trainingitems = [
		[ 0, 8, 40, 48],
		[42, 36, 42, 36]
	]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# -------GENERATE EXPERIMENT STIMULI----------
grid_stimuli, id = [], 0
for num in imageassignments:
	size, color = coordinates[num]
	stimulus = visual.Rect(win, width = size, height = size, units = 'pix',
			fillColor = (color,color,color), fillColorSpace = 'rgb',
			lineColor = 'black', lineWidth = 1.0)

	item = dict(
		id = id,
		size = size,
		color = color,
		stimulus = stimulus
	)	

	grid_stimuli.append(item)
	id+=1

grid_stimuli = sorted(grid_stimuli, key=lambda k: k['id']) 
print '\n-------------------- GRID STIMULI --------------------'
printlist(grid_stimuli)

# make instruction stimuli
instructions=visual.TextStim(win,text='', wrapWidth=900,
	alignVert='center',alignHoriz='center', pos=[0.0,0.0], **fontopts)
fixcross=visual.TextStim(win, text='+', pos=(0,150), **fontopts)

##create an OK button
OKbutton = visual.Rect(win, width=75, height=50, units = 'pix',
        fillColor = 'white', lineColor = 'black', lineWidth=2.0, pos = (0, -110))
OKlabel  = visual.TextStim(win, text = 'OK', pos=OKbutton.pos, **fontopts)


continuestring='\n\
\n\
Click anywhere to continue.'
cursor = event.Mouse(visible=True, newPos=None, win=win)
timer=core.Clock() #clock


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# PASS TO PHASE SCRIPTS

phase = "similarity1"
execfile('similarity.py')

execfile('train_classify.py')
execfile('test_generalize.py')

phase = "similarity2"
execfile('similarity.py')

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# TERMINATE EXPERIMENT
finishtime=strftime("%a, %d %b %Y %X")
print '\nStart Time: ' +starttime
print 'End Time: ' +finishtime +'\n'
subjectdata[0].append(finishtime)
writefile(subjectfile,subjectdata,',')

#do exit screen
instructions.setText(instructiontext[-1][-1])
instructions.pos=[0.0,0.0]
instructions.alignVert='center'
instructions.draw(win)
win.flip()
event.waitKeys()

print '\nExperiment complete.'
win.close()
if gethostname() in ['klab1','klab2','klab3']:
    copy2db(subjectfile,experimentname)
    logfile.close()
    os.system("TASKKILL /F /IM pythonw.exe")
