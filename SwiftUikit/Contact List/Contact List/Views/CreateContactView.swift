//
//  CreateContactView.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import SwiftUI

struct CreateContactView: View {
    @State var viewModel: ContactViewModel
    var dismissAction: () -> Void

    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $viewModel.contact.name)
                        .textContentType(.givenName)
                    
                    TextField("Apellido", text: $viewModel.contact.lastName)
                        .textContentType(.familyName)
                    
                    TextField("Teléfono", text: $viewModel.contact.phoneNumber)
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
//                        if !viewModel.contact.name.isEmpty {
                            Task {
                                await viewModel.save()
                                dismissAction()
                            }
//                        }
                        
                       
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}

#Preview {
    CreateContactView(
        viewModel: DependencyContainer.shared.makeContactViewModel(),
        dismissAction: {}
    )
}
