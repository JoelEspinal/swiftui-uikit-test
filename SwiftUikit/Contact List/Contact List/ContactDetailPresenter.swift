//
//  ContactPresenter.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import UIKit
import SwiftUI

@objc class ContactDetailPresenter: NSObject {

    @objc static func presentCreateContact(from sourceViewController: UIViewController, withContact: ContactMO?) {
        Task { @MainActor in
            let viewModel: ContactViewModel = DependencyContainer.shared.makeContactViewModel()
//            if withContact == nil {
//                viewModel = DependencyContainer.shared.makeContactViewModel()
//            } else {
//                let viewModel = DependencyContainer.shared.makeContactViewModelDetail(contactmo: withContact)
//
//            }
            
            let swiftUIView = CreateContactView(viewModel: viewModel, dismissAction: {
                sourceViewController.dismiss(animated: true, completion: nil)
            })

            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.modalPresentationStyle = .pageSheet
            sourceViewController.present(hostingController, animated: true, completion: nil)
        }
    }
}

