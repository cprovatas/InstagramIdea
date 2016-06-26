OSX Instagram Feed Application - 06/25/16  
==============

This app is being designed as a result of the recent ban on Third-Party Instagram Apps, essentially forcing non-mobile users to use the Instagram website.  This app is set up to dynamically fetch your news feed and display it.  This app is in very early stages and only has some basic functionality working.  

**What it does right now**

- After logging in (you only need to log in once at the first time opening the app), the app will display the first 24 photos of yours news feed, along with the users and captions associated with those photos
- If the user's photo is a video, it will show the video instead in a video player.


**Features Looking Forward (In order of priority)**

- resizing the table's content view when the window is full screen

- better scaling of landscape images

- improve UI design

- display more photos after user has scrolled past 24 photos

- detect when it is the first time logging in and display the instagram login page as a drop down web view

- display other core information such as # of likes, users that liked the photo, profile picture of poster, (perhaps some of the other hidden json info, such as 'user has blocked user' etc)

- a more efficient way for loading the images/videos, all of images and videos for the feed are all loaded before they are displayed, there is probably a better way

to load/cache the images as you are scrolling instead

**Features Looking Farther Forward - These will probably be more difficult to implement w/o the instagram developer api**

- perhaps support for displaying a users profile

- Ability to like/dislike photos/videos

- Ability to write comments

- display feed in different types of views

- Some other things to think about - notifications, messages, account info, block users, reporting photos