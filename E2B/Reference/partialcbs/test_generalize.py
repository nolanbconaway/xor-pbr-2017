print '\nRUNNING GENERALIZATION TEST..........'
phase='generalization'

##--------------------------------------------------------
trials = [4,5,6,11,12,13,18,19,20] + trainingitems[0] + trainingitems[1]
generalization = []
for i in uniqify(trials):
    for j in grid_stimuli:
        if j['id'] == i:
            generalization.append(j)

if MODE == "DEMO":
    generalization = generalization[:4]

print '\n -----GENERALIZATION TRIALS'
printlist(generalization)

# make buttons
buttonstim, buttontext = [], []
for i in categories:
    buttonstim.append(
        visual.Rect(win, width=100, height=60, units = 'pix',
            fillColor = 'white', lineColor = 'black', lineWidth=1.5, 
            pos = (-150, -110))
        )

    if i==categories[1]:
        buttonstim[-1].pos[0] *= -1

    buttontext.append(
        visual.TextStim(win, text = i, pos=buttonstim[-1].pos, **fontopts)
        )


## BEGIN ITERATING OVER BLOCKS AND TRIALS
presentinstructions(win,instructions,instructiontext,phase)
np.random.shuffle(generalization)
trialnumber=-1
for trial in generalization:
    starttrial(win,isi,fixcross)
    
    #get instructions
    string='Click a button to select the correct category.'
    instructions.setText(string)
    
    # define critical items
    trialnumber += 1
    stimulus = trial['stimulus']
    imagenumber = trial['id']
    stimulus.pos = (0, 150)
    #draw instructions, buttons, and image
    drawall(win,[stimulus])
    core.wait(.5)
    drawall(win,[buttonstim,buttontext,stimulus,instructions])
    # core.wait(.5)
    
    #wait for response
    [response,rt]=waitforresponse(cursor,timer,buttonstim,categories)
    drawall(win,[stimulus])     
    core.wait(.5)


    # PRINTING...
    print '\nGeneralization Trial '+str(trialnumber)+' information:'
    print ['Image ID: ', imagenumber]
    print ['Response: ', response]
    
    #log data
    trialdata=[condition,subjectid,phase,trialnumber,imagenumber,response,rt]
    subjectdata.append(trialdata)
    writefile(subjectfile,subjectdata,',')

