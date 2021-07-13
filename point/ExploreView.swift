//
//  ExploreView.swift
//  point
//
//  Created by Harrison Sherwood on 7/13/21.
//

import SwiftUI

struct ExploreView: View {
    
    @AppStorage("zipcode") var zipcode: String = UserDefaults.standard.string(forKey: "Zipcode") ?? ""
    
    var categories = ["Appliances", "Apps & Games", "Arts, Crafts, & Sewing", "Automotive Parts & Accessories", "Beauty & Personal Care",
    "Books", "CDs & Vinyl", "Cell Phones & Accesories", "Clothing", "Shoes", "Jewlery", "Collectibles & Fine Art", "Computers", "Electronics", "Garden & Outdoor", "Grocery & Gourmet Food", "Handmade", "Health & Household", "Home & Kitchen", "Industrial & Scientific", "Luggage & Travel", "Movies & TV", "Musical Instruments", "Office Products",
    "Pet Supplies", "Sports & Outdoors", "Tools & Home Improvement", "Toys & Games", "Video Games"]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
