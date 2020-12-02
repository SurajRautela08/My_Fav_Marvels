//
//  AddMarvelViewController.swift
//  My_Fav_Marvels
//
//  Created by Suraj on 01/12/20.
//  Copyright © 2020 Suraj. All rights reserved.
//

import UIKit


enum MarvelMode {
    case create
    case delete
}

class AddMarvelViewController: UIViewController {
    
    var delegate : AddMarvelViewControllerDelegate?

    var mode: MarvelMode = .create
    var marvelObject : Marvel?
    
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var marvelImage: UIImageView!
    @IBOutlet weak var marvelName: UITextField!
    @IBOutlet weak var marvelDescription: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetups()
        addDoneButtonOnKeyboard()
    }

    @objc func doneButtonAction() {
        
        marvelName.resignFirstResponder()
        marvelDescription.resignFirstResponder()
    }
    
    
    @IBAction func addImageAction(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if marvelObject == nil {
            if marvelName.text!.isEmpty
            {
                alertFunc(name: "Name")
            }
            else if marvelDescription.text!.isEmpty
            {
                alertFunc(name: "Description")
            }
            else
            {
                marvelObject = Marvel(title: marvelName.text!, image: marvelImage.image ?? UIImage(), discription: marvelDescription.text!)
                if let marvelObject = marvelObject {
                    self.delegate?.didSaveMarvel(marvelObject)
                    DataBaseHelper.shareInstance.saveMarvelObjectToCoreData(data: marvelObject)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        else
        {
            self.delegate?.didRemoveMarvel()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        switch self.mode {
        case .create:
            self.dismiss(animated: true, completion: nil)
        case .delete:
            self.navigationController?.popViewController(animated: true)
        }

    }
    
}



extension AddMarvelViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            marvelImage.image = image
        } else {
            print("Error: Not able to get image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddMarvelViewController {
    
    func initialSetups() {
           marvelName.text = marvelObject?.title
           marvelImage.image = marvelObject?.image ?? UIImage(named: "marvel")
           marvelDescription.text = marvelObject?.discription
           
           if marvelObject != nil {
               setEditRightsFalse()
               saveButton.setTitle("Delete", for: .normal)
               saveButton.backgroundColor = UIColor.red
               
           }
       }
       
       func setEditRightsFalse() {
        
           marvelName.isEnabled = false
           marvelDescription.isEditable = false
           addImage.isHidden = true
       }
       
       func addDoneButtonOnKeyboard(){
           let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
           doneToolbar.barStyle = .default

           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

           let items = [flexSpace, done]
           doneToolbar.items = items
           doneToolbar.sizeToFit()

           marvelName.inputAccessoryView = doneToolbar
           marvelDescription.inputAccessoryView = doneToolbar
       }
    
    func alertFunc(name : String) {
        
        let alert = UIAlertController(title: "Alert!!!", message: "\(name) is Mantatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}


protocol AddMarvelViewControllerDelegate {
    func didSaveMarvel(_ marvel: Marvel)
    func didRemoveMarvel()
}
