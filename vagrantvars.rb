module VagrantVars
    SERVER_NAME = "KMJ Standard Project" #name of the project
    DEV_HOST_NAME = "kmj.dev" #domain that will be used for accessing the machine
    IP_ADDRESS = "192.168.33.231" #IP address for the dev server. It is important that this does not conflict with the IP address range of your local network

    # Ansible vars below
    DATABASE_USER = "root" #user to use the database as
    DATABASE_PASSWORD = "password" #password for the database user
    DATABASE_NAME = "kmj" #database name
    
    AWS_ACCESS_KEY_ID = ""
    AWS_ACCESS_KEY_SECRET = ""
    AWS_REGION = "us-west-2"
    AWS_INSTANCE_TYPE = "t2.micro"
    AWS_KEYPAIR_NAME = "vagrant"
    AWS_SUBNET_ID = ""
    AWS_TAGS = {
      'company' => '',
      "development" => "true",
    }
end
