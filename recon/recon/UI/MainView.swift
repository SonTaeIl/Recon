//
//  MainView.swift
//  recon
//
//  Created by Dreamfora on 2023/04/14.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(entity: ARPhoto.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ARPhoto.createAt, ascending: true)], animation: .default)
    private var photos: FetchedResults<ARPhoto>
    
    @State private var present: PresentItem?
    
    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Button {
                    present = PresentItem(item: .arCamera)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera")
                            .font(.callout)
                            .foregroundColor(.white)
                        Text("AR Camera")
                            .font(.callout)
                            .foregroundColor(.white)
                    }
                    .frame(width: 250, height: 60)
                    .backgroundColor(.blue)
                    .cornerRadius(20)
                }
                .padding(.top, 10)
                
                if photos.isEmpty {
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(photos, id: \.self) { photo in
                                if let image = UIImage(data: photo.image!) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
            }
            .fullScreenCover(item: $present) { _ in
                ArCameraView()
            }
        }
//        .environmentObject(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
