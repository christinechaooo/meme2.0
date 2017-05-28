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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(Meme(fromImageWithDefaultValues: UIImage(named: "meme1")!))
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memeAll = appDelegate.memes
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
