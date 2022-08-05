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


**Stretch Stories**
- [ ] **Plant results will show new results every time (i.e. plants that users have seen already will not appear)**
    - This is a difficult/ambiguous problem because I will have to figure out how to cache certain results and store "seen" results. I also have to figure out how to get new results from later pages of the USDA database in case the user goes through all the plants on the first page.
- [x]  **Plants will be extracted from the USDA Plants database and stored in Parse, then queried for a faster search.**
    - This is a difficult/ambiguous problem because we have not learned how to extract data from an existing database for our own use. I don't really know how to go about this, but my manager says that it is doable.
- [x] Plant results from parse are shuffled so users get new results every time. 
- [x] Users can delete plants from their boards.
- [x] Users can delete boards.
- [x] Users can delete plants from their likes.
- [x] Users can refresh their boards by scrolling down.
- [x] Plant descriptions are in user friendly terms (i.e. instead of 30% soil moisture it will say "water 2 times a day")
- [x] Users cannot signup with a username that is already in use.
- [x] Users cannot have duplicate plants in their likes.
- [x] Users can add multiple plants to boards at once.
- [x] Users can reset their password through their email if they forget it. 
- [x] Users can view search results "infinitely" (goes through all the pages/results) **(Implemented for API Search, not needed for Parse Search)**
- [x] Users can add a description to their boards. 
- [x] Users can add their own cover photo to a board.
- [x] Users can like a plant by clicking a like button on detail view.
- [x] Users can search for other users and follow/unfollow them.
- [x] Users can view the users that follow them and the users they're following.
- [x] Users can remove followers.
- [x] Users can view other user's boards that are public. 
- [x] Users can set their boards to public or private, allowing or disallowing other users to view them.
- [x] **Users can set a location using the Google Maps Places Autocomplete API.**
- [x] **Users can set the search attributes using weather information about the set location read from OpenWeather API.**
- [x] Users can search through plants by name.
- [x] Users can see a feed of posts from the users they follow. 
- [x] Users can post an image with an associated plant and a caption. 
- [x] Users can search up other users to follow them and view their profile. 
- [x] Each user's profile displays their public boards and their posts. 
- [x] Users can remove followers.
- [x] Users can like and comment on posts. 
- [x] Users can see all the posts associated with a certain plant.
- [x] Users can scroll through the post feed with infinite scrolling.
- [x] Users can view who liked a post.
- [x] Users can like a post by double tapping the post image in their feed.
- [x] Like buttons bounce when tapped.


### 2. Screen Archetypes
- Login Screen
- Signup Screen
    - Displays 4 text inputs where user can enter their username, email, password, and confirm password.
- Profile Screen
    - Displays user profile image, username, email, and allows user to change each of these attributes.
- Search Screen
    - Displays three segment controls that describe different levels for each attribute: moisture, sunlight, and temperature
    - Users can set a location and use weather information from that location to input attributres.
- Name Search Screen
    - Users can search for plants by typing the plant's name into the search bar. 
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
    - Allows the user to edit the name, description, and viewability of the board.
- Add Screen
    - Displays a list of plants or list of boards than users can select. 
    - Presents a save button that allows the user to save their selections.
- Feed Screen
    - Displays posts posted by users that user follows. 
    - Users can interact with posts (like, comment, view profile)
- Comment Screen
    - Displays comments on a post in a table view. 
    - Users can post their own comment and view a commenter's profile.
- Post Likes Screen
    - Displays users that liked a post in a table view.
- Compose Screen
    - Users can add their own photo, add a caption, and pick a plant to post.
- Friends Screen
    - Users can view who they follow and who follows them.
- Find Users Screen
    - Users can search for a user by username through a search bar.
- User Profile Screen
    - Users can view other users (and their own) boards and posts in collection views.

### 3. Navigation

**Tab Navigation** (Tab to Screen)
- Feed Screen
- Plants Screen
- Search Screen
- Friends Screen
- Profile Screen


**Flow Navigation** (Screen to Screen)
- Log in/Register
    - Signup Screen
- Feed Screen
    - Compose Screen
    - Post Likes Screen
    - Comments Screen
- Plants Screen
    - Board Screen
        - Add Screen
        - Details Screen
    - Details Screen
- Search Screen
    - Results Screen
        - Details Screen
    - Name Search Screen
        - Details Screen
- Friends Screen
    - User Profile Screen
    - Find Users Screen
- Profile Screen
    - Settings Screen
    - Board Screen

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


