//
//  DatabaseHelper.swift
//  My_Fav_Marvels
//
//  Created by Suraj on 01/12/20.
//  Copyright © 2020 Suraj. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveMarvelObjectToCoreData(data: Marvel) {
        
        guard let marvel = NSEntityDescription.entity(forEntityName: "Marvel", in: context) else { return }
        let newMarvel = NSManagedObject(entity: marvel, insertInto: context)
        newMarvel.setValue(data.title, forKey: "marvelName")
        newMarvel.setValue(data.discription, forKey: "marvelDescription")
        newMarvel.setValue(data.image.pngData(), forKey: "marvelImage")
        
        do {
            try context.save()
            print("Marvel is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchMarvelObjects() -> [Marvel] {
        
        var objects: [NSManagedObject]?
        var fetchingData = [Marvel]()
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Marvel")
        do {
            objects = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let objects  = objects {
                for data in objects {
                    let name = data.value(forKey: "marvelName") as! String
                    let description = data.value(forKey: "marvelDescription") as! String
                    let image = data.value(forKey: "marvelImage") as! Data
                    let object = Marvel(title: name, image: UIImage(data: image) ?? UIImage(), discription: description)
                    fetchingData.append(object)
                }
            }
            print("Data fetched successfully")
        } catch {
            print("Error while fetching the marvel")
        }
        return fetchingData
    }
    
    func deleteMarvelObjectFormCoreData(marvel : Marvel) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Marvel")
        fetchRequest.predicate = NSPredicate(format: "marvelName = %@", marvel.title)
        
        do {
            let test = try context.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
            print("marvel object deleted")
        } catch {
            print("Error while deleting marvel")
        }
    }
    
    
}
