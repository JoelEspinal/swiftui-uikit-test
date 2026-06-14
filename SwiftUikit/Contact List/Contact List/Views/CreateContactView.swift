//
//  CreateContactView.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import SwiftUI

struct CreateContactView: View {
    @Bindable var viewModel: ContactViewModel
    var dismissAction: () -> Void

    init(viewModel: ContactViewModel, dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismissAction
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $viewModel.name)
                        .textContentType(.givenName)

                    TextField("Apellido", text: $viewModel.lastName)
                        .textContentType(.familyName)

                    TextField("Teléfono", text: $viewModel.phoneNumber)
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
                        Task {
                            await viewModel.save()
                            dismissAction()
                        }
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
