//
//  ContactPresenter.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import UIKit
import SwiftUI

@objc class ContactDetailPresenter: NSObject {

    @objc static func presentDetailContact(from sourceViewController: UIViewController, withContact: ContactMO?) {
        Task { @MainActor in
            var viewModel: ContactViewModel!
            if withContact == nil {
                viewModel = DependencyContainer.shared.makeContactViewModel()
            } else {
                viewModel = DependencyContainer.shared.makeContactViewModelDetail(contactmo: withContact)

            }
            
            let swiftUIView = CreateContactView(viewModel: viewModel, dismissAction: {
                sourceViewController.dismiss(animated: true, completion: nil)
            })

            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.modalPresentationStyle = .pageSheet
            sourceViewController.present(hostingController, animated: true, completion: nil)
        }
    }
}

