//
//  ImagePicker.swift
//  point
//
//  Created by Harrison Sherwood on 7/8/21.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(imagePicker: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        // videos can be used too
        config.filter = .images
        // 0 = multiple selections
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        // assigning delegate
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(imagePicker: ImagePicker) {
            parent = imagePicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // closing picker
            parent.picker.toggle()
            
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { image, err in
                        guard let image1 = image else {
                            print(err!)
                            return
                        }
                        
                        // appending image
                        self.parent.images.append(image1 as! UIImage)
                    }
                } else {
                    // cannot be loaded
                    print("Error: image cannot be loaded")
                }
            }
        }
    }
}
