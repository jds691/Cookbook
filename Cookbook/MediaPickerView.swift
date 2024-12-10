//
//  MediaPickerView.swift
//  Cookbook
//
//  Created by Neo Salmon on 10/12/2023.
//

import SwiftUI
import Photos
import PhotosUI

struct MediaPickerView<MenuLabel: View>: View {
    @State private var showPhotoPicker: Bool = false
    @State private var showCamera: Bool = false
    @State private var showFilePicker: Bool = false
    
    @State private var photosPickerItem: PhotosPickerItem?
    
    var label: () -> MenuLabel
    
    var body: some View {
        Menu {
            Button {
                showPhotoPicker = true
            } label: {
                Label("ACTION_PHOTO_LIBRARY", systemImage: "photo.on.rectangle")
            }
            Button {
                showCamera = true
            } label: {
                Label("ACTION_TAKE_PHOTO", systemImage: "camera")
            }
            Button {
                showFilePicker = true
            } label: {
                Label("ACTION_CHOOSE_FILE", systemImage: "folder")
            }
        } label: {
            label()
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photosPickerItem, matching: .images)
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.image]) { result in
            
        }
    }
}

#Preview {
    MediaPickerView {
        Text("Pick Photo")
    }
}
