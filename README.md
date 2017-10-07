# Tidy dataset


## Load data
The train and test datasets are loaded into two separate dataframes calling two times the function *load_data* with respectivly the train and test directories ("UCI HAR Dataset/train" and "UCI HAR Dataset/test").


### Funtion *load_data*

Given the name of the directory with the data (either train or test), it first gets the names of the files contained into it and discrads the "Inertial Signals" directory. After that, it loads the three files with the data.
* Subject file (pattern "subject_???.txt") can be loaded directly into a dataframe.
* X file (pattern "X_???.txt") is loaded thanks to the function *load_data_file*. The latter reads the file with the names of the columns ("UCI HAR Dataset/features.txt") and stores them into an array. Then it stores the indexes of the variables that contain the words "mean" or "std" (notice that they are looked for into the lowercase names of the columns) into the variable "good_col". It is convenient to extract here the indexes so that we can filter out the unwanted columns while reading the file and not after having loaded a bunch of useless data. Then it reads the first line of the file, trims trailing white spaces, replaces the two spaces with a semicolon (*gsub* function, this step is necessary since read.table can only be used with single-character separators) and finally it splits on the semicolons just inserted. The row is inserted into a dataframe and subsequently all the other rows of the file are read and are processed in the same way into the for loop. The function returns the cleaned dataframe.

* y file (pattern "y_???.txt") is loaded into a dataframe after having applied the function *map_activity* which maps the numbers of the activities into meaningful labels. 

## Merge train and test
Thanks to *rbind*, the two dataframes are merged (in practice one is appended after the last row of the other).

## Compute aggregate results
The requested aggregate results are computed thanks to the *dplyr* package. Let us notice two main aspects of this operation. First, the function *group_by* is called with two arguments (corresponding to the names of two columns). Secondly, tha call of *summarise_all* which apply the aggregate function to all columns execpt that previously used to group the data. Finally, the aggregate results are saved to file using the function *write.table*



