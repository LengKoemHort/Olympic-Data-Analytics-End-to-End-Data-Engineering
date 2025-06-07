import requests
import pandas as pd
import pyodbc
import datetime

# Define the API endpoint
url = "https://apis.codante.io/olympic-games/disciplines"

# Fetch data from the API
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    data = response.json().get('data', [])
    
    # Prepare data for DataFrame
    full_responses_events = []
    for discipline in data:
        full_responses_events.append({
            'id': discipline['id'],
            'name': discipline['name'],
            'pictogram_url': discipline['pictogram_url'],
            'pictogram_url_dark': discipline.get('pictogram_url_dark', None),
            'DataCollectionDate': datetime.datetime.now()  # Add current date
        })

    # Convert collected data to DataFrame
    df_events = pd.DataFrame(full_responses_events)

    # File paths for CSV export
    live_file_path = "C:\\Users\\lengk\\Documents\\DWH_Final_PJ\\Olympics_Live\\Disciplines_Live.csv"
    historical_file_path = "C:\\Users\\lengk\\Documents\\DWH_Final_PJ\\Olympics_History\\Disciplines_History.csv"

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

        # Insert data into [dbo].[Disciplines]
        for index, row in df_events.iterrows():
            cursor.execute("""
                INSERT INTO [dbo].[Disciplines] (id, name, pictogram_url, pictogram_url_dark, DataCollectionDate) 
                VALUES (?, ?, ?, ?, ?)
            """, row['id'], row['name'], row['pictogram_url'], row['pictogram_url_dark'], row['DataCollectionDate'])
        
        # Insert data into [dbo].[DisciplinesHistory]
        for index, row in df_events.iterrows():
            cursor.execute("""
                INSERT INTO [dbo].[DisciplinesHistory] (id, name, pictogram_url, pictogram_url_dark, DataCollectionDate) 
                VALUES (?, ?, ?, ?, ?)
            """, row['id'], row['name'], row['pictogram_url'], row['pictogram_url_dark'], row['DataCollectionDate'])
        
        # Commit the transaction
        conn.commit()
        cursor.close()
        conn.close()

        print("Data loaded into SQL Server successfully.")

    except Exception as e:
        print("Error connecting to SQL Server:", e)

else:
    print(f"Error fetching disciplines: {response.status_code}")