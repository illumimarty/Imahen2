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
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var originalImage: UIImage?
    var draftImage: UIImage?
    var selectedCategory: Category?
    var selectedFilter: ImahenFilter?
    var isOnMainLevel = true
    
    let optionCategories: [ImahenFilterCategory] = {
        var filterData: [(name: String, previewImg: UIImage?, filter: CIFilter?, usesIntensity: Bool)] = [
            ("Normal", UIImage(systemName: "camera.filters"), nil, false),
            ("Grayscale", UIImage(systemName: "camera.filters"), CIFilter(name: "CIPhotoEffectNoir"), false),
            ("Sepia", UIImage(systemName: "camera.filters"), CIFilter(name: "CISepiaTone"), true)
        ]
        
        let myFilterCategory = filterData.map { data in
            return ImahenFilter(data.name, data.previewImg, data.filter, nil, data.usesIntensity)
        }
        
        filterData = [
            ("Brightness", UIImage(systemName: "camera.filters"), nil, true),
            ("Contrast", UIImage(systemName: "camera.filters"), nil, true),
            ("Smoothen", UIImage(systemName: "camera.filters"), CIFilter(name: "CIGaussianBlur", parameters: [:]), true),
            ("Sharpen", UIImage(systemName: "camera.filters"), nil, true)
        ]
        
        let enhanceCategory = [
            ImahenFilter(name: "Brightness", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "Contrast", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "Smoothen", previewImg: UIImage(systemName: "camera.filters")),
            ImahenFilter(name: "Sharpen", previewImg: UIImage(systemName: "camera.filters")),
        ]
        
        let advancedCategory = [
            MetalFilter(name: "Normal", previewImg: UIImage(systemName: "camera.filters")),
            MetalFilter(name: "xGradient", previewImg: UIImage(systemName: "camera.filters")),
            MetalFilter(name: "yGradient", previewImg: UIImage(systemName: "camera.filters")),
            MetalFilter(name: "Sobel", previewImg: UIImage(systemName: "camera.filters"), scheme: .sobel),
            MetalFilter(name: "Otsu", previewImg: UIImage(systemName: "camera.filters"))
        ]
        
        let categories: [ImahenFilterCategory] = [
            ImahenFilterCategory(name: "Filter", iconName: "camera.filters", filters: myFilterCategory),
            ImahenFilterCategory(name: "Enhance", iconName: "wand.and.rays", filters: enhanceCategory),
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
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary   // Scrolls in orthogonal (horizontal) direction, snaps to leading/trailing edges

        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.accessibilityIdentifier = "DraftViewController"
        draftImage = originalImage
        previewImageView.image = draftImage
        
        // Setting up collection view
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.isScrollEnabled = false
        optionCollectionView.register(UINib(nibName: "OptionCell", bundle: .main), forCellWithReuseIdentifier: "OptionCell")
        optionCollectionView.collectionViewLayout = compositionalLayout
        
        // Setting up slider
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.isContinuous = false // make this true if running on device. consider having a simulator/device condition when debugging
        
        backToFilterCategoriesButton.isHidden = true
        toolbar.isHidden = true
        slider.isHidden = true
    }
    
    @IBAction func backToFiltersButtonTapped(_ sender: Any) {
        if (!isOnMainLevel) {
            toggleLevel()
            selectedCategory = nil
            toggleBackToFilterCategoriesButton()
            toggleCollectionViewScroll()
            reloadCollectionView()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        previewImageView.image = draftImage
        toggleIntensitySlider()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        draftImage = previewImageView.image
        toggleIntensitySlider()
    }
    
    @IBAction func didSliderValueChange(_ sender: Any) {
        let val = CGFloat(slider.value)
        processImage(with: val)
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
    
    func revertPreviewToOriginal() {
        previewImageView.image = originalImage
        draftImage = originalImage
    }
    
    func applyFilterEffectToImage() {
        previewImageView.image = draftImage
    }
    
    func toggleIntensitySlider() {
        navigationController?.navigationBar.isHidden = !(navigationController?.navigationBar.isHidden)!
        slider.isEnabled = !slider.isEnabled
        toolbar.isHidden = !toolbar.isHidden
        slider.isHidden = !slider.isHidden
        
        if !slider.isHidden {
            slider.value = 0.5
            processImage(with: CGFloat(slider.value))
        }
        
        toggleBackToFilterCategoriesButton()
        optionCollectionView.isHidden = !optionCollectionView.isHidden
    }
    
    /// Used by DraftVC to apply filter to image and preview to ImageView
    private func processImage(with intensity: CGFloat? = nil) {
        let currFilter = self.selectedFilter!
        let image = draftImage
        var filteredImage: UIImage?
        filteredImage = currFilter.applyEffect(to: image, val: intensity)   // ✨ Where the magic happens ✨

        if !currFilter.doesUseIntensity {
            draftImage = filteredImage
        }
        
        if let filteredImage = filteredImage {
            previewImageView.image = filteredImage
        } else {
            print("Filter not applied. Returning original image...")
        }
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
            
        // Top Level Menu
        case nil:
            let category = optionCategories[idx]
            cell.optionName.text = category.name
            cell.optionImage.image = category.icon
            
        // Category menu with filters
        default:
            if let category = selectedCategory {
                let filter = category.filters?[idx]
                cell.optionName.text = filter?.name
                cell.optionImage.image = filter?.previewImg
            }
        }
        return cell
    }
    
    
    /// If `isOnMainLevel`, the collection view's data source will reconfig to the corresponding category's filter list
    /// Else, it will apply the matching filter to `draftImage`
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.item

        if isOnMainLevel {
            selectedCategory = optionCategories[idx]
            toggleLevel()
            toggleBackToFilterCategoriesButton()
            toggleCollectionViewScroll()
            reloadCollectionView()
        } else {
            
            // Case: if normal effect is selected
            if idx == 0 {
                revertPreviewToOriginal()
                return
            }
           
            if let selectedFilter = selectedCategory?.filters![idx] {
                
                // Dev-use only (maybe remove once all filters are implemented?)
                // MetalFilter doesn't use the `filter: CIFilter` property, so we check using another way
                if selectedFilter.filterType == .metal {
                    let filter = selectedFilter as! MetalFilter     // cool use for appropriate forced downcasting!
                    if filter.selectedScheme == nil {
                        print("Filter not yet implemented, returning...")
                        return
                    }
                }
                
                self.selectedFilter = selectedFilter
                
                if selectedFilter.doesUseIntensity {
                    toggleIntensitySlider()
                } else {
                    processImage()
                }
            }
        }
    }
}
