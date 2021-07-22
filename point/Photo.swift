//
//  Photo.swift
//  point
//
//  Created by Harrison Sherwood on 7/8/21.
//
//Copyright 2021
//

import SwiftUI
import PhotosUI
import FirebaseDatabase
import FirebaseStorage

struct Photo: View {
    
    @AppStorage("zipcode") var zipcode: String = UserDefaults.standard.string(forKey: "Zipcode") ?? ""
    
    @AppStorage("showingPhoto") var showingPhoto:Bool = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    var ref = Database.database().reference()
    
    @State var images: [UIImage] = []
    @State var picker = false
    
    @State var title = ""
    
    @State var description = ""
    
    var categories = ["Appliances", "Apps & Games", "Arts, Crafts, & Sewing", "Automotive Parts & Accessories", "Beauty & Personal Care",
    "Books", "CDs & Vinyl", "Cell Phones & Accesories", "Clothing", "Shoes", "Jewlery", "Collectibles & Fine Art", "Computers", "Electronics", "Garden & Outdoor", "Grocery & Gourmet Food", "Handmade", "Health & Household", "Home & Kitchen", "Industrial & Scientific", "Luggage & Travel", "Movies & TV", "Musical Instruments", "Office Products",
    "Pet Supplies", "Sports & Outdoors", "Tools & Home Improvement", "Toys & Games", "Video Games"]
    
    @State var category = ""
    
    @State var hashtags = ""
    
    @State var price = ""
    
    @State var count = 0
    
    @AppStorage("showingCategory") var showingCategory = false
    
    @State private var scrollViewContentOffset = CGFloat(0)
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    ZStack{
                        Rectangle()
                            .fill(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 100)
                        if !images.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false, content: {
                                LazyHStack(spacing: 5) {
                                    ForEach(images, id: \.self) { img in
                                        Image(uiImage: img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                    }
                                }
                            })
                        } else {
                            Image("pluscamera")
                                .resizable()
                                .scaledToFit()
                                .frame(width:25, height:25)
                        }
                        Button(action: {
                            images.removeAll()
                            picker.toggle()
                        }, label: {
                            Text("")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 100)
                        })
                    }
                    //.padding(.top, 30)
                    VStack {
                        Text("Title")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 20)
                            .foregroundColor(.black)
                        TextField("", text: $title)
                            .font(.system(size: 20))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    VStack {
                        Text("Description")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 20)
                            .foregroundColor(.black)
                        ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.white)
                                    
                                    if description.isEmpty {
                                        Text("Add item color, style, condition, sizing, and any other important details.")
                                            .foregroundColor(Color(UIColor.placeholderText))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    TextEditor(text: $description)
                                        .padding(4)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 300)
                                .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    //.cornerRadius(20)
                    VStack {
                        Text("Price")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 20)
                            .foregroundColor(.black)
                        HStack {
                            Text("$")
                                .font(.system(size: 20))
                            TextField("0", text: $price)
                                .font(.system(size: 20))
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    //.cornerRadius(20)
                    VStack {
                        Button(action: {self.showingCategory.toggle()}, label: {
                            HStack {
                                Text("Category")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                Spacer()
                                if category == "" {
                                    Text("Choose")
                                        .foregroundColor(Color.gray)
                                }
                                else {
                                    Text(category)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 20)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    //.cornerRadius(20)
                    VStack {
                        Text("Zipcode")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 20)
                            .foregroundColor(.black)
                        TextField("0", text: $zipcode)
                            .font(.system(size: 20))
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    //.cornerRadius(20)
                    Spacer()
                        .frame(height: 10)
                    Button(action: {
                        if !images.isEmpty {
                            if description != "" {
                                if price != "" {
                                    if category != "" {
                                        if zipcode != "" {
                                            if title != "" {
                                                count = 1
                                                let post1 = UUID()
                                                let post2 = UUID()
                                                for x in images {
                                                    if let imageData = x.jpegData(compressionQuality: 0.25) {
                                                        let storage = Storage.storage()
                                                        storage.reference().child("\(wallet)/\(post1)/\(count)").putData(imageData, metadata: nil) { (_, err) in
                                                            if err != nil {
                                                                print("an error occurred")
                                                                print(err ?? "")
                                                            } else {
                                                                print("image uploaded successfully")
                                                            }
                                                        }
                                                    } else {
                                                        print("couldnt unwrap image to data")
                                                    }
                                                    ref.child("\(wallet)/posts/\(post1)/title").setValue(title)
                                                    ref.child("\(wallet)/posts/\(post1)/price").setValue(Int(price))
                                                    ref.child("\(wallet)/posts/\(post1)/zipcode").setValue(Int(zipcode))
                                                    ref.child("\(wallet)/posts/\(post1)/description").setValue(description)
                                                    ref.child("\(wallet)/posts/\(post1)/image_\(count)").setValue("\(wallet)/\(post1)/\(count)")
                                                    ref.child("\(wallet)/posts/\(post1)/image_count").setValue(count)
                                                    ref.child("\(wallet)/posts/\(post1)/category").setValue(category)
                                                    count += 1
                                                }
                                                ref.child("\(category)/\(zipcode)/\(post2)").setValue("\(wallet)/posts/\(post1)")
                                                images.removeAll()
                                                description = ""
                                                price = ""
                                                category = ""
                                                title = ""
                                                self.showingPhoto = false
                                            }
                                            else {
                                                print("title = ''")
                                            }
                                        }
                                        else {
                                            print("zipcode = ''")
                                        }
                                    }
                                    else {
                                        print("category = ''")
                                    }
                                }
                                else {
                                    print("price = nil")
                                }
                            }
                            else {
                                print("description = ''")
                            }
                        }
                        else {
                            print("images = empty")
                        }
                    }, label: {
                        Neumorphic(name: "Post", width: 300)
                            .padding()
                    })
                    //.cornerRadius(30)
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.endEditing()
                        }
                )
                .sheet(isPresented: $picker) {
                    ImagePicker(images: $images, picker: $picker)
                }
                .sheet(isPresented: $showingCategory) {
                    ZStack {
                        Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        ScrollView{
                            Spacer()
                                .frame(height: 30)
                            ForEach(categories, id: \.self) { cat in
                                Button(action: {
                                    category = cat
                                        self.showingCategory.toggle()
                                }, label: {
                                    Text(cat)
                                        .font(.system(size: 20))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .frame(height: 20)
                                        .foregroundColor(.black)
                                })
                                .padding()
                                .font(.system(size: 20))
                                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                                .foregroundColor(.white)
                                //.cornerRadius(30)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Photo_Previews: PreviewProvider {
    static var previews: some View {
        Photo()
    }
}
