//
//  TeacherModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class TeacherModelController {
    
    private var teacher: Teacher?
    
    init() {}
    
    init(teacher: Teacher) {
        self.teacher = teacher
    }
    
    //Gets teachers from coredata
    func getTeacherCollection(completion: @escaping ([Teacher]?)->Void) {
        
        let ref = Database.database().reference()
        
        ref.child("teacherKeyed").observeSingleEvent(of: .value) { (snapshot) in
            
            var teachers: [Teacher] = []
            
            var lastName: String
            var firstName: String
            var email: String
            var department: String?
            var type: String
            var homeroom: String?
            
            //Collecting all filtered snapshots
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    lastName = snapshotJSON.childSnapshot(forPath: "LegalLast").value as! String
                    firstName = snapshotJSON.childSnapshot(forPath: "LegalFirst").value as! String
                    email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    department = snapshotJSON.childSnapshot(forPath: "Department").value as? String
                    type = snapshotJSON.childSnapshot(forPath: "Type").value as! String
                    homeroom = snapshotJSON.childSnapshot(forPath: "homeroom").value as? String
                    let fullName = firstName + " " + lastName
                    
                    
                    teachers.append(Teacher(name: fullName, email: email, department: department, type: type, homeroom: homeroom))
                    
                }
                
            }
            completion(teachers)
        }
        
        
        
        
        
        
    }
    
    //Gets the department in the school
    func getDepartment(department: Department) -> String {

        switch department {
            
        case .Mathematics: return "Mathematics"

        case .AppliedSkills: return "Applied Skills"
            
        case .Sciences: return "Sciences"

        case .StudentServices: return "Student Services and Counsellors"

        case .SocialStudies: return "Social Studies"

        case .Languages: return "Languages"

        case .English: return "English"
            
        case .ELL: return "ELL"

        case .LearningSupport: return "Learning Support"

        case .Arts: return "Arts"

        case .Athletics: return "Athletics"
            
        case .Administration: return "Administration"
    
            
        }
        
        
    }
    
    //
    
    
}
