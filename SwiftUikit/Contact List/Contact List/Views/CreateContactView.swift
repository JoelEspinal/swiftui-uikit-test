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
                
                if let imageUrlString = viewModel.contact.randomImageUrl,
                   let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 250, height: 250)
                    .frame(maxWidth: .infinity) 
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .frame(maxWidth: .infinity)
                }
                

                    
             
                Button {
                    Task {
                        await viewModel.getRandomImage()
                        print($viewModel.contact.randomImageUrl)
                        
                    }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .labelStyle(.iconOnly)
                .disabled($viewModel.contact.randomImageUrl == nil)
                
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
