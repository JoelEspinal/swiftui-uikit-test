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
    
    // Instanciamos el ViewModel usando la macro @Observable de iOS 17+
    @State private var contactViewModel = ContactViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $contactViewModel.name)
                        .textContentType(.givenName)
                    
                    TextField("Apellido", text: $contactViewModel.lastName)
                        .textContentType(.familyName)
                    
                    TextField("Teléfono", text: $contactViewModel.phoneNumber)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                }
            }
            .navigationTitle("Nuevo Contacto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismissAction()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        contactViewModel.save(
                            name: contactViewModel.name,
                            lastName: contactViewModel.lastName,
                            phone: contactViewModel.phoneNumber,
                            imageUrl: contactViewModel.randomImageUrl
                        )
                        dismissAction()
                    }
                    .disabled(contactViewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    CreateContactView(dismissAction: {})
}
