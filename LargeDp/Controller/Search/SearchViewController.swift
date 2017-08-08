//
//  SearchViewController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 04/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus

class SearchViewController: BaseViewController {
    
    // Mark: - Attributes -
    var searchView : SearchView!
    var searchBar : UISearchBar!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        searchView = SearchView(frame:CGRect.zero)
        super.init(iView: searchView, andNavigationTitle: "")
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    init(searchText: String) {
        
        searchView = SearchView.init(searchText: searchText)
        
        super.init(iView: searchView, andNavigationTitle: "")
        
        self.loadViewControls()
        self.setViewlayout()
        searchBar.text = searchText
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("searchView ViewController deinit called")
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if searchView != nil && searchView.superview != nil {
            searchView.removeFromSuperview()
            searchView = nil
        }
        
        if searchBar != nil && searchBar.superview != nil {
            searchBar.removeFromSuperview()
            searchBar = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
        
        searchBar = UISearchBar(frame: CGRect(x: 60, y: 0, width: UIScreen.main.bounds.width - 60, height: 20))
        searchBar.placeholder = "searchplacehlder".localize()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        
        
        var leftNavBarButton : UIBarButtonItem! = UIBarButtonItem(customView:searchBar)
    
        self.navigationItem.setRightBarButtonItems([leftNavBarButton], animated: true)
        
        defer {
            leftNavBarButton = nil
        }
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
        
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    @objc private func btnCancelTapped(sender : UIButton) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar .showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    
        if !searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            let aString = searchBar.text!.trimmingCharacters(in: .whitespaces)
            let newString = aString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            
            self.searchView.peopleListView.searchPeople(query: newString)
          
        }
    }
}
