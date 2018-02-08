print '\nRUNNING CLASSIFICATION TRAINING..........'
phase='training'

##--------------------------------------------------------
##define training block
trainingblock=[]
for cat in trainingitems:
    currentcat=categorynames[trainingitems.index(cat)]
    for num in cat:
        for e in fullimages:
            enum=e[1][0]
            if enum==num:
                trainingblock.append([currentcat,list(e)])

print '\n -----TRAINING BLOCK'
printlist(trainingblock)

##--------------------------------------------------------
##create buttons
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


## BEGIN ITERATING OVER BLOCKS AND TRIALS
presentinstructions(win,instructions,instructiontext,phase)
for block in range(1,numtrainingblocks+1):
    np.random.shuffle(trainingblock)
    trialnumber=0
    for trial in trainingblock:
        starttrial(win,isi,fixcross)
        
        #get instructions
        string='Click a button to select the correct category.'
        instructions.setText(string)
        
        # define critical items
        trialnumber=trialnumber+1
        correctcategory=trial[0]
        stimulus=trial[1][0]
        imagenumber=trial[1][1][0]
        coordinates=trial[1][1][1]
        filename=trial[1][2]
        
        #draw instructions, buttons, and image
        drawall(win,[stimulus])
        core.wait(.5)
        drawall(win,[classifybuttons,classifybuttontext,stimulus,instructions])
        # core.wait(.5)
        
        #wait for response
        [response,rt]=waitforresponse(cursor,timer,classifybuttons,categorynames)
        drawall(win,[stimulus])
        core.wait(.5)

        #check correctness and return feedback
        if response==correctcategory:
            string='Correct! this is a member of the ' + correctcategory +' category.'
            accuracy=1
        else:
            string='Incorrect... this is a member of the ' + correctcategory +' category.'
            accuracy=0
        
        instructions.setText(string)
        drawall(win,[stimulus,instructions])
        core.wait(.5)
        
        #click to continue
        instructions.setText(string+continuestring)
        drawall(win,[stimulus,instructions])
        clicktocontinue(cursor)
        core.wait(.2)

        # PRINTING...
        print '\nTraining Block '+str(block)+', Trial '+str(trialnumber)+' information:'
        print ['Image ID: ', imagenumber]
        print ['coordinates: ',coordinates]
        print ['Correct Response: ', correctcategory]
        print ['Response: ', response]
        print ['Accuracy: ', accuracy]
        
        #log data
        trialdata=[condition,subjectid,phase,block,trialnumber,filename,imagenumber,
            coordinates,correctcategory,response,rt,accuracy]
        subjectdata.append(trialdata)
        writefile(subjectfile,subjectdata,',')

