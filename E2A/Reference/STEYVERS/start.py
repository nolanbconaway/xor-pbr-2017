from psychopy import visual, event, core
import os, sys
import numpy as np
from misc import *
from socket import gethostname
from operator import itemgetter
from time import strftime
from os.path import join as pj


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#-----------GET EXPERIMENT INFO------------
experimentname = os.path.split(os.path.split(__file__)[0])[-1]
conditions=[1,1]
categorynames=['Alpha','Beta']
isi=.5
numtrainingblocks = 12
txtcolor, txtfont, txtsize= [-1,-1,-1], 'Consolas', 22
imageposition=[0,150]
stimulusspace = [12, 12]
featurenames=['Shading','Size']

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
##Specify directories
subjectsfolder = pj(os.getcwd(), 'subjects')
imagedir       = pj(os.getcwd(), 'images12x12')
logdir         = pj(os.getcwd(), 'logfiles')
    
## get subject information
checkdirectory(subjectsfolder)
[subjectid,condition,subjectfile] = getsubjectinfo(
    experimentname,conditions,subjectsfolder)


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

##get current date and time
starttime=strftime("%d %b %Y %X")

# get running computer
pc=gethostname()

##determine counterbalance information
balancecondition=np.random.randint(0,6)

# get 9x9 counterbalance assignments
balanceinfo=getcounterbalance(stimulusspace,balancecondition)
[imageassignments, flipdims, assigndims] = balanceinfo
featurenames=[ featurenames[i] for i in assigndims]


print '\n SUBJECT INFORMATION:'
print ['Start Time: ', starttime]
print ['PC: ', pc]
print ['ID: ', subjectid]
print ['Condition: ', condition]
print ['Counterbalance condition', balancecondition]
print ['Flipped Dimensions', flipdims]
print ['Feature Order',featurenames]
print ['File: ',subjectfile]


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# -------STORE CONDITION INFO-----------------

# initalize a data list                    
subjectdata=[[starttime],[pc,subjectid,condition],
    [balancecondition,flipdims,featurenames]]

# 133 134 135 136 137 138 139 140 141 142 143 144
# 121 122 123 124 125 126 127 128 129 130 131 132
# 109 110 111 112 113 114 115 116 117 118 119 120
#  97  98  99 100 101 102 103 104 105 106 107 108
#  85  86  87  88  89  90  91  92  93  94  95  96
#  73  74  75  76  77  78  79  80  81  82  83  84
#  61  62  63  64  65  66  67  68  69  70  71  72
#  49  50  51  52  53  54  55  56  57  58  59  60
#  37  38  39  40  41  42  43  44  45  46  47  48
#  25  26  27  28  29  30  31  32  33  34  35  36
#  13  14  15  16  17  18  19  20  21  22  23  24
#   1   2   3   4   5   6   7   8   9  10  11  12

trainingitems= [[ 6, 19, 71, 84],
                [67, 78, 67, 78]]
criticalitems = [  1,   2,   3,  10,  11,  12,  13,  14,  15,  22,  23,  24,  25,  26,  
                  27,  34,  35,  36, 109, 110, 111, 118, 119, 120, 121, 122, 123, 130, 
                 131, 132, 133, 134, 135, 142, 143, 144]

# generalizetion is training and critical
generalizeitems = list(criticalitems) + uniqify(list(flatten(trainingitems)))

execfile('instructions.py')

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# -------GENERATE EXPERIMENT STIMULI----------


#-----------------------load images
fullimages=[]
for i in os.listdir(imagedir):
    if ('.jpg' in i) or ('.png' in i):
        imagestring = i.split('_')[0]
        imagenumber = int(str(imagestring)[1:])
        imageID=imageassignments[imagenumber-1]
        features=number2Features(imageID,stimulusspace)
        fullimages.append([visual.ImageStim(win,image=pj(imagedir,i),
            pos=imageposition,name=str(imagenumber)),
                [imageID,features],imagestring])

fullimages  = sorted(fullimages,key=itemgetter(1))

print '\n-----------------------IMAGES LIST----------------------'
printlist(fullimages)


# make instruction stimuli
instructions=visual.TextStim(win,text='',height=txtsize,font=txtfont,
     color=txtcolor,wrapWidth=2000,alignVert='middle',pos=[0.0,0.0])
fixcross=visual.TextStim(win,text='+',
     height=txtsize,font=txtfont,color=txtcolor,pos=imageposition)

continuestring='\n\
\n\
Click anywhere to continue.'
cursor = event.Mouse(visible=True, newPos=None, win=win)
timer=core.Clock() #clock


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# PASS TO PHASE SCRIPTS
execfile('train_classify.py')
execfile('test_generalize.py')

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# TERMINATE EXPERIMENT
finishtime=strftime("%a, %d %b %Y %X")
print '\nStart Time: ' +starttime
print 'End Time: ' +finishtime +'\n'
subjectdata[0].append(finishtime)
writefile(subjectfile,subjectdata,',')

#do exit screen
instructions.setText(instructiontext[-1][-1])
instructions.setPos=[0.0,0.0]
instructions.alignVert='top'
instructions.draw(win)
win.flip()
event.waitKeys(keyList=['q'])

print '\nExperiment complete.'
win.close()
if gethostname() in ['klab1','klab2','klab3']:
    copy2db(subjectfile,experimentname)
    logfile.close()
    os.system("TASKKILL /F /IM pythonw.exe")
