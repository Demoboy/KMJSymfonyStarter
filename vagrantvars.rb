module VagrantVars
    SERVER_NAME = "KMJ Standard Project" #name of the project
    HOST_NAME = "kmj" #domain that will be used for accessing the machine (the enviroment will be appened to the end of domain and does not need to be a FCDN)
    DEV_IP_ADDRESS = "192.168.33.99" #IP address for the dev server. It is important that this does not conflict with the IP address range of your local network
    TEST_IP_ADDRESS = "192.168.34.99" #IP address for the test server
    PROD_IP_ADDRESS = "192.168.35.99" #IP address for the prod server

    # Ansible vars below
    DATABASE_USER = "root" #user to use the database as
    DATABASE_PASSWORD = "password" #password for the database user
    DATABASE_NAME = "kmj" #database name
end
