//
//  ContactPresenter.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import UIKit
import SwiftUI
import SwiftUI

@objc class ContactPresenter: NSObject {

    @objc static func presentCreateContact(from sourceViewController: UIViewController) {
        Task { @MainActor in
            let viewModel = DependencyContainer.shared.makeContactViewModel()
            let swiftUIView = CreateContactView(viewModel: viewModel, dismissAction: {
                sourceViewController.dismiss(animated: true, completion: nil)
            })

            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.modalPresentationStyle = .pageSheet
            sourceViewController.present(hostingController, animated: true, completion: nil)
        }
    }
    
    @objc static func presentDetailContact(from sourceViewController: UIViewController, contactMO: ContactMO) {
        var currentContact = Contact(id: contactMO.id ?? UUID.zero, name: contactMO.name ?? "", lastName: contactMO.lastName ?? "", phoneNumber: contactMO.phone ?? "", randomImageUrl: contactMO.imageUrl ?? "")
        
        Task { @MainActor in
            let viewModel = DependencyContainer.shared.makeContactViewModelDetail(contactmo: contactMO)
            let swiftUIView = CreateContactView(viewModel: viewModel, dismissAction: {
                sourceViewController.dismiss(animated: true, completion: nil)
            })

            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.modalPresentationStyle = .pageSheet
            sourceViewController.present(hostingController, animated: true, completion: nil)
        }
    }
}
