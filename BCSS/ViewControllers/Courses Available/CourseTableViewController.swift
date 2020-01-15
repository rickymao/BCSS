//
//  CourseTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-24.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class CourseTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Set nav-bar text colour
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchCourse: UISearchBar!
    
    //VARIABLES
    var courseSection = ["English 8","Math 8","Science 8","English 9","English 10: Literary Studies & Spoken Language","English 10: Literary Studies & Creative Writing","English 10 First Peoples: Writing and Literature","English 10 ELL: Composition & Spoken Language","English 11","English 12","English Literature 12","Communications 12","ELL 1: Language & Literacy","ELL 1: Cultural Studies","ELL 1: Science Applications","ELL 1: Technical & Applied","ELL 2: Language & Literacy","ELL 2: Cultural Studies","ELL 2: Science Applications","Science 8","Science 8 Enriched","Science 9","Science 9 Enriched","Science 10","Science 10 Enriched","Biology 11","Chemistry 11","Physics 11","Earth Science 11","Biology 11 Enriched","Biology 12 Enriched","Biology 12","Chemistry 12","Physics 12","Social Studies 8","Social Studies 9","Social Studies 10","Social Studies 10: ELL","Social Studies Exploration 11","Psychology 11","Psychology 12","20th Century World History 12","BC First Peoples 12","Economics 12","Law Studies 12","Human Geography 12","Philosophy 12","Social Justice 12","Global and Intercultural Studies 12","Mathematics 8","Mathematics 8 Enriched","Mathematics 9","Mathematics 9 Honors","Foundations of Math & Pre-Calc 10","Foundations of Math & Pre-Calc 10 Honours","Workplace Math 10","Foundations of Math 11","Pre Calculus 11","Pre Calculus 11 Honours","Apprenticeship Workplace Math 11","Foundations of Math 12","Pre Calculus 12","Calculus 12","French 8","French 9","Mandarin 9","Japanese 9","Spanish 9","German 9","French 10","French 10 Honours","Mandarin 10","Spanish 10","Japanese 10","Italian 10","Croatian 10","Punjabi 10","Korean 10","French 11","French 11 Honours","Mandarin 11","Introductory Mandarin 11","Japanese 11","Introductory Japanese 11","Spanish 11","Introductory Spanish 11","Italian 11","Introductory Italian 11","Croatian 11","Introductory Croatian 11","Punjabi 11","Introductory Punjabi 11","Korean 11","Introductory Korean 11","French 12","Mandarin 12","Japanese 12","Spanish 12","Italian 12","Croatian 12","Punjabi 12","Korean 12","Dance 8 (Part of Rotation)","Dance 9","Dance 10: Technique & Performance","Dance 11: Performance","Dance 12: Performance","Drama 8 (Part of Rotation)","Drama 9","Theatre Company 9","Drama 10: General","Theatre Company 10","Theatre Company 11","Theatre Performance 11: Acting","Theatre Performance 12: Acting", "Theatre Performance 12: Directing & Script Development","Theatre Company 12","Improvisation 10, 11, 12","Art 8 (Part of Rotation)","Art 9","Art Studio 10","Media Arts 10","Art Foundations 11","Studio Arts 11: Drawing & Painting","Studio Arts 11: Graphics","Studio Arts 11: Cermics & Sculpture","Visual Arts:Media Arts","Photography 11","Art Foundations 12", "Studio Arts 12: Drawing & Painting","Studio Arts 12: Graphics","Studio Arts 12: Ceramics & Sculpture","Visual Arts 12: Media Arts","Photography 12","Music 8: Concert Choir","Music 8: Beginner Band","Music 8: Band","Music 9: Concert Choir","Music 9: Beginner Band","Music 9: Band","Music 9: Chamber Choir A","Music 9: Chamber Choir B","Music 10: Chamber Choir A","Music 10: Chamber Choir B","Music 10: Concert Choir","Music 10: Concert Band","Music 10: Jazz Band","Music 11: Concert Choir","Music 11: Concert Band","Music 11: Jazz Band","Music 11: Chamber Choir A","Music 11: Chamber Choir B","Music 12: Concert Choir","Music 12: Chamber Choir A","Music 12: Chamber Choir B","Music 12: Concert Band","Music 12: Jazz Band","Technology 8 (Part of Rotation)","Drafting & Robotics 9","Electronics & Robotics","Transpower & Energy 9","Woodworking 9","Drafting & Design 10","Electronics 10","Mechanics 10","Woodworking 10","Creative Wood Art Metal 10","Drafting & Design 11","Electronics 11","Automotive Technology 11","Electronics 11","Automotive Technology 11","Carpentry & Joinery 11: Woodwork","Creative Wood Art Mental 11","Drafting & Design 12","Electronics 12","Automotive Technology 12","Automotive Technology 12: Engine & Drive Train","Carpentry & Joinery 12: Woodwork","Carpentry & Joinery 12: Furniture","Creative Wood Art Mental 12","Business technology 8 (Part of Rotation)","Computer Apps 9","Computer Apps 9 Advanced","Business Ventures 9","Business Ventures 10","Digital Business Communications 11","Accounting 11","Marketing 11","Video Production 11","Yearbook 12","Financial Accounting 12","Marketing 12","Video Production 12 Advanced","Home Economics 8 (Part of Rotation)","Home Ec 9: Food & Nutrition","Home Ec 9: Textile Studies","Home Ec 10: International Foods","Home Ec 10: Textiles Studies","Culinary Studies 10","Food & Nutrition 11","Baking 11","Culinary Studies 11","Food and Catering 11","Textiles Studies 11","Child / Youth Education 11","Food & Nutrition 12","Culinary Studies 12","Food and Catering 12","Food and Catering 12","textiles Studies 12","Child / Youth Education 12","Physical & Health Education 8","Physical & Health Education 9","Physical Education 9 Leadership","Physical & Health Education 10","Physical Education 10 Leadership", "Sports Specific Conditioning 10","Physical Education 11","Sports Specific Conditioning 11","Weight Training 11","Physical Education 12","Sports Specific Conditioning 12","Weight Training 12","Career Life Education 10","AP 2-D Design Portfolio 12","AP 3-D Design Portfolio 12","AP Studio Art: Drawing 12","AP Art History 12","AP Biology 12","AP Calculus 12 AB","AP Statistics 12","AP Microeconomics 12","AP Computer Science A 12","AP French Language 12","AP Chinese Language/Culture 12","AP English Literature & Comp 12","AP Psychology 12","Leadership 9","Leadership 10","Leadership 11","Leadership 12","First Aid 11","Office Administration 11: Counselling","Office Administration 11: Technology","Peer tutoring 11","Peer Tutoring 12","Applications of Leadership 11: Tech","Applications of Leadership 11: PE","Applications of Leadership 11: Music","Applications of Leadership 12: Tech","Applications of Leadership 12: PE","Applications of Leadership 12: Music","Career Preparation 11","Career Preparation 12","Industry Training Programs" ]
    var courseFiltered = [String]()
    var isFilter = false
    

    // MARK: - Table view data source

    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFilter {
            return courseFiltered.count
        } else {
            return courseSection.count
        }
    }

    
    //Shows each course available on tableview
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)

        // Sets text to the class name
        var cellText: String
        if isFilter {
            cellText = courseFiltered[indexPath.row]
        } else {
            cellText = courseSection[indexPath.row]
        }
        cell.textLabel?.text = cellText

        return cell
    }
    
    //Search Bar filtering
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { courseFiltered = courseSection; tableView.reloadData(); return}
        courseFiltered = courseSection.filter({ $0.lowercased().contains(searchText.lowercased())
        })
        isFilter = true
        tableView.reloadData()
    }
    

}
