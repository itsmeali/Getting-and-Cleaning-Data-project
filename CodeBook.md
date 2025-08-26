
---

## 📄 `CodeBook.md`

```markdown
# Code Book

This code book describes the variables, the data, and the transformations performed to clean up the data for the "Getting and Cleaning Data" course project.

## Source Data
The dataset originates from:
- **Human Activity Recognition Using Smartphones Dataset**
- Collected from 30 subjects performing daily activities while wearing a smartphone (Samsung Galaxy S II).
- Full dataset available at: [UCI HAR Dataset](https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones)

## Variables
- **Subject**: ID of the test subject (values range from 1 to 30).
- **Activity**: The type of activity performed (one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
- **Features**: Mean and standard deviation (std) measurements extracted from the original dataset.  
  Examples include:
  - TimeBodyAccelerometerMeanX  
  - TimeBodyAccelerometerStdY  
  - FrequencyBodyGyroscopeMeanZ  
  - etc.

## Transformations
1. Merged training and test sets to create one dataset.
2. Extracted only measurements on the mean and standard deviation for each measurement.
3. Replaced activity codes with descriptive activity names.
4. Renamed variable names to be more descriptive:
   - `t` → `Time`
   - `f` → `Frequency`
   - `Acc` → `Accelerometer`
   - `Gyro` → `Gyroscope`
   - `Mag` → `Magnitude`
   - `BodyBody` → `Body`
5. Created a tidy dataset with the average of each variable for each subject and each activity.
6. Saved the resulting dataset into `tidy_dataset.txt`.

## Final Dataset
The final tidy dataset contains:
- 180 rows (30 subjects × 6 activities)
- 68 columns (Subject, Activity, and 66 feature variables)
