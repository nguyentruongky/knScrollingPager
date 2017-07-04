//
//  StickedHeaderController.swift
//  knScrollingPager
//
//  Created by Ky Nguyen on 7/4/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


class FixHeaderController: knScrollingPagerController {

    let headerView: UIView = {

        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let red = UIViewController()
        red.view.backgroundColor = .red

        let green = UIViewController()
        green.view.backgroundColor = .green

        var options = knScrollingOptions(headerView: headerView)
        options.headerFixHeight = 64

        setupPages([red, green], titles: ["Red", "Green"], options: options)
    }
    


}


