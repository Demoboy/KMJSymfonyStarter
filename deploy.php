<?php
require "recipe/symfony3.php";

set('keep_releases', 2);
set('shared_files', []);
set("repository", "REPO_URL");

server("production", "PRODUCTION_SERVER_HOSTNAME")
    ->user("ubuntu")
    ->pemFile("PATH TO PEM FILE")
    ->stage("production")
    ->env("branch", "master")
    ->env("deploy_path", "DEPLOY_PATH");

task("copy_params", function () {
    upload(".deploy/parameters.{{env}}.yml", "{{release_path}}/app/config/parameters.yml");
    upload(".deploy/htaccess_{{env}}", "{{release_path}}/web/.htaccess");
});

after("deploy:update_code", "copy_params");

task("load:fixtures", function () {
    run('php {{release_path}}/' . trim(get('bin_dir'), '/') . '/console h4cc_alice_fixtures:load:sets --env -d --no-interaction');
});

task("clear:caches", function () {
    run('php {{release_path}}/' . trim(get('bin_dir'), '/') . '/console cache:clear --no-interaction');
    run('sudo service php7.0-fpm restart');
});

before("cleanup", "clear:caches");
