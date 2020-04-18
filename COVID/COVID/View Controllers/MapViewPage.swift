//
//  MapViewPage.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/9/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import SwiftUI

struct MapViewPage: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MapViewController {
        let mapPage = MapViewController()
        return mapPage
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
    }
}

