//
//  EnumViewsView.swift
//  MapFlip
//
//  Created by Alejandro González on 17/04/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

enum LoadingStates {
    case loading, success, failed
}

struct EnumViewsView: View {
    @State private var loadingState : LoadingStates = .success
    
    var body: some View {
        switch loadingState {
        case .loading: LoadingView()
        case .success: SuccessView()
        case .failed: FailedView()
        }
    }
}

#Preview {
    EnumViewsView()
}
