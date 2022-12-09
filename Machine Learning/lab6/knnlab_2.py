
#--------------------------------------------------------------------------------
# Part 2: This lab uses the code from the previous lab

# In Part 1 we looked at:
# - Nearest Neighbour classifiers
# - - k-NN: 
# - - setting K
# - - similarity measures: euclidean distance, ...
# - Weighted Neighbours
# - - weight functions: inverse, subtraction, gaussian
# - - weighted k-NN
#
# We will begin today's lab by looking at how to handle the data.
#
#--------------------------------------------------------------------------------
#
# Cross Validation
#
# We have been given some data related to a problem and we are going to create a 
# classifier for the problem. It is important that we are able to judge how well 
# our classifier will generalise before we deploy it.
#
# A simple way to to this would be to:
# (1) Randomly choose a small subset of a data and set that aside as a test set
# (2) Take the remaing parts of out data and use it as a training set
# (3) Create our classifer using the training set
# (4) Estimate how well our classifier will generalise by testing it on the test set.
#
# This approach is called: 'test-set estimator of performance'
#
# This approach seems sensible and straight forward, so whats the problem:
# (1) Wastes data: the test set is never used during training
# (2) If we don't have much data, our test-set might just be lucky or unlucky;
# in other words, test-set estimator of performance has a high variance.
#
# Cross-validation is the name given to a set of techniques that repeatdely divides 
# up data into training sets and test sets.
# 
# During cross-validation we repeatedly do the follow sequence of steps:
#
# 1 Divide the data into a training set and test set.
# 1 The training set is given to the algorithm, along with the correct answers 
# (in this case, prices), and becomes the set used to make predictions.
# 2 The algorithm is then asked to make predictions for each item in the test set. 
# 3 The answers it gives are compared to the correct answers, and an overall score for how
# well the algorithm did is calculated.
#
# Usually this procedure is performed several times, dividing the data up differently
# each time. 
#
# Typically, the test set will be a small portion, perhaps 5 percent of the all
# the data, with the remaining 95 percent making up the training set. 
#
# We can then report the average accuracy.
#
# In order to cross-validate our k-nn classifier we need to create a function that
# will divide up the dataset into two smaller sets given a ratio that we specify:

def dividedata(data,test=0.05):
  trainset=[]
  testset=[]
  for row in data:
    if random()<test:
      testset.append(row)
    else:
      trainset.append(row)
  return trainset,testset
  
# The next step is to test the algorithm by giving it a training set and calling it with
# each item in the test set. The function calculates the differences and combines them
# to create an aggregate score for how far off it was in general. This is usually done by
# adding up the squares of all the differences.  
#
#
# testalgorithm takes an algorithm, algf, which accepts a dataset and query. It loops
# over every row in the test set and then calculates the best guess by applying algf. It
# then subtracts the guess from the real result.

def testalgorithm(algf,trainset,testset):
  error=0.0
  for row in testset:
    guess=algf(trainset,row['input'])
    error+=(row['result']-guess)**2
    #print row['result'],guess
    
  #print error/len(testset)
  return error/len(testset)

# The final step is to create a function that makes several different divisions of data and
# runs testalgorithm on each, adding up all the results to get a final score.

def crossvalidate(algf,data,trials=100,test=0.1):
  error=0.0
  for i in range(trials):
    trainset,testset=dividedata(data,test)
    error+=testalgorithm(algf,trainset,testset)
  return error/trials


# Lets try to generate a cross validated accuracy score for our k-nn
# classifier using different values of k

##>>> crossvalidate(knnestimate,data)
##254.06864176819553
##>>> def knn3(d,v): return knnestimate(d,v,k=3)
##    (press return)
##>>> crossvalidate(knn3,data)
##166.97339783733005
##>>> def knn1(d,v): return knnestimate(d,v,k=1)
##    (press return)
##>>> crossvalidate(knn1,data)
##209.54500183486215
#
# Looking at the results I got (your results may be different because the data was generated using
# some randomness) we see that: using too few neighbors or too many neighbors 
# leads to poor results. 
# In this example, a value of 3 performs better than a value of 1 or 5. 
#
# How does our weighted knn classifer do when its cross validated:
#
##>>> crossvalidate(weightedknn,data)
##200.34187674254176
##>>> def knninverse(d,v):
##        return knn2lab.weightedknn(d,v,weightf=inverseweight)
##    (press return)
##>>> crossvalidate(knninverse,data)
##148.8594770266061
#
# When the parameters are set properly, weighted kNN seems to give better results for
# this dataset. 
#
#--------------------------------------------------------------------------------
#
# Heterogeneous Variables
# 
# The dataset we have used so far is artificially simple, specifically, 
# (1) all the variables used to predict the price are roughly comparable 
# (2) and are all important to the final result.
#
# Since all the variables fall within the same range, it’s meaningful to calculate distances
# using all of them at once. However, if we add a new variable that influenced the price to
# the dataset which had a bigger range than age or rating, this new variable would have a far greater
# impact on the calculated distances than the original ones do—it will overwhelm any distance
# calculation, which essentially means that the other variables are not taken into account.
#
# We can simulate this issue in our wineset domain using the size of the bottle in milliliters. 
# Unlike age and raing, which range between 0 and 100, this variable ranges up to 1,500. 
#
# A different problem is the introduction of entirely irrelevant variables. If the dataset
# also included the number of the aisle in which you found the wine, this variable
# would be included in the distance calculations. Two items identical in every respect
# but with very different aisles would be considered very far apart, which would badly
# hinder the ability of the algorithms to make accurate predictions.
#
# Let update our dataset to simulate these issues:
# The wineset2() function is the same as wineset1() except for the inclusion of the # lines

def wineset2():
  rows=[]
  for i in range(300):
    rating=random()*50+50
    age=random()*50
    aisle=float(randint(1,20)) #
    bottlesize=[375.0,750.0,1500.0][randint(0,2)] #
    price=wineprice(rating,age)
    price*=(bottlesize/750) #
    price*=(random()*0.2+0.9)
    rows.append({'input':(rating,age,aisle,bottlesize),
                 'result':price})
  return rows

# We can now create new datasets with aisles and bottle sizes:
#
##>>> data1 = wineset2()
#
# To see how this affects the kNN predictors, try them out on the new datasets with
# the best parameters you managed to find earlier:
##>>> crossvalidate(knn3,data1)
##1427.3377833596137
##>>> crossvalidate(weightedknn,data)
##1195.0421231227463
#
# Even though the dataset now contains even more information 
# than it did before (which should theoretically lead to better predictions),
# the values returned by crossvalidate have actually gotten a lot worse. 
#
# This is because the algorithms do not yet know how to treat the variables differently.
#
#--------------------------------------------------------------------------------
#
# Scaling Dimensions
#
# If we have variables with different ranges we need to normalize their values
# so that it makes sense to consider them all in the same space.
#
# It would also be helpful to find a way to eliminate the superfluous variables
# or to at least reduce their impact on the calculations.
#
# One way to accomplish both things is to rescale the dimensions before
# performing any of the calculations. The simplest form of rescaling is multiplying
# the values in each dimension by a constant for that dimension.
#
# The rescale function takes a list of items and a parameter called scale,
# which is a list of real numbers. It returns a new dataset with all the
# values multiplied by the values in scale.

def rescale(data,scale):
  scaleddata=[]
  for row in data:
    scaled=[scale[i]*row['input'][i] for i in range(len(scale))]
    scaleddata.append({'input':scaled,'result':row['result']})
  return scaleddata

#
# Using the rescale function we can address both of our problems by:
# (1) scaling down the bottle size variable by a factor of 0.5
# (2) multiplying all the irrelevant variables (e.g., aisle) by 0
#
##>>> sdata=rescale(data1,[10,10,0,0.5])
##>>> crossvalidate(knn3,sdata)
##660.9964024835578
##>>> crossvalidate(weightedknn,sdata)
##852.32254222973802
#
# The results are pretty good for those few examples; certainly better than before
#
# In this case, it’s not difficult to choose good parameters for scaling because
# you know in advance which variables are important. However, most of the time
# you’ll be working with datasets that you didn’t build yourself, and you won’t
# necessarily know which variables are unimportant and which ones have a
# significant impact.
#
# In theory, you could try out a lot of numbers in different combinations until
# you found one that worked well enough, but there might be hundreds of
# variables to consider and it would be very tedious.
#
# Typically you have to automatically find a good solution when there are many
# input variables to consider by using optimization techniques. This basically
# involve automatically searching though a combination of ranges of scaling
# factos and cross-validating the results for each combination. You then use
# the best scaling parameters in your classifier. 
#
