cat config.json | jq '.inbounds[0].settings.clients += [{"id":"12312","flow":"ddd",level:0,"email":"ccc"}]' >> test.json


jq '.inbounds[0].streamSettings.xtlsSettings.certificates[0].certificateFile="dfasdfasdf"' config.json > test.json

