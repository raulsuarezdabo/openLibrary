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

    // Search argument
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    

    
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
        if Reachability.isConnectedToNetwork() == true {
            self.view.endEditing(true)
            
            let url = NSURL(string: self.urls + searchBar.text!)
            
            let sesion = NSURLSession.sharedSession();
            let bloque = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers)
                    dispatch_sync(dispatch_get_main_queue(), {
                        let isbn =  self.search.text!
                        let title = dictionary["ISBN:\(isbn)"]!!["title"] as! NSString as String
                        self.titleLabel.text = "Title: \(title)"
                        let authors = dictionary["ISBN:\(isbn)"]!!["authors"] as! NSArray as Array
                        var authorsText = ""
                        var i = 0
                        for item in authors {
                            let name = item["name"] as! NSString as String
                            if (i == 0) {
                                authorsText = authorsText + "\(name)"
                            }
                            else {
                                authorsText = authorsText + ",\(name)"
                            }
                            i++
                        }
                        self.authorsLabel.text = "Author/s: \(authorsText)"
                        if ((dictionary["ISBN:\(isbn)"]!!["cover"]! != nil) && (dictionary["ISBN:\(isbn)"]!!["cover"]!!["small"]! != nil)) {
                            let coverUrl = NSURL(string: dictionary["ISBN:\(isbn)"]!!["cover"]!!["small"] as! NSString as String)
                            
                            let sesion = NSURLSession.sharedSession();
                            let getCover = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                                do {
                                    dispatch_sync(dispatch_get_main_queue(), {
                                        self.image.image = UIImage(data: datos!)
                                    })
                                } catch _ as NSError {}
                            }
                            let dt = sesion.dataTaskWithURL(coverUrl!, completionHandler: getCover)
                            dt.resume()
                        }
                    })
                    
                } catch _ as NSError {
                    self.showAlert("Unexpected error", message: "Sorry :( but it looks that we get some kind of error from the API")
                }
                
            }
            
            let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
            
        }
        else {
            self.showAlert("No internet conection", message: "Sorry :( it's impossible to make this request without internet conection")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func clearSearch() {
        self.search.text = ""
    }
    
    /*func upToRepresentation(dictionary: NSDictionary, isbn: String) {
        let title = dictionary["ISBN:\(isbn)"]!["title"] as! NSString as String
        let authors = dictionary["ISBN:\(isbn)"]!["authors"] as! NSArray as Array
        for item in authors {
            print(item["name"] as NSString)
        }
        
    }*/

    
}

