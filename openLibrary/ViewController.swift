//
//  ViewController.swift
//  openLibrary
//
//  Created by Raul Suarez Dabo on 05/02/16.
//  Copyright © 2016 Raul Suarez Dabo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"

    @IBOutlet weak var textView: UITextView!
    // Search argument
    @IBOutlet weak var search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        search.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let url = NSURL(string: self.urls + searchBar.text!)
        let datos: NSData? = NSData(contentsOfURL: url!)
        self.textView.text = String(NSString(data: datos!, encoding:NSUTF8StringEncoding))
    }

    @IBAction func clearSearch() {
        self.search.text = ""
    }

    
}

