//
//  DraftViewController.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit

class DraftViewController: UIViewController {

    @IBOutlet weak var draftImageView: UIImageView!
    var draftImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        draftImageView.image = draftImage
    }
    

    


}
