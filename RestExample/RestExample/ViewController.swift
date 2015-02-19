//
//  ViewController.swift
//  RestExample
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ITunesSearchAPIProtocol {
    
    @IBOutlet weak var appsTableView: UITableView!
    
    var tableData: NSArray = NSArray()
    
    var imageCache: NSMutableDictionary = NSMutableDictionary()

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
        println("Received results")
        if results.count>0 {
            self.tableData = results["results"] as NSArray
            self.appsTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellId = "MyCell"
        
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCellWithIdentifier(kCellId) as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellId)
        }
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let cellText: String? = rowData["trackName"] as? String
        cell!.textLabel!.text = cellText
        
        var trackCensorName: NSString = rowData["trackCensoredName"] as NSString
        cell!.detailTextLabel!.text = trackCensorName
        
        cell!.imageView!.image = UIImage(named: "DeitelOrange_58x58")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var urlString: NSString = rowData["artworkUrl60"] as NSString
            
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
            
            if (image != nil) {
                
                // If the image does not exist in the cache then we need to download it
                var imgURL: NSURL = NSURL(string: urlString)!
                
                //Get the image from the URL
                var request: NSURLRequest = NSURLRequest(URL: imgURL)
                var urlConnection: NSURLConnection = NSURLConnection(request: request,
                    delegate: self)!
                
                NSURLConnection.sendAsynchronousRequest(request, queue:
                    NSOperationQueue.mainQueue(), completionHandler: {(response:
                        NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        
                        if error? != nil {
                            image = UIImage(data: data)
                            
                            // Store the image in the cache
                            self.imageCache.setValue(image, forKey: urlString)
                            cell!.imageView!.image = image
                            tableView.reloadData()
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                })

                
            } else {
                cell!.imageView!.image = image
            }
        })
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name: String = rowData["trackCensoredName"] as String
        var releaseDate: String = rowData["releaseDate"] as String
        
        //Show the alert view with the tracks information
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = releaseDate
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

}

