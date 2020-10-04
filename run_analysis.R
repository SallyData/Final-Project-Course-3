library(dplyr)

MyFile <- "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(MyFile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, MyFile, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(MyFile) 
}


#Reading the data 

Data_features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
Data_activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
Data_subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
Data_x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
Data_y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
Data_subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Data_x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
Data_y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge training and test data sets

X <- rbind(Data_x_train, Data_x_test)
Y <- rbind(Data_y_train, Data_y_test)
Subject <- rbind(Data_subject_train, Data_subject_test)
Data_Merge <- cbind(Data_Subject, Y, X)

# Only Mean and Standard deviations

Data_Only <- Data_Merge %>% select(subject, code, contains("mean"), contains("std"))


#Activity Names

Data_Only$code <- activities[Data_Only$code, 2]

#Appropriately Label the Data Set

names(Data_Only)[2] = "activity"
names(Data_Only)<-gsub("Acc", "Accelerometer", names(Data_Only))
names(Data_Only)<-gsub("Gyro", "Gyroscope", names(Data_Only))
names(Data_Only)<-gsub("BodyBody", "Body", names(Data_Only))
names(Data_Only)<-gsub("Mag", "Magnitude", names(Data_Only))
names(Data_Only)<-gsub("^t", "Time", names(Data_Only))
names(Data_Only)<-gsub("^f", "Frequency", names(Data_Only))
names(Data_Only)<-gsub("tBody", "TimeBody", names(Data_Only))
names(Data_Only)<-gsub("-mean()", "Mean", names(Data_Only), ignore.case = TRUE)
names(Data_Only)<-gsub("-std()", "STD", names(Data_Only), ignore.case = TRUE)
names(Data_Only)<-gsub("-freq()", "Frequency", names(Data_Only), ignore.case = TRUE)
names(Data_Only)<-gsub("angle", "Angle", names(Data_Only))
names(Data_Only)<-gsub("gravity", "Gravity", names(Data_Only))

Data_Final <- Data_Only %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data_Final, "DataFinal.txt", row.name=FALSE)


