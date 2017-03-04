//
//  ViewController.swift
//  HD-Space
//
//  Created by Erik Slovák on 05/12/2016.
//  Copyright © 2016 Erik Slovák. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    var username = UserDefaults.standard.string(forKey: "username")
    var upload = UserDefaults.standard.double(forKey: "upload")
    var download = UserDefaults.standard.double(forKey: "download")
    var ratio = UserDefaults.standard.double(forKey: "ratio")
    var downByteType = UserDefaults.standard.string(forKey: "downByteType")
    var upByteType = UserDefaults.standard.string(forKey: "upByteType")
    var activeUp = UserDefaults.standard.integer(forKey: "activeUp")
    var activeDown = UserDefaults.standard.integer(forKey: "activeDown")
    var bonus = UserDefaults.standard.double(forKey: "bonus")
    let downloadColor = #colorLiteral(red: 1, green: 0.3300932944, blue: 0.2421161532, alpha: 1)
    let uploadColor = #colorLiteral(red: 0.3430494666, green: 0.8636034131, blue: 0.467017293, alpha: 1)
    var didLogIn = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var navbarLabel: UINavigationItem!
    @IBOutlet weak var statsWheel: UICircularProgressRingView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var activeUpLabel: UILabel!
    @IBOutlet weak var activeDownLabel: UILabel!
    @IBAction func logOut(_ sender: Any) {
        
        clearCache()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        checkLogIn()
        
    }
    
    func logIn() {
        //performSegue(withIdentifier: "logInSegue", sender: view)
        performSegue(withIdentifier: "logInSegue", sender: nil)
    }
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    func checkLogIn() {
        let url = URL(string: "https://hd-space.org/index.php")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print(error as Any)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                    if dataString.contains("Welcome back ") {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    } else {
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    }
                }
            }
            DispatchQueue.main.sync(execute: {
                if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
                    self.clearCache()
                    self.logIn()
                }
            })
            
            
        }
        
        task.resume()
        /*
         if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
         self.logIn()
         } else {
         self.refreshData()
         }
         */
    }
    
    func refreshData() {
        /*
         self.uploadLabel.isHidden = true
         self.downloadLabel.isHidden = true
         self.ratioLabel.isHidden = true
         self.statsWheel.isHidden = true
         self.statsWheel.setProgress(value: 0, animationDuration: 0)
         */
        
        let url = URL(string: "https://hd-space.org/index.php")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print(error as Any)
                let timeOutAlert = UIAlertController(title: "Check your connection", message: "It appears you don't have an internet connection, check and try again.", preferredStyle: .alert)
                timeOutAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(timeOutAlert, animated: true, completion: nil)
                self.refreshControl.endRefreshing()
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    // fetching username
                    
                    var stringSeparator = "Welcome back <span"
                    
                    if let usernameArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if usernameArray.count > 0 {
                            
                            stringSeparator = "</span>"
                            
                            var newContentArray = usernameArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                
                                newContentArray.removeSubrange(1..<3)
                                
                                stringSeparator = ">"
                                let name = String(newContentArray[0].characters.reversed())
                                var nameArray: [String]
                                nameArray = name.components(separatedBy: stringSeparator)
                                self.username = String(nameArray[0].characters.reversed())
                            }
                        }
                    }
                    
                    // fetching upload
                    
                    stringSeparator = "align=\"center\"> UP: "
                    
                    if let uploadArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if uploadArray.count > 0 {
                            
                            stringSeparator = " "
                            
                            var newContentArray = uploadArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                
                                if let unwrappedUpload = Double(newContentArray[0].replacingOccurrences(of: ",", with: "")) {
                                    self.upload = unwrappedUpload
                                }
                                
                                let upType = newContentArray[1].components(separatedBy: "</td>")
                                self.upByteType = String(upType[0])
                            }
                        }
                    }
                    
                    // fetching download
                    
                    stringSeparator = "align=\"center\"> DL:  "
                    if let downloadArray = dataString?.components(separatedBy: stringSeparator) {
                        if downloadArray.count > 0 {
                            stringSeparator = " "
                            var newContentArray = downloadArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 0 {
                                if let unwrappedDownload = Double(newContentArray[0].replacingOccurrences(of: ",", with: "")) {
                                    self.download = unwrappedDownload
                                }
                                let downType = newContentArray[1].components(separatedBy: "</td>")
                                self.downByteType = String(downType[0])
                            }
                        }
                    }
                    
                    // fetching ratio
                    
                    stringSeparator = "> Ratio: "
                    
                    if let ratioArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if ratioArray.count > 0 {
                            
                            stringSeparator = "</td>"
                            
                            var newContentArray = ratioArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                
                                if let unwrappedRatio = Double(newContentArray[0]) {
                                    self.ratio = unwrappedRatio
                                } else {
                                    self.ratio = 0.0
                                }
                            }
                        }
                    }
                    
                    // fetching active torrents
                    
                    // checking if there are active torrents
                    if let isNotActive = dataString?.contains("Active Torrents : <font color=\"red\"><b>NONE !! ") {
                        if isNotActive {
                            self.activeUp = 0
                            self.activeDown = 0
                        } else {
                            
                            // UP
                            
                            stringSeparator = "<font color=\"green\">"
                            
                            if let activeUpArray = dataString?.components(separatedBy: stringSeparator) {
                                
                                if activeUpArray.count > 0 {
                                    
                                    stringSeparator = "</font>"
                                    
                                    var newContentArray = activeUpArray[1].components(separatedBy: stringSeparator)
                                    
                                    if newContentArray.count > 0 {
                                        
                                        if let unwrappedActiveUp = Int(newContentArray[0]) {
                                            if unwrappedActiveUp != 0 {
                                                self.activeUp = unwrappedActiveUp
                                            }
                                        }
                                    }
                                }
                            }
                            
                            stringSeparator = "<font color=\"red\">"
                            
                            if let activeDownArray = dataString?.components(separatedBy: stringSeparator) {
                                
                                if activeDownArray.count > 0 {
                                    
                                    stringSeparator = "</font>"
                                    
                                    var newContentArray = activeDownArray[1].components(separatedBy: stringSeparator)
                                    
                                    if newContentArray.count > 0 {
                                        
                                        if let unwrappedActiveDown = Int(newContentArray[0]) {
                                            self.activeDown = unwrappedActiveDown
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // fetching bonus for the badge
                    
                    stringSeparator = "Bonus: "
                    
                    if let bonusArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if bonusArray.count > 0 {
                            
                            stringSeparator = "</a>"
                            
                            var newContentArray = bonusArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                
                                if let unwrappedBonus = String(newContentArray[0]) {
                                    
                                    if let clearBonus = Double(unwrappedBonus.replacingOccurrences(of: ",", with: "")) {
                                        self.bonus = clearBonus
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.sync(execute: {
                let progress: Double = self.download * self.ratio
                self.uploadLabel.isHidden = false
                self.downloadLabel.isHidden = false
                self.ratioLabel.isHidden = false
                self.statsWheel.isHidden = false
                if let unwrappedDownType = UserDefaults.standard.string(forKey: "downByteType") {
                    self.downloadLabel.text = "\(self.download) \(unwrappedDownType)"
                }
                if let unwrappedUpType = UserDefaults.standard.string(forKey: "upByteType") {
                    self.uploadLabel.text = "\(self.upload) \(unwrappedUpType)"
                }
                
                self.statsWheel.maxValue = CGFloat(self.download + (self.download * self.ratio))
                self.statsWheel.setProgress(value: CGFloat(progress), animationDuration: 2.0)
                self.navbarLabel.title = self.username
                if self.ratio != 0.0 {
                    self.ratioLabel.text = "Ratio: \(self.ratio)"
                } else {
                    self.ratioLabel.text = "Ratio: ∞"
                }
                self.activeUpLabel.text = String(self.activeUp)
                self.activeDownLabel.text = String(self.activeDown)
                self.tabBarController?.tabBar.items?[1].badgeValue = String(self.bonus)
                
                UserDefaults.standard.set(self.username, forKey: "username")
                UserDefaults.standard.set(self.download, forKey: "download")
                UserDefaults.standard.set(self.upload, forKey: "upload")
                UserDefaults.standard.set(self.ratio, forKey: "ratio")
                UserDefaults.standard.set(self.activeUp, forKey: "activeUp")
                UserDefaults.standard.set(self.activeDown, forKey: "activeDown")
                UserDefaults.standard.set(self.upByteType, forKey: "upByteType")
                UserDefaults.standard.set(self.downByteType, forKey: "downByteType")
                UserDefaults.standard.set(self.bonus, forKey: "bonus")
                self.refreshControl.endRefreshing()
            })
        }
        refreshControl.beginRefreshing()
        task.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navbarLabel.title = self.username
        self.downloadLabel.text = String(self.download)
        self.uploadLabel.text = String(self.upload)
        self.ratioLabel.text = String(self.ratio)
        self.statsWheel.isHidden = true
        
        
        
        refreshControl.addTarget(self, action: #selector(self.checkLogIn), for: .valueChanged)
        scrollView.insertSubview(self.refreshControl, at: 0)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLogIn()
        
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.logIn()
        } else {
            self.refreshData()
        }
    }
    
    
}

