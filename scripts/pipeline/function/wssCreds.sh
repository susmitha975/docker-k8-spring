echo "Adding Userkey"
sed -i '26  a   userKey='"$WSS_USER_KEY"'' wss-unified-agent.config
echo "Adding Apikey"
sed -i '27  a   apiKey='"$WSS_API_KEY"'' wss-unified-agent.config