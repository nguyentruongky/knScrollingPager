//
//  GlobalSupporter.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/9/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}


class knView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() { }
}



class knCustomTableController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        registerCells()
    }

    lazy var tableView: UITableView = { [weak self] in

        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.dataSource = self
        tb.delegate = self
        return tb

        }()

    func setupView() { }

    func registerCells() { }

    func fetchData() { }

    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension knCustomTableController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


class knTableCell : UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() { }
}

class knCollectionController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        registerCells()
    }

    func registerCells() { }

    func setupView() { }

    func fetchData() { }

    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

extension knCollectionController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}

class knCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() { }
}


