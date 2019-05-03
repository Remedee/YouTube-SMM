# Authors: Mia Ward, Arturo Mora, Zachary Edwards Downs | R-Script to analyze a youtube data api data set.

# ~ Data Organization Notes ~
# data is the csv file with bad data points removed.
# popular is a dataframe of the popular videos and their attributes.
# related is a list of dataframes for the related videos and their attributes.
# To access the dataframe for the first popular video's related videos you would use related[[1]] and so on...
# The rest are just the raw data broken up into dataframes based on the attribute they are, views, likes, etc.

###
### DATA PREPERATION
###

# Read in a csv and remove the extra columns often left blank by the api.
data <- read.csv(file='data/data3.csv',header=FALSE,sep=',')
data$V16 <- NULL
data$V15 <- NULL

# Set while loop variables.
x <- 50
i <- 1

# Loop to remove all rows of a videos attributes if it does not have at least 13 related videos.
while (i < nrow(data)) {
  
  # Decide what command to run based on dataframe row number.
  if (i < 51) {
    v <- 'data <- data[-c(i, i + x, i + x * 2, i + x * 3, i + x * 4, i + x * 5),]'
  }
  else if (i < 101) {
    v <- 'data <- data[-c(i - x, i, i + x, i + x * 2, i + x * 3, i + x * 4),]'
  }
  else if (i < 151) {
    v <- 'data <- data[-c(i - x * 2, i - x, i, i + x, i + x * 2, i + x * 3),]'
  }
  else if (i < 201) {
    v <- 'data <- data[-c(i - x * 3, i - x * 2, i - x, i, i + x, i + x * 2),]'
  }
  else if (i < 251) {
    v <- 'data <- data[-c(i - x * 4, i - x * 3, i -x * 2, i - x, i, i + x),]'
  }
  else {
    v <- 'data <- data[-c(i - x * 5, i - x * 4, i -x * 3, i - x * 2, i - x, i),]'
  }
  
  # If the row exists and column 14 is blank then remove rows containing its attributes.
  # Decriment x by 1, and reset the loop to the beggining.
  if (!(is.na(data[i,]$V14))) {
    if (data[i,]$V14 == "") {
      eval(parse(text=v))
      x <- x - 1
      i <- 1
    }
  }
  
  i <- i + 1
  
}

# Re-configure row indicators.
row.names(data) <- 1:nrow(data)

# The number of videos still in the data set after removing bad values.
NUMVID = x

# Reads the data into data frames seperated by every NUMVID rows.
datalist <- split(data,rep(1:6,each=NUMVID))

# Loop through the data list to create data frames of its elements.
for (i in 1:6) {
  
  # Depending on the value of i, create an appropriately named data frame.
  switch(i,
         videoids <- data.frame(datalist[i]),
         channelids <- data.frame(datalist[i]),
         views <- data.frame(datalist[i]),
         comments <- data.frame(datalist[i]),
         likes <- data.frame(datalist[i]),
         dislikes <- data.frame(datalist[i]))
  
}

# Create lists to aid in data frame creation.
pop <- list()
rel <- list()
related <- list()

# Get a list of the most popular youtube videos and their attributes.
for (i in 1:NUMVID) {
  
  # Store the videos attributes into popular[[i]].
  pop[[i]] <- data.frame(Video=data[i, 1],
                         Channel=data[i + NUMVID, 1],
                         Views=data[i + NUMVID * 2, 1],
                         Comments=data[i + NUMVID * 3, 1],
                         Likes=data[i + NUMVID * 4, 1],
                         Dislikes=data[i + NUMVID * 5, 1])
  
  # Make popular into a dataframe rather than a list of dataframes.
  if (i < 2) {
    popular <- pop[[i]]
  }
  else {
    popular <- rbind(popular, pop[[i]])
  }
  
}

# Get a list of the related videos and their attributes.
for (i in 1:NUMVID) {
  
  for (j in 2:14) {
    # Store the videos attributes into popular[[i]].
    rel[[j - 1]] <- data.frame(Video=data[i, j],
                               Channel=data[i + NUMVID, j],
                               Views=data[i + NUMVID * 2, j],
                               Comments=data[i + NUMVID * 3, j],
                               Likes=data[i + NUMVID * 4, j],
                               Dislikes=data[i + NUMVID * 5, j])
    
    # Make related[[i]] into a dataframe rather than a list of dataframes.
    if (j < 3) {
      related[[i]] <- rel[[j - 1]]
    }
    else {
      related[[i]] <- rbind(related[[i]], rel[[j -1]])
    }
    
  }
  
}

# Remove no longer needed workspace objects.
rm(i, j, datalist, rel, pop, x, v)



###
### DATA ANALYSIS
###

# Necessary libraries.
library(ggplot2)
library(reshape)

# Rename the column names of videoids.
names(videoids) <- c("Popular", "R01", "R02", "R03", "R04", "R05", "R06", "R07", "R08", "R09", "R10", "R11", "R12", "R13")

# Reshpae videoids into videograph based on the Popular column.
videograph <- melt(videoids, id.vars="Popular")

# Plot videograph into a coherent graph.ins
ggplot(videograph, aes(Popular,value, col=variable)) + 
  geom_point() + 
  stat_smooth() + 
  labs(color='Related') +
  ylab ('Related') +
  theme(axis.text.x=element_blank(), axis.text.y=element_blank())
# Explanation Example: geom_text(data=subset(videomelt, value=="pvuN_WvF1to"), label='HELLO')

video_occurs <- 0
pop_likes <- 0

#for each popular video, get the number of likes it has -> video_occurs. For each related video of the popular video, get the likes it has
#make loop to check if popular video has more or less likes than its related videos
#make sure to change the number of popular videos we get and the total number of related videos
#By Mia Ward

related_videos_num <- nrow(videograph)

#getting array of popular video id and its number of likes
for (i in 1:NUMVID){
  video_occurs[i] <- as.character(popular[i,1])
}

for (i in 1:NUMVID){
  pop_likes[i] <- as.character(popular[i,5])
}

popular_likes <- array(c(video_occurs,pop_likes), dim = c(NUMVID,2))

related_id <- 0
related_li <- 0
related_likes <- 0

#getting array of related video ids
for (i in 1:NUMVID){
  for (j in 1:13){
    related_id[j + (13*(i-1))] <- as.character(related[[i]][[j,1]])
  }
}

#getting array of related video likes
for (i in 1:NUMVID){
  for (j in 1:13){
    related_li[j + (13*(i-1))] <- as.character(related[[i]][[j,5]])
  }
}

#concat ids and likes of related videos
related_likes <- array(c(related_id, related_li), dim = c(related_videos_num,2))

popular_likes_count <- 0
related_likes_count <- 0

#loop through 46 popular videos and if popular has more likes than related then add 1 to popular_likes_count otherwise add 1 to related_likes_count
for (i in 1:NUMVID){
  for (j in 1:13){
    if (popular_likes[i,2] > related_likes[j,2]){
      popular_likes_count <- popular_likes_count + 1
    }
    else {
      related_likes_count <- related_likes_count + 1
    }
  }
}

#removing unwanted variables and arrays
rm(i,j,pop_likes,related_id,related_li,video_occurs,popular_likes, related_likes)


## This part deals with videos being reccomended more than one time.
## These next two sections find that videos that occur more than once have no above average number of
## views, likes, or comments, and that dislikes don't appear to affect how many times it's recommended.

#
# Number of Occurances
#

# Create an occurances list.
occurances <- list()

# Add videoids fro related videos to occurances and do not add duplicates.
for (i in 1:NUMVID) 
{
  for (j in 1:14) 
  {
    if (!(as.character(videoids[i,j]) %in% occurances)) 
    {
      occurances[j + (14 * (i - 1))] <- as.character(videoids[i,j])
    }
  }
}

# Remove null values from occurances. (Caused by nothing appeneded when duplicates occur.)
occurances <- occurances[-which(lapply(occurances,is.null) == T)]

# Append occurances as column1 of the dataframe occ.
occ <- data.frame(videoid=I(occurances), occurances=0)

# List to be used in the next section: Averages.
values <- data.frame(Video=0,Views=0, Comments=0, Likes=0, Dislikes=0)

# Check for each row of occ if the video id is in any and every value of videoids and add 1 to its occurances each time it is found.
for (i in 1:nrow(occ)) 
{
  for (j in 1:NUMVID)
  {
    for (k in 1:14) {
      if (occ[i,1] %in% videoids[j,k]) 
      {
        occ[i,2] <- occ[i,2] + 1
      }
      # On the first pass make a dataframe known as values to append data too.
      if (i == 1) 
      {
        if (!(as.character(videoids[j,k]) %in% values[,1]))
        {
          values[k + (14 * (j - 1)),1] <- as.character(videoids[j,k])
          values[k + (14 * (j - 1)),2] <- as.numeric(as.character(views[j,k]))
          values[k + (14 * (j - 1)),3] <- as.numeric(as.character(comments[j,k]))
          values[k + (14 * (j - 1)),4] <- as.numeric(as.character(likes[j,k]))
          values[k + (14 * (j - 1)),5] <- as.numeric(as.character(dislikes[j,k]))
        }
      }
    }
  }
}

# Remove the uneeded variables.
rm (i, j, k , occurances)

#
# Calculate Above Average
#

# Remove rows in values containing nothing but NA.
values <- values[!(rowSums(is.na(values)) == 5),]
# Append occurances column 2 to new column OCCTotal in values.
values$OCCTotal <- occ[,2]
# Remove any rows in values with NA in it at all.
values <- values[rowSums(is.na(values)) == 0,]

# Calculate mean values for comparison.
meanView <- mean(values[,'Views'])
meanComm <- mean(values[,'Comments'])
meanLike <- mean(values[,'Likes'])
meanDisl <- mean(values[,'Dislikes'])

# Generate a means data frame of all 0s.
means <- as.data.frame(matrix(0, ncol=5, nrow=nrow(values)))
names(means) <- c('AAViews','AAComments','AALikes','AADislikes','AATotal')

# If a video has above average stats add a 1 to that column, unless dislikes where a -1 is added.
for (i in 1:nrow(values)) 
{
  if (values[i,2] > meanView) 
  {
    means[i,1] <- 1
  }
  if (values[i,3] > meanComm) 
  {
    means[i,2] <- 1
  }
  if (values[i,4] > meanLike) 
  {
    means[i,3] <- 1
  }
  if (values[i,5] > meanDisl) 
  {
    means[i,4] <- -1
  }
}

# Sum a videos above average score into AATotal
for (i in 1:nrow(means)) 
{
  means[i,5] <- means[i,1] + means[i,2] + means[i,3] + means[i,4]
}

# Append the AATotal Column from means into values.
values$AATotal <- means[,5]

# Tell if video is in popular or not with TRUE and FALSE.
for (i in 1:nrow(values))
{
  if (values[i,1] %in% videoids[,1]) 
  {
    values[i,8] <- TRUE
  }
  else
  {
    values[i,8] <- FALSE
  }
}

# Remove unecessary objects.
rm(i,meanView,meanComm,meanLike,meanDisl,occ,means)

#
# Decision Tree
#

library(rpart)

# Create a decision tree using the views, comments, likes, and dislikes of values and if the video is popular or not.
tree.model <- rpart(V8~., data=values[,c(2,3,4,5,8)], method="class")

# Use the tree to predict for each video whether it will be popular or not.
tree.prediction <- predict(tree.model, newdata=values[,c(2,3,4,5,8)], type="class")

# Make a confusion matrix showing how many data points the prediction got right and wrong.
confusion.matrix <- table(values$V8, tree.prediction)

# Get the percentage of accuracy the prediction had.
accuracy.percent <- 100*sum(diag(confusion.matrix))/sum(confusion.matrix)

# Plot the tree model.
plot(tree.model)
text(tree.model, pretty=1)

#Finding which videos are the most popular among all the videos. So looking for the most occuring videos.
#Interating through OCCTotal, if the OCCTotal for a video is greater than 2, then add that video id to an array with all popular videos

cream_of_the_crop <- c()
total_videos <- nrow(values)


for (i in 1:total_videos){
  if (values[i,"OCCTotal"] > 2) {
    cream_of_the_crop <- c(cream_of_the_crop, values[i,"Video"])
  }
}

print(cream_of_the_crop)

# Cleanup non-result data sets and uneeded objects.
rm(i, channelids, comments, views, likes, dislikes, data)



###Getting the median to use for the mean (SUBTOPICS)
med <- data.frame(views=numeric(), comments=numeric, likes, dislikes)

for (i in 1:NUMVID) {
  med[i,1] <- values[i + 13 * (i - 1), 2]
  med[i,2] <- values[i + 13 * (i - 1), 3]
  med[i,3] <- values[i + 13 * (i - 1), 4]
  med[i,4] <- values[i + 13 * (i - 1), 5]
}

med <- med[rowSums(is.na(med)) == 0,]

# Tell if video is in popular or not with TRUE and FALSE
median(as.numeric(as.character(med$views)))
median(as.numeric(as.character(med$comments)))
median(as.numeric(as.character(med$likes)))
median(as.numeric(as.character(med$dislikes)))


#Find the mean for Data 0-4 with hardcoded answers from previous median
a <- c(970589, 1243840, 1312130, 1590022, 2219152)
b <- c(1564, 3368, 3534.5, 4063.5, 2837)
c <- c(25528, 25469, 24928.5, 37290.5, 28671)
d <- c(580, 1173, 1328, 1222, 1134)

mean(a)
mean(b)
mean(c)
mean(d)
