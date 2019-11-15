library(dplyr)
#Load both data set files into RStudio:
#Load in train data:
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Load test data:
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Load remaining files:
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

#set column names in the data set:
#For train data:
colnames(X_train) = features[,2]
colnames(y_train) = "activityId"
colnames(subject_train) = "subjectId"
#For test data:
colnames(X_test) = features[,2]
colnames(y_test) = "activityId"
colnames(subject_test) = "subjectId"
#Change names of activity labels:
colnames(activity_labels) <- c('activityId','activityType')

#Merge the two data sets using the subject variable:
X_total <- cbind(X_train, subject_train, y_train)
y_total <- cbind(X_test, subject_test, y_test)
data_total <- rbind(X_total, y_total)

#extract the measurnments of the mean and standard deviation from each measurenment:
#Use descriptive activity names to name the activities in the data set:
colnames <- colnames(data_total) #Get the column name data

mean_sd <- (grepl("activityID", colnames) |
                   grepl("subjectID", colnames) |
                   grepl("mean..", colnames) |
                   grepl("std...", colnames))

meanAndSd <- data_total[ , mean_std == TRUE]

#Change activity names to a more descriptive format:
ActivityNames = merge(meanAndSd, activity_labels, 
                             by='activityId', all.x=TRUE)


#Create a new data set with the average of each variable for each activity and each subject:
tidyData <- aggregate(. ~subjectId + activityId, ActivityNames, mean)
tidyData <- tidyData[order(tidyData$subjectId, secTidySet$activityId),]

#Create a text file of the data:
write.table(tidyData, "tidyData.txt", row.name=FALSE)
