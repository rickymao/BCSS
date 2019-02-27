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
        clubs = [Club(name: "Coding", teacher: "Ms. Kim", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 6)], room: "B314", owner: "Ricky Mao, Ritchie Xia",desc: "Coding Club meets up at lunch each week to learn about programming and computer science.  Students get to learn languages like Java, Swift, and more. We also explore the details of computer science from each lesson and activities. In the end, we strive to ensure each student is fluent in programming and the foundation of computer science, so they can utilize our skills in the real world.",email: ["maxbox8899@gmail.com"]),
                
                     
                 Club(name: "Track and Field", teacher: "Mr. Kamiya", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 2), createDate(hours: 15, minutes: 0, dayOfTheWeek: 4), createDate(hours: 15, minutes: 0, dayOfTheWeek: 6)], room:"Field", owner: "Daniel Yu",desc: "This club currently has no description. ", email: ["daniel2001yu@gmail.com"]),
                     
                 Club(name: "Yearbook Club", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 2)], room: "B203", owner: "Angie Soberanis", desc:"This club currently has no description. ", email: ["anysoberanis5@gmail.com"]),
                     
                 Club(name: "First Aid", teacher: "N/A", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 2), createDate(hours: 15, minutes: 0, dayOfTheWeek: 5)], room: "B233", owner: "Catherine Hsu", desc:"This club currently has no description. ", email: ["ctrhsu@gmail.com"]),
                     
                 Club(name: "Peace And Wellness Society (P.A.W.S.)", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C232", owner: "Jasmine Kainth, James Iglesias", desc:"P.A.W.S. is a student led club dedicated to promoting healthy minds at Burnaby Central.Students work together to promote many different initiatives, such as: organizing and participating in intra-murals, guest speakers, yoga classes,  dance parties, work with assistance animals, etc. Our goal is to promote healthy living all year long.", email: ["jasminekainth2010@gmail.com"]),
                     
                 Club(name: "Interact Club", teacher: "Mrs. Eng", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "B208", owner: "Trinity Troung, Ricky Mao", desc:" Interact Club is a high school community based club sponsored by Deerlake's Rotary Club. Our focus as a club is to help make our community a better place, and to make a difference. We are a part of many volunteer events, and fundraisers for organizations. Our focus as a club is to help make our community a better place, and to make a difference. We want to give our students the opportunity to give back to their communities, grow as individuals, and connect with others. That is our objective of this year's Burnaby Central Interact Club.", email: ["wildcats.interact@gmail.com"]),
                     
                 Club(name: "Green Club", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C233", owner: "Aidan Labreche, Cindy Heller", desc:"Green club is conscientiously concerned about the future of our planet. Our actions are in an attempt to heal the environment on a small scale. Our focus this year will be on going green with pen recycling in the school and saving the bees with spring flower planting.", email: ["aejlab5@gmail.com", "cindyroseheller@gmail.com"]),
                     
                 Club(name: "Central’s Autism Network", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "C329", owner: "Sharleen Sasis, Katrina Ly", desc:"Central Autism Network’s focus is to raise funds for individuals, families and friends who are affected by autism. We strive to broaden awareness and understanding of autism, in hopes of creating more of an inclusive environment, where these individuals feel comfortable, accepted, and supported in various communities.", email: ["sharleen_sasis@gmail.com"]),
                     
                 Club(name: "Business Club", teacher: "Mr. Kamiya", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 3)], room: "B206", owner: "Wasay Hayat", desc:" Central's Business Club is committed to engaging students in hands-on experiences in organizing sales and events throughout the year. Our goal is to allow everyone to take on a leadership role, gain more exposure to the business world, and learn how to make a tonne of money while having a tonne of fun.", email: ["bcssbusiness@gmail.com"]),
                     
                 Club(name: "United Nations Connections Club", teacher: "N/A", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 3)], room: "Library", owner: "Jem Zheng, Ruby Yang", desc:"This club currently has no description. ", email: ["burnabyuncc@gmail.com, mettatonsneo@gmail.com"]),
                     
                 Club(name: "BCSS Robotics Club", teacher: "N/A", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 3), createDate(hours: 15, minutes: 0, dayOfTheWeek: 5)], room: "B127", owner: "Foysal Arian", desc:" In Robotics club, we learn about coding, software, and other parts of technology as we apply the technology side of STEM. We also build robots from the ground up and take them to competitions throughout the lower mainland.", email: ["foysal2002@gmail.com"]),
                     
                 Club(name: "W.I.S.H. Club", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "C226", owner: "Alyana Lalani, Xenya Vasiu", desc:"The World In Students Hands (W.I.S.H.) Club is associated with the WE Movement and focuses on helping solve pressing global and local humanitarian issues.  Each year, we select an international goal to raise funds for based on the Five Pillars of WE Villages: Opportunity, Food, Clean Water, Health and Education.  This year, we are focusing our efforts on creating more sustainable income opportunities for villages in Kenya. We support a local charity each year as well. In the past, we have donated funds to Canuck Place and the Alzheimer Society of BC.  We raise proceeds for our goals by holding fundraisers such as delivering candygrams during Christmas and selling chocolate covered strawberries on Valentine's Day.  We also support the Greater Vancouver Food Bank Society each year by collecting nonperishable food items instead of candy on Halloween. With the world in our students' hands, we are working to shift ME into WE.", email: ["xenya.vasiu@gmail.com"]),
                     
                 Club(name: "International Club", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "B209", owner: "Lucas Soares", desc:"The International Club organizes, promotes and supports cultural, and social activities representing its members who are from diverse cultures and countries. All Burnaby Central students are welcome to join and meet other students during our weekly lunchtime meetings. This year, we are featuring movies including Big Hero 6 and Avengers: Infinity Wars.", email: ["lucassoaresdeoliveira@gmail.com"]),
                     
                 Club(name: "Sexual Orientation and Gender Identity", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "C330", owner: "Areesa Kassam", desc:"SOGI (Sexual Orientation and Gender Identity): We support all students regardless of their sexual orientation or identity. SOGI believes in creating an inclusive and accepting environment in our school, and a safe space for LGBTQ2+ people and our straight allies.  We meet in room C330 at lunch on Wednesdays", email: ["areesa.kassam@gmail.com"]),
                     
                 Club(name: "Beyond STEM", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 4)], room: "B306", owner: "Catherine Hsu", desc: "Beyond STEM is a team of determined students with the mission of influencing and encouraging youth to find their passions in STEM. From genome editors to quantitative analysts,we strive to introduce to the vast variety of occupations in these fields! We hold fairs and conferences throughout the academic year to spread the love for STEM.", email: ["beyondstem@gmail.com"]),
                     
                     Club(name: "Kpop Club", teacher: "N/A", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 4)], room: "Dance", owner: "Trang Lam, Grace Kan", desc:"This club currently has no description. ", email: ["tranglam111@gmail.com"]),
                     
                     Club(name: "Cross Country", teacher: "N/A", meeting: [createDate(hours: 15, minutes: 0, dayOfTheWeek: 4)], room: "Field", owner: "Daniel Yu, Kate O’Shea, Tyler Chai", desc:"This club currently has no description. ", email: ["katevoshea@gmail.com"]),
                     
                     Club(name: "Senior Math Club", teacher: "N/A", meeting: [createDate(hours: 12, minutes: 0, dayOfTheWeek: 5)], room: "B302", owner: "Jason Shin, Mark Shin", desc:"This club currently has no description. ", email: ["seokhoonshin@gmail.com"])
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
