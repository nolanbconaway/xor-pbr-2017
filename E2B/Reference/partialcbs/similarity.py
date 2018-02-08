print '\nRUNNING ' + phase +'..........' 

# define pairs
crit_to_train = [[i,j] for i in [5, 6, 12, 13] for j in [0, 42, 36, 48]]
extras = [
        [0,36],
        [0,42],
        [8,36],
        [8,42],
        [40,36],
        [40,42],
        [48,36],
        [48,42],
        [0,40],
        [0,48],
        [8,40],
        [8,48],
]

# define all trials
similarity = []
for i in crit_to_train + extras:
    trial = []
    for j in grid_stimuli:
        if j['id'] in i:
           trial.append(j)
    np.random.shuffle(trial)
    similarity.append(trial)

if MODE == "DEMO":
    similarity = similarity[:4]

print '\n -----SIMILARITY TRIALS'
printlist(similarity)

##--------------------------------------------------------
# create rating scale
labels = [
'\nNot at all\nsimilar',
'\nHighly\nsimilar'
]

ratingscale = visual.RatingScale(win, low = 1, high = 9,
        labels=labels, scale = None, showAccept = True, acceptText = "Continue", acceptPreText = "",
        leftKeys=None,rightKeys=None,skipKeys=None,respKeys=None,
        textColor=fontopts['color'],  textFont=fontopts['font'], textSize=.7, 
        stretch = 0.8, marker = 'triangle', markerColor = 'black',
        lineColor=[-1,-1,-1], showValue = False, pos=[0,-100]) 

## BEGIN ITERATING OVER TRIALS
presentinstructions(win,instructions,instructiontext,phase)
np.random.shuffle(similarity)
trialnumber=-1
for trial in similarity:
    starttrial(win,isi,fixcross)
    
    #get instructions
    string='Click along the line to indicate similarity.'
    instructions.setText(string)
    
    # define critical items
    trialnumber += 1
    left, right = trial

    # set image positions
    left['stimulus'].pos = (-170, 150)
    right['stimulus'].pos = (170, 150)
    bothstim = [left['stimulus'], right['stimulus']]

    #draw instructions, buttons, and image
    drawall(win,[bothstim, ratingscale, instructions])
    
   # obtain rating scale response
    ratingscale.reset()
    while ratingscale.noResponse:
       drawall(win,[bothstim, ratingscale, instructions])
       if 'q' in event.getKeys(keyList = ['q']):
           print 'USER ENDED EXPERIMENT'
           core.quit()
    rating = ratingscale.getRating()
    rt = ratingscale.getRT()

    # PRINTING...
    print '\nTrial ' + str(trialnumber) + ' information:'
    print ['Left ID: ', left['id']]
    print ['Right ID: ', right['id']]
    print ['Similarity Rating: ', rating]
    
    #log data
    trialdata=[condition,subjectid,phase,trialnumber,
        left['id'],right['id'],rating,rt]
    subjectdata.append(trialdata)
    writefile(subjectfile,subjectdata,',')
