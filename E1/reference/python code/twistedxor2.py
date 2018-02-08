from psychopy import visual, event, core, logging, data, gui
import os, random, misc, numpy, sys, socket
from operator import itemgetter

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#-----------GET EXPERIMENT INFO------------
experimentname='twistedxor2'
conditions=[1,2]
categorynames=['Alpha','Beta']
isi=.5
numtrainingblocks=12
stimspace=[7,7]
txtcolor=[-1,-1,-1]
txtfont='Arial'
txtsize=22
imageposition=[0,150] #where center of image lies on screen [0,0=center]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# ----------GET SUBJECT INFO ------------
##Specify directories and get subject info
if sys.platform=='darwin':
    misc.checkdirectory(os.getcwd() + '/subjects/')
    imagedirectory=os.getcwd() + '/IMAGES/'

    #dimflip(shade),dimflip(size),dimposition(shade),dimposition(size)
    counterbalancelist=numpy.genfromtxt(os.getcwd() + '/counterbalancelist.csv',
        skip_header=1,delimiter=',',dtype='int').astype(int)

    [subjectid,condition,subjectfile] = misc.getsubjectinfo(experimentname,conditions,
                        os.getcwd() + '/subjects/')
else:
    misc.checkdirectory(os.getcwd() + '\\subjects\\')
    imagedirectory=os.getcwd() + '\\IMAGES\\'

    #dimflip(shade),dimflip(size),dimposition(shade),dimposition(size)
    counterbalancelist=numpy.genfromtxt(os.getcwd() + '\\counterbalancelist.csv',
        skip_header=1,delimiter=',',dtype='int').astype(int)

    [subjectid,condition,subjectfile] = misc.getsubjectinfo(experimentname,conditions,
                    os.getcwd() + '\\subjects\\')

#create window
if socket.gethostname() not in ['klab1','klab2','klab3']:
    win=visual.Window([1440,900],units='pix',color=[1,1,1])
else:
    win=visual.Window(fullscr=True,units='pix',color=[1,1,1])
    misc.checkdirectory(os.getcwd() + '\\logfiles\\')
    logfile=open(os.getcwd()+ '\\logfiles\\' + str(subjectid)+ '-logfile.txt','w')
    sys.stdout=logfile
    sys.stderr=logfile


##determine counterbalance information
balancecondition=subjectid%numpy.shape(counterbalancelist)[0]
counterbalancespecs=counterbalancelist[balancecondition,:]
flippeddims=counterbalancespecs[:2].tolist()
dimpositions=counterbalancespecs[2:].tolist()

## get counterbalance list
counterbalancelist= misc.getcounterbalancelist(
    stimspace,flippeddims,dimpositions)

print counterbalancelist
print '\n SUBJECT INFORMATION:'
print ['ID: ', subjectid]
print ['Condition: ', condition]
print ['Counterbalance condition: ', balancecondition]
print ['File: ',subjectfile]

# initalize a data list                    
subjectdata=[]
phaselist=['training','generalization']

##43	44	45	46	47	48	49
##36	37	38	39	40	41	42
##29	30	31	32	33	34	35
##22	23	24	25	26	27	28
##15	16	17	18	19	20	21
##8	9	10	11	12	13	14
##1	2	3	4	5	6	7

if condition==1: # full xor
    examplenumbers=[[1,9,41,49],[7,13,37,43]]
if condition==2: # partial xor
    examplenumbers=[[1,9,41,49],[37,43,37,43]]
if condition==3: #twisted xor
    examplenumbers=[[4,11,39,46],[22,23,27,28]]
if condition==4: #partial twisted
    examplenumbers=[[4,11,39,46],[22,23,22,23]]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# -------GENERATE EXPERIMENT STIMULI----------
# ------------------------------------------load instructions
from instructions import *

#------------------------------------------load images -- full examples
fullimages=[]
for i in os.listdir(imagedirectory):
    if '.jpg' in i:
        imagenumber=int(i[1:3])
        imagestring=i[0:3]
        imageID=counterbalancelist[imagenumber-1]
        features=misc.number2Features(imageID,stimspace)
        features.reverse()
        fullimages.append([
            visual.ImageStim(win,image=imagedirectory+i,
            pos=imageposition,name=str(imagenumber)),
                [imageID,features],imagestring])

## sort fullimages based on counterbalance-based ID
fullimages=sorted(fullimages,key=itemgetter(1))

print '\n-------------------------------------------------------------'
print '-----------------------FULL IMAGES LIST----------------------'
misc.printlist(fullimages)

            
# ------------------------------------------make buttons
classifybuttons=[]
classifybuttontext=[]
for i in categorynames:
    buttonnum=categorynames.index(i)
    
    classifybuttons.append(visual.Rect(win, width=150, height=75))
    classifybuttons[buttonnum].setFillColor([0.8,0.8,0.8])
    classifybuttons[buttonnum].setLineColor([-1,-1,-1])
    classifybuttons[buttonnum].setPos([-150,-110])
    if buttonnum:
        classifybuttons[buttonnum].setPos([150,-110])
        
    #create a text label
    classifybuttontext.append(visual.TextStim(win,
        text=categorynames[buttonnum],height=txtsize,font=txtfont,
        color=txtcolor,pos=classifybuttons[buttonnum].pos))

# ------------------------------------------make instruction stimuli
instructions=visual.TextStim(win,text='press the spacebar to continue',
    height=txtsize,font=txtfont,color=txtcolor,wrapWidth=1000,
    alignVert='top',pos=[0.0,-30.0])
fixcross=visual.TextStim(win,text='+',
    height=txtsize,font=txtfont,color=txtcolor,pos=imageposition)
    
continuestring='\n\
\n\
Click anywhere to continue.'
classfiytasktext='Click a button to select the correct category.'
cursor = event.Mouse(visible=True, newPos=None, win=win)
timer=core.Clock() #clock

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# -------GENERATE BLOCKS FOR EACH PHASE----------
# define images numbers for each category

trainingblock=[]
for i in examplenumbers:
    for j in i:
        trainingblock.append(
            [categorynames[examplenumbers.index(i)],fullimages[j-1]])

print '\n -----TRAINING BLOCK'
misc.printlist(trainingblock)

generalization=fullimages

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# - - - - - - - - - - - ITERATE OVER PHASES - - - - - - - - - - - 
for phase in phaselist:
    # --------------------TRAINING PHASE ------------------------------------   
    if phase=='training':
        misc.presentinstructions(win,instructions,instructiontext,phase)
        for block in range(1,numtrainingblocks+1):
            random.shuffle(trainingblock)
            trialnumber=0
            for trial in trainingblock:
                misc.starttrial(win,isi,fixcross)
                
                #get instructions
                instructions.setText(classfiytasktext)
                
                # define critical items
                trialnumber=trialnumber+1
                correctcategory=trial[0]
                stimulus=trial[1][0]
                imagenumber=trial[1][1][0]
                coordinates=trial[1][1][1]
                filename=trial[1][2]
                
                #draw instructions, buttons, and image
                misc.drawall(win,[stimulus])
                core.wait(.5)
                misc.drawall(win,[instructions,classifybuttons,classifybuttontext,stimulus])
                core.wait(.5)
                
                #wait for response
                [response,rt]=misc.waitforresponse(cursor,timer,classifybuttons,categorynames)
                misc.drawall(win,[stimulus])
                core.wait(.5)

                #check correctness and return feedback
                if response==correctcategory:
                    string='Correct! this is a member of the ' + correctcategory + ' category.'
                    accuracy=1
                else:
                    string='Incorrect... this is a member of the ' + correctcategory + ' category.'
                    accuracy=0
                
                instructions.setText(string)
                misc.drawall(win,[instructions,stimulus])
                core.wait(.5)
                
                #click to continue
                instructions.setText(string+continuestring)
                misc.drawall(win,[instructions,stimulus])
                misc.clicktocontinue(cursor)
                core.wait(.2)

                # PRINTING...
                print '\nTraining Block '+str(block)+', Trial '+str(trialnumber)+' information:'
                print ['Image ID: ', imagenumber]
                print ['Correct Response: ', correctcategory]
                print ['Response: ', response]
                print ['Accuracy: ', accuracy]
                
                #log data
                trialdata=[condition,subjectid,phase,block,trialnumber,filename,imagenumber,
                    coordinates[0],coordinates[1],correctcategory,response,rt,accuracy]
                subjectdata.append(trialdata)
                misc.writefile(subjectfile,subjectdata,',')


    # --------------------GENERALIZATION PHASE-------------------------- 
    if phase=='generalization':
        misc.presentinstructions(win,instructions,instructiontext,phase)
        random.shuffle(generalization)
        for trial in generalization:
            misc.starttrial(win,isi,fixcross)
            
            #get instructions
            instructions.setText(classfiytasktext)

            # define critical items
            trialnumber=generalization.index(trial)
            stimulus=trial[0]
            imagenumber=trial[1][0]
            coordinates=trial[1][1]
            filename=trial[2]
            
            #draw instructions, buttons, and image
            misc.drawall(win,[stimulus])
            core.wait(.5)
            misc.drawall(win,[instructions,classifybuttons,classifybuttontext,stimulus])
            core.wait(.5)
            
            #wait for response
            [response,rt]=misc.waitforresponse(cursor,timer,classifybuttons,categorynames)
            misc.drawall(win,[stimulus])
            core.wait(.5)
            
            #click to continue
            instructions.setText(continuestring)
            misc.drawall(win,[instructions,stimulus])
            misc.clicktocontinue(cursor)
            core.wait(.2)

            # PRINTING...
            print '\nGeneralization Trial '+str(trialnumber)+' information:'
            print ['Image ID: ', imagenumber]
            print ['Response: ', response]
            
            #log data
            trialdata=[condition,subjectid,phase,'',trialnumber,filename,imagenumber,
                coordinates[0],coordinates[1],'',response,rt,'']
            subjectdata.append(trialdata)
            misc.writefile(subjectfile,subjectdata,',')
            

# ----------------------------------------------------------------------------------------
#do exit screen
misc.printlist(subjectdata)
misc.presentinstructions(win,instructions,instructiontext,'exit')

print '\nExperiment complete.'
if socket.gethostname() in ['klab1','klab2','klab3']:
	logfile.close()
	os.system("TASKKILL /F /IM pythonw.exe")
