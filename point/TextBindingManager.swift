//
//  TextBindingManager.swift
//  point
//
//  Created by Harrison Sherwood on 7/7/21.
//

import Foundation

class TextBindingManager: ObservableObject {
   @Published var text = "" {
       didSet {
           if text.count > characterLimit && oldValue.count <= characterLimit {
               text = oldValue
           }
       }
   }
   let characterLimit: Int

   init(limit: Int = 1){
       characterLimit = limit
   }
}
