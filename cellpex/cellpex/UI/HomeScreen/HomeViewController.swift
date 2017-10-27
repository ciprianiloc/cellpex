//
//  HomeViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/27/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        searchController.searchBar.placeholder = "Type mode"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        self.navigationItem.hidesBackButton = true
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "hamburger_icon"), style: .plain, target: self, action: #selector(HomeViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func back(sender: UIBarButtonItem) {

        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
