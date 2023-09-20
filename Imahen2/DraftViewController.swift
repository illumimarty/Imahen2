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
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 1 / 3
        let inset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        draftImageView.image = draftImage
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.isScrollEnabled = false
        optionCollectionView.register(UINib(nibName: "OptionCell", bundle: .main), forCellWithReuseIdentifier: "OptionCell")
        optionCollectionView.collectionViewLayout = compositionalLayout
    }
}

extension DraftViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
