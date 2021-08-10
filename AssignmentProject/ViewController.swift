//
//  ViewController.swift
//  AssignmentProject
//
//  Created by iOS on 06/08/2021.
//

import UIKit


class ViewController: UIViewController
{
    @IBOutlet weak var tableV:UITableView!
    @IBOutlet weak var btSort:UIBarButtonItem!
    @IBOutlet weak var btFilter:UIBarButtonItem!
    @IBOutlet weak var searchBar:UISearchBar!


    var data = [Items(title: "England and Wales", isSelected: false, types: ""),
                Items(title: "Scotland", isSelected: false, types: ""),
                Items(title: "Northern Ireland", isSelected: false, types: ""),
                Items(title: "Bunting Holidays Only", isSelected: false, types: ""),
                Items(title: "Contain Notes", isSelected: false, types: "")]
    var height: CGFloat = 300
    var topCornerRadius: CGFloat = 20
    var presentDuration: Double = 0.4
    var dismissDuration: Double = 0.4
    
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    //Local data
    var ListArray = NSMutableArray()
    var localCategory = ""

    //filter content
    var selectedCells:[Int] = []

    var cellIdentifier = "cellIdentifier"

    private var bankholidayaData:Bankholiday?
    var eventdata = [Event]()
    var Noteseventdata = [Event]()
    var Localeventdata = [newEvent]()

    var SearchUnfilteredData = [Newbankdata]()

    var UnfilteredData = [Newbankdata]()
    var filteredData = [Newbankdata]()

    var subFiltereddata = [Newbankdata]()
    var tableViewcellheight = 0
    var selectedIndexpath = 0
    var PrevSelectedIndexpath = 0

    var isSelected = false

    var resultSearchController = UISearchController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        let cellNib = UINib(nibName: "Listcell", bundle: nil)
        self.tableV.register(cellNib, forCellReuseIdentifier: cellIdentifier)
 
        searchBar.delegate = self


        loadData()
    }
    func loadData()
    {
        guard let url = URL(string: "https://www.gov.uk/bank-holidays.json") else {return}

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
 
            do
            {

                let decoder = JSONDecoder()
                self.bankholidayaData = try decoder.decode(Bankholiday.self, from: data ?? Data())
                if self.bankholidayaData?.englandAndWales?.events?.count ?? 0 > 0
                {
                    self.eventdata.removeAll()
                    for i in self.bankholidayaData?.englandAndWales?.events ?? [Event]()
                    {
                        let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                        self.eventdata.append(evnt)
                    }
                    let data = Newbankdata(division: self.bankholidayaData?.englandAndWales?.division, events: self.eventdata)
                    self.UnfilteredData.append(data)
                }
               // ******** //
                if self.bankholidayaData?.scotland?.events?.count ?? 0 > 0
                {
                    self.eventdata.removeAll()
                    for i in self.bankholidayaData?.scotland?.events ?? [Event]()
                    {
                        let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                        self.eventdata.append(evnt)
                    }
                    let data2 = Newbankdata(division: self.bankholidayaData?.scotland?.division, events: self.eventdata)
                    self.UnfilteredData.append(data2)
                }
               
                // ******** //

                if self.bankholidayaData?.scotland?.events?.count ?? 0 > 0
                {
                    self.eventdata.removeAll()
                    for i in self.bankholidayaData?.northernIreland?.events ?? [Event]()
                    {
                        let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                        self.eventdata.append(evnt)
                    }
                    let data3 = Newbankdata(division: self.bankholidayaData?.northernIreland?.division, events: self.eventdata)
                    self.UnfilteredData.append(data3)
                }
                
                if self.UnfilteredData.count > 0
                {
                    self.filteredData = self.UnfilteredData
                    self.SearchUnfilteredData = self.UnfilteredData
                    
                    DispatchQueue.main.async
                    {
                        self.tableV.delegate = self
                        self.tableV.dataSource = self
                        self.tableV.reloadData()
                    }
                }
            }catch
            {
                print(error.localizedDescription)
            }
            
        })

        task.resume()
        
    }
    
    @IBAction func btSorttapped( _ sender:UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Sort", message: "Select Date Sort Type", preferredStyle: .actionSheet)
              alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler:{ _ in
                self.sortthearray(type: "Asc")
                                                
              }))
              alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { _ in
                self.sortthearray(type: "Desc")

              }))
        
              alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

               
              switch UIDevice.current.userInterfaceIdiom {
              case .pad:
                 alert.popoverPresentationController?.sourceView = self.view
                 alert.popoverPresentationController?.sourceRect = CGRect(x: 60, y: 50, width: 75, height: 30)
                  alert.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
              default:
                  break
              }
              self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btFiltertapped( _ sender:UIBarButtonItem)
    {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC else { return }
        popupVC.data = data
        popupVC.height = height
        popupVC.topCornerRadius = topCornerRadius
        popupVC.presentDuration = presentDuration
        popupVC.dismissDuration = dismissDuration
        popupVC.popupDelegate = self
        popupVC.filtrdelegate = self
        present(popupVC, animated: true, completion: nil)
        
    }
    

    func sortthearray(type:String)
    {
        if type == "Asc"
        {
            for i in self.UnfilteredData
            {
                i.events?.sort(by: {$0.date ?? "" < $1.date ?? ""})
            }
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        }else if type == "Desc"
        {
            for i in self.UnfilteredData
            {
                i.events?.sort(by: {$0.date ?? "" > $1.date ?? ""})
            }
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
            
        }
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
          return UnfilteredData.count
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
                 
        let titleLabel = UILabel(frame: CGRect(x: 32, y: 0, width: 200, height: 44))
            headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.font =  UIFont.systemFont(ofSize: 18)
        titleLabel.text = UnfilteredData[section].division
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return UnfilteredData[section].events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Listcell
        {
             
            let color  = selectedIndexpath == indexPath.row ? UIColor.black : UIColor.lightGray
                cell.contentView.layer.borderColor = color.cgColor
                cell.contentView.layer.borderWidth = 0.2
                cell.lbTitle.text = UnfilteredData[indexPath.section].events?[indexPath.row].title
                cell.lbDate.text = UnfilteredData[indexPath.section].events?[indexPath.row].date
            
            cell.lbNotes.text = "Notes : \(UnfilteredData[indexPath.section].events?[indexPath.row].notes ?? "def")"
            cell.lbBounting.text = "Bounting : \(UnfilteredData[indexPath.section].events?[indexPath.row].bunting ?? false)"
           
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexpath = indexPath.row
        PrevSelectedIndexpath = indexPath.row
        if isSelected
        {
            isSelected = false
        }else
        {
            isSelected = true
        }

        tableViewcellheight = 130
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
        tableV.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == selectedIndexpath && isSelected == true
        {
            return CGFloat(tableViewcellheight)
        }else
        {
            return 70
        }
    }
}
extension ViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.subFiltereddata.removeAll()
        if searchText == ""
        {
            self.UnfilteredData = SearchUnfilteredData
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        }else
        {
            UnfilteredData = SearchUnfilteredData
            for items in self.UnfilteredData
            {
                self.eventdata.removeAll()
                let data = items.events?.filter{ ($0.title?.contains(searchText) ?? false)}
                for i in data ?? [Event]()
                {
                    let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                    self.eventdata.append(evnt)
                }
                let data3 = Newbankdata(division: items.division, events: self.eventdata)
                self.subFiltereddata.append(data3)
            }
            self.UnfilteredData = self.subFiltereddata
            DispatchQueue.main.async {
                self.tableV.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.UnfilteredData = SearchUnfilteredData
        DispatchQueue.main.async {
            self.tableV.reloadData()
        }    }
}
extension ViewController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
extension ViewController:Filterdelegate
{
    func filterthecontents(filtertypes:[Filter],notesfilter:Filter,buntyfilter:Filter,isInvolved:Bool)
    {
        self.eventdata.removeAll()
        self.Noteseventdata.removeAll()
        self.subFiltereddata.removeAll()
         
        if isInvolved == false
        {
        for filtertype in filtertypes
        {
            self.eventdata.removeAll()
            if filtertype.self == .englandandwales
            {
                for item in filteredData
                {
                    if item.division == "england-and-wales"
                    {
                        for i in item.events ?? [Event]()

                        {
                            if notesfilter.self == .containnotes && buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true && i.notes == "Substitute day"
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                            }else if notesfilter.self == .containnotes
                            {
                                if i.notes == "Substitute day"
                                {
                                   let evnts = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnts)
                                }
                                
                            }else if buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                                 
                            }else
                            {
                                let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                self.eventdata.append(evnt)
                            }
                            
                        }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                    }
                }
                
            }else if filtertype.self == .scotland
            {
                for item in filteredData
                {
                    if item.division == "scotland"
                    {
                        for i in item.events ?? [Event]()

                        {
                            if notesfilter.self == .containnotes && buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true && i.notes == "Substitute day"
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                            }else if notesfilter.self == .containnotes
                            {
                                if i.notes == "Substitute day"
                                {
                                   let evnts = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnts)
                                }
                                
                            }else if buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                                 
                            }else
                            {
                                let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                self.eventdata.append(evnt)
                            }
                            
                        }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                    }
            }
            }else if filtertype.self == .Northernirland
            {
                for item in filteredData
                {
                    if item.division == "northern-ireland"
                    {
                        for i in item.events ?? [Event]()

                        {
                            if notesfilter.self == .containnotes && buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true && i.notes == "Substitute day"
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                            }else if notesfilter.self == .containnotes
                            {
                                if i.notes == "Substitute day"
                                {
                                   let evnts = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnts)
                                }
                                
                            }else if buntyfilter.self == .buntingholidaysonly
                            {
                                if i.bunting == true
                                {
                                  let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                  self.eventdata.append(evnt)
                                }
                                 
                            }else
                            {
                                let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                                self.eventdata.append(evnt)
                            }
                            
                        }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                    }
            }
                
            }
            
        }
        }else
        {
            if notesfilter == .containnotes && buntyfilter == .buntingholidaysonly
            {
                for item in filteredData
                {
                    for i in item.events ?? [Event]()
                    {
                        if i.bunting == true && i.notes == "Substitute day"
                        {
                          let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                          self.eventdata.append(evnt)
                        }
                    }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                        
                    
                }
            }
            else if notesfilter == .containnotes
            {
                for item in filteredData
                {
                    for i in item.events ?? [Event]()
                    {
                        if i.notes == "Substitute day"
                        {
                           let evnts = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                          self.eventdata.append(evnts)
                        }
                           
                    }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                        
                    
                }
                 
            }else if buntyfilter == .buntingholidaysonly
            {
                for item in filteredData
                {
                    for i in item.events ?? [Event]()
                    {
                        if i.bunting == true
                        {
                          let evnt = Event(title: i.title, date: i.date, notes: i.notes, bunting: i.bunting)
                          self.eventdata.append(evnt)
                        }
                    }
                        let data3 = Newbankdata(division: item.division, events: self.eventdata)
                        self.subFiltereddata.append(data3)
                        
                    
                }
            }
        }
        self.SearchUnfilteredData = self.subFiltereddata
            self.UnfilteredData = self.subFiltereddata
            DispatchQueue.main.async
            {
                self.tableV.reloadData()
            }
        
        
        
    }
    func selectthefilter(type: FilterVC)
    {
        self.data = type.data
        self.eventdata.removeAll()
        self.Noteseventdata.removeAll()
        self.subFiltereddata.removeAll()
        self.SearchUnfilteredData.removeAll()

        if type.isEnglandselcted || type.isScotlandselcted || type.isNorthernselcted
        {
            
            var filters = [Filter]()
            if type.isEnglandselcted
            {
                filters.append(.englandandwales)
            }
            if type.isScotlandselcted
            {
                filters.append(.scotland)
            }
            if type.isNorthernselcted
            {
                filters.append(.Northernirland)
            }
            
            if type.isBountyselcted && type.isNotesselcted
            {
                self.filterthecontents(filtertypes: filters, notesfilter: .containnotes, buntyfilter: .buntingholidaysonly, isInvolved: false)

            }else if type.isBountyselcted
            {
                self.filterthecontents(filtertypes: filters, notesfilter: .None, buntyfilter: .buntingholidaysonly, isInvolved: false)
            }else if type.isNotesselcted
            {
                self.filterthecontents(filtertypes: filters, notesfilter: .containnotes, buntyfilter: .None, isInvolved: false)
            }else
            {
                self.filterthecontents(filtertypes: filters, notesfilter: .None, buntyfilter: .None, isInvolved: false)
            }
            
          }else if  type.isBountyselcted || type.isNotesselcted
        {
            if type.isBountyselcted && type.isNotesselcted
            {
                self.filterthecontents(filtertypes: [], notesfilter: .containnotes, buntyfilter: .buntingholidaysonly, isInvolved: true)

            }else if type.isBountyselcted
            {
                self.filterthecontents(filtertypes: [], notesfilter: .None, buntyfilter: .buntingholidaysonly, isInvolved: true)
            }else if type.isNotesselcted
            {
                self.filterthecontents(filtertypes: [], notesfilter: .containnotes, buntyfilter: .None, isInvolved: true)
            }
        }else
        {
            if type.isEnglandselcted == false && type.isScotlandselcted == false && type.isNorthernselcted == false && type.isBountyselcted == false && type.isNotesselcted == false
            {
                self.UnfilteredData = filteredData
                self.SearchUnfilteredData = filteredData
                DispatchQueue.main.async {
                    self.tableV.reloadData()
                }

            }
        }
         
    }
    
}
