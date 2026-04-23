//
//  AuthView.swift
//  MapFlip
//
//  Created by Alejandro González on 22/04/26.
//

import LocalAuthentication
import SwiftUI

struct AuthView: View {
    @State private var isUnlocked = false;
    var body: some View {
        if isUnlocked {
            Text("Unlocked :D")
        } else {
            Text("Please give me your face's biometric information!")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock app") { success, error in
                if (success) {
                    isUnlocked = true
                } else {
                    //Problemo
                }
            }
        } else { //This means device has no biometrics
            
        }
        
    }
}

#Preview {
    AuthView()
}
