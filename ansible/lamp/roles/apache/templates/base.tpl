{% macro defaultConfig(doc_root, servername) %}
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
{% endmacro %}

{% macro phpmyadmin() %}
    Alias /phpmyadmin/ "/usr/share/phpmyadmin/"

    <Directory "/usr/share/phpmyadmin/">
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>    
{% endmacro %}

{% macro ssl(servername) %}
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
{% endmacro %}