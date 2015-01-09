# Default Apache virtualhost template

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot {{ doc_root }}
    {% set servernames = servername.split() %}
    {% for servername in servernames %}
    {% if loop.first %}
        ServerName {{ servername }}
    {% else %}
        ServerAlias {{ servername }}
    {% endif %}
    {% endfor %}

    <Directory {{ doc_root }}>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
        
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    DocumentRoot {{ doc_root }}
    {% set servernames = servername.split() %}
    {% for servername in servernames %}
    {% if loop.first %}
        ServerName {{ servername }}
    {% else %}
        ServerAlias {{ servername }}
    {% endif %}
    {% endfor %}
    
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/{{servername}}.crt
    SSLCertificateKeyFile /etc/apache2/ssl/{{servername}}.key
    
    <FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
    </FilesMatch>
    
    <Directory /usr/lib/cgi-bin>
                    SSLOptions +StdEnvVars
    </Directory>
    
    BrowserMatch "MSIE [2-6]" \
                    nokeepalive ssl-unclean-shutdown \
                    downgrade-1.0 force-response-1.0
    BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

    <Directory {{ doc_root }}>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
        
        

