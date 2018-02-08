from psychopy import visual, event, core, logging, data, gui
import os, random, socket, numpy, operator

#------------------------------------------------------------------------------------
# creates folder if it doesnt exist
def checkdirectory(dir): 
    if not os.path.exists(dir):
        os.makedirs(dir)

#------------------------------------------------------------------------------------    
# writes list to file
def writefile(filename,data,delim):
    datafile=open(filename,'w')
    for line in data: #iterate over litems in data list
        currentline='\n' #start each line with a newline
        for j in line: #add each item onto the current line

            if isinstance(j, (list, tuple)): #check if item is a list
                for k in j:
                    currentline=currentline+str(k)+delim
            else:
                currentline=currentline+str(j)+delim
                
##        write current line
        datafile.write(currentline)
    datafile.close()  


#------------------------------------------------------------------------------------        
# do a dialouge and return subject info 
def getsubjectinfo(experimentname,conditions,datalocation):
    ss_info=[]
    pc=socket.gethostname()
    myDlg = gui.Dlg(title=experimentname)
    myDlg.addText('Subject Info')
    myDlg.addField('ID:', tip='or subject code')
    myDlg.addField('Condition:', random.choice(conditions),choices=conditions)
    myDlg.show()
    if not myDlg.OK:
        core.quit()
        
    subjectinfo = [str(i) for i in myDlg.data]
    
    if subjectinfo[0]=='':
        core.quit()
    else: 
        id=subjectinfo[0]
        condition=subjectinfo[1]
        subjectfile=datalocation+pc+'-'+experimentname+'-'+condition+'-'+id+'.csv'
        while os.path.exists(subjectfile) == True:
            subject_file=datalocation+pc+'-'+experimentname+'-'+condition+'-'+id+'.csv' + '_dupe'
        return [int(id),int(condition),subjectfile]

#------------------------------------------------------------------------------------    
#takes in 1 or 2-d lists of objects and draws them in the window
def drawall(win,objects):
    for i in objects:
        if isinstance(i, (list, tuple)):
            for j in i:
                j.draw()
        else:
            i.draw()
    win.flip()

#------------------------------------------------------------------------------------
def number2Features(number,dimensions):
    # create a full, labeled example space
    totaln=reduce(operator.mul, dimensions)
    examplespace=numpy.arange(1.,totaln+1.)
    examplespace=examplespace.reshape(tuple(dimensions))
    #examplespace=numpy.flipud(examplespace)
    
    #look up the example number
    coordinates = numpy.where(examplespace==number)
    coordinates = [int(i)+1 for i in list(coordinates)]
    return coordinates

def starttrial(win,isi,fixcross):
    fixcross.draw()
    win.flip()
    core.wait(isi)
    
#------------------------------------------------------------------------------------   
def presentinstructions(win,stim,text,phase):
    event.clearEvents()
    originalposition=stim.pos
    stim.setPos=[0.0,0.0]
    stim.alignVert='center'
    
    #search text for instructions matching phase
    for i in text:
        if i[0]==phase:
            instructs=i[1]
            break
            
    #draw text and wait for key press
    stim.setText(instructs)
    stim.draw()
    win.flip()
    if 'end' in event.waitKeys(keyList=['end','space']):
        core.quit()
    stim.alignVert='top'
    stim.setPos=originalposition
    event.clearEvents() 

def waitforresponse(cursor,timer,buttons,labels):
    
    #clear events
    timer.reset()
    cursor.clickReset()
    event.clearEvents() 
    
    #iterate until response
    while True:
        
        #quit if desired
        if 'end' in event.getKeys():
            core.quit()
            
        #check to see if  any stimulus has been clicked inside of
        for i in buttons:
            if (True in cursor.getPressed()) & (i.contains(cursor.getPos())):
                return [labels[buttons.index(i)],timer.getTime()]
               
#-----------------------------------------------------------------------------------
## program waits for a mouse click to continue
def clicktocontinue(cursor):
    event.clearEvents()
    cursor.clickReset() 
    while cursor.getPressed()==[False,False,False]:
        cursor.getPressed()
        if event.getKeys(keyList='end'):
            core.quit()

#-----------------------------------------------------------------------------------
## prints each item in a list on a new line
def printlist(toprint):
    for i in toprint:
        print i

#-----------------------------------------------------------------------------------
## returns a list of image # re-assignments based on counterbalance specs
def getcounterbalancelist(dimensions,flipdims,dimpositions):
    # create a stimulus space according to the size of dimensions
    space=numpy.array(range(0,dimensions[0]*dimensions[1]))+1
    space=space.reshape(dimensions)

    # flip feature values where specified
    if flipdims[0]:
        space=space[:,::-1]
    if flipdims[1]:
        space=space[ ::-1,:]

    # reverse feaure -> dimension assignment where specified
    if dimpositions==[1, 0]:
        space=numpy.transpose(space)

    # convert space back into a vector list
    balancelist=space.reshape([1,dimensions[0]*dimensions[1]])
    balancelist=balancelist.tolist()[0]
    return balancelist
        

    








        
