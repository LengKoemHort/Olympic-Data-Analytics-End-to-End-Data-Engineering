import requests
import pandas as pd
import pyodbc
from datetime import datetime

# Global Parameters
collection_date_time = datetime.utcnow().isoformat()

# Define the API endpoint and headers
url = "https://apis.codante.io/olympic-games/countries"
headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    # 'Authorization': 'Bearer <MyTokenID>'  # Uncomment and add your token if needed
}

# Make the API call and retrieve data from all pages (1 to 5)
responses = []
for i in range(1, 6):
    response = requests.get(f"{url}?page={i}", headers=headers)
    if response.status_code == 200:
        responses.extend(response.json()['data'])
    else:
        print(f"Error fetching page {i}: {response.status_code}")

# Create a DataFrame and select desired columns
data = pd.DataFrame(responses)
data = data[['id', 'name', 'continent', 'flag_url', 
             'gold_medals', 'silver_medals', 'bronze_medals', 
             'total_medals', 'rank', 'rank_total_medals']]
data['DataCollectionDate'] = collection_date_time

# Print the DataFrame
print(data)

# File paths for saving the data
live_file_path = r"C:\Users\lengk\Documents\DWH_Final_PJ\Olympics_Live\Countries_Live.csv"
historical_file_path = r"C:\Users\lengk\Documents\DWH_Final_PJ\Olympics_History\Countries_History.csv"

# Export to CSV
data.to_csv(live_file_path, index=False, sep='|', encoding='utf-8')
data.to_csv(historical_file_path, mode='a', index=False, sep='|', encoding='utf-8')

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
    cursor.execute("SELECT * FROM information_schema.tables WHERE table_name = 'Countries'")
    if not cursor.fetchone():
        print("Table 'Countries' does not exist.")
        conn.close()
        exit()

    cursor.execute("SELECT * FROM information_schema.tables WHERE table_name = 'CountriesHistory'")
    if not cursor.fetchone():
        print("Table 'CountriesHistory' does not exist.")
        conn.close()
        exit()

    # Insert data into Countries table
    for index, row in data.iterrows():
        cursor.execute("""
            INSERT INTO Countries (id, name, continent, flag_url, gold_medals, silver_medals, bronze_medals, total_medals, rank, rank_total_medals, DataCollectionDate) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['id'], row['name'], row['continent'], row['flag_url'], 
        row['gold_medals'], row['silver_medals'], row['bronze_medals'], 
        row['total_medals'], row['rank'], row['rank_total_medals'], 
        row['DataCollectionDate'])

    # Insert data into CountriesHistory table
    for index, row in data.iterrows():
        cursor.execute("""
            INSERT INTO CountriesHistory (id, name, continent, flag_url, gold_medals, silver_medals, bronze_medals, total_medals, rank, rank_total_medals, DataCollectionDate) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, row['id'], row['name'], row['continent'], row['flag_url'], 
        row['gold_medals'], row['silver_medals'], row['bronze_medals'], 
        row['total_medals'], row['rank'], row['rank_total_medals'], 
        row['DataCollectionDate'])

    # Commit the transaction
    conn.commit()
    cursor.close()
    conn.close()

    print("Data loaded into SQL Server successfully.")

except Exception as e:
    print("Error connecting to SQL Server:", e)