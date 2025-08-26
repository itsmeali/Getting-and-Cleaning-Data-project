# Load packages
library(dplyr)

# 1. Load data
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# 2. Merge datasets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

colnames(X) <- features[, 2]
colnames(Y) <- "Activity"
colnames(Subject) <- "Subject"

merged_data <- cbind(Subject, Y, X)

# 3. Extract mean and std
tidy_data <- merged_data %>% select(Subject, Activity, contains("mean"), contains("std"))

# 4. Use descriptive activity names
tidy_data$Activity <- activity_labels[tidy_data$Activity, 2]

# 5. Label with descriptive variable names
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))

# 6. Create independent tidy dataset with average
final_data <- tidy_data %>%
    group_by(Subject, Activity) %>%
    summarise_all(mean)

# 7. Write to file
write.table(final_data, "tidy_dataset.txt", row.name=FALSE)

