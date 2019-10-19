//
//  ApplicationCoordinator.swift
//  CoordanatorTemplateApp
//
//  Created by sergey.bendak on 10/19/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: ApplicationCoordinatorFactory
    private let router: Router
    private let launchManager: LaunchManager
    
    private var window: UIWindow
    
    init(window: UIWindow,
         router: Router = RouterImpl(),
         launchManager: LaunchManager = LaunchManagerImpl(),
         factory: ApplicationCoordinatorFactory = ApplicationCoordinatorFactoryImpl()) {
        self.router = router
        self.window = window
        self.launchManager = launchManager
        self.coordinatorFactory = factory
    }
    
    override func start() {
        window.makeKeyAndVisible()
        
        launchManager.update(isAuthorized: false)
        
        runRootFlow()
    }
    
    private func runRootFlow() {
        switch launchManager.flow {
        case .flow1:
            runFlow1()
        case .flow2:
            runFlow2()
        }
    }
    
    private func runFlow1() {
        let navController = UINavigationController()
        let router = RouterImpl(rootController: navController)
        var coordinator = coordinatorFactory.makeFlow1Coordinator(router: router, factory: coordinatorFactory)
        coordinator.flowComplition = { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.removeDependency(coordinator)
            self.launchManager.update(isAuthorized: true)
            self.runRootFlow()
        }
        addDependency(coordinator)
        coordinator.start()
        window.rootViewController = navController
    }
    
    private func runFlow2() {
        let tabBarController = TabBarAssembly.build()
        let tabBarCoordinator = coordinatorFactory.makeFlow2TabBarCoordinator(tabBarController: tabBarController, factory: coordinatorFactory)
        tabBarCoordinator.finishFlow = { [weak self, weak tabBarCoordinator] in
            guard let self = self, let coordinator = tabBarCoordinator else { return }
            self.removeDependency(coordinator)
            self.launchManager.update(isAuthorized: false)
            self.runRootFlow()
        }
        addDependency(tabBarCoordinator)
        tabBarCoordinator.start()
        window.rootViewController = tabBarController
    }
    
}
