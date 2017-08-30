# Coya full stack challenge

This repository holds the full stack development challenge for applicants of COYA.

## The application

We want to create a simple frontend + backend microservice,
that display data from two external services:

* https://restcountries.eu/
* https://openweathermap.org/api

### User stories

1. As a user, I access to the root path and see:
* The Berlin country name
* The Berlin weather description
* The Berlin temperature
* The Berlin currency

2. As a user, if I add a `rootPAth/:city-name` sub-path:
* The city country name
* The city weather description
* The city temperature
* The city currency

### UX design
You can find the assets under the folder assets and a version of the desktop and mobile versions of the frontend.

**Berlin landscape** is the common background for all the webs not only for the default city.

### Notes:

* We estimate this challenge to be done around 5 hours.
* You don't have any restriction about languages and methodologies.

## The acceptance criteria

* Follow the UX design and the user story.
* Provide instructions under the **Instructions** section.
* Provide some notes about the challenge into **Impressions** section.
* Use git to deliver your challenge `git bundle create $myName-coya-fs-challenge.git master`.

### Extra point (none mandatory)

We use docker (a lot!!) in our company,
but we know that takes time create Dockerfiles and docker-compose.yml files,
so if you have time please add some basic docker way to run your challenge.

## Instructions
Working demo: https://coya-challenge.herokuapp.com/
Repo: https://github.com/danilol/coya_challenge

To run locally without docker:
* Start memcached
* Start postgres
* bundle exec rails server
* bundle exec rspec

## Impressions
* I enjoyed implementing this challenge. I learned a lot, since this was my first project with FE did 100% by me. I'm very proud.
Independent of the result, the balance is already positive.
* If I had more time I would improve the service API response objects instead of using OpenStruct and also not use all the Rails
framework, to make the project smaller, but after I built the services I was worried about the FE.

* There is no database configured
* Caching is working properly using dalli and memcached
* To test the timeout, just change the timeout method in the services file.
* I was using the country endpoint, then I read the instructions again and realized the correct endpoint is the capital endpoint =)
* There were many weather conditions returned by the API missing in the Icons directory provided for this challenge.
I've found the icon set and added to the directory.

Frontend
* The fonts you sent me were in the .TTF format, I thought was better to convert to .WOFF for browser compatibility
* The icons had to be centralized for the correct alignment

Docker
* Although I'm not using the database, I decided to use the postgres service as a challenge (had some problems, but fixed)
* The container is working, you can start and access the app using:
docker-compose up -d
docker-compose build (After build you can access http://localhost:3000)
docker-compose run web rspec

