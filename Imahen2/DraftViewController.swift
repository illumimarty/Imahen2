//
//  DraftViewController.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit

class DraftViewController: UIViewController {
    @IBOutlet weak var optionCollectionView: UICollectionView!
    @IBOutlet weak var draftImageView: UIImageView!
    var draftImage: UIImage?
    
    let optionNames = ["Filter", "Enhance", "Advanced"]
    let optionImages = ["camera.filters", "wand.and.rays", "square.3.layers.3d.middle.filled"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        draftImageView.image = draftImage
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.register(UINib(nibName: "OptionCell", bundle: .main), forCellWithReuseIdentifier: "OptionCell")
    }
}

extension DraftViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
        let idx = indexPath.item
        cell.optionName.text = optionNames[idx]
        cell.optionImage.image = UIImage(systemName: optionImages[idx])
        
        return cell
    }
    
    
}
