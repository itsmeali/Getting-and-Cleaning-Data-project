# Step 0: Setup
library(dplyr)
library(data.table)

# Step 1: Download and unzip the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
if (!file.exists(zip_file)) download.file(url, zip_file, mode = "wb")
if (!file.exists("UCI HAR Dataset")) unzip(zip_file)

# Step 2: Load data
features <- fread("UCI HAR Dataset/features.txt")
activities <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Training data
x_train <- fread("UCI HAR Dataset/train/X_train.txt")
y_train <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "activity_code")
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Test data
x_test <- fread("UCI HAR Dataset/test/X_test.txt")
y_test <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "activity_code")
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Step 3: Merge training and test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 4: Extract mean and standard deviation features
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$V2)
x_data <- x_data[, ..mean_std_features]
setnames(x_data, features$V2[mean_std_features])

# Step 5: Use descriptive activity names
y_data$activity <- activities$activity[match(y_data$activity_code, activities$code)]

# Step 6: Label dataset with descriptive variable names
names(x_data) <- gsub("^t", "Time", names(x_data))
names(x_data) <- gsub("^f", "Frequency", names(x_data))
names(x_data) <- gsub("Acc", "Accelerometer", names(x_data))
names(x_data) <- gsub("Gyro", "Gyroscope", names(x_data))
names(x_data) <- gsub("Mag", "Magnitude", names(x_data))
names(x_data) <- gsub("BodyBody", "Body", names(x_data))

# Step 7: Create tidy dataset with averages
tidy_data <- cbind(subject_data, y_data$activity, x_data)
colnames(tidy_data)[2] <- "activity"
tidy_summary <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop")

# Step 8: Save tidy dataset
write.table(tidy_summary, "tidy_data.txt", row.name = FALSE)
