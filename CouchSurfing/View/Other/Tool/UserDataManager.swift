//
//  UserDataManager.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/7.
//  Copyright © 2016年 monstar. All rights reserved.
//

import Foundation

/*
protocol BoolDefaultSettable {
    associatedtype BoolKey : RawRepresentable
}

extension UserDefaults : BoolDefaultSettable {
    enum BoolKey:NSString {
        case isGuidancePageShow
    }
}

extension BoolDefaultSettable where BoolKey.RawValue == String {
    
    func set(_ value: Bool, forKey key: BoolKey) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func bool(forKey key: BoolKey) -> Bool {
        let key = key.rawValue
        return UserDefaults.standard.bool(forKey: key)
    }
}
*/
class UserDataManager{
    fileprivate static let userdataManager:UserDataManager = UserDataManager()
    
    public var guidancePageShow:Bool{
        get{
           return UserDefaults.standard.bool(forKey: "isGuidancePageShow")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isGuidancePageShow")
        }
    }
    public var isLogin:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
    }
    
    
}

// MARK: - public func
extension UserDataManager{
   static public func manager()->UserDataManager{
        return userdataManager
    }

}
