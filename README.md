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

#Random Thoughts
- babel gem
- autoprefixer

#left to do
- show page should also allow for deletion or adding to studio if applicable
- each link on wait list should allow for deleting and add to studio
- each link on studio should allow for deletion
- style show page
- style index page
- make whole website responsive
- style the buttons on the forms
- allow user to enter multiple phone numbers
- autoprefixer
- test on different browsers

#left to figure out
- lesson functionality
- payment functionality
