# Authors: Mia Ward, Arturo Mora, Zachary Edwards Downs | R-Script to analyze a youtube data api data set.

# ~ Data Organization Notes ~
# data is the csv file with bad data points removed.
# popular is a dataframe of the popular videos and their attributes.
# related is a list of dataframes for the related videos and their attributes.``
# To access the dataframe for the first popular video's related videos you would use related[[1]] and so on...
# The rest are just the raw data broken up into dataframes based on the attribute they are, views, likes, etc.

###
### DATA PREPERATION
###

# Read in a csv and remove the extra columns.
data <- read.csv(file='GitHub/YouTube-SMM/data/data0.csv',header=FALSE,sep=',')
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

# Re-configure row incicators.
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

#for each popular video, get the number of likes it has.-> video_occurs. For each related video of the popular video, get the likes it has
#make loop to check if popular video has more or less likes than its related videos
#By Mia Ward

#getting array of popular video id and its number of likes
for (i in 1:NUMVID){
  video_occurs[i] <- as.character(popular[i,1])
}

for (i in 1:NUMVID){
  pop_likes[i] <- as.character(popular[i,5])
}

popular_likes <- array(c(video_occurs,pop_likes), dim = c(46,2))

related[[2]]

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
related_likes <- array(c(related_id, related_li), dim = c(598,2))

popular_likes_count <- 0
related_likes_count <- 0

#loop through 46 popular videos and if popular has more likes than related then add 1 to popular_likes_count otherwise add 1 to related_likes_count
for (i in 1:46){
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
rm(i,j,pop_id,pop_likes,realted_likes,related_id,related_li,video_occurs,popular_likes,related_likes)
