//
//  ClubTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-18.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit


class ClubTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up clubs
        clubs = [Club(name: "Computer", teacher: "Ms. Wuolle", meeting: [createDate(hours: 10, minutes: 35, dayOfTheWeek: 7), createDate(hours: 12, minutes: 35, dayOfTheWeek: 1)], room: "B314", owner: "Ricky Mao",desc: "A club about computers.",email: "maxbox8899@gmail.com"),
                
                     
                 Club(name: "Track and Field", teacher: "Mr. Kamiya", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 2), createDate(hours: 15, minutes: 0, dayOfTheWeek: 4), createDate(hours: 15, minutes: 0, dayOfTheWeek: 6)], room:"Field", owner: "Daniel Yu",desc:"A club about Track and Field", email: "daniel2001yu@gmail.com"),
                     
                     Club(name: "Yearbook Club", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 2)], room: "B203", owner: "Angie Soberanis", desc:"A club about Year Book", email: "anysoberanis5@gmail.com"),
                     
                     Club(name: "First Aid", teacher: "", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 2), createDate(hours: 15, minutes: 0, dayOfTheWeek: 5)], room: "B233", owner: "Catherine Hsu", desc:"A club about First Aid", email: "ctrhsu@gmail.com"),
                     
                     Club(name: "Peace And Wellness Society (P.A.W.S.)", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C232", owner: "Jasmine Kainth, James Iglesias", desc:"A club about Peace And Wellness Society", email: "jasminekainth2010@gmail.com"),
                     
                     Club(name: "Interact Club", teacher: "Mrs. Eng", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "B208", owner: "Trinity Troung, Ricky Mao", desc:"A club about Interact Club", email: "wildcats.interact@gmail.com"),
                     
                     Club(name: "Green Club", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C233", owner: "Aidan Labreche, Cindy Heller", desc:"A club about Green Club", email: "aejlab5@gmail.com, cindyroseheller@gmail.com"),
                     
                     Club(name: "Central’s Autism Network", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C329", owner: "Sharleen Sasis, Katrina Ly", desc:"A club about Central’s Autism Network", email: "sharleen_sasis@gmail.com, katrinaly62@gmail.com"),
                     
                     Club(name: "Business Club", teacher: "Mr. Kamiya", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "B206", owner: "Wasay Hayat", desc:"A club about Business Club", email: "bcssbusiness@gmail.com"),
                     
                     Club(name: "United Nations Connections Club", teacher: "", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 3)], room: "Library", owner: "Jem Zheng, Ruby Yang", desc:"A club about United Nations Connections Club", email: "burnabyuncc@gmail.com, mettatonsneo@gmail.com"),
                     
                     Club(name: "BCSS Robotics Club", teacher: "", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 3), createDate(hours: 15, minutes: 0, dayOfTheWeek: 5)], room: "B127", owner: "Foysal Arian", desc:"A club about BCSS Robotics Club", email: "foysal2002@gmail.com"),
                     
                     Club(name: "W.I.S.H. Club", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "C226", owner: "Alyana Lalani, Xenya Vasiu", desc:"A club about W.I.S.H. Club", email: "xenya.vasiu@gmail.com"),
                     
                     Club(name: "International Club", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "B209", owner: "Lucas Soares", desc:"A club about International Club", email: "lucassoaresdeoliveira@gmail.com"),
                     
                     Club(name: "Sexual Orientation and Gender Identity", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "C330", owner: "Areesa Kassam", desc:"A club about Sexual Orientation and Gender Identity", email: "areesa.kassam@gmail.com"),
                     
                     Club(name: "Beyond STEM", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "B306", owner: "Catherine Hsu", desc:"A club about Beyond Stem", email: "beyondstem@gmail.com"),
                     
                     Club(name: "Kpop Club", teacher: "", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 4)], room: "Dance", owner: "Trand Lam, Grace Kan", desc:"A club about Kpop Club", email: "tranglam111@gmail.com"),
                     
                     Club(name: "Cross Country", teacher: "", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 4)], room: "Field", owner: "Daniel Yu, Kate O’Shea, Tyler Chai", desc:"A club about Cross Country", email: "katevoshea@gmail.com"),
                     
                     Club(name: "Senior Math Club", teacher: "", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 5)], room: "B302", owner: "Jason Shin, Mark Shin", desc:"A club about Math", email: "seokhoonshin@gmail.com")
]
        
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    

    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setting up club info page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let clubInfoController = segue.destination as! InfoClubTableViewController
        
        if let myIndex = tableView.indexPathForSelectedRow?.row {
        clubInfoController.nameTable = "\(clubs[myIndex].name) Club"
        clubInfoController.teacherTable = "Sponsor: \(clubs[myIndex].teacher)"
            clubInfoController.dateTable = clubs[myIndex].meetingDates
        clubInfoController.roomTable = "Room: \(clubs[myIndex].room)"
        clubInfoController.ownerTable = "President: \(clubs[myIndex].clubOwner)"
        clubInfoController.descTable = clubs[myIndex].description
        clubInfoController.emailTable = clubs[myIndex].email
        
        }
        
    
    }
    
    
    
    //Clubs
    var dateFormat = DateFormatter()
    var clubs: [Club] = []
    
    func createDate(hours: Int, minutes: Int, dayOfTheWeek: Int) -> Date {
        
        //Reminder - The week starts at 1 to 7 (Sunday to Saturday)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var date = DateComponents()
        date.weekday = dayOfTheWeek
        date.hour = hours
        date.minute = minutes
        
        let next = calendar.nextDate(after: Date(), matching: date, matchingPolicy: .strict)

        print(DateFormatter.localizedString(from: next!, dateStyle: .short, timeStyle: .short))
        return next!
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell", for: indexPath)

        // Configure the cell...
        let index = indexPath.row
        cell.textLabel?.text = "\(clubs[index].name)"
        cell.detailTextLabel?.text = "Sponsor Teacher: \(clubs[index].teacher)"

        return cell
    }
    
}
