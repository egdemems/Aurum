//
//  PostView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct PostView: View {
    
    var ref = Database.database().reference()
    
    @AppStorage("showingPhoto") var showingPhoto = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    @State var thumbnail = [UIImage]()
    
    @State var firstLoad = true
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var postCount = 0
    
    func loader() {
        ref.child("\(wallet)/posts/count").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.postCount = pop!
            if pop! != 0 {
                if self.firstLoad == true{
                    for x in 1...pop! {
                        ref.child("\(wallet)/posts/post_\(x)/image_1").observe(.value) {
                            (snapshot) in
                            let pop1 = snapshot.value as? String
                            Storage.storage().reference().child("\(pop1!)").getData(maxSize: 1 * 10000 * 10000) {
                            (imageData, err) in
                            if err != nil {
                                  print("error downloading image")
                              } else {
                                  if let imageData = imageData {
                                    self.thumbnail.append(UIImage(data: imageData)!)
                                  } else {
                                        print("couldn't unwrap")
                                  }
                              }
                            }
                        }
                    }
                    self.firstLoad = false
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 30)
            Button(action: {self.showingPhoto = true}, label: {
                Text("List and item")
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
                if self.thumbnail.count == postCount {
                    if thumbnail == [UIImage]() {
                        Text("")
                    }
                    else {
                        LazyVGrid(columns: twoColumnGrid) {
                            ForEach(thumbnail, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 190, height: 190, alignment: .topLeading)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 255 / 255, green: 158 / 255, blue: 0 / 255)))
                }
            }
            .sheet(isPresented: $showingPhoto) {
                Photo()
            }.onAppear{
                loader()
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
