//
//  ITunesSearchAPI.swift
//  RestExample


import UIKit

protocol ITunesSearchAPIProtocol {
    func didReceiveResponse(results: NSDictionary)
}

class ITunesSearchAPI: NSObject {
    
    var data: NSMutableData = NSMutableData()
    var delegate: ITunesSearchAPIProtocol?

    func searchItunesFor(searchTerm: String) {
    
        //Clean up the search terms by replacing spaces with +
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ",
            withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch,
            range: nil)
 
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=music"
       
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        println("Search iTunes API at URL \(url)")
        
        connection.start()
    }
    
    // handle failed connection
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Failed with error:\(error.localizedDescription)")
    }
    
    // new request starting
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response:NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    // append incoming data
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    // request completed
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        delegate?.didReceiveResponse(jsonResult)
    }
}