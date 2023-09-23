//
//  DraftViewController.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/17/23.
//

import UIKit
import CoreImage

class DraftViewController: UIViewController {
    
    typealias Category = ImahenFilterCategory
    
    @IBOutlet weak var optionCollectionView: UICollectionView!
    @IBOutlet weak var backToFilterCategoriesButton: UIButton!
    @IBOutlet weak var draftImageView: UIImageView!
    
    var originalImage: UIImage?
    var selectedCategory: Category?
    var isOnMainLevel = true
    
    let optionCategories: [ImahenFilterCategory] = {
        let myFilterCategory = [
            ImahenFilter(name: "Normal", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(
                name: "Grayscale",
                previewImg: UIImage(systemName: "camera.filters"),
                filter: CIFilter(name: "CIPhotoEffectNoir")
            ),
            ImahenFilter(
                name: "Sepia",
                previewImg: UIImage(systemName: "camera.filters"),
                filter: CIFilter(name: "CISepiaTone")
            ),
        ]
        
        let advancedCategory = [
            ImahenFilter(name: "Normal", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "xGradient", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "yGradient", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "Sobel", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "Otsu", previewImg: UIImage(systemName: "camera.filters"))
        ]
        
        let categories: [ImahenFilterCategory] = [
            ImahenFilterCategory(name: "Filter", iconName: "camera.filters", filters: myFilterCategory),
            ImahenFilterCategory(name: "Enhance", iconName: "wand.and.rays", filters: nil),
            ImahenFilterCategory(name: "Advanced", iconName: "square.3.layers.3d.middle.filled", filters: advancedCategory),
        ]
        
        return categories
    }()
    
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
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary   // Scrolls in orthogonal (horizontal) direction, snaps to lea

        let layout = UICollectionViewCompositionalLayout(section: section)
        return UICollectionViewCompositionalLayout(section: section)
    }()

    
    @IBAction func backToFiltersButtonTapped(_ sender: Any) {
        if (!isOnMainLevel) {
            toggleLevel()
            selectedCategory = nil
            toggleBackToFilterCategoriesButton()
            toggleCollectionViewScroll()
            reloadCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.accessibilityIdentifier = "DraftViewController"
        draftImageView.image = originalImage
        backToFilterCategoriesButton.isHidden = true
        
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.isScrollEnabled = false
        optionCollectionView.register(UINib(nibName: "OptionCell", bundle: .main), forCellWithReuseIdentifier: "OptionCell")
        optionCollectionView.collectionViewLayout = compositionalLayout
    }
    
    func reloadCollectionView() {
        optionCollectionView.reloadData()
    }
    
    func toggleBackToFilterCategoriesButton() {
        backToFilterCategoriesButton.isHidden = !backToFilterCategoriesButton.isHidden
    }
    
    func toggleCollectionViewScroll() {
        optionCollectionView.isScrollEnabled = !optionCollectionView.isScrollEnabled
    }
    
    func toggleLevel() {
        isOnMainLevel = !isOnMainLevel
    }
}

extension DraftViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let category = selectedCategory {
            guard let filters = category.filters else { return 0 }
            return filters.count
        }
        return optionCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
        let idx = indexPath.item
        
        switch (selectedCategory) {
        case nil:
            let category = optionCategories[idx]
            cell.optionName.text = category.name
            cell.optionImage.image = category.icon
        default:
            if let category = selectedCategory {
                let filter = category.filters?[idx]
                cell.optionName.text = filter?.name
                cell.optionImage.image = filter?.previewImg
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.item

        if isOnMainLevel {
            selectedCategory = optionCategories[idx]
            toggleLevel()
            toggleBackToFilterCategoriesButton()
            toggleCollectionViewScroll()
            reloadCollectionView()
        } else {
            // Apply filter / effect
            
            // Case: if normal effect is selected
            if idx == 0 {
                draftImageView.image = originalImage
                return
            }
           
            if let selectedFilter = selectedCategory?.filters![idx] {
                // TODO: Write condition that prevents further filtering after one application. OR utilize a slider
                let image = draftImageView.image
                let filteredImage = selectedFilter.applyEffect(from: image)     // ✨ Where the magic happens ✨
                draftImageView.image = filteredImage
                selectedCategory?.filters![idx].toggleIsApplied()
            }
        }
    }
}
