import requests
import pandas as pd
import pyodbc
from datetime import datetime, timezone  # Import timezone directly

# Get Current Date (UTC)
collection_date_time = datetime.now(timezone.utc).isoformat()

# Establish Variables
current_page_events = 1
date_time_search_events = "2024-08-10"
full_responses_events = []

# Define the API endpoint
base_url = "https://apis.codante.io/olympic-games/events"
headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
}

# Initial API Call to get the total number of pages
uri = f"{base_url}?date={date_time_search_events}&page={current_page_events}"
response = requests.get(uri, headers=headers)

# Check if the response is successful
if response.status_code != 200:
    print(f"Error retrieving data: {response.status_code}")
    exit()

data = response.json()
last_page_events = data['meta']['last_page']

# Process data and paginate through the results
while current_page_events <= last_page_events:
    uri = f"{base_url}?date={date_time_search_events}&page={current_page_events}"
    response = requests.get(uri, headers=headers)

    if response.status_code != 200:
        print(f"Error retrieving data on page {current_page_events}: {response.status_code}")
        break

    data = response.json()
    
    # Append relevant data to the list
    for event in data['data']:
        full_responses_events.append({
            'id': event['id'],
            'day': event['day'],
            'discipline_name': event['discipline_name'],
            'discipline_pictogram': event['discipline_pictogram'],
            'name': event.get('name'),
            'venue_name': event['venue_name'],
            'event_name': event['event_name'],
            'detailed_event_name': event['detailed_event_name'],
            'start_date': event['start_date'],
            'end_date': event['end_date'],
            'status': event['status'],
            'is_medal_event': event['is_medal_event'],
            'is_live': event['is_live'],
            'gender_code': event['gender_code'],
            'competitors': event['competitors'],  # Keep it as is for now
        })

    # Increment Page Counter
    current_page_events += 1

# Convert collected data to DataFrame
df_events = pd.DataFrame(full_responses_events)

# File paths
live_file_path = "C:\\Users\\lengk\\Documents\\DWH_Final_PJ\\Olympics_Live\\Events_Live.csv"
historical_file_path = "C:\\Users\\lengk\\Documents\\DWH_Final_PJ\\Olympics_History\\Events_History.csv"

# Export to CSV
df_events.to_csv(live_file_path, index=False, sep='|', encoding='utf-8')
df_events.to_csv(historical_file_path, index=False, sep='|', encoding='utf-8', mode='a', header=False)

print("Data exported successfully.")

# SQL Server connection parameters
conn_string = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=BLACKAPPLE\\STARLOGS;"
    "Database=Olympics;"
    "UID=sa;"
    "PWD=Mystarlogs$168;"
)

# Connect to SQL Server
try:
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()

    # Insert data into [dbo].[Events]
    for index, row in df_events.iterrows():
        cursor.execute("""
            INSERT INTO [dbo].[Events] (id, day, discipline_name, discipline_pictogram, name, venue_name, event_name, detailed_event_name, start_date, end_date, status, is_medal_event, is_live, gender_code) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['id'], row['day'], row['discipline_name'], row['discipline_pictogram'], row['name'], 
        row['venue_name'], row['event_name'], row['detailed_event_name'], row['start_date'], 
        row['end_date'], row['status'], row['is_medal_event'], row['is_live'], row['gender_code'])
    
    # Insert data into [dbo].[EventsHistory]
    for index, row in df_events.iterrows():
        cursor.execute("""
            INSERT INTO [dbo].[EventsHistory] (id, day, discipline_name, discipline_pictogram, name, venue_name, event_name, detailed_event_name, start_date, end_date, status, is_medal_event, is_live, gender_code) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['id'], row['day'], row['discipline_name'], row['discipline_pictogram'], row['name'], 
        row['venue_name'], row['event_name'], row['detailed_event_name'], row['start_date'], 
        row['end_date'], row['status'], row['is_medal_event'], row['is_live'], row['gender_code'])
    
    # Commit the transaction
    conn.commit()
    cursor.close()
    conn.close()

    print("Data loaded into SQL Server successfully.")

except Exception as e:
    print("Error connecting to SQL Server:", e)