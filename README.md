# [Flora](https://github.com/kleookku/Flora)

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Questions](#Questions)


## Overview

### Description

This app helps users find plants that are suitable for them based on three growth requirements--soil moisture level, minimum temperature, and sunlight/shade tolerance--and organize these plants into gardens or boards for their own use.

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** This app would be developed for mobile because it is meant to allow the user to quickly find suitable plants in a fun way (swiping feature).
- **Story:** Allows users to save and organize information about which plants are are most suitable for them. 
- **Market:** People of any age or group looking to figure out what plants are best for them.
- **Habit:** This app will be used as often as the user wants. 
- **Scope:** The app will allow the user to look at and save as many plants as they want.

## Product Spec

### 1. Users Stories
**Required Stories**
- [x] Users can login/create an account or logout. 
- [x] Users can search for plants based on three growth requirements.
- [x] **Results will be fetched from the USDA Plants database through a poorly documented API** 
    - This is a difficult/ambiguous problem because the API is very clunky and complicated, so we expect some extra challenges in using it for the app's needs
- [x] **Results can be liked or disliked in a stacked view.** 
    - This is a difficult/ambiguous problem because we have no learned how to do swipe gesture recognize or make an item on the screen look like it is moving off the screen. I also would like to have the next plant in the stack prefetched so that the user can swipe through quickly.
- [x] Liked plants and each plant's relevant information (image, moisture, sunlight, temperature) will be saved to a database.
- [x] Plants can be viewed in a detail view.
- [x] Plants can be added to a board/"garden". 
- [x] Users can navigate between the search view and plants view using a navigation bar. 
- [x] Users can view and scroll through their likes in the plants view. 
- [x] Users can view and scroll through their boards/"gardens" in the plants view. 
- [x] Users can create new boards or rename current boards. 
- [x] Users are warned when they attempt to add a plant to a board that already contains it.
- [x] Users can change their username or password and set a profile picture.


**Optional Stories**
- [ ] **Plant results will show new results every time (i.e. plants that users have seen already will not appear)**
    - This is a difficult/ambiguous problem because I will have to figure out how to cache certain results and store "seen" results. I also have to figure out how to get new results from later pages of the USDA database in case the user goes through all the plants on the first page.
- [ ]  **Plants will be extracted from the USDA Plants database and stored in Parse, then queried for a faster search.**
    - [ ] This is a difficult/ambiguous problem because we have not learned how to extract data from an existing database for our own use. I don't really know how to go about this, but my manager says that it is doable.
- [ ] Users can replace plant images with their own image.
- [x] Users can delete plants from their boards.
- [ ] Users can delete boards.
- [x] Plant descriptions are in user friendly terms (i.e. instead of 30% soil moisture it will say "water 2 times a day")
- [x] Users cannot signup with a username that is already in use.
- [ ] Users can add multiple plants to boards at once.


**Stretch Stories**
- [ ] Users can buy plants within the app.
- [ ] Users can take a picture of a plant and the app will help determine what plant it is. 

### 2. Screen Archetypes
- Login Screen
- Signup Screen
    - Displays 4 text inputs where user can enter their username, email, password, and confirm password.
- Profile Screen
    - Displays user profile image, username, email, and allows user to change each of these attributes.
- Search Screen
    - Displays three sliders that describe different levels for each attribute: moisture, sunlight, and temperature
- Results Screen
    - Displays each plant's image and name in a stacked view. 
    - Users can swipe right or left on each plant to like or dislike the plant.
- Details Screen
    - Displays plant image and details information on the plant's required moisture, sunlight, and temperature. 
    - Presents a button that allows users to add the plant to one of their boards/gardens. 
- Select Screen
    - Displays the user's boards, with the most recent plant as the picture and the name of the board underneath. 
    - Presents a button that allows the user to create a new board. 
- Plants Screen
    - Displays a user's liked plants and a user's boards/gardens.
    - Presents a button in the boards section that allows the user to create a new board.
- Board Screen
    - Displays a user's board, with an image and the name of each plant that is part of the board. 
    - Allows the user to edit the name of the board.
- Delete Screen
    - Displays a list of plants or list of boards than users can select. 
    - Presents a remove button that allows the user to delete their selections.

### 3. Navigation

**Tab Navigation** (Tab to Screen)
- Search Screen
- Plants Screen


**Flow Navigation** (Screen to Screen)
- Log in/Register
    - Signup Screen
- Search Screen
    - Results Screen
        - Details Screen
            - Select Screen
- Plants Screen
    - Board Screen
        - Delete Screen

## Wireframes

![](https://i.imgur.com/tT1QaWx.jpg)

## Schema

### Models

#### --- Plant

|Property | Type | Description |
| --- | -------- | ---------- | 
| plantName | String | name of the plant (read from "commonName" in USDA plant profile GET request) | 
|image | PFFile | image of the plant read from USDA image library GET request | 
| moistureUse | String | describes soil moisture (i.e. low, medium, or high) | 
|shadeLevel | String | describes shade tolerance (i.e. shady, sunny, slightly shady) | 
| minTemp | String | describes minimum temperature range in fahrenheit (i.e. -42 to -38)

#### --- Board

|Property | Type | Description |
| --- | -------- | ---------- | 
| boardName | String | name of the board | 
| plantsArray | Array | array of plant objects

#### --- User

|Property | Type | Description |
| --- | -------- | ---------- | 
| username | String | user's username |
| email | String | user's email (will be used if they forgot their password) |
| password | String | user's password | 
| profilePic | PFFile | user's profile picture | 
| boards | Array | array of board objects that the user has |
| likes | Array | array of all the plants the user liked | 
| seen | Array | array of the IDs of plants the user has already seen| 


### Networking

#### --- List of Network Requests by Screen
- Login Screen
    - (Update/Put) Login user: `logInWithUsernameInBackground`
- Signup Screen
    - (Create/POST) Create a user: `signupInBackgroundWithBlock`
- Search Screen
    - (Create/POST) Create a characteristics search: `/api/CharacteristicsSearch`
- Results Screen
    - (Read/GET) Read plant profile: `/api/PlantProfile?symbol=:symbol`
    - (Read/GET) Read plant image: `/ImageLibrary/standard/:filename`
    - (Create/POST) Create a new plant object
    - (Update/PUT) Add a plant to the user's likes
    - (Update/PUT) Add a plant ID to the user's seen plants
- Details Screen
    - (Read/GET) Read plant characteristics: `/api/PlantCharacteristics/:id`
- Select Screen
    - (Update/PUT) Add plant to a board
    - (Create/POST) Create a new board
- Plants Screen
    - (Read/GET) Get user's liked plants
    - (Read/GET) Get user's boards
- Board Screen
    - (Read/Get) Get plants in a board
- Remove Screen
    - (Update/PUT) Remove a plant from a board
    - (Update/PUT) Remove a board from a user's list of boards
    - (Update/PUT) Remove a plant from user's likes


#### --- USDA Plant Database API

- Base URL: https://plantsservices.sc.egov.usda.gov

| Endpoint | HTTP Verb | Description | url | 
| --------- | -------- | ----------- |  -- |
| /api/CharacteristicsSearch | `POST` | creates new characteristics search from user entered attributes in JSON Payload Document (body) | [url](https://plantsservices.sc.egov.usda.gov/api/CharacteristicsSearch) |
| /api/PlantProfile?symbol=:symbol | `GET` | gets plant profile by :symbol (from characteristics search results)| [url](https://plantsservices.sc.egov.usda.gov/api/PlantProfile?symbol=ACNED) | 
| /api/PlantCharacteristics/:id | `GET` | gets plant characteristics information by :id (from characteristics) | [url](https://plantsservices.sc.egov.usda.gov/api/PlantCharacteristics/42690) | 
| /ImageLibrary/standard/:filename | `GET` | gets plant image by :filename (from characteristics search results) | [url](https://plants.sc.egov.usda.gov/ImageLibrary/standard/abgr4_001_svp.jpg) |

<!-- Get all unfiltered plants
Get plant details from api and store in database
Use parse query to search
 -->
 
 ## Questions
 
1. In the Project Expectations document, it says:

>  Your app incorporates at least one external library to add visual polish

What kind of external library could I use? What do they mean by visual polish?


 2. It also says

> Your app uses at least one animation (e.g. fade in/out, e.g. animating a view growing and shrinking)

Does my swiping feature fulfill this requirement, since each "card" has to look like it is physically moving off screen? I'm also not sure how to implement this.


