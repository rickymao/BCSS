//
//  TeacherContactTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import MessageUI

class TeacherContactTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
        


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //chosen department
    var currentDepartment: Department!
    var currentTeachers: [Teacher] {
        return getTeachers(department: currentDepartment)
    }
    
    
    //Get teachers depending on department
    func getTeachers(department: Department) -> [Teacher] {
        
        switch department {
            
        case .Mathematics: return [Teacher(name: "Ms. C. Acheson", email: "christal.acheson@burnabyschools.ca"), Teacher(name: "Mr. G. Hendry", email: "amanda.hemingway@burnabyschools.ca"), Teacher(name: "Mr. K. Herndier", email: "kevin.herndier@burnabyschools.ca"), Teacher(name: "Ms. M. Hnativ", email: "maryana.hnativ@burnabyschools.ca"), Teacher(name: "Ms. E. Huang", email: "erica.huang@burnabyschools.ca"), Teacher(name: "Mr. C. Kyle", email: "christian.kyle@burnabyschools.ca"), Teacher(name: "Ms. S. Lei", email: "sin-si.lei@burnabyschools.ca"), Teacher(name: "Mr. C. Leung", email: "chester.leung@burnabyschools.ca"), Teacher(name: "Ms. I. Penner", email: "irmgard.penner@burnabyschools.ca"), Teacher(name: "Ms. S. Wuolle", email: "suzanne.wuolle@burnabyschools.ca")]
            
        case .AppliedSkills: return [Teacher(name: "Mr. I. Adamu", email: "ibrahim.adamu@burnabyschools.ca"), Teacher(name: "Ms. G. Bains", email: "gurjot.bains@burnabyschools.ca"), Teacher(name: "Mr. B. Dunse", email: "bryan.dunse@burnabyschools.ca"), Teacher(name: "Ms. J. Eng", email: "judy.eng@burnabyschools.ca"), Teacher(name: "Mr. A. Fricker", email: "alex.fricker@burnabyschools.ca"), Teacher(name: "Ms. P. Jukes", email: "patti.jukes@burnabyschools.ca"), Teacher(name: "Mr. R. Kamiya", email: "randy.kamiya@burnabyschools.ca"), Teacher(name: "Ms. D. Kraemer", email: "donna.kraemer@burnabyschools.ca"), Teacher(name: "Mr. C. Kyle", email: "christian.kyle@burnabyschools.ca"), Teacher(name: "Mr. N. Manak", email: "naresh.manak@burnabyschools.ca"), Teacher(name: "Ms. M. Morabito-Chisholm", email: "maria.morabito@burnabyschools.ca"), Teacher(name: "Ms. K. Palosaari", email: "kristy.palosaari@burnabyschools.ca"), Teacher(name: "Ms. H. Parkes", email: "heather.parkes@burnabyschools.ca"), Teacher(name: "Mr. S. Wade", email: "stephen.wade@burnabyschools.ca"), Teacher(name: "Mr. I. Steko", email: "ivan.steko@burnabyschools.ca")]
            
        case .Sciences: return [Teacher(name: "Ms. T. Cordy-Simpson", email: "tara.cordy-simpson@burnabyschools.ca"), Teacher(name: "Mr. E. Bryan", email: "eric.byman@burnabyschools.ca"), Teacher(name: "Mr. G. Gertz", email: "graham.gertz@burnabyschools.ca"), Teacher(name: "Ms. A. Hemingway", email: "amanda.hemingway@burnabyschools.ca"), Teacher(name: "Ms. T. Hemer", email: "tarnjit.hemer@burnabyschools.ca"), Teacher(name: "Mr. M. Joe", email: "mingeat.joe@burnabyschools.ca"), Teacher(name: "Mr. P. Kim", email: "peter.kim@burnabyschools.ca"), Teacher(name: "Mr. B. Munro", email: "bruce.munro@burnabyschools.ca"), Teacher(name: "Ms. V. Pereira", email: "val.pereira@burnabyschools.ca"), Teacher(name: "Ms. Y.Yu", email: "yiwei.yu@burnabyschools.ca")]

            
        case .Services: return [Teacher(name: "Ms. C. Magriotidis", email: "catherine.magriotidis@burnabyschools.ca"), Teacher(name: "Ms. C. Chase", email: "corrina.chase@burnabyschools.ca"), Teacher(name: "Ms. L. Clauson", email: "leslie.clauson@burnabyschools.ca"), Teacher(name: "Ms. J. Ferraby", email: "jacqui.ferraby@burnabyschools.ca"), Teacher(name: "Ms. K. Gango", email: "kathy.gagno@burnabyschools.ca"), Teacher(name: "Ms. R. Jones", email: "rhiannon.jones@burnabyschools.ca"), Teacher(name: "Mr. V. Mann", email: "vijay.mann@burnabyschools.ca"), Teacher(name: "Mr. R. Mclean", email: "ryan.mclean@burnabyschools.ca"), Teacher(name: "Ms. I. Ranu", email: "inderjeet.ranu@burnabyschools.ca" ), Teacher(name: "Ms. L. Strong", email: "lisa.strong@burnabyschools.ca"), Teacher(name: "Ms. H. Welwood", email: "hannah.welwood@burnabyschools.ca"), Teacher(name: "Ms. R. Westinghouse", email: "rosa.westinghouse@burnabyschools.ca"), Teacher(name: "Mr. T. Lim", email: "tim.lim@burnabyschools.ca")]
            

            
        case .Socials: return [Teacher(name: "Ms. H. Keon", email: "holly.keon@burnabyschools.ca"), Teacher(name: "Ms. G. Campbell", email: "georgia.campbell@sd41.bc.ca"), Teacher(name: "Ms. D. Dunne", email: "dana.dunne@burnabyschools.ca"), Teacher(name: "Ms. H. Keon", email: "holly.keon@burnabyschools.ca"), Teacher(name: "Mr. C. Mah", email: "colin.mah@burnabyschools.ca"), Teacher(name: "Ms. D. Pereira", email: "diana.pereira@burnabyschools.ca"), Teacher(name: "Mr. R. Stamm", email: "raimund.stamm@burnabyschools.ca"), Teacher(name: "Ms. C. Uhren", email: "cindy.uhren@burnabyschools.ca"), Teacher(name: "Mr. I. Steko", email: "ivan.steko@burnabyschools.ca")]
            

            
        case .Languages: return [Teacher(name: "Ms. P. Ollivier", email: "penelope.ollivier@burnabyschools.ca"), Teacher(name: "Mr. V. Lagrange", email: "vincent.lagrange@burnabyschools.ca"), Teacher(name: "Ms. P. Neves", email: "patricia.neves@burnabyschools.ca"), Teacher(name: "Ms. P. Ollivier", email: "penelope.ollivier@burnabyschools.ca"), Teacher(name: "Mr. J. Pepler", email: "jesse.pepler@burnabyschools.ca"), Teacher(name: "Mr. J. Saggu", email: "jasper.saggu@burnabyschools.ca"), Teacher(name: "Ms. A. Zakas", email: "abigail.zakus@burnabyschools.ca"), Teacher(name: "Ms. Y. Yu", email: "yiwei.yu@burnabyschools.ca")]

            
        case .English: return [Teacher(name: "Ms. K. Payne", email: "kelly.payne@burnabyschools.ca"), Teacher(name: "Ms. G. Bains", email: "gurjot.bains@burnabyschools.ca"), Teacher(name: "Ms. K. Clinton", email: "katherine.clinton@burnabyschools.ca"), Teacher(name: "Ms. H. Couture", email: "hayley.couture@burnabyschools.ca"), Teacher(name: "Ms. G. D’angelo", email: "gina.dangelo@burnabyschools.ca"), Teacher(name: "Ms. S. Dhaliwal", email: "sonia.dhaliwal@burnabyschools.ca"), Teacher(name: "Ms. A. Inkster", email: "abra.inkster@burnabyschools.ca"), Teacher(name: "Ms. S. Tham", email: "sasha.tham@burnabyschools.ca"), Teacher(name: "Mr. E. Wan", email: "edison.wan@burnabyschools.ca")]

            
        case .ELL: return [Teacher(name: "Mr. K. Parbhakar", email: "kamal.parbhakar@burnabyschools.ca"), Teacher(name: "Mr. C. Anderson", email: "christian.anderson@burnabyschools.ca"), Teacher(name: "Ms. G. Bains", email: "gurjot.bains@burnabyschools.ca"), Teacher(name: "Ms. S. Dhaliwal", email: "sonia.dhaliwal@burnabyschools.ca")]

            
        case .LearningSupport: return [Teacher(name: "Ms. N. Zilkie", email: "nicole.zilkie@burnabyschools.ca"), Teacher(name: "Ms. S. Lee-wen", email: "suzanne.lee-wen@burnabyschools.ca"), Teacher(name: "Ms. C. Magriotidis", email: "catherine.magriotidis@burnabyschools.ca")]

            
        case .Arts: return [Teacher(name: "Ms. C. Taylor", email: "carrie.taylor@burnabyschools.ca"), Teacher(name: "Ms. C. Mann", email: "carol.mann@burnabyschools.ca"), Teacher(name: "Mr. R.Shier", email: "robin.shier@burnabyschools.ca"), Teacher(name: "Mr. M. Shumiatcher", email: "michael.shumiatcher@burnabyschools.ca"), Teacher(name: "Mr. A. Steko", email: "anto.steko@burnabyschools.ca")]

        
    
        case .Athletics: return [Teacher(name: "Ms. S. Digeso", email: "sadie.digeso@burnabyschools.ca"), Teacher(name: "Mr. G. Buono", email: "gianni.buono@burnabyschools.ca"), Teacher(name: "Mr. D. Einhorn", email: "danny.einhorn@burnabyschools.ca"), Teacher(name: "Mr. P. Kuhn", email: "paul.kuhn@burnabyschools.ca"), Teacher(name: "Mr. C. Preda", email:
            "cosmin.preda@burnabyschools.ca"), Teacher(name: "Ms. S. Snow", email: "sharon.snow@burnabyschools.ca"), Teacher(name: "Mr. A. Vagnarelli", email: "andrew.vagnarelli@burnabyschools.ca")]
            
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return getTeachers(department: currentDepartment).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath)
        let index = indexPath.row
        cell.textLabel?.text = currentTeachers[index].teacherName
        
        

        // Configure the cell...
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Email
        if !MFMailComposeViewController.canSendMail() {
            showError()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
        
            let mail = configureMailController(email: currentTeachers[indexPath.row].teacherEmail)
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
