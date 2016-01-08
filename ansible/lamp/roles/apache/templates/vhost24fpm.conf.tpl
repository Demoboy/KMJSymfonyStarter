{% import "base.tpl" as tools with context %}

<VirtualHost *:80>
    {{ tools.defaultConfig(doc_root, servername) }}
    {% if enviroment == "dev" or enviroment == "test" %}
    {{ tools.phpmyadmin() }}
    {% endif %}
    
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000{{ doc_root }}/$1

</VirtualHost>
        
<VirtualHost *:443>
    {{ tools.defaultConfig(doc_root, servername) }}
    {% if enviroment == "dev" or enviroment == "test" %}
    {{ tools.phpmyadmin() }}
    {% endif %}
    {{ tools.ssl(servername) }}
    
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000{{ doc_root }}/$1

</VirtualHost>
    