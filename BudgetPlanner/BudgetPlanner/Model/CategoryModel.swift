//
//  CategoryModel.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/2/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    var imageName = ""
    var type = ""
    var name = ""
    
    func create(imageName: String, type: String, name: String) ->  CategoryModel {
        self.imageName = imageName
        self.type = type
        self.name = name
        return self
    }
}
