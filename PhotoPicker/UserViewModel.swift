//
//  UserViewModel.swift
//  PhotoPicker
//
//  Created by Mesut Aygün on 14.03.2023.
//

import Foundation
import SwiftUI
import UIKit
import Alamofire
import SDWebImageSwiftUI


@MainActor class UserViewModel : ObservableObject {
    @Published var selectedImage = UIImage()
    @Published var userPetImage : [ImageModel] = []
    @Published var photoUrl = ""
    let urlAWSforUSER = "https://snifferstorage.s3.eu-central-1.amazonaws.com/app/public/images/users/"
    let urlAWSforUPLOAD_USER = "https://api.sniffersocial.uk/mobile/uploadUserImage"
    func uploadImage() {
        
        
            guard let mediaImage = Media(withImage: self.selectedImage.sd_resizedImage(with: CGSize(width: 600 , height: 800 ), scaleMode: .aspectFill)!, forKey: "image" , imageName: "image") else { return }
            guard let url = URL(string: urlAWSforUPLOAD_USER) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //create boundary
            let boundary = generateBoundary()
            //set content type
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //call createDataBody method
            let dataBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                    
                }
                if let data = data {
                    
                    
                    do {
                        
                        let pageData = try JSONDecoder().decode(ImageModel.self, from: data)
                        DispatchQueue.main.async {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                
                                    self.photoUrl =  self.urlAWSforUSER + "\(pageData.image)"
                                    print("photoUrl -> \(String(describing: self.photoUrl))")
                                
                                
                            }
                            
                        }
                        
                        
                    } catch  {
                        print("errorrr")
                    }
                    
                    
                }
            }.resume()
        
    }
    
    

    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}



struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String, imageName : String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = imageName + ".jpg"
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        print("datas\(data)")
        self.data = data
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
            print("data======>>>",data)
        }
    }
}
