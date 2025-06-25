//
//  UploadImageView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI
import EasyErrorHandling
import PhotosUI

struct UploadImageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var imageUrl: URL?
    
    @State private var showPhotoPicker: Bool = false
    @State private var showFilePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    
    @State private var isUploading: Bool = false
    
    func preparePhoto() {
        guard let selectedPhoto else {
            return
        }
        Task {
            do {
                let tempDir = FileManager.default.temporaryDirectory
                if let loaded = try await selectedPhoto.loadTransferable(type: Data.self), let imgData = UIImage(data: loaded)?.jpegData(compressionQuality: 85) {
                    let fileURL = tempDir.appendingPathComponent("\(UUID().uuidString).jpg")
                    
                    try imgData.write(to: fileURL)
                    
                    self.imageUrl = fileURL
                } else {
                    errorHandler.handle("Couldn't get photos", while: "preparing photo for upload")
                }
            } catch {
                self.errorHandler.handle(error, while: "preparing photo for upload")
            }
        }
    }
    
    func prepareFile(_ result: Result<URL, any Error>) {
        switch result {
        case .success(let success):
            if success.startAccessingSecurityScopedResource() {
                self.imageUrl = success
            } else {
                self.errorHandler.handle("Couldn't access selected file", while: "selecting file for upload")
            }
        case .failure(let failure):
            self.errorHandler.handle(failure, while: "selecting file for upload")
        }
    }
    
    func uploadImage() {
        guard let imageUrl else {
            return
        }

        self.isUploading = true

        Task {
            do {
                _ = try await self.connectionHandler.uploadImage(fileURL: imageUrl)
                self.imageUrl?.stopAccessingSecurityScopedResource()
                self.imageUrl = nil
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "Uploading image")
            }
            self.isUploading = false
        }
    }
    
    var body: some View {
        VStack {
            if let imageUrl {
                if let imgData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imgData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
                Button(action: self.uploadImage) {
                    if isUploading {
                        ProgressView()
                    } else {
                        Text("Upload")
                    }
                }
                .disabled(isUploading)
                .buttonStyle(.borderedProminent)
            } else {
                Menu {
                    Button {
                        self.showPhotoPicker.toggle()
                    } label: {
                        Label("Upload from photos", systemImage: "photo")
                    }
                    Button {
                        self.showFilePicker.toggle()
                    } label: {
                        Label("Upload from files", systemImage: "folder")
                    }
                } label: {
                    Label("Select image to upload", systemImage: "photo")
                }
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images, preferredItemEncoding: .compatible)
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.image], onCompletion: prepareFile)
        .onChange(of: selectedPhoto, preparePhoto)
    }
}

#Preview {
    UploadImageView()
        .withErrorHandling()
        .environment(HubConnectionHandler())
}
