# Invoice management example in Xiana + PostgREST

## Setup

Create database invoice_management.
Create user invoicer with password invoicer.
Grant access to invoicer to invoice_management

## Running

You will need to run PostgREST in one terminal, Xiana in a second terminal and nginx.

## Running Xiana app

## Running PostgREST

`postgrest postgrest.conf`

## Running nginx

Run nginx:

`sudo nginx -c nginx.conf`

Check nginx is running:

`sudo systemctl status nginx`