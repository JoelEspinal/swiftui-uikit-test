//
//  ContactPresenter.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import UIKit
import SwiftUI


// La anotación @objc hace que esta clase sea visible desde archivos .m de Objective-C
@objc class ContactPresenter: NSObject {
    
    // El método debe ser 'static' y marcado con @objc
    // Pasamos el UIViewController de origen para poder hacer el 'present' desde ahí
    @objc static func presentCreateContact(from sourceViewController: UIViewController) {
        
        // 1. Instanciamos la vista de SwiftUI.
        // Le pasamos la lógica para cerrar la pantalla de forma segura.
        let swiftUIView = CreateContactView(dismissAction: {
            sourceViewController.dismiss(animated: true, completion: nil)
        })
        
        // 2. Envolvemos la vista de SwiftUI en un UIHostingController (que es un UIViewController)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 3. Opcional: Configurar cómo se mostrará (ej: pantalla completa)
        hostingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        
        // 4. Usamos el controlador de Objective-C que nos pasaron para presentar el Hosting Controller
        sourceViewController.present(hostingController, animated: true, completion: nil)
    }
}
