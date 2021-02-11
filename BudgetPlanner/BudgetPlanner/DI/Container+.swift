//
//  Container+.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//



import Swinject

extension Container {
    static let shareResolver = Assembler([
        
        //Base Assembly
        RootVCAssembly(),
        
        //ViewController
//        SplashViewControllerAssembly(),
        MapViewControllerAssembly(),
        MonthViewControllerAssembly(),
        AssetDetailViewControllerAssembly(),
        PaymentViewControllerAssembly(),
        SelectedViewControllerAssembly(),
        
        ]).resolver
}
