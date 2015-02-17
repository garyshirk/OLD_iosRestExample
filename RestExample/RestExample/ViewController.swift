//
//  ViewController.swift
//  RestExample
//

import UIKit

class ViewController: UIViewController, ITunesSearchAPIProtocol {

    var api: ITunesSearchAPI = ITunesSearchAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        api.delegate = self;
        api.searchItunesFor("Jimmy Buffett")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponse(results: NSDictionary) {
        // Store the results in our table data array
        println(results)
    }

}

