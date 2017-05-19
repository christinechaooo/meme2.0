//
//  AddMemeViewController.swift
//  Meme2.0
//
//  Created by Christine Chao on 8/22/16.
//  Copyright © 2016 Christine Chao. All rights reserved.
//

import UIKit

class AddMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var bottomTF: UITextField!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-4)
        ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextStyle(textfield: topTF, withText: "TOP")
        configureTextStyle(textfield: bottomTF, withText: "BOTTOM")
        
        shareBtn.isEnabled = false
    }
    
    func configureTextStyle(textfield:UITextField, withText text:String) {
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.text = text
        textfield.delegate = self
        textfield.textAlignment = .center
        textfield.autocapitalizationType = .allCharacters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }

    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        presentImagePickerWith(source: UIImagePickerControllerSourceType.photoLibrary)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
        
        dismiss(animated: true, completion: nil)
        shareBtn.isEnabled = true
    }

    @IBAction func useCamera(_ sender: UIBarButtonItem) {
        presentImagePickerWith(source: UIImagePickerControllerSourceType.camera)
    }
    
    func presentImagePickerWith(source:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func topTFBeginEdit(_ sender: AnyObject) {
        topTF.text = ""
    }
    
    @IBAction func bottomTFBeginEdit(_ sender: AnyObject) {
        bottomTF.text = ""
    }
    
    
    @IBAction func topTFEditingEnd(_ sender: AnyObject) {
        topTF.resignFirstResponder()
    }

    @IBAction func bottomTFEditingEnd(_ sender: AnyObject) {
        bottomTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (topTF.isFirstResponder) {
            topTF.resignFirstResponder()
        } else {
            bottomTF.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddMemeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddMemeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if(bottomTF.isEditing) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        print("save")
        let meme = Meme( topText: topTF.text!, bottomText: bottomTF.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        print(appDelegate.memes)
        dismiss(animated: true, completion: nil)
    }
    
    
    func generateMemedImage() -> UIImage
    {
//        navigationController?.navigationBar.isHidden = true
        navBar.isHidden = true
        self.bottomBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        self.bottomBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let memeImg = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memeImg], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler =  {
            (activityType, completed:Bool, returnedItems, error) in
            if (!completed) {
                return
            }
            
            self.save()
        }
    }
}

