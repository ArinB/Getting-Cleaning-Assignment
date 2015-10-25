## Download Data: This script assumes that the provided data files are downloaded to your 
## local present working directory (pwd) and a folder structure os created identical to the source data
## zip file structure with "relative path" convention.
##
## Read all data into tables
##
training_base_table <- read.table("./train/X_train.txt", header=FALSE)
training_act_table <- read.table("./train/y_train.txt", header=FALSE)
training_sub_table <- read.table("./train/subject_train.txt", header=FALSE)
names(training_sub_table) <- "Subject"
##
test_base_table <- read.table("./test/X_test.txt", header=FALSE)
test_act_table <- read.table("./test/y_test.txt", header=FALSE)
test_sub_table <- read.table("./test/subject_test.txt", header=FALSE)
names(test_sub_table) <- "Subject"
##
## Read Activity Label master table to use as a look up table
##
activity_labels <- read.table("./activity_labels.txt", header=FALSE)
##
##Replace the Activity Codes with Activity Labels in both Training & Test act_tables
training_act_table$V1 <- as.factor(activity_labels$V2[training_act_table$V1])
names(training_act_table) <- "Activity"
test_act_table$V1 <- as.factor(activity_labels$V2[test_act_table$V1])
names(test_act_table) <- "Activity"
names(training_act_table) <- "Activity"

## Merge the columns of Training Tables
col_merged_train_table <- cbind(training_base_table, training_act_table, training_sub_table)
##
## Merge the columns of Training Tables
col_merged_test_table <- cbind(test_base_table, test_act_table, test_sub_table)
##
## Merge all rows of the two column merged tables
total_train_test_table <- rbind(col_merged_train_table, col_merged_test_table)
##
##Extract Time Series Data columns only for Mean and SD. Also have the "Activity" column
extracted_table <- total_train_test_table[,c((1:6),(41:46),(81:86),(121:126),(161:166),(201:202),(214:215),(227:228),(240:241),(253:254),(562:563))]
#
# Change the Column Names to meaningful variable names
names(extracted_table) <- c("tBodyAcc-mean-X","tBodyAcc-mean-Y","tBodyAcc-mean-Z","tBodyAcc-std-X","tBodyAcc-std-Y","tBodyAcc-std-Z","tGravityAcc-mean-X","tGravityAcc-mean-Y","tGravityAcc-mean-Z","tGravityAcc-std-X","tGravityAcc-std-Y","tGravityAcc-std-Z","tBodyAccJerk-mean-X","tBodyAccJerk-mean-Y","tBodyAccJerk-mean-Z","tBodyAccJerk-std-X","tBodyAccJerk-std-Y","tBodyAccJerk-std-Z","tBodyGyro-mean-X","tBodyGyro-mean-Y","tBodyGyro-mean-Z","tBodyGyro-std-X","tBodyGyro-std-Y","tBodyGyro-std-Z","tBodyGyroJerk-mean-X","tBodyGyroJerk-mean-Y","tBodyGyroJerk-mean-Z","tBodyGyroJerk-std-X","tBodyGyroJerk-std-Y","tBodyGyroJerk-std-Z","tBodyAccMag-mean","tBodyAccMag-std","tGravityAccMag-mean","tGravityAccMag-std","tBodyAccJerkMag-mean","tBodyAccJerkMag-std","tBodyGyroMag-mean","tBodyGyroMag-std","tBodyGyroJerkMag-mean","tBodyGyroJerkMag-std","Activity","Subject")
#
# Average of each variable grouped by Activity and Subject - should generate 180 rows
final_table <- group_by(extracted_table, Activity, Subject) %>% summarise_each(funs(mean))
nrow(final_table)
#
# Write the final table to a local text file
#
write.table(final_table, file = "final_data.txt", row.name = FALSE)
#
# End of Script
