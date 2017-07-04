//
//  ScrollingPager.swift
//  knScrollPager
//
//  Created by Ky Nguyen on 7/3/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import UIKit

struct knScrollingOptions {

    var headerView: UIView?

    var headerHeight: CGFloat = 200
    var headerFixHeight: CGFloat = 64

    var tabHeight: CGFloat = 44

    var tabFont = UIFont.systemFont(ofSize: 14)
    var tabTextColor = UIColor.darkGray

    var tabActivateFont = UIFont.boldSystemFont(ofSize: 14)
    var tabActiveTextColor = UIColor.black

    var tabBackgroundColor = UIColor.white

    var indicatorHeight: CGFloat = 2
    var indicatorColor = UIColor.lightGray

    init(headerView: UIView?) {
        self.headerView = headerView
    }

}

class knScrollingPagerController: knCustomTableController {

    fileprivate var option = knScrollingOptions(headerView: nil)

    fileprivate var datasource = [knTableCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchData()
    }

    fileprivate func addHeaderView() {

        tableView.tableHeaderView = UIView()

        guard let headerView = option.headerView, let tableHeader = tableView.tableHeaderView else { return }
        headerView.height(option.headerHeight)

        tableHeader.frame.size.height = option.headerHeight
        tableHeader.addSubview(headerView)
        headerView.horizontal(toView: tableHeader)
        headerView.top(toView: tableHeader)
    }

    internal override func setupView() {

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.fill(toView: view)
    }

    override func registerCells() {
        tableView.register(knTableCell.self, forCellReuseIdentifier: "knTableCell")
    }

    fileprivate let tabView: knTabView = {

        let view = knTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate let pageView: knPageView = {

        let view = knPageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate func makeTabCell(tabTitles: [String]) -> knTableCell {

        let cell = knTableCell()

        cell.addSubview(tabView)
        tabView.fill(toView: cell)
        tabView.datasource = tabTitles
        tabView.option = option
        
        return cell
    }

    fileprivate func makePagesContainerCell(controllers: [UIViewController]) -> knTableCell {

        let cell = knTableCell()

        pageView.addPageOutside = handleAddPage

        cell.addSubview(pageView)
        pageView.fill(toView: cell)
        pageView.datasource = controllers

        return cell
    }

    fileprivate func handleAddPage(_ page: UIViewController) {

        addChildViewController(page)
        page.didMove(toParentViewController: self)
    }
}

//MARK: Public

extension knScrollingPagerController {

    func setupPages(_ pages: [UIViewController], titles: [String], options: knScrollingOptions) {

        self.option = options

        let isHeaderAvailable = option.headerView != nil

        if isHeaderAvailable {
            addHeaderView()
        }

        let tabCell = makeTabCell(tabTitles: titles)
        datasource.append(tabCell)

        let pagesCell = makePagesContainerCell(controllers: pages)
        datasource.append(pagesCell)
        pageView.tab = tabView

        tableView.reloadData()
    }
}

extension knScrollingPagerController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return datasource[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let pageHeight = screenHeight - option.tabHeight - option.headerFixHeight
        return indexPath.row == 0 ? option.tabHeight : pageHeight
    }

}






//MARK: PageView

private class knPageView: knView {

    weak var tab: knTabView?

    var addPageOutside: ((UIViewController) -> Void)?

    internal var numberOfPages = 1

    var datasource = [UIViewController]() {
        didSet {
            numberOfPages = datasource.count > 0 ? datasource.count : 1
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    override func setupView() {
        collectionView.register(knPageCell.self, forCellWithReuseIdentifier: "knPageCell")

        addSubview(collectionView)
        collectionView.fill(toView: self)
    }
}


extension knPageView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tab?.indicatorLeft?.constant = scrollView.contentOffset.x / CGFloat(datasource.count)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let index = targetContentOffset.pointee.x / frame.width
        tab?.collectionView.selectItem(at: IndexPath(item: Int(index), section: 0), animated: true, scrollPosition: [])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "knPageCell", for: indexPath) as! knPageCell
        cell.addPageOutside = addPageOutside
        cell.data = datasource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.frame.size
    }
}

private class knPageCell: knCollectionCell {

    var addPageOutside: ((UIViewController) -> Void)?

    var data: UIViewController? {
        didSet {
            guard let data = data, let view = data.view else { return }
            containerView.addSubview(view)
            view.frame = containerView.bounds
            addPageOutside?(data)
        }
    }

    let containerView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func setupView() {
        addSubview(containerView)
        containerView.fill(toView: self)
    }
}





//MARK: knTabView

private class knTabView: knView {

    var option = knScrollingOptions(headerView: nil) {
        didSet {
            indicatorView.backgroundColor = option.indicatorColor
            indicatorHeight?.constant = option.indicatorHeight
        }
    }

    fileprivate var numberOfTabs: CGFloat = 2

    var datasource = [String]() {
        didSet {
            numberOfTabs = CGFloat(datasource.count > 0 ? datasource.count : 1)
            indicatorWidth?.constant = screenWidth / CGFloat(numberOfTabs)
            collectionView.reloadData()
        }
    }

    lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    private var indicatorHeight: NSLayoutConstraint?
    private var indicatorWidth: NSLayoutConstraint?
    var indicatorLeft: NSLayoutConstraint?
    private let indicatorView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return view
    }()

    override func setupView() {
        collectionView.register(knTabCell.self, forCellWithReuseIdentifier: "knTabCell")

        addSubview(collectionView)
        collectionView.fill(toView: self)

        addSubview(indicatorView)
        indicatorView.bottom(toView: self)

        indicatorWidth = indicatorView.width(screenWidth / CGFloat(numberOfTabs))
        indicatorHeight = indicatorView.height(1)
        indicatorLeft = indicatorView.left(toView: self)

    }

}

extension knTabView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "knTabCell", for: indexPath) as! knTabCell
        cell.titleLabel.text = datasource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = screenWidth / CGFloat(numberOfTabs)
        return CGSize(width: width, height: option.tabHeight)
    }
}

private class knTabCell: knCollectionCell {

    let titleLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override func setupView() {
        addSubview(titleLabel)
        
        titleLabel.center(toView: self)
    }
    
}






