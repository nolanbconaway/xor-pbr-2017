print '\nRUNNING GENERALIZATION TEST..........'
phase='generalization'

##--------------------------------------------------------
##define items for generalization
generalization = []
for num in generalizeitems:
    for e in fullimages:
        enum=e[1][0]
        if enum==num:
            generalization.append(list(e))

print '\nGENERALIZE BLOCK..........'
printlist(generalization)

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
np.random.shuffle(generalization)
trialnumber=0
for trial in generalization:
    starttrial(win,isi,fixcross)
    
    #get instructions
    string='Click a button to select the correct category.'
    instructions.setText(string)
    
    # define critical items
    trialnumber=trialnumber+1
    stimulus=trial[0]
    imagenumber=trial[1][0]
    coordinates=trial[1][1]
    filename=trial[2]
    
    #draw instructions, buttons, and image
    drawall(win,[stimulus])
    core.wait(.5)
    drawall(win,[classifybuttons,classifybuttontext,stimulus,instructions])
    # core.wait(.5)
    
    #wait for response
    [response,rt]=waitforresponse(cursor,timer,classifybuttons,categorynames)
    drawall(win,[stimulus])     
    core.wait(.5)

    # PRINTING...
    print '\nGeneralization Trial '+str(trialnumber)+' information:'
    print ['Image ID: ', imagenumber]
    print ['Response: ', response]
    
    #log data
    trialdata=[condition,subjectid,phase,'',trialnumber,filename,imagenumber,
        coordinates,response,rt]
    subjectdata.append(trialdata)
    writefile(subjectfile,subjectdata,',')


