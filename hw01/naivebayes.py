#!/usr/bin/env python

"""
naive bayes implementation for ml701 class.
willie neiswanger, 09/2012.
"""

import csv
import numpy as np
import random as ran
import math

def parseData(fileString=None):
    if fileString==None: fileString = 'hw1-data.txt'
    data = np.array(list(csv.reader(open(fileString,"rb"),delimiter=',')))
    X = data[:,1:].astype('float')
    Y = data[:,0]
    return X,Y

def getTrainTest(X,Y,numTrain):
    indTrain = ran.sample(xrange(X.shape[0]), int(math.floor((2/3.)*X.shape[0])))
    indTrainSub = ran.sample(indTrain, numTrain)
    indTest = [i for i in xrange(X.shape[0]) if not(i in indTrain)]
    XTrain = X[indTrainSub,:]
    YTrain = Y[indTrainSub,:]
    XTest = X[indTest,:]
    YTest = Y[indTest,:]
    return XTrain,YTrain,XTest,YTest

#def trainModel(XTrain,YTrain):
    # count number of A labels and B labels ( ie n_A and n_B)
    # for each of 16 features, 2 classes, and 3 values, find number of examples who's feature i took value x in class Y
        # return these parameters in some form (3d matrix?) (a 2d matrix per class) called model

#def testModel(model,XTest,YTest):
    # predict new label for each obs in XTest, and get accuracy by comparing with YTest
    # return accuracy
    
#def plotAccuracyVsNumTrain(accuracyDict):

# main function (carries out naive bayes part of 3.4 of hw)
# parse data, for 100 times: split data (into train/test), for train-size ranging from 2:max-size (2:200?), learn model, test on test set [and compute / record accuracy]. afterwards, make plot.
