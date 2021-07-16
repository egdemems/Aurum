//
//  accountView.swift
//  point
//
//  Created by Harrison Sherwood on 7/5/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct accountView: View {
    var ref = Database.database().reference()
    @AppStorage("wallet") var wallet:String = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage(imageLiteralResourceName: "tab")
    @State var check = true
    func load() {
        Storage.storage().reference().child("\(wallet)/pfp").getData(maxSize: 1 * 1024 * 1024) {
        (imageData, err) in
        if err != nil {
              print("error downloading image")
          } else {
              if let imageData = imageData {
                self.image = UIImage(data: imageData)!
              } else {
                    print("couldn't unwrap")
              }
          }
        }
    }
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(50)
                }
                Text(wallet)
                    .font(.system(size: 40, design: .rounded))
            }
            Button(action: {
                wallet = ""
            }, label: {
                Neumorphic(name: "Log out", width: 300)
                    .padding()
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.992025435, green: 0.9831623435, blue: 0.8817279935, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowPhotoLibrary) {
            SingleImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .onChange(of: image, perform: { value in
            if check == false {
                ref.child("\(wallet)/pfp").setValue(true)
                if let imageData = image.jpegData(compressionQuality: 0.25) {
                    let storage = Storage.storage()
                    storage.reference().child("\(wallet)/pfp").putData(imageData, metadata: nil) { (_, err) in
                        if err != nil {
                            print("an error occurred")
                            print(err ?? "")
                        } else {
                            print("image uploaded successfully")
                        }
                    }
                }
            }
        })
        .onAppear{
            if check == true {
                load()
                check = false
            }
        }
    }
}

struct accountView_Previews: PreviewProvider {
    static var previews: some View {
        accountView()
    }
}
