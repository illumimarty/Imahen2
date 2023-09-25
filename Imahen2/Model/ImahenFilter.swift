//
//  ImahenFilter.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/21/23.
//

import Foundation
import UIKit
import CoreImage

class ImahenFilter {
    var name: String?
    var previewImg: UIImage?
    var filter: CIFilter?
    var key: String?
    var isAppliedToImage: Bool
    var doesUseIntensity: Bool
    var threshold: CGFloat?
    var filterType: FilterType
    
    enum FilterType {
        case coreImage
        case metal
    }
    
    init(
        name: String!,
        previewImg: UIImage!,
        filter: CIFilter? = nil,
        thresh: CGFloat? = nil,
        usesIntensity: Bool = false) {
        self.name = name
        self.previewImg = previewImg
        self.filter = filter
        self.isAppliedToImage = false
        self.filterType = .coreImage
        self.doesUseIntensity = usesIntensity
    }
    
    init(
        _ name: String!,
        _ previewImg: UIImage!,
        _ filter: CIFilter? = nil,
        _ thresh: CGFloat? = nil,
        _ usesIntensity: Bool = false) {
        self.name = name
        self.previewImg = previewImg
        self.filter = filter
        self.isAppliedToImage = false
        self.filterType = .coreImage
        self.doesUseIntensity = usesIntensity
    }
    
    func applyEffect(to image: UIImage?, val: CGFloat? = nil) -> UIImage? {
        guard let image = prepareImage(image) else { return nil }
        
        // Check if filter is set, dev-use only
        if filter != nil {
            return processImage(image, val ?? nil)
        }
        return nil
    }
    
    func removeEffect(from image: UIImage) {
        
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
    
    /// Used by `ImahenFilter` to apply the filter to image using CoreImage
    private func processImage(_ img: CIImage, _ val: Any? = nil) -> UIImage! {
        var processedImage: UIImage? = nil

        let context = ImahenCIContext.shared.context
        if let val = val {
            // TODO: add data type checking -> going to use a slider component
            filter?.setValue(val, forKey: kCIInputIntensityKey)
        }
        
        // Case: using CIFilter with a given CGFloat intensity value
        guard let image = self.filter?.outputImage else { return nil }
        if let key = self.key {
            filter?.setValue(val, forKey: key)
        }
        
        if let cgimg = context.createCGImage(image, from: image.extent) {
            processedImage = UIImage(cgImage: cgimg)
        }
        
        return processedImage
    }
    
    func toggleIsApplied() {
        isAppliedToImage = !isAppliedToImage
    }
}

struct ImahenFilterCategory {
    var name: String?
    var iconName: String?
    var icon: UIImage?
    var category: filterCategory
    var filters: [ImahenFilter]?
    
    enum filterCategory {
        case filter
        case enhance
        case advanced
        case none
    }
        
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

class ImahenCIContext {
    // Singleton instance
    static let shared = ImahenCIContext()
    private init() {}
    
    let context = CIContext()
}

class MetalFilter: ImahenFilter {
    private let kernel: ImahenMetalKernel
    var selectedScheme: Scheme?
    
    enum Scheme {
        case sobel
        case xgrad
        case ygrad
        case otsu
    }
    
    init(name: String!, previewImg: UIImage!, threshold: CGFloat? = 0.0, scheme: Scheme) {
        kernel = ImahenMetalKernel()
        selectedScheme = scheme
        super.init(name: name, previewImg: previewImg)
        self.filterType = .metal
        self.threshold = threshold
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getMetalFunction(for scheme: Scheme) -> String? {
        switch scheme {
        case .sobel: return "sobelEdgeDetect"
        default: return nil
        }
    }
    
    override func applyEffect(to image: UIImage?, val: CGFloat? = nil) -> UIImage? {
        if let val = val {
            let context = ImahenCIContext.shared.context
            let schemeFunction = getMetalFunction(for: selectedScheme!)
            guard let image = prepareImage(image) else { return nil }
            
            // Calls Metal kernel to process image on GPU
            guard let processedImage = try? ImahenMetalKernel.apply(
                withExtent: image.extent,
                inputs: [image],
                arguments: ["thresholdValue": val, "functionName": schemeFunction!])
            else { return nil }
            
            guard let cgImageResult = context.createCGImage(processedImage, from: processedImage.extent) else { return nil }
            return UIImage(cgImage: cgImageResult)
        }
        return nil
    }
}
