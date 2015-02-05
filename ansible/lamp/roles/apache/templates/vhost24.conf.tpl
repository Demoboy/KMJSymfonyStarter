{% import "base.tpl" as tools with context %}

<VirtualHost *:80>
    {{ tools.defaultConfig(doc_root, servername) }}
    {{ tools.phpmyadmin() }}
</VirtualHost>
        
<VirtualHost *:443>
    {{ tools.defaultConfig(doc_root, servername) }}
    {{ tools.phpmyadmin() }}
    {{ tools.ssl(servername) }}
</VirtualHost>
        
        

