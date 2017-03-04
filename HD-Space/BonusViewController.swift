//
//  BonusViewController.swift
//  HD-Space
//
//  Created by Erik Slovák on 13/12/2016.
//  Copyright © 2016 Erik Slovák. All rights reserved.
//

import UIKit

class BonusViewController: UITableViewController, UITextFieldDelegate {
    
    let rewards = ["1 GB Upload", "2 GB Upload", "5 GB Upload", "10 GB Upload", "1 Invite", "2 Invites", "3 Invites"]
    let prices = [600, 1100, 2700, 5200, 1000, 1500, 2000, 7500, 55555]
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
   
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBAction func reward1(_ sender: Any) {
        buyReward(sender: 1, input: "")
    }
    @IBAction func reward2(_ sender: Any) {
        buyReward(sender: 2, input: "")
    }
    @IBAction func reward3(_ sender: Any) {
        buyReward(sender: 3, input: "")
    }
    @IBAction func reward4(_ sender: Any) {
        buyReward(sender: 4, input: "")
    }
    @IBAction func reward5(_ sender: Any) {
        buyReward(sender: 5, input: "")
    }
    @IBAction func reward6(_ sender: Any) {
        buyReward(sender: 6, input: "")
    }
    @IBAction func reward7(_ sender: Any) {
        buyReward(sender: 7, input: "")
    }
    @IBAction func reward8(_ sender: Any) {
        var newTitle = ""
        if let unwrapTitle = titleInput.text {
            newTitle = unwrapTitle
        }
        buyReward(sender: 8, input: newTitle)
    }
    @IBAction func reward9(_ sender: Any) {
        var newUsername = ""
        if let unwrapUsername = usernameInput.text {
            newUsername = unwrapUsername
        }
        buyReward(sender: 9, input: newUsername)
        
    }
    
    func refreshButtons() {
        
        let bonus = UserDefaults.standard.integer(forKey: "bonus")
        let buttons = [button1, button2, button3, button4, button5, button6, button7, button8, button9]
        var i = 0
        
        for button in buttons {
            
            if bonus > prices[i] {
                button?.isEnabled = true
            } else {
                button?.isEnabled = false
            }
            i += 1
        }
        
        button8.isEnabled = false
        button9.isEnabled = false
        
    }
    
    func buyReward(sender: Int, input: String) {

        func sureAlert() {
            if sender == 8 {
                let sureAlert = UIAlertController(title: "Changing Title", message: "Are you sure you want to change your title to \(input)?", preferredStyle: .alert)
                sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in buy(sender: sender, input: input)}))
                sureAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(sureAlert, animated: true, completion: nil)
            } else if sender == 9 {
                let sureAlert = UIAlertController(title: "Changing Username", message: "Are you sure you want to change your username to \(input)?", preferredStyle: .alert)
                sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in buy(sender: sender, input: input)}))
                sureAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(sureAlert, animated: true, completion: nil)
            } else {
                let sureAlert = UIAlertController(title: "Buying \(rewards[sender - 1])", message: "Are you sure you want to buy \(rewards[sender - 1])?", preferredStyle: .alert)
                sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in buy(sender: sender, input: input)}))
                sureAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(sureAlert, animated: true, completion: nil)
            }
        }
        
        func emptyCheck() {
            
            let emptyError = UIAlertController(title: "Textfield is empty", message: "Username/Title textfield is empty. Enter desired username/title and try again.", preferredStyle: .alert)
            emptyError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            if input.isEmpty {
                self.present(emptyError, animated: true, completion: nil)
            } else {
                
                sureAlert()
                
            }
        }
 
        if sender == 8 || sender == 9 {
            emptyCheck()
        } else {
            sureAlert()
        }
 
        // fetch text from textfield !!!
        
        
        func buy(sender: Int, input: String) {
            
            var urlString = "https://google.com"
            
            func changeTitle(input: String) {
                print("Title: \(input)")
            }
            
            func changeUsername(input: String) {
                print("Username: \(input)")
            }
            
            switch sender - 1 {
            case 0: urlString = "https://hd-space.org/seedbonus_exchange.php?id=3"// 1 GB Upload
            case 1: urlString = "https://hd-space.org/seedbonus_exchange.php?id=4"// 2 GB Upload
            case 2: urlString = "https://hd-space.org/seedbonus_exchange.php?id=5"// 5 GB Upload
            case 3: urlString = "https://hd-space.org/seedbonus_exchange.php?id=6"// 10 GB Upload
            case 4: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite"// 1 Invite
            case 5: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite2"// 2 Invites
            case 6: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite3"// 3 Invites
            case 7: changeTitle(input: input)
            case 8: changeUsername(input: input)
            default: print(sender)
            }
            let url = URL(string: urlString)!
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    print(error as Any)
                    let timeOutAlert = UIAlertController(title: "Check your connection", message: "It appears you don't have an internet connection, check and try again.", preferredStyle: .alert)
                    timeOutAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(timeOutAlert, animated: true, completion: nil)
                } else {
                    
                }
                
                DispatchQueue.main.async(execute: {
                    if sender == 8 {
                        let succesfulAlert = UIAlertController(title: "Purchase successful!", message: "You've successfully changed your title to \(input).", preferredStyle: .alert)
                        succesfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(succesfulAlert, animated: true, completion: nil)
                    } else if sender == 9 {
                        let succesfulAlert = UIAlertController(title: "Purchase successful!", message: "You've successfully changed your username to \(input).", preferredStyle: .alert)
                        succesfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(succesfulAlert, animated: true, completion: nil)
                    } else {
                        let succesfulAlert = UIAlertController(title: "Purchase successful!", message: "You've successfully bought \(self.rewards[sender - 1]).", preferredStyle: .alert)
                        succesfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(succesfulAlert, animated: true, completion: nil)
                    }
                })
            }
            
            task.resume()
            print("task resume")
            print(urlString)
        }
        
        sureAlert()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        
        refreshButtons()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
