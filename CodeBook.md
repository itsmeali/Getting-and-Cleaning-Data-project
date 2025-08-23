# CodeBook

## Data Source
- UCI HAR Dataset from Samsung Galaxy S smartphone accelerometers.

## Variables
- `subject`: ID of the participant (1–30)
- `activity`: Descriptive activity name (e.g., WALKING, SITTING)
- Measurement variables: Time/Frequency domain signals from accelerometer and gyroscope.

## Transformations
- Merged training and test sets.
- Extracted only mean and standard deviation measurements.
- Renamed variables for clarity.
- Created summary dataset with average of each variable per subject/activity.
