//
//  ArCameraView.swift
//  recon
//
//  Created by Dreamfora on 2023/04/15.
//

import SwiftUI

struct ArCameraView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ARViewContainer()
            .overlay(
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                Text("Close")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                            .padding(14)
                            .backgroundColor(.blue)
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        HStack {
                            Button("x-axis rotation") {
                                viewModel.action(.onTapRotationX)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button("y-axis rotation") {
                                viewModel.action(.onTapRotationY)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button("z-axis rotation") {
                                viewModel.action(.onTapRotationZ)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button {
                            viewModel.action(.onTapCapture)
                        } label: {
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                                .frame(width: 65, height: 65)
                                .overlay(
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                )
                        }
                    }
                }
                    .padding(20))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    viewModel.addBox()
                }
            }
            .environmentObject(viewModel)
    }
}

struct ArCameraView_Previews: PreviewProvider {
    static var previews: some View {
        ArCameraView()
    }
}
