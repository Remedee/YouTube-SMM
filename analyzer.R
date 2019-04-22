# Authors: Mia Ward, Arturo Mora, Zachary Edwards Downs | R-Script to analyze a youtube data api data set.

# ~ Data Organization Notes ~
# data is the raw csv file as a dataframe.
# popular is a dataframe of the popular videos and their attributes.
# related is a list of dataframes for the related videos and their attributes.
# To access the dataframe for the first popular video's related videos you would use related[[1]] and so on...
# The rest are just the raw data broken up into dataframes based on the attribute they are, views, likes, etc.

###
### DATA PREPERATION
###

# Read in a csv and remove the extra column.
data <- read.csv(file='data/data0.csv',header=FALSE,sep=',')
data$V16 <- NULL

# Reads the data into data frames seperated by every 50 rows.
datalist <- split(data,rep(1:6,each=50))

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
for (i in 1:50) {
  
  # Store the videos attributes into popular[[i]].
  pop[[i]] <- data.frame(Video=data[i, 1],
                             Channel=data[i + 50, 1],
                             Views=data[i + 100, 1],
                             Comments=data[i + 150, 1],
                             Likes=data[i + 200, 1],
                             Dislikes=data[i + 250, 1])
  
  # Make popular into a dataframe rather than a list of dataframes.
  if (i < 2) {
    popular <- pop[[i]]
  }
  else {
    popular <- rbind(popular, pop[[i]])
  }
  
}

# Get a list of the related videos and their attributes.
for (i in 1:50) {
  
  for (j in 2:15) {
    # Store the videos attributes into popular[[i]].
    rel[[j - 1]] <- data.frame(Video=data[i, j],
                               Channel=data[i + 50, j],
                               Views=data[i + 100, j],
                               Comments=data[i + 150, j],
                               Likes=data[i + 200, j],
                               Dislikes=data[i + 250, j])
    
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
rm(i, j, datalist, rel, pop)



###
### DATA ANALYSIS
###