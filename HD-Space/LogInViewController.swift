//
//  LogInViewController.swift
//  HD-Space
//
//  Created by Erik Slovák on 07/12/2016.
//  Copyright © 2016 Erik Slovák. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var logInView: UIWebView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBAction func closePressed(_ sender: Any) {
        
        let url = URL(string: "https://hd-space.org/")!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error as Any)
            } else {
                
                
                if let unwrappedData = data {
                    
                    self.dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                    
                    if self.dataString.contains("Welcome back") {
                        //self.timer.invalidate()
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let notLoggedAlert = UIAlertController(title: "Not logged in", message: "It appears that you are not logged in, if you are not, please log in and click Done again.", preferredStyle: .alert)
                        notLoggedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(notLoggedAlert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        task.resume()
        
        
        
    }
    
    var timer = Timer()
    var dataString: NSString = ""
    let logInURL = URL(string: "https://hd-space.org")
    
    override func viewDidAppear(_ animated: Bool) {
        //self.closeButton.isEnabled = false
        
        logInView.loadRequest(URLRequest(url: logInURL!))
        
        let url = URL(string: "https://hd-space.org/")!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error as Any)
            } else {
                
                
                if let unwrappedData = data {
                    
                    self.dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                    
                }
                
            }
            
        }
        task.resume()
        
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {timer in
                if self.dataString.contains("Welcome back") {
                    self.timer.invalidate()
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    task.suspend()
                    task.resume()
                }
            })
        } else {
            // Fallback on earlier versions
        
        let alertMessage = UIAlertController(title: "Auto dismiss not supported on iOS 9 and below", message: "When you are successfully logged in, please click Done.", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertMessage, animated: true, completion: nil)
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
