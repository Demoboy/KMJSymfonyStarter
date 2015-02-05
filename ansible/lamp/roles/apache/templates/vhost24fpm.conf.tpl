{% import "base.tpl" as tools with context %}

<VirtualHost *:80>
    {{ tools.defaultConfig(doc_root, servername) }}
    {{ tools.phpmyadmin() }}
    
    <FilesMatch \.php$>
        SetHandler proxy:fcgi://127.0.0.1:9000
    </FilesMatch>
</VirtualHost>
        
<VirtualHost *:443>
    {{ tools.defaultConfig(doc_root, servername) }}
    {{ tools.phpmyadmin() }}
    {{ tools.ssl(servername) }}
    
    <FilesMatch \.php$>
        SetHandler proxy:fcgi://127.0.0.1:9000
    </FilesMatch>
</VirtualHost>
    