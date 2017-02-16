//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]?
    var filteredDict: [Business]?
    let searchBar = UISearchBar()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        
        Business.searchWithTerm(term: "Restaurants", offset: nil, limit: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()

            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func loadMoreData(){
        Business.searchWithTerm(term: "Restaurants", offset: self.businesses?.count, limit: nil) { (businesses, error) in
            if let newBusinesses = businesses, newBusinesses.count > 0{
                self.isMoreDataLoading = false
                self.businesses?.append(contentsOf: newBusinesses)
                DispatchQueue.main.async {
                    self.loadingMoreView!.stopAnimating()
                    self.tableView.reloadData()
                }
            }else{
                print(error!)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                // ... Code to load more results ...
                self.loadMoreData()
                
                
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredDict = self.businesses
        } else {
            self.filteredDict = self.businesses!.filter { (data: Business) -> Bool in
                let title = data.name
                let range = title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                if range == nil {
                    // no match
                    return false
                }else {
                    // match exists within the business name
                    return true
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text!.isEmpty{
            return businesses?.count ?? 0
        }else{
            return filteredDict?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell
        let business = self.searchBar.text!.isEmpty ?  businesses![indexPath.row] : filteredDict![indexPath.row]
        
        cell.business = business
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailFromTable"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let business = businesses![indexPath!.row]
            
            let businessDetailViewController = segue.destination as! BusinessDetailViewController
            businessDetailViewController.business = business
        }
    }
    
}
