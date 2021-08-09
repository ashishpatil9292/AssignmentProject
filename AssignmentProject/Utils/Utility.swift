//
//  Utility.swift
//  AssignmentProject
//
//  Created by iOS on 09/08/2021.
//

import Foundation

import UIKit
extension UIViewController {
    func showAlert(msg: String,okBtnTitle:String,cancelBtnTitle:String? = "Cancel",okBtnCompletion: @escaping () -> Void, cancelbtnCompletion : @escaping () -> Void) {
        
        let alert = UIAlertController(title: AppConstant.AppName, message: msg, preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: { _ in
            okBtnCompletion()
        }))
        
        if cancelBtnTitle != nil {
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: UIAlertAction.Style.default, handler: { (action) in
                cancelbtnCompletion()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
     
}

struct AppConstant {
    static let AppName = "Assignment project"

}
