//
//  InfoClubTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-18.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import MessageUI

class InfoClubTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let dateformat = DateFormatter()
    let persistenceManagers = PersistenceManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Sets nav-bar text color
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //SETUP
        
        dateformat.dateFormat = "E HH:mm"
        //Setting up Info
        name.text = nameTable
        clubOwner.text = ownerTable
        room.text = roomTable
        sponsorTeacher.text = teacherTable
        
        //Puts multiple meetings in list format
        var meetingLoop: String = String()
        meetingLoop += "Meetings: "
        for date in dateTable {
            
            
            let dateString = dateformat.string(from: date)
            
            
            if dateTable.last == date {
                
                meetingLoop += dateString + ""
                
            } else {
                meetingLoop += dateString + ", "
            }
            
        }
        
    
        date.text = meetingLoop
        desc.text = descTable
        
        //Checking if student is a member
        guard let context = try! persistenceManagers.context.fetch(CoreClub.fetchRequest()) as? [CoreClub]
            else { return }
        
        checkClubs: for club in context {
            
            if club.name == nameTable {
                joinButton.isEnabled = false
                joinButton.setTitle("Club Joined", for: .normal)
                break checkClubs;
            } else {
                
                joinButton.isEnabled = true
                joinButton.setTitle("Join Club", for: .normal)
                
            }
            
            
        }
        
        
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //OUTLETS
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var clubOwner: UILabel!
    @IBOutlet weak var sponsorTeacher: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var joinButton: UIButton!
    
    //VARIABLES
    var nameTable: String = ""
    var ownerTable: String = ""
    var teacherTable: String = ""
    var roomTable: String = ""
    var dateTable: [Date] = []
    var descTable: String = ""
    var emailTable: [String]?
    

    //EMAIL SETUP
    
    
    //Sent email
    @IBAction func contactTapped(_ sender: Any) {
        
        //Email
        if !MFMailComposeViewController.canSendMail() {
            showError()
        
        } else {
            
            if let email = emailTable {
                
                let mail = configureMailController(email: email)
                self.present(mail, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    //Setting up Email
    func configureMailController(email: [String]) -> MFMailComposeViewController {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(email)
        
        return composeVC
        
    }
    
    //Handles Email send/cancel
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //error when Mail app isn't configured
    func showError() {
        
        let alert = UIAlertController(title: "Email Error", message: "Check your Mail app", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
        
    }

        
    
    //Join club on tap
    @IBAction func joinTapped(_ sender: Any) {
        
        
        let myClub = CoreClub(context: persistenceManagers.context)
        myClub.name = nameTable
        myClub.leader = ownerTable
        myClub.sponsor = teacherTable
        myClub.room = roomTable
        myClub.meeting = dateTable as [NSDate]
        myClub.descriptionClub = descTable
        persistenceManagers.save()
        
        joinButton.isEnabled = false
        joinButton.setTitle("Club Joined", for: .normal)
        
    }
    
}


