//
//  ViewController.swift
//  Universal Fetch Library
//
//  Created by Keshav Bansal on 26/07/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var items = [Fetch]()
    let barHeight: CGFloat = 50
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
    }
    
    func refresh(sender: Any) {
        items = [Fetch]()
        self.fetchData()
        refreshControl.endRefreshing()
    }
    
    func customization() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
    }

    func fetchData() {
        
        Fetch.getURLData(urlString: "http://pastebin.com/raw/wgkJgazE", completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
//            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageTableViewCell
        cell.clearCellData()
        if self.items[indexPath.row].content != nil{
            if let image = self.items[indexPath.row].image{
                cell.messageBackground.image = image
                cell.message.isHidden = true
            } else {
                cell.messageBackground.image = UIImage.init(named: "loading")
                self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                    if state == true {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.items[indexPath.row].type {
        case .photo:
            if self.items[indexPath.row].image != nil {
                self.inputAccessoryView?.isHidden = true
            }
        default: break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

