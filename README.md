# Group Project: Messaging App
by: **Savannah McCoy**, **Shumba Brown** and **Ayotunde Odejayi**



Name: Talk Up! 


Description: *"Bored? Talk to Anyone!"* - **Talk Up!** is a messaging app for iOS. 


Link to WireFrame: 

## Core

Required (core) user stories your app:

- test
- test 2
- test 3


* [ ] User can chat with anyone anonymously
* [ ] Random Chatroom Assignment
* [ ] Online/Offline user tracking
* [ ] Reassignment to new Chatroom once partner goes offline for > 10s
* [ ] Gif support/integration
* [ ] Elegant UI Features
* [ ] Intuitive App structure
* [ ] Google Maps API
* [ ] Settings page for Customizable UI features (fonts, themes, etc)


## Optionals

Optional (nice to have) user stories listed separately

* [ ] User can choose from Topics based on location
        - Allow more than one person in chatroom
* [ ] Recognizing Links, phone numbers, email addresses
* [ ] Censoring: Private information in messages
* [ ] Waiting Game for users to play while waiting to join chat


## API Endpoints

- Google Maps Geolocation API
    - Map Objects > My Location


## Notes

Project is currently in development

## License

    Copyright [2017] [CP-SVM-SB Organizaion]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# Backend
--------

### User 

Name | Datatype |
--- | --- |
username | String |
password | String |
location | Location |

### Location

Name | Datatype |
--- | --- |
latitude | String |
longitue | String |

### Message

Name | Datatype |
--- | --- |
text | String |
media | Array of Links |
timeStamp | String |

### UserInChat
Name | Dataype|
--- | --- |
user | User |
isInApp | Bool |

### Chatroom

Name | Dataype|
--- | --- |
members | Array of UserInChat |
messages | Array of Message |


# Locally
--------

### Theme

Name | Dataype|
--- | --- |
description | String |
primaryColor | String |
secondaryColor | String |

