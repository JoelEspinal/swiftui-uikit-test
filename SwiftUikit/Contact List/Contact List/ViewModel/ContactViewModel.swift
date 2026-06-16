//
//  ContactViewModel.swift
//  Contact List
//s
//  Created by Joel Espinal on 12/6/26.
//

import Foundation
import Combine
import SwiftUI

extension Notification.Name {
    static let contactSaved = Notification.Name("ContactSaved")
}

@Observable
class ContactViewModel: ObservableObject {
    var contact = Contact(id: UUID(), name: "", lastName: "", phoneNumber: "", randomImageUrl: "")

    private let getContactUseCase: GetContactUseCase
    private let saveContactUseCase: SaveContactUseCase
    private let getRandomImageUseCase: GetRandomImageUseCase

    
    init(getContactUseCase: GetContactUseCase, saveContactUseCase: SaveContactUseCase, getRandomImageUseCase: GetRandomImageUseCase) {
        self.getContactUseCase = getContactUseCase
        self.saveContactUseCase = saveContactUseCase
        self.getRandomImageUseCase = getRandomImageUseCase
    }
    
    
    
    init(getContactUseCase: GetContactUseCase, saveContactUseCase: SaveContactUseCase, getRandomImageUseCase: GetRandomImageUseCase, Contact: ContactMO) {
        self.getContactUseCase = getContactUseCase
        self.saveContactUseCase = saveContactUseCase
        self.getRandomImageUseCase = getRandomImageUseCase
        
//        self.contact = Contact
    }
    
    var canSave: Bool {
        !contact.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//         && !contact.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func save() async {
        contact.name = contact.name.trimmingCharacters(in: .whitespacesAndNewlines)
        contact.lastName = contact.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        contact.phoneNumber = contact.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
       
//        if contact.id == UUID() {
//            contact.randomImageUrl = try! await getRandomImageUseCase.execute()
//        }
        

        do {
            _ = try await saveContactUseCase.execute(contact: contact)
            NotificationCenter.default.post(name: .contactSaved, object: nil)
        } catch {
            print("Failed to save contact: \(error)")
        }
    }

    func getContact(byUUID uuid: UUID) async -> Contact? {
        try? await getContactUseCase.execute(id: uuid)
    }
    
    func getRandomImage() async {
        if contact.randomImageUrl != nil || contact.randomImageUrl?.isEmpty == true {
            let randomImage = try! await getRandomImageUseCase.execute()
            contact.randomImageUrl = randomImage?.url
        }
    }
}
