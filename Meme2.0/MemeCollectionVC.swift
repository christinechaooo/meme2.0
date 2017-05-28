//
//  MemeCollectionVC.swift
//  Meme2.0
//
//  Created by Christine Chao on 5/14/17.
//  Copyright © 2017 Christine Chao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionCell"

class MemeCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memeAll = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFlowLayout()
        
        self.collectionView?.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memeAll = appDelegate.memes
        
        self.collectionView?.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setFlowLayout), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setFlowLayout() {
        let space: CGFloat = 5.0
        let dimension:CGFloat
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.width - (4 * space)) / 5.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeAll.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memeAll[(indexPath as NSIndexPath).row]
        
        cell.memeImageView?.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.meme = self.memeAll[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
