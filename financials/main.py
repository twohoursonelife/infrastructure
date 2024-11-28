import sqlite3
import os
import requests
import pandas as pd
from dotenv import load_dotenv

load_dotenv()


API_ENDPOINT = "https://api.opencollective.com/graphql/v2"
OC_API_KEY = os.getenv("OC_API_KEY")
WEBHOOK_URL = os.getenv("WEBHOOK_URL")
SQLITE3_PATH = "financials.db"


def sql_connect(path: str) -> sqlite3.Connection:
    return sqlite3.connect(path)


def sql_query(connection: sqlite3.Connection, query: str) -> list:
    cursor = connection.cursor()
    cursor.execute(query)
    connection.commit()
    return cursor.fetchall()


CREATE_TRANSACTIONS_TABLE = """
CREATE TABLE IF NOT EXISTS transactions (
    id TEXT PRIMARY KEY,
    created_at TEXT,
    from_account TEXT,
    amount REAL);
"""


# Why is it not creating the table?
sql_query(
    sql_connect(SQLITE3_PATH),
    CREATE_TRANSACTIONS_TABLE,
)

# CREATE_TRANSACTIONS = """
# INSERT INTO
#     transactions (id, created_at, from_account, amount)
# VALUES
#     ('0a794cae-8161-4423-a5dc1-dd', '2024-11-27T00:5404411', 'Hopelynn', 20.0);
# """

# sql_query(
#     sql_connect(SQLITE3_PATH),
#     CREATE_TRANSACTIONS,
# )

SELECT_TRANSACTIONS = """
SELECT * FROM transactions;
"""

print(
    sql_query(
        sql_connect(SQLITE3_PATH),
        SELECT_TRANSACTIONS,
    )
)


# Drop
DROP = """
DROP TABLE transactions;
"""

sql_query(
    sql_connect(SQLITE3_PATH),
    DROP,
)

exit()

# Get OC API, list transactions? contributions? idk yet
query = """
query account($account: String) {
    account(slug: $account) {
        name
        slug
        transactions(limit: 100, type: CREDIT) {
            totalCount
            nodes {
                id
                fromAccount {
                    name
                }
                amount {
                    value
                }
                createdAt
            }
        }
    }
}
"""

payload = {"query": query, "variables": {"account": "twohoursonelife"}}
headers = {"Content-Type": "application/json", "Api-key": OC_API_KEY}
response = requests.post(API_ENDPOINT, json=payload, headers=headers)
response.raise_for_status()

contributions = pd.json_normalize(
    response.json()["data"]["account"]["transactions"]["nodes"]
)

contributions.rename(
    columns={
        "createdAt": "created_at",
        "fromAccount.name": "from_account",
        "amount.value": "amount",
    },
    inplace=True,
)

print(contributions)


# Get last set of transactions? from sqlite db

# Diff between two dates

# Save latest transactions? to sqlite db
# Bless, it only appends new transactions
contributions.to_sql(
    "transactions",
    sql_connect(SQLITE3_PATH),
    if_exists="append",
    index=False,
    method="multi",
)

# Format transactions? to json

# Call webhook with transactions?
embed = {
    "title": "@person donated $$$",
    "color": 16759605,
    "timestamp": "2018-08-17T07:00:00",
}
json = {
    "username": "Open Collective",
    "avatar_url": "https://cdn.discordapp.com/avatars/948569181513724024/dab2d4c4ae7f5b2253a97dde3ef09a67.webp?size=80",
    "content": "[New contribution](https://linky.link) to 2HOL on [Open Collective](https://opencollective.com/twohoursonelife)!",
    "embeds": [embed],
}
# webhook_response = requests.post(WEBHOOK_URL, json=json)
# webhook_response.raise_for_status()
