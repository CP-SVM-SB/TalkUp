//
//  TopicsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol TopicsVCDelegate {
    func startTimer()
}


class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TopicsVCDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var counterItem: UIBarButtonItem!
    @IBOutlet var newChatButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backToChatButton: UIButton!
    @IBOutlet var otherTopicsLabel: UILabel!
    @IBOutlet var trendingTopicsLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    let screenHeight = UIScreen.main.bounds.height
    //let scrollViewContentHeight = 1200 as CGFloat
  let myParseClient = ParseClient()
  let keywordApi = WatsonClient()
  let myDispatchGroup = DispatchGroup()
  let fakeTopicsArr = ["Donald Trump", "United Airlines", "WWIII", "iPhone 8", "Kendrick Lamar", "Berkeley", "Maxine Waters", "North Korea"]
  let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  // -- Settable Vars --
  var noTopicsMax = 7               // max. number of topics you wish to see
  var topicsRollbackLength: Int = 50   // no of recent msgs you wish to use in getting topics [NB]: if 0, ALL messages are used
  var noCurrentlyAvailableChats = 0
  var rawMessages: String?
  var chatmsg: String?
  var chatRawMsgs = [String]()
  var keywordsWithRelevance = Dictionary <String, Double>()
  var keywordsWithChats = Dictionary<String, NSMutableArray>()
  var keywordsArr = [String]()
  var previewChats : NSMutableArray?
  var noChatsWithKeyword = [Int]()
  var chatTopicWithRelevance = Dictionary<String, Double>()
  var chatTopicsArr = [String]()
  var chatIDs = [Int]()
  var nonEmptyChatId = 0
  var keywordID = 0
  var chatCount = 0
  var chatIndex = 0
  var revChatMsgs = Dictionary<Int, [Message]>()
  var firstValSet = false
  var userSettings: UserSettings?
  var timer = Timer()
  var counter = 0
  var dataArr = [Data]()
  var cellIndexArr = [Int]()
    var location = Location()
    
    let locationManager = CLLocationManager()

    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.locationManager.requestAlwaysAuthorization()
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.estimatedRowHeight = 80
    tableView.preservesSuperviewLayoutMargins = false
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.layoutMargins = UIEdgeInsets.zero
    tableView.rowHeight = UITableViewAutomaticDimension
    
    
    scrollView.delegate = self
 
    
    counterItem.title = " "
    counterItem.tintColor = .black
    
    trendingTopicsLabel.text = "Trending Topics"
    otherTopicsLabel.text = "All Topics"

    containerView.layer.shadowColor = UIColor(white: 0.7, alpha: 0.7).cgColor
    containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
    containerView.layer.shadowOpacity = 0.4
    containerView.layer.masksToBounds = false
    containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
    
    layout.minimumInteritemSpacing = 1
    layout.minimumLineSpacing = 1
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    view.backgroundColor = userSettings?.theme?.primaryColor
    counter = 30
    myDispatchGroup.enter()
    myParseClient.getChatCount (onSuccess: { (chatCount: Int) in
      print("No. of available chats: \(chatCount+1)")
      self.noCurrentlyAvailableChats = chatCount+1
      self.myDispatchGroup.leave()
    })
    
    myDispatchGroup.notify(queue: .main) {
      self.getIndexChatMsgs(index: self.chatCount)
    }
    
    
  }
    

  override func viewDidLayoutSubviews() {
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self, sourceView: tableView)
    }
  }
  
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

        if scrollView.bounds.intersects(view.frame) == true {
            //the UIView is within frame, use the UIScrollView's scrolling.
            
            if tableView.contentOffset.y == 0 {
                //tableViews content is at the top of the tableView.
                
                tableView.isUserInteractionEnabled = false
                tableView.resignFirstResponder()
                //print("using scrollView scroll")
                
            } else {
                
                //UIView is in frame, but the tableView still has more content to scroll before resigning its scrolling over to ScrollView.
                
                tableView.isUserInteractionEnabled = true
                scrollView.resignFirstResponder()
                //print("using tableView scroll")
            }
            
        } else {
            
            //UIView is not in frame. Use tableViews scroll.
            
            tableView.isUserInteractionEnabled = true
            scrollView.resignFirstResponder()
            //print("using tableView scroll")
            
        }
        
    }
    
    func startTimer(){
        
        counter = 30
        newChatButton.isHidden  = true
        newChatButton.isEnabled = false
        backToChatButton.isHidden = false
        
        counterItem.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TopicsViewController.updateTime), userInfo: nil, repeats: true)
    }
  
    func updateTime(){
        counter = counter - 1
        //print("TIMER:", counter)
        counterItem.title = String(counter)
        
        if counter == 0{
            timesUp()
        }
    }
    
    
    func timesUp(){
        timer.invalidate()
        counterItem.title = " "
        newChatButton.isHidden = false
        newChatButton.isEnabled = true
        backToChatButton.isHidden = true
    }
  
  func getIndexChatMsgs(index: Int) {     // lots of moving parts! (hint: nested, dependent async calls)
    var msg: String?
    //print("\nrequesting chat(\(index))")
    
    self.myParseClient.getMessagesFromChatWithId(id: index, onSuccess: { (rawChatMsgs: [Message]) in
      //print("returned chat(\(index))")
      if rawChatMsgs.isEmpty {} else {  // TODO: limited no. of msgs check to qualify for keyword search
        //print ("Chat(\(index)) Non-empty chat found!")
        self.chatIDs.append(index)
        
        // rollback?
        let revMsgs = rawChatMsgs.reversed()
        var ind = 0
        if (self.topicsRollbackLength == 0) {
          for msg in revMsgs { self.chatRawMsgs[self.nonEmptyChatId] = (self.chatRawMsgs[self.nonEmptyChatId] == "") ? msg.text! : self.chatRawMsgs[self.nonEmptyChatId]+", "+msg.text!}
        } else {
          for i in revMsgs.indices {
            if (ind > self.topicsRollbackLength) {break}
            msg = (!self.firstValSet) ? revMsgs[i].text! : msg!+", "+revMsgs[i].text!
            self.firstValSet = true
            ind += 1
          }
        }
        self.chatRawMsgs.append(msg!)
        
        // extract keywords for current chat
        self.keywordApi.performKeywordSearch(textBody: self.chatRawMsgs[self.chatCount], success: { (keys: [String : Double]) in
          self.chatTopicWithRelevance = keys
          var chatTopic : String?
          
          // inelegant! extracts element "0" of dictionary keys
          for key in keys.keys {
            self.chatTopicsArr.append(key)
            break
          }
          
          if self.chatTopicsArr.count == self.chatIndex + 1 { // check if a key was returned
            chatTopic = self.chatTopicsArr[self.chatIndex]
            self.keywordsArr.append(chatTopic!)
            
            var count = 0
            self.keywordsWithChats[chatTopic!] = [""]  // initialize dict. of NSMutable Arr for appending
            
            for msg in revMsgs {
              // case-insensitive search
              if msg.text!.lowercased().range(of: (chatTopic?.lowercased())!) != nil {
                if count > 0 {
                  self.keywordsWithChats[chatTopic!]!.add(msg.text!)
                } else {
                  self.keywordsWithChats[chatTopic!]![0] = msg.text!
                }
                count += 1
              }
            }
            self.noChatsWithKeyword.append(count)
          }
          
          self.firstValSet = false
          self.chatCount += 1
          self.chatIndex += 1
          
          // perform Recursion
          if (self.chatIndex < self.noCurrentlyAvailableChats) {
            let nextIter = self.chatIndex
            self.getIndexChatMsgs(index: nextIter)
            self.tableView.reloadData()
            self.tableView.estimatedRowHeight = self.tableView.contentSize.height
            
          } else {
            self.tableView.reloadData()
            self.tableView.estimatedRowHeight = self.tableView.contentSize.height
          }
          
        }, failure: { (error: Error) in
          print (error.localizedDescription)
        })
        
     }
    }, onFailure: { (error: Error) in
      print(error.localizedDescription)
    })
  }
  
  @IBAction func unwindToTopics (segue: UIStoryboardSegue) {
    
  }
  
  // ------------------------ PREPARE FOR SEGUE --------------------------
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toSettings"{
      let settingsVC = segue.destination as! SettingsTableViewController
      settingsVC.userSettings = self.userSettings
    }
    
    if segue.identifier == "toMenu"{
        let menuTableVC = segue.destination as! TopicsMenuTableViewController
        
        menuTableVC.userSettings = self.userSettings
    }
    
    if segue.identifier == "topicsToChatsSegue"{
      let navC = segue.destination as! UINavigationController
      let chatVC = navC.viewControllers.first as! ChatRoomViewController
      chatVC.userSettings = self.userSettings
        chatVC.chat.location?.longitude = self.location.longitude
        chatVC.chat.location?.latitude = self.location.latitude
        chatVC.delegate = self
    }
    
    
    
    
  }
  
    
    @IBAction func didTapBackToChat(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier :"chatVC") as!ChatRoomViewController
        let navC = UINavigationController(rootViewController: chatVC)
        self.present(navC, animated:true, completion: nil)
        
        
        //present(chatVC, animated: true, completion: nil)
    }
  
    
    @IBAction func didTapMenu(_ sender: Any) {
        
        self.view.bringSubview(toFront: containerView)
        
        if containerView.isHidden == false {
            containerView.slideOutToLeft()
            containerView.isHidden = true
        }else{
            containerView.slideInFromLeft()
            containerView.isHidden = false
        }
        
    }
    
    
    @IBAction func didTapOutsideMenu(_ sender: Any) {
        containerView.slideOutToLeft()
        containerView.isHidden = true
    }
    
    
    
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.keywordsArr.count > self.noTopicsMax) ? self.noTopicsMax : self.keywordsArr.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath) as! TrendCell
    
    cell.noChatsforTopic = self.noChatsWithKeyword[indexPath.row]
    cell.buttonTitle = self.keywordsArr[indexPath.row]
    
    return cell
  }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.location.longitude = locValue.longitude
        self.location.latitude = locValue.latitude
        //print(self.location.latitude)
        //print("LOCATION = \(locValue.latitude) \(locValue.longitude)")
    }
  
  
  
  
}
