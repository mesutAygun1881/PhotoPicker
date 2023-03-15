//
//  ContentView.swift
//  PhotoPicker
//
//  Created by Mesut Aygün on 14.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var camera = false
    @State private var photoAlbum = false
    @State private var showPhotoGallery = false
    @EnvironmentObject var userViewModel : UserViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
            VStack {
                Button(action:{
                    self.showPhotoGallery = true
                }){
                    Text("Select Photo")
                        .frame(width: 200, height: 50)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(colors: [Color.red , Color.black.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(23)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                }
                Spacer()
                AsyncImage(url: URL(string: "\(self.userViewModel.photoUrl)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                    
                } placeholder: {
                    Color.gray
                }
                .frame(width: 300, height: 400)
                .cornerRadius(16)
                .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.purple, lineWidth: 3)
                    )
                Spacer()
            }
        
        .actionSheet(isPresented: $showPhotoGallery) {
            ActionSheet(
                title: Text("Image Choose"),
                buttons: [
                    .default(Text("Camera")) {
                        camera = true
                    },
                    
                        .default(Text("Photo Album")) {
                            photoAlbum = true
                        },
                    
                        .cancel(Text("Cancel"))
                ]
            )
        }
        
        .onChange(of: self.userViewModel.selectedImage, perform: { newValue in
            self.userViewModel.uploadImage()
        })
        .fullScreenCover(isPresented: $photoAlbum) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $userViewModel.selectedImage)
        }
        .fullScreenCover(isPresented: $camera) {
            ImagePicker(sourceType: .camera, selectedImage: $userViewModel.selectedImage)
        }
        
    }
}


