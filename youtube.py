# Zachary Edwards Downs

# Necessary imports.
import csv
import os
from apiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow

# List of popular videos ids and data file names.
popids=[]
fnames=[]

# Get credentials from client secret.
CLIENT_SECRET_FILE = 'client_secret.json'
SCOPES = ['https://www.googleapis.com/auth/youtube']
flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRET_FILE, SCOPES)
credentials = flow.run_console()

# Build the api.
apiKey = 'AIzaSyBDfBHkXmijo0Ji4Lv2pae95dJ1dyxwTo0'
youtube = build('youtube', 'v3', developerKey=apiKey, credentials=credentials)

# Get the related video ids of the 5 most popular youtube titles.
request = youtube.videos().list(part='id', chart="mostPopular", maxResults="50", regionCode="US")
result = request.execute()

# Store these ids into popids.
for item in result['items']:
    popids.append(item['id'])

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

# Open a csv file to write the data to.
with open(name, mode='w') as youtubeIDS:
    youtube_writer = csv.writer(youtubeIDS, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # Loop to append popular videoIds and their related videoIds to a csv.
    for video in range(len(popids)):

        data=[]
        related=[]

        # Request the related videos of the relatedToVideoID video and run that request.
        request = youtube.search().list(part='id', relatedToVideoId=popids[video], type='video', maxResults='15')
        result = request.execute()

        # Append videoId's to the related array.
        for item in result['items']:
            related.append(item['id']['videoId'])

        # Append popular videoID to the data array.
        data.append(popids[video])

        # Append related videos to the data array, after the popular videoID.
        for i in range(len(related)):
            data.append(related[i])

        # Store the data array as a line in a csv file.
        youtube_writer.writerow(data)