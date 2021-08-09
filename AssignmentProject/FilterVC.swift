//
//  FilterVC.swift
//  AssignmentProject
//
//  Created by iOS on 07/08/2021.
//

import UIKit
protocol Filterdelegate {
    func selectthefilter(type:FilterVC)
}

class FilterVC: BottomPopupViewController {

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var filtrdelegate:Filterdelegate?
    var SelectedCells = [Int]()
    var isEnglandselcted = false
    var isScotlandselcted = false
    var isNorthernselcted = false
    var isBountyselcted = false
    var isNotesselcted = false

    var data = [Items(title: "England and Wales", isSelected: false, types: ""),
                Items(title: "Scotland", isSelected: false, types: ""),
                Items(title: "Northern Ireland", isSelected: false, types: ""),
                Items(title: "Bunting Holidays Only", isSelected: false, types: ""),
                Items(title: "Contain Notes", isSelected: false, types: "")]
    @IBOutlet var tableV:UITableView!
    var cellIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "FilterCell", bundle: nil)
        self.tableV.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableV.delegate = self
        tableV.dataSource = self
     }
    @IBAction func btDonetapped(_ sender:UIBarButtonItem)
    {
        for item in data
        {
            if item.title == "England and Wales" && item.isSelected == true
            {
                isEnglandselcted = true
            }else if item.title == "Scotland" && item.isSelected == true
            {
                isScotlandselcted = true
            }else if item.title == "Northern Ireland" && item.isSelected == true
            {
                isNorthernselcted = true
            }else if item.title == "Bunting Holidays Only" && item.isSelected == true
            {
                isBountyselcted = true
            }else if item.title == "Contain Notes" && item.isSelected == true
            {
                print(isNotesselcted)
                isNotesselcted = true
                print(isNotesselcted)

            }
        }
        
        filtrdelegate?.selectthefilter(type: self)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btDeletetapped(_ sender:UIBarButtonItem)
    {
        for item in data
        {
            item.isSelected = false
        }
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }
    }
     override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 0.3 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }


 
}
extension FilterVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterCell
        {
            let item = data[indexPath.row]
            cell.Lbtitle.text = item.title
            if item.isSelected ?? false
            {
                cell.accessoryType = .checkmark
            }else
            {
                cell.accessoryType = .none
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.SelectedCells.contains(indexPath.row)
       {
        
            let myIndex = self.SelectedCells.firstIndex(of: indexPath.row)
            data[indexPath.row].isSelected = false
            data[indexPath.row].types = "\(indexPath.row + 1)"
           self.SelectedCells.remove(at: myIndex!)
        } else
       {
          data[indexPath.row].types = ""
          data[indexPath.row].isSelected = true
         self.SelectedCells.append(indexPath.row)
          
        }
     
     tableV.reloadData()
    }
    
}
