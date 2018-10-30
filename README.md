# Jeff's App

## pages for types of users

### non-logged in users
- can visit home page
- can visit about page
- can visit create new account page
- can visit sign in page
- has a contact teacher page?

### logged in non-student page
- can visit home page
- can visit about page
- can visit studio request page

### logged in student page
- has a dashboard
- has a calendar lesson request page
- has a lesson show page
- has a profile settings page
- has a contact teacher page

### logged in admin
- has a dashboard
- has a student roster page
- has a calendar page

## database

### users

- admin vs non-admin
- studio vs non-studio
- first-name:string
- last-name:string
- email:string unique: true
- has many addresses
- has many phone numbers

#### address
- street address
- city
- state
- zip code

#### phone number
- number: bigint
- type: mobile/home
