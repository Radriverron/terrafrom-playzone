#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Terraform Team Server</title></head><body><h1>Brilliant! You have a webserver running on &#9729;</h1></body></html>' | sudo tee /usr/share/nginx/html/index.html