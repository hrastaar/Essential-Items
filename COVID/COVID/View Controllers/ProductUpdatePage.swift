//
//  ProductUpdatePage.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/10/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import SwiftUI

struct ProductUpdatePage: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ProductFormViewController {
        let mapPage = ProductFormViewController()
        return mapPage
    }
    
    func updateUIViewController(_ uiViewController: ProductFormViewController, context: Context) {
        
    }
}
