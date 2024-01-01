<div align="center">

<p align="center">
  <img src="Resource/InTouch_AppIcon.png" width="200"/>
</p>

# InTouch
![Static Badge](https://img.shields.io/badge/Swift-5.0-orange?logo=swift&style=for-the-badge) ![Static Badge](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge) ![Static Badge](https://img.shields.io/badge/iOS-16.0+-lightgrey?style=for-the-badge)

The only social media app you need to keep in touch with friends and family.
</div>

## 📖 Introduction
InTouch is a social media app that prioritizes meaningful connections by curating a weekly feed update, offering users a deliberate way to share multimedia content with close friends or communities they join.

## ⚙️ Requirements
- iOS 16.0+

## ⚡️ Getting Started

### 1. Installation
Install by cloning the repo.
```
git clone https://github.com/r1ddx2/InTouch.git
```
### 2. Set up third-party libraries
To use InTocuh properly, navigate to the project folder and input 
```
pod install
```
### 3. Build & Run
Build and run the project in Xcode.
### 4. Log In or Sign Up
Start using InTouch by registering your own account or logging in with the default account that already has joined communities and contents to view!
- Register your own account
- Log in with default account

👤 Default account :
```
Account : r1ddx09@gmail.com
Password : Red123
```

<p align="center">
  <div style="text-align:center;">
    <img src="https://github.com/JimmyChao90196/save-the-date/assets/69179262/edf2c4f6-9c92-4c09-a105-4385334618c7" alt="First GIF" style="width:40%; height:auto; display:inline-block;"/>
    <img src="https://github.com/JimmyChao90196/save-the-date/assets/69179262/f8d9af16-1f7e-4379-bf34-e161a16cc3ae" alt="Second GIF" style="width:40%; height:auto; display:inline-block;"/>
  </div>
</p>

## ❓How Does InTouch Work?
### ➕ Create or Join Groups 
- Create groups and invite your friends to join!
- Join groups with the group code and start sharing contents with other members!
### ❤️‍🔥 Post and Share Contents
- Upload photos along with location tagging and captions.
- Write short paragraphs to share your thoughts with the community.
- Generate audio messages to share long stories.
- Edit your submits anytime before the end of the week!
### ❗️Weekly Updated Feeds
- Feeds are only updated every Monday, enabling users to stay connected with friends in a time-conscious manner amid their busy lives.
- Be excited and check out the countdown for the next update!
### 🧭 Explore Locations on the Map
- Discover where your friends has been to visit these places.
- Find your current location.
### 🗂️ Review Archived Newsletters
- Treasure the enduring memories cultivated within each community!

## 📲 Tech Implementation
- Implemented the **MVC** architecture to ensure clarity and maintainability throughout the development process. 
- Enabled users to visually explore the geographic context of their posts with interactive pins, through **MapKit** and **Core Location**.  
- Allow a seamless search for places and locations through **Google API** and **Google SDK**, to accurately attach locations to user’s post contents.
- Provide users with the ability to play and record posted audio content through the utilization of **AVFoundation**. 
- Store user data and community updates by utilizing **Firebase Firestore** to efficiently store, retrieve, and synchronize data.  
- Integrating **Firebase Storage** to upload and manage different media files.
- Managed the user’s login and sign-up flow efficiently with the proficient use of **Firebase Authentication**. 
- Employed **Firebase Crashlytics** to monitor the app stability and capture real-time crashes.  
- Enforced coding standards and elevated quality assurance with **SwiftLint** to ensure consistent code.

## 📐 Tech Stack
- [UIKit](https://developer.apple.com/documentation/uikit/) - Construct and manage a graphical, event-driven user interface for your iOS, iPadOS, or tvOS app.
- [MapKit](https://developer.apple.com/documentation/mapkit) - Display map or satellite imagery within your app, call out points of interest, and determine placemark information for map coordinates.
- [Core Location](https://developer.apple.com/documentation/corelocation/) - Obtain the geographic location and orientation of a device.
- [AVFoundation](https://developer.apple.com/documentation/avfoundation/) - Work with audiovisual assets, control device cameras, process audio, and configure system audio interactions.
- [Firebase Firestore](https://firebase.google.com/docs/firestore) - Flexible, scalable NoSQL cloud database, built on Google Cloud infrastructure, to store and sync data for client- and server-side development.
- [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions.

## 👨🏻‍💻 Author
 **Red Wang**
* Email: [red0wang9@gmail.com]()
* Linkedin: [Red Wang](https://www.linkedin.com/in/red-wang-19a49623a/)
* GitHub: [@r1ddx](https://github.com/r1ddx2)

## 📝 License

Copyright © 2023 [Red Wang](https://github.com/r1ddx2).<br />
This project is [MIT](https://github.com/r1ddx2/InTouch/blob/main/LICENSE) licensed.
