//
//  NsObjFile.swift
//  TestLax
//
//  Created by iRoid on 07/05/19.
//  Copyright © 2019 iRoid. All rights reserved.
//

import UIKit
import SQLite3
 
class NsObjFile: NSObject
{
    static let shareobj = NsObjFile()
    var db1:OpaquePointer? = nil
    var stmt:OpaquePointer? = nil
    
    func dicPath() -> String
    {
        let fileURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = fileURL.first! + "/Test"
 
        
        return url
        
    }
    func CreatTast(Query:String) -> Bool
    {
        let ulr = dicPath()
        var success = false
        if (sqlite3_open(ulr, &db1) ==  SQLITE_OK)
        {
            if (sqlite3_prepare_v2(db1, Query, -1, &stmt, nil) == SQLITE_OK)
            {
                
                if sqlite3_step(stmt) == SQLITE_DONE
                {
                    success = true
                    sqlite3_close(db1)
                    sqlite3_finalize(stmt)
                }
                else
                {
                    print("step faild :\(String(describing: sqlite3_errmsg(db1)))")
                }
            }
            else
            {
             
                 print("prepare v2 faild2 :\(String(describing: sqlite3_errmsg(db1)))")
            }
        }
        else
        {
          
            print("prepare openning faild :\(String(describing: sqlite3_errmsg(db1)))")
        }
        return success
        
    }
    func createTable()
    {
        //lastmessagetext,lastmessageid,onlinestatus,unreadchatcount,isunread,lastmessagedate
        let crateTable =  "create table if not exists localDb3(title text, date text,notes text,bunting text, category text)"
        let success = CreatTast(Query: crateTable)
        if success{
            print("create table successfully")
        }
        else
        {
            print("create table unsuccessfully")
        }
    }
    func getAllTask(Query:String) -> NSMutableArray
    {
        
        let dataArray = NSMutableArray()
    
        let ulr = dicPath()
        if (sqlite3_open(ulr, &db1) ==  SQLITE_OK)
        {
            if (sqlite3_prepare_v2(db1, Query, -1, &stmt, nil) == SQLITE_OK)
            {
                
               while (sqlite3_step(stmt) == SQLITE_ROW)
               {
                    let DataDic = NSMutableDictionary()
                /*
                 (StoreId text,Title text,Email text,MobileNo text,Address text,City text,State text,ZipCode text,MobileStoreURL text,Logo text)
                 */
                    
                     let Title = sqlite3_column_text(stmt, 0)
                    let TitleString = String(cString: Title!)
                    DataDic.setValue(TitleString, forKey: "title")

                    let Email = sqlite3_column_text(stmt, 1)
                    let EmailStrng = String(cString: Email!)
                    DataDic.setValue(EmailStrng, forKey: "date")
                    
             // title,email,mobileno,address,city,state,zipcode ,mobilestoreurl,logo
                    let MobileNo = sqlite3_column_text(stmt, 2)
                    let MobileNoString = String(cString: MobileNo!)
                    DataDic.setValue(MobileNoString, forKey: "notes")

                    let Address = sqlite3_column_text(stmt, 3)
                    let AddressString = String(cString: Address!)
                    DataDic.setValue(AddressString, forKey: "bunting")
                
                    let City = sqlite3_column_text(stmt, 4)
                    let CityString = String(cString: City!)
                    DataDic.setValue(CityString, forKey: "category")
                
                    
                     
                    dataArray.add(DataDic)
                   
                }
               
            }
            else
            {
               print("prepare v2 faildasaa :\(String(describing: sqlite3_errmsg(db1)))")
            }
        }
        else
        {
            print("prepare opennin1g faild :\(String(describing: sqlite3_errmsg(db1)))")
        }
        
        
        
        return dataArray
        
    }

}
 
 
