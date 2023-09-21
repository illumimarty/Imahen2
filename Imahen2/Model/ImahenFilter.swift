//
//  ImahenFilter.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/21/23.
//

import Foundation
import UIKit

struct ImahenFilter {
    var name: String?
    var previewImg: UIImage?
    var filter: CIFilter?
    
    init(name: String!, previewImg: UIImage!, filter: CIFilter? = nil) {
        self.name = name
        self.previewImg = previewImg
        self.filter = filter
    }
    
    func applyFilter(from image: UIImage) {
        
    }
    
    func removeFilter(from image: UIImage) {
        
    }
}

struct ImahenFilterCategory {
    var name: String?
    var icon: UIImage?
    var filters: [ImahenFilter]?
    
    init(name: String? = nil, icon: UIImage? = nil, filters: [ImahenFilter]? = nil) {
        self.name = name
        self.icon = icon
        self.filters = filters
    }
}
