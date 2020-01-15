//
//  InfoSportsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-20.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import MessageUI

class InfoSportsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Setting nav-bar title text and color
        self.title = "Team"
        contactButton.setTitle("Contact Team", for: .normal)
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //SETUP
        
        //Setting up text
        teamName.text = "\(teamString) Team"
        coachNames.text = "Coaches: \(coachString)"
        sponsorTeacher.text = "Sponsor: \(sponsorString)"
        season.text = "Season: \(seasonString)"
        
        //Checking if student joined the team
        
        if sportController.isInTeam(teamString: teamString) {
            joinButton.setTitle("Team Joined", for: .normal)
        } else {
            joinButton.setTitle("Join Team", for: .normal)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //OUTLETS
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var coachNames: UILabel!
    @IBOutlet weak var sponsorTeacher: UILabel!
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var grades: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    //VARIABLES
    var teamString = ""
    var coachString = ""
    var sponsorString = ""
    var seasonString = ""
    var gradeString = ""
    var emailString = ""
    let sportController = SportModelController()
    var practiceDate = Date()


    //Join team and adds it to coredata
    @IBAction func joinTapped(_ sender: Any) {
        
        sportController.addMySport(name: teamString, grade: gradeString, coach: coachString, season: seasonString, practiceDate: practiceDate as NSDate, sponsor: sponsorString)
        joinButton.isEnabled = false
        joinButton.setTitle("Team Joined", for: .normal)
        
        
        
    }
    
    //Email setup
    @IBAction func contactTapped(_ sender: Any) {
        
        
        //Email
        if !MFMailComposeViewController.canSendMail() {
            showError()
            
        } else {
            
            let mail = configureMailController(email: emailString)
            self.present(mail, animated: true, completion: nil)
        }
        
        
    }
    
    //Setting up Email
    func configureMailController(email: String) -> MFMailComposeViewController {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([email])
        
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

    
    
}
