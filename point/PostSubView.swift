//
//  PostSubView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct PostSubView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("wallet") var wallet:String = ""
    
    var ref = Database.database().reference()
    
    var username: String
    
    var firstPhoto: UIImage
    
    var name: String
    
    @State var postCount1 = true
    
    @State var thumbnail1 = [UIImage]()
    
    @State var description = ""
    
    @State var category = ""
    
    @State var price = 0
    
    @State var zipcode = 0
    
    func loader() {
        ref.child("\(name)/image_count").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            if pop! != 0 {
                if pop == 1 {
                    postCount1 = true
                }
                else {
                    postCount1 = false
                    for x in 2...pop! {
                        ref.child("\(name)/image_\(x)").observe(.value) {
                            (snapshot) in
                            let pop1 = snapshot.value as? String
                            if pop1 != nil {
                                Storage.storage().reference().child("\(pop1!)").getData(maxSize: 1 * 10000 * 10000) {
                                (imageData, err) in
                                if err != nil {
                                      print("error downloading image")
                                  } else {
                                      if let imageData = imageData {
                                        self.thumbnail1.append(UIImage(data: imageData)!)
                                      } else {
                                            print("couldn't unwrap")
                                      }
                                  }
                                }
                            }
                        }
                    }
                }
            }
        }
        ref.child("\(name)/description").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.description = pop ?? "No Description"
        }
        ref.child("\(name)/category").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.category = pop ?? ""
        }
        ref.child("\(name)/price").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.price = pop ?? 0
        }
        ref.child("\(name)/zipcode").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.zipcode = pop ?? 0
        }
    }
    
    var body: some View {
        VStack{
            ScrollView {
                ZStack(alignment: .topLeading) {
                    if postCount1 == true {
                        Image(uiImage: firstPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 390, height: 390, alignment: .center)
                            .clipped()
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                Image(uiImage: firstPhoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 390, height: 390, alignment: .center)
                                    .clipped()
                                if thumbnail1 != [UIImage]() {
                                    ForEach(thumbnail1, id: \.self) { thing in
                                        Image(uiImage: thing)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 390, height: 390, alignment: .center)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                    Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            }) {
                                ZStack {
                                    Ellipse()
                                        .fill(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                                    .frame(width: 50, height: 50)
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                }
                                .padding(.leading, 20)
                                .padding(.top, 20)
                    }
                }
                .frame(width: 390, height: 390, alignment: .center)
                VStack{
                    HStack {
                        Text(username)
                            .bold()
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(self.price)")
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .frame(width: 350, alignment: .leading)
                    .padding()
                    Text("Description")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 350, alignment: .leading)
                    Text(self.description)
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 350, alignment: .leading)
                    Spacer()
                        .frame(height:40)
                    Text("Category")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 350, alignment: .leading)
                    Text(self.category)
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 350, alignment: .leading)
                    Spacer()
                        .frame(height:40)
                    HStack {
                        Text("Zipcode:")
                            .bold()
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.black)
                        Text(String(self.zipcode))
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.black)
                    }
                    .frame(width: 350, alignment: .leading)
                    .padding()
                    Spacer()
                }
                .background(Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255))
                .cornerRadius(10)
                .padding(.top, 1)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        if username == wallet {
                            Button(action: {}, label: {
                                Text("Buy")
                                    .foregroundColor(.black)
                                    .font(.system(size: 30, design: .rounded))
                                    .padding()
                            })
                        }
                    }
                }
            }
        }
        //.navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        //.navigationBarItems(leading: btnBack)
        //.navigationBarTitle("", displayMode: .inline)
        .onAppear{
            loader()
            UIToolbar.appearance().barTintColor = UIColor(Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255))
            UIToolbar.appearance().layer.borderWidth = 0.0
            //UIToolbar.appearance().clipsToBounds = true
        }
    }
}
