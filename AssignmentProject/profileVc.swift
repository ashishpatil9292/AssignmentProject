//
//  profileVc.swift
//  AssignmentProject
//
//  Created by iOS on 07/08/2021.
//

import UIKit
import SDWebImage
class profileVc: UIViewController {

     var profileData:ProfileInfo?
    @IBOutlet weak var lbProfilename:UILabel!
    @IBOutlet weak var lbGender:UILabel!
    @IBOutlet weak var lbAge:UILabel!
    @IBOutlet weak var lbDob:UILabel!
    @IBOutlet weak var lbContact:UILabel!
    @IBOutlet weak var lbEmail:UILabel!
    @IBOutlet weak var lbRegisteredon:UILabel!

    

    @IBOutlet weak var imgProfile:UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.clear.cgColor
        
        self.loadData()

    }
    @IBAction func btRefreshtapped( _ sender:UIBarButtonItem)
    {
        loadData()
    }
    func loadData()
    {
        guard let url = URL(string: "https://randomuser.me/api/") else {return}

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          // your code here
            if let error = error {
              print("Error accessing file: \(error)")
              return
            }
            
            do
            {

                let decoder = JSONDecoder()
                self.profileData = try decoder.decode(ProfileInfo.self, from: data ?? Data())
                guard let profdata = self.profileData else {return}
                let item = profdata.results[0].name
                let profileitem = profdata.results[0].picture
                let profileDob = profdata.results[0].dob
                let profileRegisteredon = profdata.results[0].registered
                DispatchQueue.main.async
                {
                    self.lbAge.text = "\(profileDob.age )"
                    self.lbGender.text = profdata.results[0].gender
                    self.imgProfile.sd_setImage(with: URL(string: "\(profileitem.large )"), completed: nil)
                    self.lbProfilename.text = "\(item.title ).\(item.first) \(item.last)"
                    self.lbEmail.text = profdata.results[0].email
                    self.lbContact.text = profdata.results[0].cell
                    self.lbDob.text = profileDob.date
                    self.lbRegisteredon.text = profileRegisteredon.date
                    
                }
            }catch
            {
                print(error.localizedDescription)
            }
            
        })

        task.resume()
        
    }

    
 

}
