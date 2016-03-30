{% import "base.tpl" as tools with context %}

<VirtualHost *:80>
    {{ tools.defaultConfig(doc_root, servername) }}
    {% if enviroment == "dev" or enviroment == "test" %}
    {{ tools.phpmyadmin() }}
    {% endif %}
    
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php7.0-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
        
<VirtualHost *:443>
    {{ tools.defaultConfig(doc_root, servername) }}
    {% if enviroment == "dev" or enviroment == "test" %}
    {{ tools.phpmyadmin() }}
    {{ tools.ssl(servername) }}
    {% endif %}
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php7.0-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
    