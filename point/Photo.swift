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
    
    @AppStorage("showingPhoto") var showingPhoto:Bool = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    var ref = Database.database().reference()
    
    @State var images: [UIImage] = []
    @State var picker = false
    
    @State var description = ""
    
    @State var price = ""
    
    @State var count = 0
    
    @State private var scrollViewContentOffset = CGFloat(0)
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack{
                    Rectangle()
                        .fill(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                        .frame(width: 450, height: 100)
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            LazyHStack(spacing: 5) {
                                ForEach(images, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100, alignment: .topLeading)
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
                            .frame(width: 450, height: 100)
                    })
                }
                //.padding(.top, 30)
                VStack {
                    Text("Description")
                        .font(.system(size: 20, design: .rounded))
                        .frame(width: 300 , height: 20, alignment: .leading)
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
                            .frame(width: 350, height: 300)
                            .font(.body)
                }
                .frame(width: 350)
                .padding()
                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                .cornerRadius(20)
                VStack {
                    Text("Points")
                        .font(.system(size: 20, design: .rounded))
                        .frame(width: 300 , height: 20, alignment: .leading)
                        .foregroundColor(.black)
                    TextField("0", text: $price)
                        .font(.system(size: 20, design: .rounded))
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 325)
                }
                .frame(width: 350)
                .padding()
                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                .cornerRadius(20)
                Button(action: {
                    if !images.isEmpty {
                        if images.count < 7 {
                            if description != "" {
                                if price != "" {
                                    count = 1
                                    let post1 = UUID()
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
                                        ref.child("\(wallet)/posts/\(post1)/price").setValue(Int(price))
                                        ref.child("\(wallet)/posts/\(post1)/description").setValue(description)
                                        ref.child("\(wallet)/posts/\(post1)/image_\(count)").setValue("\(wallet)/\(post1)/\(count)")
                                        ref.child("\(wallet)/posts/\(post1)/image_count").setValue(count)
                                        count += 1
                                    }
                                    images.removeAll()
                                    description = ""
                                    price = ""
                                    self.showingPhoto = false

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
                            print("too many images")
                        }
                    }
                    else {
                        print("images = empty")
                    }
                }, label: {
                    Text("Post")
                        .font(.system(size: 30, design: .rounded))
                        .frame(width: 350 , height: 20, alignment: .center)
                        .foregroundColor(.black)
                })
                .padding()
                .font(.system(size: 20, design: .rounded))
                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                .foregroundColor(.white)
                .cornerRadius(30)
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
