import os
import requests
import pandas as pd


API_ENDPOINT = "https://api.opencollective.com/graphql/v2"
OC_API_KEY = os.getenv("OC_API_KEY")
WEBHOOK_URL = os.getenv("WEBHOOK_URL")


# Get OC API, list transactions? contributions? idk yet
query = """
query account($account: String) {
    account(slug: $account) {
        name
        slug
        transactions(limit: 10, type: CREDIT) {
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
# response = requests.post(API_ENDPOINT, json=payload, headers=headers)
# response.raise_for_status()

# contributions = pd.json_normalize(
#     response.json()["data"]["account"]["transactions"]["nodes"]
# )

# print(contributions)


# Get last set of transactions? from sqlite db

# Diff between two dates

# Save latest transactions? to sqlite db

# Format transactions? to json

# Call webhook with transactions?
embed = {"title": "I am a title", "description": "I am a description"}
json = {"content": "this is pretty cool", "embeds": [embed]}
webhook_response = requests.post(WEBHOOK_URL, json=json)
webhook_response.raise_for_status()
