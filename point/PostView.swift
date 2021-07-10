//
//  PostView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct Post: Hashable {
    var id = UUID()
    var image: UIImage
    var postNum: String
}

struct PostView: View {
    
    var ref = Database.database().reference()
    
    @AppStorage("showingPhoto") var showingPhoto = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    @State var thumbnail = [Post]()
    
    @State var adder = [String]()
    
    //@State var firstLoad = true
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    func loader() {
        ref.child("\(wallet)/posts").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                print(key)
                if adder.contains("\(wallet)/posts/\(key)") {
                    print("already loaded")
                }
                else {
                    ref.child("\(wallet)/posts/\(key)/image_1").getData {
                        (err, snapshot) in
                        let pop = snapshot.value as? String
                        Storage.storage().reference().child("\(pop!)").getData(maxSize: 1 * 10000 * 10000) {
                        (imageData, err) in
                        if err != nil {
                              print("error downloading image")
                          } else {
                              if let imageData = imageData {
                                self.thumbnail.append(Post(image: UIImage(data: imageData)!, postNum: "\(wallet)/posts/\(key)"))
                                self.adder.append("\(wallet)/posts/\(key)")
                              } else {
                                    print("couldn't unwrap")
                              }
                          }
                        }
                    }
                }
            }
        })
    }
    
    var body: some View {
            VStack{
                Spacer()
                    .frame(height: 30)
                Button(action: {self.showingPhoto = true}, label: {
                    Text("List an item")
                        .font(.system(size: 30, design: .rounded))
                        .frame(width: 350 , height: 20, alignment: .center)
                        .foregroundColor(.black)
                })
                .padding()
                .font(.system(size: 20, design: .rounded))
                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                .foregroundColor(.white)
                .cornerRadius(30)
                ScrollView {
                    Spacer()
                        .frame(height: 30)
                    Text("Your Listings")
                        .font(.system(size: 25, design: .rounded))
                        .frame(width: 350 , height: 20, alignment: .leading)
                        .foregroundColor(.black)
                    Spacer()
                        .frame(height: 10)
                    if thumbnail == [Post]() {
                        Text("")
                    }
                    else {
                        LazyVGrid(columns: twoColumnGrid) {
                            ForEach(thumbnail, id: \.self) { thing in
                                NavigationLink(destination: PostSubView(username: wallet,firstPhoto: thing.image, name: thing.postNum)) {
                                    Image(uiImage: thing.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 190, height: 190, alignment: .topLeading)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .onAppear{
                    loader()
                }
                .padding(.top, 1)
                .sheet(isPresented: $showingPhoto) {
                    Photo()
                }
            }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
