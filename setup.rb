#!/usr/bin/ruby

def prompt(*args)
  print(*args);
  response = gets;
  response.strip!;
  return response;
end

if ENV["USER"] != "root"
  puts "This project must be run in sudo. Requesting permission"
  exec("sudo #{ENV['_']} #{ARGV.join(' ')}")
end

puts "\n  Welcome to the KMJ Symfony Starter Project\n
This program will add the current vagrant machines to your host file\n";

installPrompt = "";

if !File.exists?("vagrantvars.rb")
  puts "Cannot load vagrantvars file... exiting";
  exit;
end

while (installPrompt != "y" and installPrompt != "n") do
  installPrompt = prompt("Would you like to install the vagrant machines into the hosts file? (Y/n)");
  installPrompt.downcase!;
end

if installPrompt === "n"
  #exit if the user denied the request
  exit
end

require_relative 'vagrantvars.rb'
include VagrantVars

open('/etc/hosts', 'a') do |f|
  #Add machines to hosts file
  f.puts(DEV_IP_ADDRESS + "\t" + HOST_NAME + ".dev");
  f.puts(TEST_IP_ADDRESS + "\t" + HOST_NAME + ".test");
  f.puts(PROD_IP_ADDRESS + "\t" + HOST_NAME + ".prod");
end

puts "Completed!";
