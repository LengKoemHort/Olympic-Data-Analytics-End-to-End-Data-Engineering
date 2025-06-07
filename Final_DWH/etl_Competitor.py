import requests
import pandas as pd
import pyodbc
from datetime import datetime, timezone  # Import timezone

# Current Date
collection_date_time = datetime.now(timezone.utc).isoformat()  # Updated line

# Initialize Variables
current_page = 1
date_to_search = "2024-08-10"
full_responses = []

# Define the API endpoint
base_url = "https://apis.codante.io/olympic-games/events"
headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
}

while True:
    # Construct the API URL
    uri = f"{base_url}?date={date_to_search}&page={current_page}"

    # Make the API call and retrieve the data
    response = requests.get(uri, headers=headers)
    
    # Check for successful response
    if response.status_code != 200:
        print(f"Error retrieving data: {response.status_code}")
        break

    data = response.json()

    # Check if there's data
    if not data['data']:
        break

    # Process the competitors
    for event in data['data']:
        event_id = event['id']
        discipline_name = event['discipline_name']
        
        for competitor in event['competitors']:
            competitor_data = {
                'event_id': event_id,
                'event_discipline_name': discipline_name,
                'country_name': competitor['country_id'],
                'country_flag_url': competitor['country_flag_url'],
                'competitor_name': competitor['competitor_name'],
                'position': competitor['position'],
                'result_position': competitor['result_position'],
                'result_winnerLoserTie': competitor['result_winnerLoserTie'],
                'result_mark': competitor['result_mark'],
                'DataCollectionDate': collection_date_time
            }
            full_responses.append(competitor_data)

    # Increment Page Counter
    current_page += 1

# Create DataFrame
df = pd.DataFrame(full_responses)

# File paths
live_file_path = r"C:\Users\lengk\Documents\DWH_Final_PJ\Olympics_Live\Competitor_Live.csv"
historical_file_path = r"C:\Users\lengk\Documents\DWH_Final_PJ\Olympics_History\Competitor_History.csv"

# Export to CSV
df.to_csv(live_file_path, index=False, sep='|', encoding='utf-8')
df.to_csv(historical_file_path, index=False, sep='|', encoding='utf-8', mode='a', header=False)

print("Data exported successfully.")

# SQL Server connection parameters
conn_string = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=BLACKAPPLE\\STARLOGS;"
    "Database=Olympics;"
    "UID=sa;"
    "PWD=Mystarlogs$168;"
)

# Connect to SQL Server and insert data
try:
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()

    # Check if tables exist
    cursor.execute("SELECT * FROM information_schema.tables WHERE table_name = 'Competitors'")
    if not cursor.fetchone():
        print("Table 'Competitors' does not exist.")
        conn.close()
        exit()

    cursor.execute("SELECT * FROM information_schema.tables WHERE table_name = 'CompetitorsHistory'")
    if not cursor.fetchone():
        print("Table 'CompetitorsHistory' does not exist.")
        conn.close()
        exit()

    # Insert data into Competitors table
    for index, row in df.iterrows():
        cursor.execute("""
            INSERT INTO Competitors (event_id, event_discipline_name, country_name, country_flag_url, competitor_name, position, result_position, result_winnerLoserTie, result_mark, DataCollectionDate) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['event_id'], row['event_discipline_name'], row['country_name'], row['country_flag_url'], 
        row['competitor_name'], row['position'], row['result_position'], row['result_winnerLoserTie'], 
        row['result_mark'], row['DataCollectionDate'])
    
    # Insert data into CompetitorsHistory table
    for index, row in df.iterrows():
        cursor.execute("""
            INSERT INTO CompetitorsHistory (event_id, event_discipline_name, country_name, country_flag_url, competitor_name, position, result_position, result_winnerLoserTie, result_mark, DataCollectionDate) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['event_id'], row['event_discipline_name'], row['country_name'], row['country_flag_url'], 
        row['competitor_name'], row['position'], row['result_position'], row['result_winnerLoserTie'], 
        row['result_mark'], row['DataCollectionDate'])

    # Commit the transaction
    conn.commit()
    cursor.close()
    conn.close()

    print("Data loaded into SQL Server successfully.")

except Exception as e:
    print("Error connecting to SQL Server:", e)