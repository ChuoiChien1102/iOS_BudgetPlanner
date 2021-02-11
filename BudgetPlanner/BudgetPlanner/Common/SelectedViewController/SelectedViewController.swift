//
//  SelectedViewController.swift
//  VNPT-BRIS
//
//  Created by ERP-PM2-1174 on 4/29/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit

class SelectedViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewContent: UIView!
    var onSelectedDetails:((_ category: CategoryModel) -> Void)?
    var data = [CategoryModel]()
    
    private let itemsPerRow: CGFloat = 5
    fileprivate let sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
    }
    
    @IBAction func close(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }
}

extension SelectedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.data[indexPath.row]
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if self.onSelectedDetails != nil {
                    self.onSelectedDetails!(model)
                }
            }
        }
    }
}

extension SelectedViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height_title = 40
        
        let paddingSpace = sectionInset.left * (itemsPerRow + 1)
        let availableWidth = viewContent.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + CGFloat(height_title))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        if data.count > 0 {
            let item = data[indexPath.row]
            cell.configUI(category: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.data[indexPath.row]
        DispatchQueue.main.async {
            self.appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: {
                if self.onSelectedDetails != nil {
                    self.onSelectedDetails!(model)
                }
            })
        }
    }
}
