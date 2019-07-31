export TELEGRAM_API_KEY="XXXXXX:XXXXXXXXXXXXXXXXXXXXXXXX"
alias get_telegram_chat_info="curl https://api.telegram.org/bot$TELEGRAM_API_KEY/getUpdates"

function push_to_telegram () {
  curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": "***********", "text": "Hello world" }' \
      https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage
}
