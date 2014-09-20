# loading the files

subject_train <- read.table("./train/subject_train.txt",stringsAsFactors=FALSE)
subject_test <- read.table("./test/subject_test.txt",stringsAsFactors=FALSE)
y_train <- read.table("./train/y_train.txt",stringsAsFactors=FALSE)
y_test <- read.table("./test/y_test.txt",stringsAsFactors=FALSE)
x_train <- read.table("./train/x_train.txt",stringsAsFactors=FALSE)
x_test <- read.table("./test/x_test.txt",stringsAsFactors=FALSE)
features <- read.table("features.txt",stringsAsFactors=FALSE)
activities<- read.table("activity_labels.txt",stringsAsFactors=FALSE)

# joining subjects, labels and data sets and, after, train and test data

data_train <- cbind(subject_train,y_train,x_train)
data_test <- cbind(subject_test,y_test,x_test)
data <- rbind(data_train,data_test)
colnames(data) <- c("Subject","Activity",features$V2)
attach(data)

#merging activities to data

datamerged <- merge(data,activities,by.x="Activity",by.y="V1")
datamerged$Activity <- datamerged$V2
datamerged <- datamerged[,-564]

# identifying measurements on the mean and standard deviation and filtering out
# data and features

features$mean <- strsplit(features$V2,"mean")
features$std <- strsplit(features$V2,"std")
colmeanstd <- which(features$V2!=features$mean|features$V2!=features$std)
colmeanstd <- colmeanstd+2
datamerged <- datamerged[,c(1,2,colmeanstd)]
attach(datamerged)

# calculating mean by Subject, Activity and variable

projectdata <- aggregate(datamerged[,3:81],by=list(Subject,Activity), mean)
write.table(projectdata,file="projectdata.txt",row.names=FALSE)
