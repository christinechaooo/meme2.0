//
//  MemeTableVC.swift
//  Meme2.0
//
//  Created by Christine Chao on 5/14/17.
//  Copyright © 2017 Christine Chao. All rights reserved.
//

import UIKit

class MemeTableVC: UITableViewController {
    
    var memeAll = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "meme1")!))
        self.tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func rotated() {
        self.tableView.reloadData()
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        memeAll = appDelegate.memes
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeAll.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memeAll[(indexPath as NSIndexPath).row]
        
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.meme = self.memeAll[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            memeAll.remove(at: (indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
