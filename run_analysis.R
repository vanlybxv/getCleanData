#SECTION TO READ IN ALL THE DATA SETS

#read in from the train folder
setwd("~/Downloads/UCI HAR Dataset/train")
subject_train <- read.table(file ="subject_train.txt", header = FALSE, quote = "" )
x_train <- read.table(file ="X_train.txt", header = FALSE, quote = "" )
y_train <- read.table(file ="Y_train.txt", header = FALSE, quote = "" )

#read in from the test folder
setwd("~/Downloads/UCI HAR Dataset/test")
subject_test <- read.table(file ="subject_test.txt", header = FALSE, quote = "" )
x_test <- read.table(file ="X_test.txt", header = FALSE, quote = "" )
y_test <- read.table(file ="Y_test.txt", header = FALSE, quote = "" )

#read in from the UCI HAR Data Set folder
setwd("~/Downloads/UCI HAR Dataset")
activity_labels <- read.table(file ="activity_labels.txt", header = FALSE, quote = "" )
features <- read.table(file ="features.txt", header = FALSE, quote = "" )


# TRANSFORM THE VARIABLE NAMES TO MAKE MORE HUMAN READABLE
#give human readable variable names
names(subject_train) <-c('subject_no')
names(subject_test) <-c('subject_no')
names(y_train) <- c('activity_no')
names(y_test) <- c('activity_no')
names(activity_labels) <- c('activity_no','activity_name')

#merge the activity numbers to activity names to make the data table more intuitive
y_train <- merge(y_train,activity_labels, by = 'activity_no')
y_train <- cbind(subject_train,y_train)

y_test <- merge(y_test,activity_labels, by = 'activity_no')
y_test <- cbind(subject_test,y_test)

# use the observations in "features" data frame as variable names for x_train, x_test data
colnames(x_train) <- features[['V2']]
colnames(x_test) <- features[['V2']]

#merge (via cbind) the qualittative, descriptive varaible observations and the quantitative obs
training_set_full <- cbind(y_train, x_train)
test_set_full <- cbind(y_test, x_test)
#indicate which group the observation belongs to 
training_set_full$group <- 'training'
test_set_full$group <- 'test'

#combine the 2 data sets
combined_data_set <-rbind(training_set_full,test_set_full)

#make a subset of the full data set with only mean and SD concerned variables
mean_sd_data <- combined_data_set[, c(1:3,grep('mean()', names(combined_data_set)),grep('std()', names(combined_data_set)))]

# change the numeric variable column names to somwthign more descriptive
names(mean_sd_data) <- sub("^t","time_",names(mean_sd_data))
names(mean_sd_data) <- sub("^f","freq_",names(mean_sd_data))

# create a subset of the data with avg for each subject & activity
# will use dplyr
library(dplyr)

# calc mean of all the variables, sumarized at unique subject & activity combo
activity_subj_means <- mean_sd_data %>%
  group_by(subject_no, activity_no, activity_name)%>%
  summarise_each(funs(mean))
  

  
