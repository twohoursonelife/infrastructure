import os
import requests
import pandas as pd
from dotenv import load_dotenv

load_dotenv()


API_ENDPOINT = "https://api.opencollective.com/graphql/v2"
OC_API_KEY = os.getenv("OC_API_KEY")
WEBHOOK_URL = os.getenv("WEBHOOK_URL")


# Get OC API, list transactions? contributions? idk yet
query = """
query account($account: String) {
    account(slug: $account) {
        name
        slug
        transactions(limit: 100, type: CREDIT) {
            totalCount
            nodes {
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

print(contributions)


# Get last set of transactions? from sqlite db

# Diff between two dates

# Save latest transactions? to sqlite db

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
webhook_response = requests.post(WEBHOOK_URL, json=json)
webhook_response.raise_for_status()
