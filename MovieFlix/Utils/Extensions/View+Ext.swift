//
//  View+Ext.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import SwiftUI

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}
