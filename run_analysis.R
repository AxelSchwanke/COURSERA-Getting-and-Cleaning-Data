#
# 1. Read train- and test-datasets and merge them to create one data set
#
# train data in ./train/X_train.txt
# test data in ./test/X_test.txt
#
# merge data in ./data/X.txt
#


X1 <- read.table("./train/X_train.txt")
X2 <- read.table("./test/X_test.txt")
X <- rbind(X1, X2)
dim(X)

subject1 <- read.table("./train/subject_train.txt")
subject2 <- read.table("./test/subject_test.txt")
subject <- rbind(subject1, subject2)
dim(subject)

y1 <- read.table("./train/y_train.txt")
y2 <- read.table("./test/y_test.txt")
y <- rbind(y1, y2)
dim(y)

features <- read.table("./features.txt")
dim(features)

# set column names 
names(X) <- features[,2]
names(y) <- "activity"
names(subject)<- "subject"

# merge subject, X, y
data <- cbind(subject,X,y)
dim(data)

#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#
# remove all columns that do NOT contain '-mean' or '-std', 
# except column 1 (subject) and column 563 (activity)
#

# collect numbers of all columns that do NOT contain '-mean' or '-std'
rlist = vector()
for (i in 2:(dim(data)[2]-1)) {
  name = names(data)[i]
  if ( grepl("-mean\\(",name) == FALSE & grepl("-std\\(",name) == FALSE ) {
    rlist <- c(rlist,i)
  }
}
# remove those columns from data set
data <- data[,-rlist]
dim(data)

#
# 3. Uses descriptive activity names to name the activities in the data set
#

activityLabels <- read.table("./activity_labels.txt")
data$activity <- activityLabels[data$activity,2]


#
# 4. Appropriately labels the data set with descriptive activity names.
# or better
# 4. Appropriately labels the data set with descriptive variable or feature (column) names
#

data <- data.frame(data, check.rows=TRUE)

names(data) <- gsub(" |-|\\.","_",names(data))
names(data) <- gsub("(_)\\1+","_", names(data))

names(data) <- gsub("_m","M", names(data))
names(data) <- gsub("_s","S", names(data))

names(data) <- gsub("_$","", names(data))


# 
# 5. From the data set in step 4, Create a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#

require(reshape2)
dataMelt <- melt(data, id=c("activity","subject"))
dim(dataMelt)

dataCast <- dcast(dataMelt, activity + subject ~ variable, mean)
dim(dataCast)

#
# write tidy data set to file
#

write.table(dataCast,"./tidyDataSet.txt")
