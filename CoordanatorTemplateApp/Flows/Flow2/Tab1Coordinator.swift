//
//  Tab1Coordinator.swift
//  CoordanatorTemplateApp
//
//  Created by sergey.bendak on 10/19/19.
//  Copyright © 2019 sb. All rights reserved.
//

import Foundation

/// Protocol helps pass data outside current coordinator and handle it in parent coordinator.
protocol Tab1CoordinatorOutput {
    var finishFlow: VoidClosure? { get set }
}

final class Tab1Coordinator: BaseCoordinator, Tab1CoordinatorOutput {
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let factory: CoordinatorFactory
    
    init(router: Router,
         factory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        showScreen()
    }
    
    private func showScreen() {
        let vc = ViewControllerAssembly.build(
            buttonTitle: "Finish Flow",
            completion: { [weak self] in
                guard let self = self else { return }
                self.finishFlow?()
            }
        )
        vc.title = "Tab 1 Title"
        router.setRootViewController(vc)
    }
    
}
