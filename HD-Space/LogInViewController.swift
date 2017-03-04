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
                }
            }
        
            DispatchQueue.main.sync(execute: {
                
                if self.dataString.contains("Welcome back") {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let notLoggedAlert = UIAlertController(title: "Not logged in", message: "It appears that you are not logged in, if you are not, please log in and click Done again.", preferredStyle: .alert)
                    notLoggedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(notLoggedAlert, animated: true, completion: nil)
                }
                
            })
            
        }
        task.resume()
        
    }
    
    var dataString: NSString = ""
    let logInURL = URL(string: "https://hd-space.org")
    
    override func viewDidAppear(_ animated: Bool) {
        
        logInView.loadRequest(URLRequest(url: logInURL!))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInSegue" {
            if let destVC = segue.destination as? ViewController {
                destVC.didLogIn = true
            }
        }
    }
    
}
