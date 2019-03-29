# Zachary Edwards Downs
from apiclient.discovery import build
from google_auth_oauthlib.flow import IAF

CLIENT_SECRET_FILE = 'client_secret.json'
SCOPES = ['https://www.googleapis.com/auth/youtube']
flow = IAF.from_client_secrets_file(CLIENT_SECRET_FILE, SCOPES)
credentials = flow.run_console()

apiKey = 'AIzaSyBDfBHkXmijo0Ji4Lv2pae95dJ1dyxwTo0'
youtube = build('youtube', 'v3', developerKey=apiKey, credentials=credentials)
 
request = youtube.search().list(part='snippet', relatedToVideoId='niz3Shv6QWY', type='video')

result = request.execute()
#print(result)
#for item in result['items']:
#    print(item['snippet']['title'])
