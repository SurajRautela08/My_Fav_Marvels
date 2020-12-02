//
//  ViewController.swift
//  My_Fav_Marvels
//
//  Created by Suraj on 01/12/20.
//  Copyright © 2020 Suraj. All rights reserved.
//

import UIKit

class MarvelsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var index : Int?
    var marvelArray : [Marvel] = []
    let cellIdentifier = "MarvelCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MarvelCellTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        marvelArray =  DataBaseHelper.shareInstance.fetchMarvelObjects()
    }

    @IBAction func addMarvelsButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "AddMarvelNavViewController") as! UINavigationController
        let addMarvelViewController = navigationController.topViewController as! AddMarvelViewController
        addMarvelViewController.delegate = self
        addMarvelViewController.mode = .create
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

extension MarvelsListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        marvelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MarvelCellTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.name.text = marvelArray[indexPath.row].title
        cell.about.text = marvelArray[indexPath.row].discription
        cell.cellImage.image = marvelArray[indexPath.row].image
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let controller = self.getAddMarvelController()
        controller.marvelObject = marvelArray[indexPath.row]
        controller.mode = .delete
        self.navigationController?.pushViewController(controller, animated: true)
        self.index = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
}

extension MarvelsListViewController : AddMarvelViewControllerDelegate {
    
    func didSaveMarvel(_ marvel: Marvel) {
        self.marvelArray.append(marvel)
        self.tableView.reloadData()
    }
    
    func didRemoveMarvel() {
        marvelArray.remove(at: index!)
        DataBaseHelper.shareInstance.deleteMarvelObjectFormCoreData(marvel: marvelArray[index!])
        tableView.reloadData()
    }
}


extension MarvelsListViewController {
    
    private func getAddMarvelController() -> AddMarvelViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddMarvelViewController") as! AddMarvelViewController
        controller.delegate = self
        return controller
    }
    
}
