#1.Merging the training and Test sets to create one data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# creating 'Feature' data set that combines both training and test sets in 'x' using rbind
Feature_data <- rbind(x_train, x_test)

# creating 'Activity' data set that combines both training and test sets in 'y' using rbind
Activity_data <- rbind(y_train, y_test)

# creating 'subject' data set that combines both training and test sets in 'subject' using rbind.
subject_data <- rbind(subject_train, subject_test)
# setting names to the variables

names(subject_data)<-c("Subject")
names(Activity_data)<-c("Activity")

FeatureNames_data<-read.table("features.txt")
names(Feature_data)<-FeatureNames_data$V2
## merging the three data sets into one data set using "cbind"

mergingdata<-cbind(subject_data,Activity_data)
whole_data<-cbind(Feature_data,mergingdata)

##2.Extracting only the measurements on the mean and standard deviation for each measurement
#getting coloumns with mean or std in their names

mean_and_std_features <- grep("-(mean|std)\\(\\)", FeatureNames_data[, 2])
# subsetting the desired coloumns
Feature_data <- Feature_data[, mean_and_std_features]
#naming the coloumns
names(Feature_data) <- FeatureNames_data[mean_and_std_features, 2]


##3.Using descriptive activity names to name the activities in the data set

activity_labels<-read.table("activity_labels.txt")

# updating values with correct activity names
Activity_data[, 1] <- activity_labels[Activity_data[, 1], 2]

# Assigning correct column name
names(Activity_data) <- "activity"

##4.Appropriately label the data set with descriptive variable names

names(whole_data)<-gsub("^t", "time", names(whole_data))
names(whole_data)<-gsub("^f", "frequency", names(whole_data))
names(whole_data)<-gsub("Acc", "Accelerometer", names(whole_data))
names(whole_data)<-gsub("Gyro", "Gyroscope", names(whole_data))
names(whole_data)<-gsub("Mag", "Magnitude", names(whole_data))
names(whole_data)<-gsub("BodyBody", "Body", names(whole_data))

##5.Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

average_data <- ddply(whole_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(average_data, "tidy_data.txt", row.name=FALSE)

