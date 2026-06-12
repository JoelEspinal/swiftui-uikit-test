//
//  CreateContactView.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import Foundation

import SwiftUI

struct CreateContactView: View {
    // Callback para avisarle a UIKit/Objective-C que la pantalla debe cerrarse
    var dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pantalla de Creación (SwiftUI)")
                .font(.title)
            
            Button("Cerrar / Cancelar") {
                dismissAction() // Llama al callback
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
