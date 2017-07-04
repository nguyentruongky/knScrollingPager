//
//  MainController.swift
//  knScrollingPager
//
//  Created by Ky Nguyen on 7/4/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {

        let fixButton = UIButton()
        fixButton.translatesAutoresizingMaskIntoConstraints = false
        fixButton.backgroundColor = .blue
        fixButton.setTitle("Fix header button", for: .normal)
        fixButton.setTitleColor(.white, for: .normal)
        fixButton.addTarget(self, action: #selector(showFixHeaderController), for: .touchUpInside)

        let scrollingButton = UIButton()
        scrollingButton.translatesAutoresizingMaskIntoConstraints = false
        scrollingButton.addTarget(self, action: #selector(showScrollingHeaderController), for: .touchUpInside)
        scrollingButton.backgroundColor = .red
        scrollingButton.setTitle("Scrolling header button", for: .normal)
        scrollingButton.setTitleColor(.white, for: .normal)

        view.addSubview(fixButton)
        view.addSubview(scrollingButton)

        fixButton.height(44)
        fixButton.horizontal(toView: view, space: 32)
        fixButton.centerY(toView: view, space: -32)

        scrollingButton.height(44)
        scrollingButton.horizontal(toView: view, space: 32)
        scrollingButton.centerY(toView: view, space: 32)

    }

    func showScrollingHeaderController() {
        let controller = ScrollingHeaderController()
        present(controller, animated: true)
    }

    func showFixHeaderController() {
        let controller = FixHeaderController()
        present(controller, animated: true)
    }
}


