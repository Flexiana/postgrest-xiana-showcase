# Invoice management example in Xiana + PostgREST

## Setup

Create database invoice_management.

`docker build -t xiana_showcase -f docker/db.dockerfile .`

`docker run --name xiana_showcase -e POSTGRES_PASSWORD=curve25519 -p 5433:5432 -d xiana_showcase`

`docker start xiana_showcase`

Create user invoicer with password invoicer.
Grant access to invoicer to invoice_management

Run file db.sql in order to set up the database.

## Running

You will need to run PostgREST in one terminal, Xiana in a second terminal and nginx.

## Running Xiana app

go to invoices folder and

`lein run`

It will download the dependencies of the project the first time. Then start the project, the server. It adds migrations table and sessions table. 

## Running PostgREST

`postgrest postgrest.conf`

## Running nginx

Is the proxy.

Run nginx:

sudo nginx -c /Users/jacobocordova/Documents/GitHub/postgrest-xiana-showcase/nginx.conf

`sudo nginx -c nginx.conf`

Check nginx is running:

`sudo systemctl status nginx`

To reload some configuration from the nginx.conf file  You can run:

```
sudo pkill nginx
sudo nginx -c /Users/jacobocordova/Documents/GitHub/postgrest-xiana-showcase/nginx.conf

```


## JWT tokens and usage


username user1, role user
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.bQvG3aHyPdJrtO2E-seHRrsOcgtxkkKjhdqOSwI7m6U

username user2, role user
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMiIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.aYZbKJ9T6OLVVKlbKBXwf3sR56xlwEfAQIneH9yverI

username admin1, role admin
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbjEiLCJyb2xlIjoiYWRtaW4iLCJpc3MiOiJ4aWFuYS1hcGkiLCJhdWQiOiJhcGktY29uc3VtZXIiLCJleHAiOjE3MTYzMDA5NDB9.RMTG_lgBfvs2D6GszBPZCLAKjmi6joP9-Hjdt3znSYY

username admin2, role admin
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbjIiLCJyb2xlIjoiYWRtaW4iLCJpc3MiOiJ4aWFuYS1hcGkiLCJhdWQiOiJhcGktY29uc3VtZXIiLCJleHAiOjE3MTYzMDA5NDB9.E-tH6XtqzVyfM506Le_vxzQJfAAh5cxT9OKdBv23ufk

## Calling PostgREST

Depends on httpie cli https://httpie.io/cli

Commands

1. Create an Invoice for user1

```sh

http POST http://localhost:3000/invoices \
Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.bQvG3aHyPdJrtO2E-seHRrsOcgtxkkKjhdqOSwI7m6U" \
name="Invoice for user1" date="2023-01-01" amount:=100 currency="USD" bank_details="Bank ABC, Account 123" attached_file="invoice1.pdf" user_id="UUID-OF-USER1" current_status="created"
```

Replace "UUID-OF-USER1" with the actual UUID of user1 from your users table.

2. Create an Invoice for user2

```sh

http POST http://localhost:3000/invoices \
Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMiIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.aYZbKJ9T6OLVVKlbKBXwf3sR56xlwEfAQIneH9yverI" \
name="Invoice for user2" date="2023-01-01" amount:=200 currency="USD" bank_details="Bank XYZ, Account 456" attached_file="invoice2.pdf" user_id="UUID-OF-USER2" current_status="created"
```

Replace "UUID-OF-USER2" with the actual UUID of user2 from your users table.
3. Change Status of an Invoice for user1

Assuming you want to change the status of a specific invoice (replace INVOICE-ID with the actual invoice ID):

```sh

http PATCH http://localhost:3000/invoices/INVOICE-ID \
Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.bQvG3aHyPdJrtO2E-seHRrsOcgtxkkKjhdqOSwI7m6U" \
current_status="cancelled"
```

4. List All Invoices for user1

```sh

http GET http://localhost:3000/invoices \
Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsInJvbGUiOiJ1c2VyIiwiaXNzIjoieGlhbmEtYXBpIiwiYXVkIjoiYXBpLWNvbnN1bWVyIiwiZXhwIjoxNzE2MzAwOTQwfQ.bQvG3aHyPdJrtO2E-seHRrsOcgtxkkKjhdqOSwI7m6U" \
user_id=="UUID-OF-USER1"
```

5. List All Invoices as admin1

```sh

http GET http://localhost:3000/invoices \
Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbjEiLCJyb2xlIjoiYWRtaW4iLCJpc3MiOiJ4aWFuYS1hcGkiLCJhdWQiOiJhcGktY29uc3VtZXIiLCJleHAiOjE3MTYzMDA5NDB9.RMTG_lgBfvs2D6GszBPZCLAKjmi6joP9-Hjdt3znSYY"
```