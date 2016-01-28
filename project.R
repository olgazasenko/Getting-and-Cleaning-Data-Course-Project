# download the data
 temp <- tempfile()
 download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
 unzip(temp, exdir = "E:\\Documents\\R\\data")
 unlink(temp)
 library(dplyr)
 # read the data
 y_test <- read.table("./test/y_test.txt", col.names = "activity")
 X_test <- read.table("./test/X_test.txt")
 subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
 test <- cbind(subject_test, y_test)
 test <- cbind(test, X_test)
 y_train <- read.table("./train/y_train.txt", col.names = "activity");
 X_train <- read.table("./train/X_train.txt");
 subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
 train <- cbind(subject_train, y_train)
 train <- cbind(train, X_train)
 # remove variables that are no longer necessary
 rm(y_test, X_test, subject_test, subject_train, y_train, X_train)
 my_dataset = rbind(test, train)
 rm(train, test)
 # select the measurements on the mean and standard deviation
 my_dataset <- select(my_dataset, subject, activity, V1:V6, V41:V46, V81:V86, V121:V126, V161:V166, V201:V202, V214:V215, V227:V228, V240:V241, V253:V254, V266:V271, V345:V350, V424:V429, V503:V504, V516:V517, V529:V530, V542:V543)
 activity_labels <- read.table("activity_labels.txt")
 # name the activities in the dataset
 my_dataset$activity <- sapply(my_dataset$activity, function(x){x <- activity_labels[x, 2]})
 features <- read.table("features.txt")
 my_dataset_colnames <- colnames(my_dataset)[3:68]
 my_dataset_colnames <- as.numeric(gsub("V", "", my_dataset_colnames))
 # tidy up the column names
 feature_names <- as.character(features[my_dataset_colnames,]$V2)
 feature_names <- c("subject", "activity", feature_names)
 feature_names <- gsub("^t", "time", feature_names)
 feature_names <- gsub("^f", "freq", feature_names)
 feature_names <- gsub("-", ".", feature_names)
 feature_names <- gsub("\\)", "", feature_names)
 feature_names <- gsub("\\(", "", feature_names)
 # assign the column names
 colnames(my_dataset) <- feature_names
 rm(features, feature_names)
 my_dataset_grouped <- group_by(my_dataset, subject, activity)
 independent_dataset <- summarise_each(my_dataset_grouped, funs(mean), contains("std"), contains("mean"))
 detach("package:dplyr")


