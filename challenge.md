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

To run locally:
* Start memcached
* Start postgres

## Impressions
* Caching is working properly using dalli and memcached
* To test the timeout, just change the method on service file.
* I was using the country and point, then I read the instructions again and realized the correct endpoint is the capital one =)

Frontend
* The fonts you sent me were in the .TTF format, I thought was better to convert to .WOFF for browser compatibility
* The icons had to be centralized

