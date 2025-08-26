library(dplyr)

#1) Read files

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("index", "feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# 2) read traning data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

# 3) read test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

# 4) Naming measurement columns according to features
colnames(x_train) <- features$feature
colnames(x_test)  <- features$feature

# 5) Merage train + test
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
S <- rbind(sub_train, sub_test)

merged <- cbind(S, Y, X)  # Expected dimensions: 10299 row × (2 + 561) coloum

# 6) pick colums mean() and std() only (without meanFreq Or a corner)
mean_std_idx <- grepl("mean\\(\\)|std\\(\\)", features$feature)
selected <- cbind(merged[, c("Subject", "Activity")], X[, mean_std_idx, drop = FALSE])

# 7) exchange code
selected$Activity <- factor(selected$Activity,
                            levels = activities$code,
                            labels = activities$activity)

# 8)Clean up column names to be descriptive and clear.
clean_names <- colnames(selected)
clean_names <- gsub("\\(\\)", "", clean_names)       #Remove brackets
clean_names <- gsub("-", "", clean_names)            # Remove dashes
clean_names <- gsub("^t", "Time", clean_names)
clean_names <- gsub("^f", "Frequency", clean_names)
clean_names <- gsub("Acc", "Accelerometer", clean_names)
clean_names <- gsub("Gyro", "Gyroscope", clean_names)
clean_names <- gsub("Mag", "Magnitude", clean_names)
clean_names <- gsub("BodyBody", "Body", clean_names)
clean_names <- gsub("mean", "Mean", clean_names)
clean_names <- gsub("std", "Std", clean_names)
colnames(selected) <- clean_names

# 9) Create the final data set: Mean per Subject/Activity
final <- selected %>%
  group_by(Subject, Activity) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  arrange(Subject, Activity)

# 10) save result file
write.table(final, "tidy_dataset.txt", row.name = FALSE)

# 11) Print quick tests
cat("Rows x Cols (selected):", dim(selected)[1], "x", dim(selected)[2], "\n") 
cat("Rows x Cols (final):   ", dim(final)[1], "x", dim(final)[2], "\n")       
