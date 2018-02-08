print '\nRUNNING CLASSIFICATION TRAINING..........'
phase='training'

##--------------------------------------------------------
##define training block
trainingblock=[]

for c in trainingitems:
    for e in c:
        for j in grid_stimuli:
            if j['id'] == e:
                classlabel = categories[trainingitems.index(c)]
                trainingblock.append(dict(j))
                trainingblock[-1]['category'] = classlabel

if MODE == "DEMO":
    numtrainingblocks = 1

print '\n -----TRAINING BLOCK'
printlist(trainingblock)


# define buttons
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
for block in range(1,numtrainingblocks+1):
    np.random.shuffle(trainingblock)
    trialnumber = -1
    for trial in trainingblock:
        starttrial(win,isi,fixcross)
        
        #get instructions
        string='Click a button to select the correct category.'
        instructions.setText(string)
        
        # define critical items
        trialnumber += 1
        stimulus = trial['stimulus']
        imagenumber = trial['id']
        category = trial['category']

        stimulus.setPos((0, 150))

        #draw instructions, buttons, and image
        drawall(win,[stimulus])
        core.wait(.5)
        drawall(win,[buttonstim,buttontext,stimulus,instructions])
        
        #wait for response
        [response,rt]=waitforresponse(cursor,timer,buttonstim,categories)
        drawall(win,[stimulus])     
        core.wait(.5)

        correct = int(response == category)
        if correct:
            feedback = "Correct! This is a member of the " +  category + ' category.'
        else:
            feedback = "Incorrect. This is a member of the " +  category + ' category.'

        instructions.setText(feedback)
        drawall(win,[stimulus,instructions])   
        core.wait(1)
        instructions.setText(feedback + continuestring)
        drawall(win,[stimulus,instructions])   
        clicktocontinue(cursor)

        # PRINTING...
        print '\nTraining Block '+str(block)+', Trial '+str(trialnumber)+' information:'
        print ['Image ID: ', imagenumber]
        print ['Response: ', response]
        print ['Accuracy: ', correct] 
        print ['RT: ', rt]
        
        #log data
        trialdata=[condition,subjectid,phase,block,trialnumber,
            imagenumber,category,response,correct,rt]
        subjectdata.append(trialdata)
        writefile(subjectfile,subjectdata,',')

