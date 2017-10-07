load_data <- function(data_directory, inertial_signals_dir="Inertial Signals") {
    # List content of directory and checks for all data to exist
    dir_content <- list.files(data_directory)
    inertial_signals_dir <- inertial_signals_dir
    dir_content <- dir_content[dir_content != inertial_signals_dir]

    # Get file path
    dir_content <- sapply(dir_content, function(file) {file.path(data_directory,file)})

    # Load subject file (subject_???.txt)
    subject_file <- dir_content[grep("subject", dir_content)]
    data_frame <- read.table(subject_file, col.names="subject_id")
    # Load data file (X_???.txt)
    X_file <- dir_content[grep("X", dir_content)]
    data <- load_data_file(X_file)
    data_frame <- cbind(data_frame,data)
    # Load label file (y_???.txt)
    y_file <- dir_content[grep("y", dir_content)]
    data <- read.table(y_file, col.names="activity")
    data <- sapply(data, map_activity)
    data_frame <- cbind(data_frame,data)
    
    return(data_frame)
}


load_data_file <- function(filename, col_file="UCI HAR Dataset/features.txt") {
    # Parse columns' names from file
    col_names <- c()
    cols <- readLines(con <- file(col_file))
    for(row in cols) {
        x <- strsplit(trimws(row)," ")[[1]][2]
        col_names <- c(col_names, x)
    }
    close(con)
    
    # Filter "good" columns, i.e. that containing the mean and standard deviation
    # Notice the tolower function
    good_col <- sapply(col_names, function(x) {grepl("mean", tolower(x)) || grepl("std", tolower(x)) })
    good_col <- which(good_col)

    # Read data from file and filter "good" columns
    data <- read.table(filename, col.names = col_names)
    data <- data[,good_col]
    return(data)

}

map_activity <- function(x) {
    # Map numbers to activities
    activity <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                  "SITTING", "STANDING", "LAYING")
    return(activity[x])
}

data_test <- load_data("UCI HAR Dataset/test")
data_train <- load_data("UCI HAR Dataset/train")

# The merged dataframe
all_data <- rbind(data_test, data_train)

# The dataframe for the 5th request
library(dplyr)
aggregate_data <- all_data %>% group_by(subject_id, activity) %>% summarise_all(mean)
write.table(aggregate_data,file = "tidy.txt", row.name=FALSE)







