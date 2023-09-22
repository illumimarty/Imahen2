//
//  ImahenFilter.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/21/23.
//

import Foundation
import UIKit
import CoreImage

struct ImahenFilter {
    var name: String?
    var previewImg: UIImage?
    var filter: CIFilter?
    var key: String?
    
    init(name: String!, previewImg: UIImage!, filter: CIFilter? = nil) {
        self.name = name
        self.previewImg = previewImg
        self.filter = filter
    }
    
    func applyFilter(from image: UIImage?, with val: Any) -> UIImage? {
        guard let image = prepareImage(image) else { return nil }
        return processImage(image, val)
    }
    
    func removeFilter(from image: UIImage) {
        
    }
    
    func prepareImage(_ img: UIImage?) -> CIImage? {
        guard let img = img,
              let cgimg = img.cgImage else {
            print("no image found")
            return nil
        }
        let preprocessedImage = CIImage(cgImage: cgimg)
        self.filter?.setValue(preprocessedImage, forKey: kCIInputImageKey)
        return preprocessedImage
    }
    
    func processImage(_ img: CIImage, _ val: Any) -> UIImage! {
        var processedImage: UIImage? = nil
        let context = CIContext()
        guard let image = self.filter?.outputImage else { return nil }
        if let key = self.key {
            filter?.setValue(val, forKey: key)
        }
        
        if let cgimg = context.createCGImage(image, from: image.extent) {
            processedImage = UIImage(cgImage: cgimg)
        }
        
        return processedImage
    }
}

struct ImahenFilterCategory {
    enum filterCategory {
        case filter
        case enhance
        case advanced
        case none
    }
    
    var name: String?
    var iconName: String?
    var icon: UIImage?
    var category: filterCategory
    var filters: [ImahenFilter]?
    
    init(name: String? = nil, iconName: String? = nil, filters: [ImahenFilter]? = nil) {
        self.name = name
        self.filters = filters
        self.iconName = iconName
        self.category = .none

        if let name = iconName {
            self.icon = UIImage(systemName: name)
        }
    }
}
