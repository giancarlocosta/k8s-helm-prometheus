#!/bin/bash

name=$RANDOM
url='http://localhost:9093/api/v1/alerts'

echo "firing up alert $name"

# change url o
curl -XPOST $url -d "[{
	\"status\": \"firing\",
	\"labels\": {
		\"alertname\": \"$name\",
		\"service\": \"my-service\",
		\"severity\":\"critical\",
		\"instance\": \"$name.example.net\",
    \"set_slack_recipient\": \"yes\",
    \"slack_recipient\": \"@gian.costa\"
	},
	\"annotations\": {
		\"summary\": \"High latency is high!\"
	},
	\"generatorURL\": \"http://prometheus.int.example.net/<generating_expression>\"
}]"

echo ""

echo "press enter to resolve alert"
read

echo "sending resolve"
curl -XPOST $url -d "[{
	\"status\": \"resolved\",
	\"labels\": {
		\"alertname\": \"$name\",
		\"service\": \"my-service\",
		\"severity\":\"critical\",
		\"instance\": \"$name.example.net\",
    \"set_slack_recipient\": \"yes\",
    \"slack_recipient\": \"@gian.costa\"
	},
	\"annotations\": {
		\"summary\": \"High latency is high!\"
	},
	\"generatorURL\": \"http://prometheus.int.example.net/<generating_expression>\"
}]"

echo ""
