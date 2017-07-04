//
//  ScrollingHeaderController.swift
//  knScrollingPager
//
//  Created by Ky Nguyen on 7/4/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


class ScrollingHeaderController: knScrollingPagerController {

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

        let blue = UIViewController()
        blue.view.backgroundColor = .blue

        var options = knScrollingOptions(headerView: headerView)
        options.headerFixHeight = 0

        setupPages([red, green, blue], titles: ["Red", "Green", "Blue"], options: options)
    }
    
}

