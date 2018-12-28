//
//  InfoSportsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-20.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import MessageUI

class InfoSportsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let persistenceManager = PersistenceManager.shared
    let context = PersistenceManager.shared.context

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Team"
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Setting up text
        teamName.text = "\(teamString) Team"
        coachNames.text = "Coaches: \(coachString)"
        sponsorTeacher.text = "Sponsor: \(sponsorString)"
        season.text = "Season: \(seasonString)"
        
        //Checking if student joined the team
        do {
            if let teams = try persistenceManager.context.fetch(Team.fetchRequest()) as? [Team] {
                checkTeams: for team in teams {
                    
                    if team.sport == teamString {
                        
                        joinButton.isEnabled = false
                        joinButton.setTitle("Team Joined", for: .normal)
                        break checkTeams;
                    }
                    else {
                        joinButton.isEnabled = true
                        joinButton.setTitle("Join Team", for: .normal)
                        
                    }
                    
                }
            }
        } catch {
            print(error)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var coachNames: UILabel!
    @IBOutlet weak var sponsorTeacher: UILabel!
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var grades: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    var teamString = ""
    var coachString = ""
    var sponsorString = ""
    var seasonString = ""
    var gradeString = ""
    var emailString = ""
    var practiceDate = Date()


    @IBAction func joinTapped(_ sender: Any) {
        
        let team = Team(context: context)
        team.sport = teamString
        team.grade = gradeString
        team.coach = coachString
        team.season = seasonString
        team.teacher = sponsorString
        team.practiceTime = practiceDate as NSDate
        persistenceManager.save()
        
        joinButton.isEnabled = false
        joinButton.setTitle("Team Joined", for: .normal)
        
        
        
    }
    
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
