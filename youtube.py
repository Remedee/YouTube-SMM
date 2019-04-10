# Zachary Edwards Downs

# Necessary imports.
from apiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow

# Get credentials from client secret.
CLIENT_SECRET_FILE = 'client_secret.json'
SCOPES = ['https://www.googleapis.com/auth/youtube']
flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRET_FILE, SCOPES)
credentials = flow.run_console()

# Build the api.
apiKey = 'AIzaSyBDfBHkXmijo0Ji4Lv2pae95dJ1dyxwTo0'
youtube = build('youtube', 'v3', developerKey=apiKey, credentials=credentials)

# Grabs 5 videos from YouTube's most popular in the US.
request = youtube.videos().list(part='snippet', chart="mostPopular", maxResults="5", regionCode="US")
result = request.execute()

# Request the related videos of the relatedToVideoID video and run that request.
request = youtube.search().list(part='snippet', relatedToVideoId='niz3Shv6QWY', type='video')
result = request.execute()

# Print out the titles of related videos.
for item in result['items']:
    print(item['snippet']['title'])
