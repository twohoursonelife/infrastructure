import sqlite3
import os
import requests
import pandas as pd
from dotenv import load_dotenv

load_dotenv()


OC_API_ENDPOINT = "https://api.opencollective.com/graphql/v2"
OC_API_KEY = os.getenv("OC_API_KEY")
OC_ACCOUNT_SLUG = "twohoursonelife"
WEBHOOK_URL = os.getenv("WEBHOOK_URL")
SQLITE3_PATH = "financials.db"


SQL_CONNECTION = sqlite3.connect(SQLITE3_PATH)


def sql_query(query: str, connection: sqlite3.Connection) -> list:
    cursor = connection.cursor()
    cursor.execute(query)
    connection.commit()
    return cursor.fetchall()


def get_open_collective_transactions() -> pd.DataFrame:
    QUERY = """
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

    payload = {"query": QUERY, "variables": {"account": OC_ACCOUNT_SLUG}}
    headers = {"Content-Type": "application/json", "Api-key": OC_API_KEY}

    response = requests.post(OC_API_ENDPOINT, json=payload, headers=headers)
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

    return contributions


def sql_save_transactions(transactions: pd.DataFrame, connection: sqlite3.Connection):
    # Bless, it only appends new transactions, does it?
    return transactions.to_sql(
        "transactions",
        connection,
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


def setup_transaction_table(connection: sqlite3.Connection) -> None:
    TRANSACTIONS_TABLE = """
    CREATE TABLE IF NOT EXISTS transactions (
        id TEXT PRIMARY KEY,
        created_at TEXT,
        from_account TEXT,
        amount REAL);
    """

    sql_query(
        TRANSACTIONS_TABLE,
        connection,
    )


def drop_transaction_table(connection: sqlite3.Connection) -> None:
    sql_query(
        "DROP TABLE transactions",
        connection,
    )


def delete_all_transactions(connection: sqlite3.Connection) -> None:
    sql_query(
        "DELETE FROM transactions",
        connection,
    )


if __name__ == "__main__":
    setup_transaction_table(SQL_CONNECTION)

    sql_save_transactions(
        get_open_collective_transactions(),
        SQL_CONNECTION,
    )

    # Get last set of transactions? from sqlite db

    # Diff between two dates

    print(pd.read_sql("SELECT * FROM transactions", SQL_CONNECTION))

    drop_transaction_table(SQL_CONNECTION)
