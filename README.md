# Group Project: Messaging App
by: **Savannah McCoy**, **Shumba Brown** and **Ayotunde Odejayi**



Name: Talk Up! 


Description: *"Bored? Talk to Anyone!"* - **Talk Up!** is a messaging app for iOS. 

Wire Frames in Repo Files

## Core

Required (core) user stories:

- User can chat with anyone anonymously
- Random Chatroom Assignment
- Online/Offline user tracking
- Reassignment to new Chatroom once partner goes offline for > 10s
- Gif support/integration
- Settings page for Customizable UI features (fonts, themes, etc)


## Optionals

Optional (nice to have) user stories:
- Random username/profile pic assignment based on theme
- User can choose from Topics based
- 3D touch topic for preview of messages on that topic
- Allow more than two people in chatroom (option controlled by user)
- Recognizing Links, phone numbers, email addresses
    - Censoring: Private information in messages, explitives
- Message Reactions
- Preset replies
- Message Likes
- Stickers
- Splashscreen with animation
- Swipe guesture animations
- Typing indicator
- Onboarding app tour
- App intro on Login screen
- Milestones/Award system for frequent chatters



## API Endpoints

- IBM Watson -- (Watson Developer Cloud)
    - Alchemy Language 
    - TextGetRankedKeyWord
- Giphy
    - Search
    - Random


# Backend
--------

### User 

Name | Datatype |
--- | --- |
username | String |
password | String |
location | Location |
activityStatus | String |

### Location

Name | Datatype |
--- | --- |
latitude | String |
longitue | String |

### Message

Name | DataType |
--- | --- |
text | String |
media | Array of Links |
timeStamp | String |

### UserInChat
Name | DataType|
--- | --- |
user | User |
isInApp | Bool |

### Chatroom

Name | DataType|
--- | --- |
members | Array of UserInChat |
messages | Array of Message |


# Locally
--------

### Theme

Name | DataType|
--- | --- |
CharacterType | String |
primaryColor | UIColor |
secondaryColor | UIColor |
tertiaryColor | UIColor |
quarternaryColor | UIColor |
chatBackgroundImage | UIImage |
font | String |



### Settings

Name | DataType|
--- | --- |
notifications | Bool |
encryptMessages | Bool |
enableVoiceMessaging | Bool |
fontSize | Int |
Theme | Theme.type |
anonymousUserName | String |
anonymousProfileImage | UIImage |


## Notes

Project is currently in development

## License

    Copyright [2017] [CP-SVM-SB Organization]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.



