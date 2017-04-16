//
//  AnonUser.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/14/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import Foundation
import UIKit


class AnonUser: NSObject {
    
    
    // USER NAMES AND PROFILE PICS BY THEME
    var robotUsernames = ["dryBot", "snappyBot", "chinchillaBot", "illRobot", "biscuitBot", "glyderBot", "quagswaggingBot", "Botnebula", "herculesBot", "Robotpasta"]
    var fruitUsernames = ["unflavoredApple", "sugaryTomatoe", "pingpongOrange", "Watermelonprincess", "pimpedoutBanana", "Pinappleglass", "biopsyKiwi", "viceGrapes", "subscriptStrawberry", "teenageLemon"]
    var planetUsernames = ["Saturnsunrise", "theeJupiter", "extraneousEarth", "Venusastronomer", "snorklingPluto", "minsmereMercury", "Uranusstreet", "marsuniverse", "boundlessneptune", "beachedSun"]
    var animalUsernames = ["bundleTurtle", "butterflyChicken", "jokesGiraffe", "venomousFish", "malcontentFlamingo", "puddingSnail", "glorySquirrel", "banginCamel", "dimDolphin", "confusedZebra"]
    var snapchatUsernames = ["djkhaled305", "arnoldschnitzel", "ellen", "kylizzlemynizzl", "kendalljenner", "howusnap", "jicknonas", "ohheyhilary", "jlobts", "snoopdogg213"]
    
    var robotProfilepics =  ["hotpink.png", "jeanblue.png", "lightblue.jpg", "limegreen.jpg", "magenta.jpg", "orange.jpg", "purple.jpg", "red.jpg", "skyblue.jpg", "turquoise.jpg"]
    var fruitProfilepics =  ["hotpink.png", "jeanblue.png", "lightblue.jpg", "limegreen.jpg", "magenta.jpg", "orange.jpg", "purple.jpg", "red.jpg", "skyblue.jpg", "turquoise.jpg"]
    var planetProfilepics =  ["hotpink.png", "jeanblue.png", "lightblue.jpg", "limegreen.jpg", "magenta.jpg", "orange.jpg", "purple.jpg", "red.jpg", "skyblue.jpg", "turquoise.jpg"]
    var animalProfilepics =  ["hotpink.png", "jeanblue.png", "lightblue.jpg", "limegreen.jpg", "magenta.jpg", "orange.jpg", "purple.jpg", "red.jpg", "skyblue.jpg", "turquoise.jpg"]
    var snapchatProfilepics =  ["hotpink.png", "jeanblue.png", "lightblue.jpg", "limegreen.jpg", "magenta.jpg", "orange.jpg", "purple.jpg", "red.jpg", "skyblue.jpg", "turquoise.jpg"]
    
    
    var anonUserName = String()
    var anonProfilePic = String()
    var themeNum = 0
    
    override init(){
        
        anonUserName = " "
        anonProfilePic = "purpleSelect.png"
        
    }
    
    
    func setAnonInfo(themeNum: Int){
        
        switch(themeNum){
            
            case 1:
                let nameAndPic = chooseRandomNameAndPic(nameList: fruitUsernames, imageList: fruitProfilepics)
                anonUserName = nameAndPic.0
                anonProfilePic = nameAndPic.1
                break
            case 2:
                let nameAndPic = chooseRandomNameAndPic(nameList: planetUsernames, imageList: planetProfilepics)
                anonUserName = nameAndPic.0
                anonProfilePic = nameAndPic.1
                break
            case 3:
                let nameAndPic = chooseRandomNameAndPic(nameList: animalUsernames, imageList: animalProfilepics)
                anonUserName = nameAndPic.0
                anonProfilePic = nameAndPic.1
                break
            case 4:
                let nameAndPic = chooseRandomNameAndPic(nameList: snapchatUsernames, imageList: snapchatProfilepics)
                anonUserName = nameAndPic.0
                anonProfilePic = nameAndPic.1
                break
            default:
                let nameAndPic = chooseRandomNameAndPic(nameList: robotUsernames, imageList: robotProfilepics)
                anonUserName = nameAndPic.0
                anonProfilePic = nameAndPic.1
                break
            
        }
        
    }
    
    func chooseRandomNameAndPic(nameList: [String], imageList: [String]) -> (String, String) {
        
        let random = Int(arc4random_uniform(10))
    
        return (nameList[random], imageList[random])
        
    }
    
    
}
