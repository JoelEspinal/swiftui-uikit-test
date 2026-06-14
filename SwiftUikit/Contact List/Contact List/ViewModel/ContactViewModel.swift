//
//  ContactViewModel.swift
//  Contact List
//
//  Created by Joel Espinal on 12/6/26.
//

import Foundation
import Observation

extension Notification.Name {
    static let contactSaved = Notification.Name("ContactSaved")
}

@MainActor
@Observable
final class ContactViewModel {

    var name = ""
    var lastName = ""
    var phoneNumber = ""
    var randomImageUrl = ""

    private let getContactUseCase: GetContactUseCase
    private let saveContactUseCase: SaveContactUseCase

    init(getContactUseCase: GetContactUseCase, saveContactUseCase: SaveContactUseCase) {
        self.getContactUseCase = getContactUseCase
        self.saveContactUseCase = saveContactUseCase
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func save() async {
        let contact = Contact(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            randomImageUrl: randomImageUrl
        )

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
}
