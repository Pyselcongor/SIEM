#!/bin/bash

ELASTIC_PASSWORD=ChangeMe$

printf "Setting ilm policies.\n"
printf "trimonthly_rollover_yearly_retention:\n"
curl -XPUT -H 'Content-Type: application/json' -u elastic:$ELASTIC_PASSWORD -k https://localhost:9200/_ilm/policy/trimonthly_rollover_yearly_retention -d'
{
  "policy": {
    "_meta": {
      "description": "Index rollover after three months, then auto-delete after 365 days."
    },
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "90d",
            "max_primary_shard_size": "50gb"
          },
          "set_priority": {
            "priority": 100
          }
        },
        "min_age": "0ms"
      },
      "delete": {
        "min_age": "365d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'
printf "\nmonthly_rollover_yearly_retention:\n"
curl -XPUT -H 'Content-Type: application/json' -u elastic:${ELASTIC_PASSWORD} -k https://localhost:9200/_ilm/policy/monthly_rollover_yearly_retention -d'
{
  "policy": {
    "_meta": {
      "description": "Monthly rollover, then auto-delete after 365 days."
    },
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_primary_shard_size": "50gb"
          },
          "set_priority": {
            "priority": 100
          }
        },
        "min_age": "0ms"
      },
      "delete": {
        "min_age": "365d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'
printf "\n"
