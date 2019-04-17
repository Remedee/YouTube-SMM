# Zachary Edwards Downs | YouTube Data Api v3 Project

###
### Api set-up
###

# Necessary imports.
import csv
import os
from apiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow

# Create the data folder if it does not already exist.
if not os.path.isdir('data'):

    os.mkdir('data')

# Popular array defenition.
popids=[]
popchannels=[]
poplikes=[]
popdislikes=[]
popviews=[]
popcomments=[]

# Array for csv file names.
fnames=[]

# Get credentials from client secret.
CLIENT_SECRET_FILE = 'client_secret.json'
SCOPES = ['https://www.googleapis.com/auth/youtube']
flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRET_FILE, SCOPES)
credentials = flow.run_console()

# Build the api.
apiKey = 'AIzaSyBDfBHkXmijo0Ji4Lv2pae95dJ1dyxwTo0'
youtube = build('youtube', 'v3', developerKey=apiKey, credentials=credentials)



###
### Generates an unused file name to store data in.
###

# Change to the data directory.
os.chdir('data')

# Get the file names in the data directory.
for files in os.walk("."):
        for file in files:
            if '.' not in file:
                fnames = file

# Sort the file names alphabetically.
fnames.sort()

# Generate an unused filename.
for i in range(len(fnames) + 1):

    # If all files have been checked generate a name then break.
    if i == len(fnames):
        name = 'data' + str(i) + '.csv'
        break

    name = 'data' + str(i) + '.csv' # Generate a file name.

    # If the generated file name does not exist then use it and break.
    if name != fnames[i]:
        break



###
### Make requests of the api for the 50 most popular videos and their related videos.
###

# Get the video ids, titles, and channel ids of the 50 most popular youtube videos.
request = youtube.videos().list(part='snippet', chart="mostPopular", maxResults="1", regionCode="US")
snippet = request.execute()

# Get the view, like, comment, and other information from the 50 most popular youtube videos.
request = youtube.videos().list(part='statistics', chart="mostPopular", maxResults="1", regionCode="US")
statistics = request.execute()

# Get that same data but now from the related videos of the 50 most popular videos.
for video in range(len(popids)):

    # Get the video ids, titles, and channel ids of related videos.
    request = youtube.search().list(part='snippet', relatedToVideoId=popids[video], type='video', maxResults='2')
    relsnippet.append(request.execute())

    # Get the view, like, comment, and other information of related videos.
    request = youtube.search().list(part='statistics', relatedToVideoId=popids[video], type='video', maxResults='2')
    relstats.append(request.execute())



###
### Grab the videoIds of the 50 most popular YouTube videos and the videoIds of 15 related videos for each.
###

# Store these popular ids into popids.
for item in snippet['items']:
    popids.append(item['id'])

# Open a csv file to write the data to.
with open(name, mode='w') as youtubeDATA:
    youtube_writer = csv.writer(youtubeDATA, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # Loop to append popular videoIds and their related videoIds to a csv.
    for video in range(len(popids)):

        data=[]
        related=[]

        # Get the snippet of a videos related videos.
        relids = relsnippet[video]

        # Append videoId's to the related array.
        for item in relids['items']:
            related.append(item['id']['videoId'])

        # Append popular videoID to the data array.
        data.append(popids[video])

        # Append related videos to the data array, after the popular videoID.
        for i in range(len(related)):
            data.append(related[i])

        # Store the data array as a line in a csv file.
        youtube_writer.writerow(data)


    '''
    ###
    ### Grab the channels for these videos.
    ###

    # Store these ids into popids.
    for item in snippet['items']:
        popchannels.append(item['snippet']['channelId'])

    # Loop to append chanelIds to a csv.
    for video in range(len(popchannels)):

        data=[]
        related=[]

        # Request the related videos of the relatedToVideoID video and run that request.
        request = youtube.search().list(part='snippet', relatedToVideoId=popids[video], type='video', maxResults='2')
        result = request.execute()

        # Append videoId's to the related array.
        for item in result['items']:
            related.append(item['snippet']['channelId'])

        # Append popular videoID to the data array.
        data.append(popchannels[video])

        # Append related videos to the data array, after the popular videoID.
        for i in range(len(related)):
            data.append(related[i])

        # Store the data array as a line in a csv file.
        youtube_writer.writerow(data)



    ###
    ### Grab the channels for the ratings for these videos.
    ###

    # Store these ids into popids.
    for item in statistics['items']:
        popviews.append(item['statistics']['viewCount'])

    # Loop to append popular videoIds and their related videoIds to a csv.
    for video in range(len(popviews)):

        data=[]
        related=[]

        # Request the related videos of the relatedToVideoID video and run that request.
        request = youtube.search().list(part='statistics', relatedToVideoId=popids[video], type='video', maxResults='2')
        result = request.execute()

        # Append videoId's to the related array.
        for item in result['items']:
            related.append(item['statistics']['viewCount'])

        # Append popular videoID to the data array.
        data.append(popviews[video])

        # Append related videos to the data array, after the popular videoID.
        for i in range(len(related)):
            data.append(related[i])

        # Store the data array as a line in a csv file.
        youtube_writer.writerow(data)
        '''