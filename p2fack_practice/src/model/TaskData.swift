//
//  TaskData.swift
//  p2fack_practice
//
//  Created by Fuuya Yamada on 2019/02/16.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit

class TaskData{
    var day:Date = Date()
    var name:String = ""
    
    let kday = "DAY"
    let kname = "NAME"
    
    init() {
        
    }

    init(day: Date, name: String) {
        self.day = day
        self.name = name
    }
    
    init(dictionary:[String:Any] ) {
        day = dictionary[kday] as! Date
        name = dictionary[kname] as! String
    }
    
    func dictionaryFromTask() -> [String:Any]{
        return [kday : day, kname : name]
    }
    
}
