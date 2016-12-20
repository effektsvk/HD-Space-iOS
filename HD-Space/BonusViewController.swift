//
//  BonusViewController.swift
//  HD-Space
//
//  Created by Erik Slovák on 13/12/2016.
//  Copyright © 2016 Erik Slovák. All rights reserved.
//

import UIKit

class BonusViewController: UITableViewController {

    let rewards = ["1 GB Upload", "2 GB Upload", "5 GB Upload", "10 GB Upload", "1 Invite", "2 Invites", "3 Invites"]
    let prices = [600, 1100, 2700, 5200, 1000, 1500, 2000]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BonusTableViewCell
        
        cell.label.text = rewards[indexPath.row]
        cell.priceLabel.text = String(prices[indexPath.row])
        if Double(prices[indexPath.row]) < UserDefaults.standard.double(forKey: "bonus") {
            cell.buyButton.isEnabled = true
        } else {
            cell.buyButton.isEnabled = false
        }
        
        return cell
    }
    
    @IBAction func buyReward(_ sender: AnyObject) {
        // getting selected row
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        func buy(sender: Int) {
            
            var urlString = ""
            switch sender {
            case 0: urlString = "https://hd-space.org/seedbonus_exchange.php?id=3"// 1 GB Upload
            case 1: urlString = "https://hd-space.org/seedbonus_exchange.php?id=4"// 2 GB Upload
            case 2: urlString = "https://hd-space.org/seedbonus_exchange.php?id=5"// 5 GB Upload
            case 3: urlString = "https://hd-space.org/seedbonus_exchange.php?id=6"// 10 GB Upload
            case 4: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite"// 1 Invite
            case 5: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite2"// 2 Invites
            case 6: urlString = "https://hd-space.org/seedbonus_exchange.php?id=invite3"// 3 Invites
            default: break
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
                    
                    let succesfulAlert = UIAlertController(title: "Purchase successful!", message: "You've successfully bought \(self.rewards[indexPath.row]).", preferredStyle: .alert)
                    succesfulAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(succesfulAlert, animated: true, completion: nil)
                    
                }
                
                
            }
            
            print(sender)
            
            task.resume()
            print(urlString)
            
        }
        
        let sureAlert = UIAlertController(title: "Buying \(rewards[indexPath.row])", message: "Are you sure you want to buy \(rewards[indexPath.row])?", preferredStyle: .alert)
        sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in buy(sender: indexPath.row)}))
        sureAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(sureAlert, animated: true, completion: nil)
        
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
