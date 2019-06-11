//
//  MapViewController+UICollectionView.swift
//  EyePop
//
//  Created by Gurinder Singh on 5/23/19.
//  Copyright © 2019 Faswaldo. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! LocationImageCollectionViewCell
       // cell.locatiionImageView.image = UIImage(named: "public")
        //cell.configure(with: data[indexPath.row])
        let imageForNow = #imageLiteral(resourceName: "thotianna.png")
        let uiImageview = UIImageView(image: imageForNow)
        uiImageview.frame = cell.frame
        cell.addSubview(uiImageview)
        return cell
        
    }
}
