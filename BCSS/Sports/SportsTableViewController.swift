//
//  SportsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-19.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SportsTableViewController: UITableViewController {

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

        //Retrieve Data
        getDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sports
    let dateFormat = DateFormatter.init()
  var sports: [Sports] = [ // Sports(name: "Badminton", coach: ["Mr. Choi", "Kevin Chen", "Kayla Yu"], teacher: "Ms. Keon", season: "Spring", meeting: Date(), grade: "", email: "holly.keon@burnabyschools.ca"),
//
//        Sports(name: "Ball Hockey", coach: ["Ask PE Department"], teacher: "Mr. Anderson", season: "Spring", meeting: Date(), grade: "", email: "christian.anderson@burnabyschools.ca"),
//
//        Sports(name: "Grade 8 Boys Basketball", coach: ["Ask PE Department"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "", email: "andrew.vagnarelli@burnabyschools.ca"),
//
//        Sports(name: "Grade 8 Girls Basketball", coach: ["Mr. R. MacLean", "Elva Yu", "Maneesha Dhaliwal"], teacher: "MR.R.MacLean", season: "Winter", meeting: Date(), grade: "", email: "ryan.maclean@burnabyschools.ca"),
//
//        Sports(name: "Grade 9 Boys Basketball", coach: ["Mr. Stephens"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "", email: "andrew.vagnarelli@burnabyschools.ca"),
//
//        Sports(name: "Grade 10 Boys Basketball", coach: ["Mr. M. Levajac"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "Grade 10 Boys", email: "milan.levajic16@gmail.com"),
//
//        Sports(name: "Grade 9/10 Girls/Boys Basketball", coach: ["Mr. M. Magus"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "Grade 9/10 Girls Boys", email: "exit33@shaw.ca"),
//
//        Sports(name: "Senior Boys Basketball", coach: ["Mr. D. Coleman"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "", email: "doncoleman@shaw.ca"),
//
//        Sports(name: "Senior Girls Basketball", coach: ["Mr. P. VanDenHoogen", "Mr. C. Ducharme"], teacher: "Ask PE Department", season: "Winter", meeting: Date(), grade: "", email: "peter.vandenhoogen@sd41.bc.ca"),
//
//        Sports(name: "Cross Country", coach: ["Mr. D. Einhorn"], teacher: "Mr. Einhorn", season: "Fall", meeting: Date(), grade: "", email: "danny.einhorn@burnabyschools.ca"),
//
//        Sports(name: "Cricket", coach: ["Lovereet Chauhan"], teacher: "Ask PE Department", season: "Spring", meeting: Date(), grade: "", email: "Ask PE Department"),
//
//        Sports(name: "Field Hockey", coach: ["Mrs. deSousa"], teacher: "Ask PE Department", season: "Ask PE Department", meeting: Date(), grade: "", email: "Ask PE Department"),
//
//        Sports(name: "Golf", coach: ["Mr. K. Hendier", "Mr. E. Byman"], teacher: "Mr. K. Herndier", season: "Spring", meeting: Date(), grade: "", email: "kevin.herndier@burnabyschools.ca"),
//
//        Sports(name: "Netball", coach: ["F.Hoq", "Indigo Chow"], teacher: "Ask PE Department", season: "Spring", meeting: Date(), grade: "", email: "andrew.vagnarelli@burnabyschools.ca"),
//
//        Sports(name: "Grade 8/9 Boys Rugby", coach: ["Mr. A. Vagnarelli", "Mr. B. Dunse", "Mr. P. Kuhn"], teacher: "Mr. B. Dunse", season: "Fall", meeting: Date(), grade: "", email: "andrew.vagnarelli@burnabyschools.ca"),
//
//        Sports(name: "Junior/Senior Rugby", coach: ["Mr. A. Vagnarelli", "Mr. B. Dunse"], teacher: "Mr. B. Dunse", season: "Spring", meeting: Date(), grade: "", email: "brian.dunse@burnabyschools.ca"),
//
//        Sports(name: "Junior Boys Soccer", coach: ["Mr. A. Steko"], teacher: "Mr. A. Steko", season: "Fall", meeting: Date(), grade: "", email: "anto.steko@burnabyschools.ca"),
//
//        Sports(name: "Junior Girls Soccer", coach: ["Mr. A. Steko"], teacher: "Mr. A. Steko", season: "Spring", meeting: Date(), grade: "", email: "anto.steko@burnabyschools.ca"),
//
//        Sports(name: "Senior Boys Soccer", coach: ["Mr. A. Steko", "Mr. I. Adamu"], teacher: "Mr. A. Steko", season: "Fall", meeting: Date(), grade: "", email: "anto.steko@burnabyschools.ca"),
//
//        Sports(name: "Senior Girls Soccer", coach: ["Mr. A. Steko"], teacher: "Mr. A. Steko", season: "Spring", meeting: Date(), grade: "", email: "anto.steko@burnabyschools.ca"),
//
//        Sports(name: "Swim", coach: ["Mrs. E. Lin"], teacher: "Ask PE Department", season: "Fall", meeting: Date(), grade: "", email: "ericalin1314@gmail.com"),
//
//        Sports(name: "Track & Field", coach: ["Mr. Kamiya"], teacher: "Mr. Kamiya", season: "Spring", meeting: Date(), grade: "", email: "randy.kamiya@burnabyschools.ca"),
//
//        Sports(name: "Ultimate", coach: ["Ms. M. Wright"], teacher: "Ask PE Department", season: "Spring", meeting: Date(), grade: "", email: "morganw@sfu.ca"),
//
//        Sports(name: "Wrestling", coach: ["Mr. G. Buono", "Mr. D. Einhorn"], teacher: "Mr.G.Buono", season: "Winter", meeting: Date(), grade: "", email: "gianni.buono@burnabyschools.ca"),
//
//        Sports(name: "Grade 8 Boys Volleyball", coach: ["Mr. Hendry", "Emily Wong", "Alysha Sidhu", "Denise Wong", "Anna Yang", "Leah Fernandes"], teacher: "Mr. Hendry", season: "Spring", meeting: Date(), grade: "", email: "graham.hendry@burnabyschools.ca"),
//
//        Sports(name: "Grade 9 Boys Volleyball", coach: ["Ask PE Department"], teacher: "Ask PE Department", season: "Spring", meeting: Date(), grade: "", email: "andrew.vagnarelli@burnabyschools.ca"),
//
//        Sports(name: "Grade 8 Girls Volleyball", coach: ["Cassie Chan", "Arika Lee", "Gurneet Sidhu", "Cynthia Gu", "Nikolia Jutric"], teacher: "Mr. R. MacLean", season: "Fall", meeting: Date(), grade: "", email: "ryan.mclean@burnabyschools.ca"),
//
//
//        Sports(name: "Grade 9 Girls Volleyball", coach: ["Mykaela Lee", "Sophie Virani"], teacher: "Mrs. S. Dhaliwal", season: "Fall", meeting: Date(), grade: "", email: "sonia.dhaliwal@burnabyschools.ca"),
//
//          Sports(name: "Junior Boys Volleyball", coach: ["Jamil Minhas", "Connor Jung", "Ronin Sakamoto"], teacher: "Mr. Hendry", season: "Fall", meeting: Date(), grade: "", email: "graham.hendry@burnabyschools.ca"),
//
//        Sports(name: "Junior Girls Volleyball", coach: ["Mr. J. Wong"], teacher: "Ask PE Department", season: "Fall", meeting: Date(), grade: "", email: "jwong2627@gmail.com"),
//
//        Sports(name: "Senior Boys Volleyball", coach: ["Mr. B. Veeken"], teacher: "Ask PE Department", season: "Fall", meeting: Date(), grade: "", email: "brennan.veeken@burnabyschools.ca"),
//
//        Sports(name: "Senior Girls Volleyball", coach: ["Mrs. S. Snow"], teacher: "Mrs. S. Snow", season: "Fall", meeting: Date(), grade: "", email: "sharon.snow@burnabyschools.ca")

]
    
    func getDatabase() {
        
        
        let ref = Database.database().reference()
        
        ref.child("sportKeyed").observe(.value) { (snapshot) in
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let name = snapshotJSON.childSnapshot(forPath: "Name").value as! String
                    let coach = snapshotJSON.childSnapshot(forPath: "Coach").value as! String
                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    let season = snapshotJSON.childSnapshot(forPath: "Season").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String

                        //Adding to array
                        self.sports.append(Sports(name: name, coach: coach, teacher: teacher, season: season, email: email))
                    
                }
                
                
            }
            self.tableView.reloadData()
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoSportController = segue.destination as! InfoSportsTableViewController
        if let index = tableView.indexPathForSelectedRow?.row {
        let currentSport = sports[index]

        
        //Setting up text
        infoSportController.teamString = currentSport.name
        infoSportController.coachString = currentSport.coach
        infoSportController.seasonString = currentSport.season
        infoSportController.sponsorString = currentSport.teacher
        infoSportController.emailString = currentSport.email
            
        
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath)
        
        let index = indexPath.row
        cell.textLabel?.text = "\(sports[index].name) Team"
        return cell
    }

}
