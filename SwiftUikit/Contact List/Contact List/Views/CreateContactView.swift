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
    
    // Opciones para pasar datos si se requiere
    var onSave: ((String, String, String) -> Void)? = nil
    
    // Propiedades de estado para los campos del formulario
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $name)
                        .textContentType(.givenName)
                    
                    TextField("Apellido", text: $lastName)
                        .textContentType(.familyName)
                    
                    TextField("Teléfono", text: $phoneNumber)
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
                        onSave?(name, lastName, phoneNumber)
                        dismissAction()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    CreateContactView(dismissAction: {})
}
