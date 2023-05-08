//
//  Enum.swift
//  recon
//
//  Created by Dreamfora on 2023/04/16.
//

import Foundation

struct PresentItem: Identifiable {
    let id = UUID()
    let item: Item
    
    enum Item {
        case arCamera
    }
}
