# Invoice management example in Xiana + PostgREST

## Setup

Create database invoice_management.

`docker build -t xiana_showcase -f docker/db.dockerfile .`

`docker run --name xiana_showcase -e POSTGRES_PASSWORD=curve25519 -p 5433:5432 -d xiana_showcase`

`docker start xiana_showcase`

<!-- Create user invoicer with password invoicer. -->
<!-- Grant access to invoicer to invoice_management -->

<!-- Run file db.sql in order to set up the database. -->

## Running

You will need to run PostgREST in one terminal, Xiana in a second terminal and nginx in another terminal.

## Running Xiana app

### Install leiningen

Download the lein script (or on Windows lein.bat if you don't use WSL)
Place it on your $PATH where your shell can find it (eg. /usr/local/bin/)
Set it to be executable (sudo chmod a+x /usr/local/bin/lein)
Run it (lein) and it will download the self-install package

https://leiningen.org/

`brew install leiningen`

### Run Xiana

go to invoices folder

`cd invoices`

and
 
`lein run`

It will download the dependencies of the project the first time. Then
start the project, the server. It adds migrations table and sessions
table.

## Running PostgREST

### Generate secret key

The secret key need to be at leat 32 characters long.

```
echo "jwt-secret = \"$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c32)\"" >> postgrest.conf
```

`postgrest postgrest.conf`

## Running nginx

### Install Ngninx

For Debian-based Linux

```
sudo apt install nginx-core
```

For Mac OS

```
brew install nginx
```

Is a web server that can also be used as a reverse proxy.

Run nginx:

sudo nginx -c /path-to-your-repo/postgrest-xiana-showcase/nginx.conf

`sudo nginx -c nginx.conf`

Check nginx is running:

`sudo systemctl status nginx`

To reload some configuration from the nginx.conf file  You can run:

```
sudo pkill nginx
sudo nginx -c /Users/jacobocordova/Documents/GitHub/postgrest-xiana-showcase/nginx.conf
```

To check if there is something already running on some port:

```
sudo netstat -nlp | grep :80
```

## JWT tokens and usage

We will be using a Ruby script to generate a JWT token.

### Installing Ruby

```
sudo apt-get install ruby-full
```

Install `jwt` gem

```
sudo gem install jwt
```

Generate JWT token

```
ruby gen-jwt.rb <user> <role>
```

For example:

```
ruby gen-jwt.rb user1 web_user
```

During development, you can verify your JWT Token here: https://jwt.io/

## Calling PostgREST

Depends on httpie cli https://httpie.io/cli

Run the sample request in `rest.http`

