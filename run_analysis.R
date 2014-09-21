# You should create one R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.


## load libraries
library(plyr)
library(reshape2)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")[,2]
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = " ")[,2]

extract_features <- grepl("mean|std", features)

test_subject <-read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = " ",col.names = "subject")
x_test_data <-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features)
x_test_data <- x_test_data[,extract_features]
y_test_data <-read.table("UCI HAR Dataset/test/Y_test.txt")
y_test_data[,2] = activity_labels[y_test_data[,1]]
names(y_test_data) = c("Activity_ID", "Activity_Label")
test_data <- cbind(as.data.table(test_subject), y_test_data, x_test_data)

train_subject <-read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = " ",col.names = "subject")
x_train_data <-read.table("UCI HAR Dataset/train/x_train.txt", col.names = features)
x_train_data <- x_train_data[,extract_features]
y_train_data <-read.table("UCI HAR Dataset/train/y_train.txt")
y_train_data[,2] = activity_labels[y_train_data[,1]]
names(y_train_data) = c("Activity_ID", "Activity_Label")
training_data <- cbind(as.data.table(train_subject), y_train_data, x_train_data)
 
data = rbind(test_data, training_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")