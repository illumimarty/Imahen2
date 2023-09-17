//
//  ViewController.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var draftImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func didTapView(_ sender: Any) {
        imagePicker()
    }
    
    func imagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Choose from Album", style: .default) { action in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { action in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage]
        let editedImage = info[.editedImage]
        
        
        let bounds: CGRect = self.view.window!.bounds
        let width: CGFloat = bounds.size.width
        let imageSize: CGSize = CGSizeMake(width, width)
        draftImageView.image = resizeImage(editedImage as! UIImage, withSize: imageSize)
        self.dismiss(animated: true)
    }
    
    func resizeImage(_ image: UIImage, withSize size: CGSize) -> UIImage {
        
        // previously written in Obj-C
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        resizeImageView.contentMode = .scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    

}

