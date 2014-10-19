# The code is structured in 5 parts.



#----------------------------------------------------------------------------------------
# part 1: Merges the training and the test sets to create one data set.
#----------------------------------------------------------------------------------------

# Reading text files into R

featurenames <- read.table("features.txt") 
# dimension: 562 rows and 2 columns

featurestrainingset <- read.table("train/X_train.txt") 
# dimension: 7352 rows and 561 columns

featurestestset <- read.table("test/X_test.txt") 
# dimension: 2947 rows and 561 columns

subjectstrainingset <- read.table("train/subject_train.txt")
# dimension: 7352 rows and 1 columns

subjectstestset <- read.table("test/subject_test.txt")
# dimension: 2947 rows and 1 columns

activitiestrainingset <- read.table("train/Y_train.txt")
# dimension: 7352 rows and 1 columns

activitiestestset <- read.table("test/Y_test.txt")
# dimension: 2947 rows and 1 columns

activitylabels <- read.table("activity_labels.txt")
# dimension: 6 rows and 2 columns

# Preparing data to merge in one database

# First column contains subjects; second column activities and the following columns contain the features

subjects <- rbind(subjectstrainingset, subjectstestset)
# Adding subjects from training and test set
# dimension: 10299 (7352+2947) rows and 1 columns

activities <- rbind(activitiestrainingset, activitiestestset)
# Adding activities from training and test set
# dimension: 10299 rows and 1 columns

features <- rbind(featurestrainingset, featurestestset)
# Adding features from training and test set
# dimension: 10299 rows and 561 columns

rawdata <- cbind(subjects, activities, features)
# Adding subjects, activities and features
# dimension: 10299 rows and 563 (1+1+561) columns

featurenamescharacter <- as.character(featurenames[,2])
# Changing second column of featurenames from factor to character

names(rawdata) <- c("subjects", "activities", featurenamescharacter)
# Naming the columns 

#----------------------------------------------------------------------------------------
# IMPORTANT note 1: 
# There are 561 features listed in the features.txt. 
# Unfortunately these 561 features are not named with distinct 
# names, although the values in the corresponding feature data is different!!!
# See for example row 317 and 331 in features.txt. 
# Both have the entry "fBodyAcc-bandsEnergy()-1,8".
#
# The values are different. See train/X_train.txt for proofing.
# [value is -0.9996568 in row 1 in column 317], 
# [value is -0.9999687 in row 1 in column 331], 
# This is true for all values.
#
# so i decided to keep same in data and have to change the duplicated names with numbers
# in order to differantiate them later in part 5.
# If the values happens to be the same i would have dropped them.
#----------------------------------------------------------------------------------------

# Cleaning the Global Environment
rm(list=c("featurenamescharacter", "features", "activities", "subjects", "activitiestestset", "activitiestrainingset", "subjectstestset", "subjectstrainingset", "featurestestset","featurestrainingset", "featurenames" ))

# Changing the variable names will be done later with special attention to duplicated names



#----------------------------------------------------------------------------------------
# part 2: Extracts only the measurements on the mean and standard deviation for each measurement.
#----------------------------------------------------------------------------------------

columnnamescontainingmean <- grep("mean", names(rawdata))
# Vector with the index of the columns with "mean" inside their names   
# Length 46

columnnamescontainingstd <- grep("std", names(rawdata))
# Vector with the index of the columns with "std" inside their names
# Length 33

vectorsubsetting <- sort(c(columnnamescontainingmean,columnnamescontainingstd))
# Combining the vectors for subsetting excluding the two first column (subjects and activities)
# Length 79
# Names are not yet changed according to "coding standards". This will be done in the part where it is explicitly asked for,(i.e. part 4)

extracteddata <- rawdata[,vectorsubsetting]
# Dimension 10299 rows, 79 (46+33) columns

rm(list=c("vectorsubsetting","columnnamescontainingstd","columnnamescontainingmean"))
# Cleaning Global Environmet



#----------------------------------------------------------------------------------------
# part 3: Uses descriptive activity names to name the activities in the data set 
#----------------------------------------------------------------------------------------

cleaningdata <- rawdata
# Creating dataframe for the cleaning process so that the rawdata will be preserved
# In case you make mistake in manipulating the data, you can access the rawdata without reading the text files again. This may save some time in the event an error occurs in the processing of the data.

fixedactivitylabels <- gsub("_", "", tolower(activitylabels[,2]))
# Fixing the labels to lower cases without "_"

rm("activitylabels")
# Cleaning Global Environment

cleaningdata$activities <- factor(cleaningdata$activities, levels=1:6, labels=fixedactivitylabels)
# Changing the numericals 1 to 6 with the corresponding labels from the fixedactivitylabels to factor 

rm("fixedactivitylabels")
# Cleaning Global Environment



#----------------------------------------------------------------------------------------
# part 4: Appropriately labels the data set with descriptive variable names.
#----------------------------------------------------------------------------------------

# According to the lecture and the TAs contribtions in the forum the variable names will have no abbreviations and thus being very long. The number which indicate the interval are not changed.

# Important
# Here the problem of the duplicated names for the features will be addressed (Important note 1).

indexduplicatednames <- duplicated(names(cleaningdata))
sum(indexduplicatednames)
# There are 84 features which can not be uniquely addressed by their name.

createdifferentnames <- 1:84
# As the readme.txt does not provide information on the these features and
# we dont know how they are processed later in the research, I will just add increasing number to 
# these names so that they can be differentiated. This seems to be the only reansonable way,
# because we dont know how the different value are created and why the have the same feature names.

names(cleaningdata)[indexduplicatednames] <- paste(createdifferentnames, names(cleaningdata)[indexduplicatednames])
# Creating distinctive names by adding a unique number to each of the the duplicated names.

names(cleaningdata) <- sub(" ", "", names(cleaningdata))
names(cleaningdata) <- tolower(gsub("\\(|\\)|\\,|-", "", names(cleaningdata)))
names(cleaningdata) <- sub("^t", "time", names(cleaningdata))
names(cleaningdata) <- sub("freq$", "frequency", names(cleaningdata))
names(cleaningdata) <- sub("^f", "frequency", names(cleaningdata))
names(cleaningdata) <- sub("std", "standarddeviation", names(cleaningdata))
names(cleaningdata) <- sub("min", "minimum", names(cleaningdata))
names(cleaningdata) <- sub("max", "maximum", names(cleaningdata))
names(cleaningdata) <- sub("mag", "magnitude", names(cleaningdata))
names(cleaningdata) <- sub("acc", "acceleration", names(cleaningdata))
names(cleaningdata) <- sub("tbody", "timebody", names(cleaningdata))
names(cleaningdata) <- sub("sma", "signalmagnitudearea", names(cleaningdata))
names(cleaningdata) <- sub("mad", "medianabsolutedeviation", names(cleaningdata))
names(cleaningdata) <- sub("iqr", "interquartilerange", names(cleaningdata))
names(cleaningdata) <- sub("arcoeff", "autoregressioncoefficents", names(cleaningdata))
# Changing the names according lectures. There is a ongoing discussion about what are
# appropiate variable names in the forum. The answer seems to depend on the personal preferences.
# I opted for these variable names in order to practice the content of the lectures and follow 
# the advice of the community TAs.

rm(list=c("createdifferentnames","indexduplicatednames"))
# Cleaning Global environment



#----------------------------------------------------------------------------------------
# part 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#----------------------------------------------------------------------------------------

tidydata = aggregate(cleaningdata[,3:563], by=list(activities = cleaningdata$activities, subjects=cleaningdata$subjects), mean)
# Calculating the mean for each combination of subjects and activities
# dimensions: 180 rows (30 subjects * 6 activities), 563 columns (561 features + 2 (subjects and activies))

tidydata <- tidydata[,3:563]
# Removing the first two rows with the subjects and activities created be the aggregate function
# dimensions: 180 rows (30 subjects * 6 activities), 561 columns (561 features)
# tidy data containing the averages for all features calculated for each subject/activity combination

names(tidydata) <- paste(names(cleaningdata)[3:563],"mean", sep="")
# Following the structure for nameing the variables, the variables names in tidydata end all with mean.

write.table(tidydata, "tidydata.txt", sep=" ", row.name=FALSE)
# Writing text file with tidydata separarted by " ".



