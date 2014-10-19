#CodeBook

* Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

* A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

* There are 561 feature variables in the rawdata.

* There are 10299 oberservation (training + test data) in the raw data, which include data about 30 subjects and 6 activities. 

* The tidy data have 180 observations (rows). This is 30 subjects * 6 activities = 180 unique observations.

* For each of these 180 subject/activity observations the mean is calculated for every feature variable.

* Thus the tidy data has 180 observations and 561 variables.


* The variables are renamed the remove the abbreviations and added the string "mean" at the end to indicate that the mean has been calculated. For more information see the feature_info.txt in extracted folder UCI HAR Dataset. 

##The procedure to clean the data:

###part 1: Merges the training and the test sets to create one data set.

1. Naming the columns with the original feature names
2. IMPORTANT note 1:  
There are 561 features listed in the features.txt.  
Unfortunately these 561 features are not named with distinct  
names, although the values in the corresponding feature data is different!!!  
See for example row 317 and 331 in features.txt.  
Both have the entry "fBodyAcc-bandsEnergy()-1,8".  
The values are different. See train/X_train.txt for proofing.  
[value is -0.9996568 in row 1 in column 317],  
[value is -0.9999687 in row 1 in column 331],   
This is true for all values.  
so i decided to keep same in data and have to change the duplicated names with numbers  
in order to differantiate them later in part 5.  
If the values happens to be the same i would have dropped them.  
3. Changing the variable names will be done later with special attention to duplicated names

###part 2: This part is only related to extracting data, which is not used for cleaning the data.

###part 3: Uses descriptive activity names to name the activities in the data set.

1. Creating dataframe for the cleaning process so that the rawdata will be preserved
In case you make mistake in manipulating the data, you can access the rawdata without reading the text files again. This may save some time in the event an error occurs in the processing of the data.
2.Fixing the labels to lower cases without "_"
3. Changing the numericals 1 to 6 with the corresponding labels from the fixedactivitylabels to factor

###part 4: Appropriately labels the data set with descriptive variable names.

1. According to the lecture and the TAs contribtions in the forum the variable names will have no abbreviations and thus being very long. The number which indicate the interval are not changed.
2. Important  
Here the problem of the duplicated names for the features will be addressed (Important note 1).  
3. There are 84 features which can not be uniquely addressed by their name.
4. As the readme.txt does not provide information on the these features and
we dont know how they are processed later in the research, I will just add increasing number to 
these names so that they can be differentiated.  
This seems to be the only reansonable way,
because we dont know how the different value are created and why the have the same feature names.
5. Creating distinctive names by adding a unique number to each of the the duplicated names.
6. Changing the names according lectures. There is a ongoing discussion about what are
appropiate variable names in the forum. The answer seems to depend on the personal preferences.
I opted for these variable names in order to practice the content of the lectures and follow 
the advice of the community TAs.

###part 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Calculating the mean for each combination of subjects and activities
dimensions: 180 rows (30 subjects * 6 activities), 563 columns (561 features + 2 (subjects and activies))
2. tidy data containing the averages for all features calculated for each subject/activity combination
3. Following the structure for nameing the variables, the variables names in tidydata end all with mea

