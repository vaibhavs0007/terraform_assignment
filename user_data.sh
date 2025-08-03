#!/bin/bash
sudo apt update -y
sudo apt install apache2 php libapache2-mod-php -y
sudo systemctl enable apache2
sudo systemctl start apache2
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
