//
//  ViewController.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var imageToSend: UIImage?
    
    // lazy: will load when it's actually needed
    private lazy var imagePickerController: UIImagePickerController! = {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        return vc
    }()
    
    private lazy var alertController: UIAlertController! = {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ipc = self.imagePickerController!
        let libraryAction = UIAlertAction(title: "Choose from Album", style: .default) { action in
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { action in
            ipc.sourceType = .camera
            self.present(ipc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(libraryAction)
        controller.addAction(cameraAction)
        controller.addAction(cancelAction)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
    }

    
    @IBAction func didTapView(_ sender: Any) {
        imagePicker()
    }
    
    func imagePicker() {
        self.present(alertController!, animated: true)
    }
    
    // Resizes the selectedImage to a square for editing
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[.editedImage] as! UIImage
        imageToSend = editedImage
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "pickerToDraft", sender: nil)
        }
    }
    
    /// Resize image to given width and height
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "pickerToDraft") {
            let draftVC = segue.destination as! DraftViewController
            
            if let img = self.imageToSend {
                draftVC.originalImage = img
            }
        }
    }
}

