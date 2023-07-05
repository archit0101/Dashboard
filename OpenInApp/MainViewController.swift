//
//  MainViewController.swift
//  OpenInApp
//
//  Created by Archit Gupta on 16/06/23.
//
import Foundation
import UIKit
import SnapKit

protocol DashboardViewModelable {
    func viewLoaded()
    func makeAPICallWithBearerToken()
    func getItem(row: Int) -> AnalyticsModel?
    func getCount() -> Int
    func getNumberOfTableViewCells() -> Int
    func getTableViewCellItem(indexPath: IndexPath) -> LinksModel?
    func getGreeting() -> String
}

class MainViewController: UIViewController {
    private struct Style {
        let graphViewWidth: CGFloat = 328.0
        let graphViewHeight: CGFloat = 250.0
    }
    private let style: Style = .init()
    private let viewModel = DashboardViewModel()
    var currLinkType: LinkType = .topLinks
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textColor = .white
        label.text = "Dashboard"
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var greetingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.text = "Good Morning"
        label.textColor = UIColor(hex: "#999CA0")
        return label
    }()
    
    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [greetingsSubLabel, greetingImage])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 2.0
        return stack
    }()
    
    private lazy var greetingsSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ajay Manva"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textColor = UIColor(hex: "#000000")
        return label
    }()
    
    private lazy var greetingImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.size.equalTo(28.0)
        }
        return imageView
    }()
    
    private lazy var graphContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints { make in
            make.height.equalTo(style.graphViewHeight)
        }
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var graphTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Overview"
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.textColor = UIColor(hex: "#999CA0")
        return label
    }()
    
    private lazy var graphView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var analyticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.registerDefaultCell()
        collectionView.register(AnalyticsCollectionViewCell.self)
        collectionView.backgroundColor = UIColor(hex: "#F5F5F5")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var viewAnalyticsButton: UIView = {
        let button = UIView()
        button.layer.borderColor = UIColor(hex: "#D8D8D8").cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(analyticsButtonClicked))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private lazy var analyticsButtonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View Analytics"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var analyticsButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "price-boost"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        return imageView
    }()
    
    private lazy var analyticsButtonTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [analyticsButtonImage, analyticsButtonTitle])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16.0
        return stack
    }()
    
    private lazy var topLinksView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.snp.makeConstraints { make in
            make.width.equalTo(101)
            make.height.equalTo(36)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topLinksClicked))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Links"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private lazy var recentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(36)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recentLinksClicked))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Links"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private lazy var linkTypeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topLinksView, recentView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 8.0
        return stack
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.registerDefaultCell()
        view.register(LinksTableViewCell.self)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        return view
    }()
    
    private lazy var viewAllLinksButton: UIView = {
        let button = UIView()
        button.layer.borderColor = UIColor(hex: "#D8D8D8").cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(analyticsButtonClicked))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private lazy var linksButtonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View all Links"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var linksButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "link"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        return imageView
    }()
    
    private lazy var linksButtonTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [linksButtonImage, linksButtonTitle])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16.0
        return stack
    }()
    
    private lazy var talkWithUsButton: UIView = {
        let button = UIView()
        button.backgroundColor = UIColor(hex: "#E0F1E3")
        button.layer.borderColor = UIColor(hex: "#B0E7B9").cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(analyticsButtonClicked))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private lazy var talkWithUsButtonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Talk with us"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var talkWithUsButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "whatsapp"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        return imageView
    }()
    
    private lazy var talkWithUsButtonTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [talkWithUsButtonImage, talkWithUsButtonTitle])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16.0
        return stack
    }()
    
    private lazy var faqButton: UIView = {
        let button = UIView()
        button.backgroundColor = UIColor(hex: "#E8F1FF")
        button.layer.borderColor = UIColor(hex: "#A2C7FF").cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(analyticsButtonClicked))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private lazy var faqButtonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Frequently Asked Questions"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var faqButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "question-mark"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        return imageView
    }()
    
    private lazy var faqButtonTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [faqButtonImage, faqButtonTitle])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16.0
        return stack
    }()
    
    @objc private func topLinksClicked(_gesture: UITapGestureRecognizer) {
        currLinkType = .topLinks
        topLabel.textColor = .white
        recentLabel.textColor = UIColor(hex: "#999CA0")
        recentView.backgroundColor = UIColor(hex: "#F5F5F5")
        topLinksView.backgroundColor = UIColor(hex: "#0E6FFF")
        self.reloadTableView()
    }
    
    @objc private func recentLinksClicked(_gesture: UITapGestureRecognizer) {
        currLinkType = .recentLinks
        recentLabel.textColor = .white
        topLabel.textColor = UIColor(hex: "#999CA0")
        topLinksView.backgroundColor = UIColor(hex: "#F5F5F5")
        recentView.backgroundColor = UIColor(hex: "#0E6FFF")
        self.reloadTableView()
    }
    
    @objc private func analyticsButtonClicked(_gesture: UITapGestureRecognizer) {
        self.reloadCollectionView()
        viewModel.makeAPICallWithBearerToken()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0E6FFF")
        viewModel.presenter = self
        viewModel.viewLoaded()
        addSubview()
        greetingsLabel.text = viewModel.getGreeting()
        updateScrollViewContentSize()
        topLabel.textColor = .white
        recentLabel.textColor = UIColor(hex: "#999CA0")
        topLinksView.backgroundColor = UIColor(hex: "#0E6FFF")
    }
    
    private func addSubview() {
        addTitleLabel()
        addScrollView()
        addMainView()
        addGreetingLabel()
        addNameStack()
        addGraphContainerView()
        addGraphTitleLabel()
        addGraphView()
        addCollectionView()
        addAnalyticsButton()
        addAnalyticsStack()
        addLinkTypeStack()
        addLabels()
        addTableView()
        addLinksButton()
        addLinksStack()
        addTalkWithUsButton()
        addTalkWithUsStack()
        addFAQButton()
        addFAQStack()
    }
    
    private func addTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(48)
        }
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
        }
    }
    
    private func addGreetingLabel() {
        mainView.addSubview(greetingsLabel)
        greetingsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func addNameStack() {
        mainView.addSubview(nameStack)
        nameStack.snp.makeConstraints { make in
            make.top.equalTo(greetingsLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func addMainView() {
        scrollView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.equalTo(1500)
        }
    }
    
    private func addGraphContainerView() {
        mainView.addSubview(graphContainerView)
        graphContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameStack.snp.bottom).offset(24)
        }
    }
    
    private func addGraphTitleLabel() {
        graphContainerView.addSubview(graphTitleLabel)
        graphTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
        }
    }
    
    private func addGraphView() {
        graphContainerView.addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(graphTitleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    private func addCollectionView() {
        mainView.addSubview(analyticsCollectionView)
        analyticsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(graphContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func addAnalyticsButton() {
        mainView.addSubview(viewAnalyticsButton)
        viewAnalyticsButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(analyticsCollectionView.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
    }
    
    private func addAnalyticsStack() {
        viewAnalyticsButton.addSubview(analyticsButtonTitleStack)
        analyticsButtonTitleStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addLinksButton() {
        mainView.addSubview(viewAllLinksButton)
        viewAllLinksButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
    }
    
    private func addLinksStack() {
        viewAllLinksButton.addSubview(linksButtonTitleStack)
        linksButtonTitleStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addTalkWithUsButton() {
        mainView.addSubview(talkWithUsButton)
        talkWithUsButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(viewAllLinksButton.snp.bottom).offset(40)
            make.height.equalTo(64)
        }
    }
    
    private func addTalkWithUsStack() {
        talkWithUsButton.addSubview(talkWithUsButtonTitleStack)
        talkWithUsButtonTitleStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func addFAQButton() {
        mainView.addSubview(faqButton)
        faqButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(talkWithUsButton.snp.bottom).offset(16)
            make.height.equalTo(64)
        }
    }
    
    private func addFAQStack() {
        faqButton.addSubview(faqButtonTitleStack)
        faqButtonTitleStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func addTableView() {
        mainView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(530)
            make.top.equalTo(linkTypeStack.snp.bottom).offset(24)
        }
    }
    
    private func addLinkTypeStack() {
        mainView.addSubview(linkTypeStack)
        linkTypeStack.snp.makeConstraints { make in
            make.top.equalTo(viewAnalyticsButton.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(12)
        }
    }
    
    private func addLabels() {
        topLinksView.addSubview(topLabel)
        recentView.addSubview(recentLabel)
        topLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        recentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateScrollViewContentSize() {
        //let scrollViewContentHeight = style.graphViewHeight + 32.0 + 200.0 + 16.0 + 16.0
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1200)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCount()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = viewModel.getItem(row: indexPath.row) else {
            return collectionView.dequeDefaultCell(for: indexPath)
        }
        let cell: AnalyticsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(with: item)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: 120,
            height: 120
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 4.0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfTableViewCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.getTableViewCellItem(indexPath: indexPath) else {
            return tableView.dequeDefaultCell(for: indexPath)
        }
        let cell: LinksTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setup(model: cellModel)
        return cell
    }
}

extension MainViewController: MainViewPresenter {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    func reloadCollectionView() {
        self.analyticsCollectionView.reloadData()
    }
    
    func drawLineGraph(withData data: [String: CGFloat]) {
        let containerSize = graphView.bounds.size
        
        let graphLayer = CAShapeLayer()
        graphLayer.frame = graphView.bounds
        graphLayer.fillColor = UIColor.clear.cgColor
        
        let graphPath = UIBezierPath()
        
        let keys = data.keys.sorted()
        let dataPoints: [CGFloat] = keys.compactMap { data[$0] }
        
        let xSpacing = containerSize.width / CGFloat(dataPoints.count - 1)
        let yMaxValue = dataPoints.max() ?? 1
        let yScale = containerSize.height / yMaxValue
        
        // Adjust the left margin for the graph area
        let leftMargin: CGFloat = 40
        
        // Draw y-axis scale and grid markings
        for i in 0...5 {
            let y = containerSize.height - (CGFloat(i) / 5) * containerSize.height
                
                // Draw scale labels
            let scaleLabel = UILabel(frame: CGRect(x: -leftMargin, y: y - 10, width: leftMargin, height: 20))
            scaleLabel.textAlignment = .right // Align labels to the right
            scaleLabel.font = UIFont.systemFont(ofSize: 10)
            scaleLabel.text = "\(Int((CGFloat(i) / 5) * yMaxValue))"
            scaleLabel.textColor = UIColor.black // Set label text color to black
            graphView.addSubview(scaleLabel)
            
            // Draw grid markings
            let gridLayer = CAShapeLayer()
            let gridPath = UIBezierPath()
            gridPath.move(to: CGPoint(x: 0, y: y))
            gridPath.addLine(to: CGPoint(x: containerSize.width, y: y))
            gridLayer.path = gridPath.cgPath
            gridLayer.strokeColor = UIColor.lightGray.cgColor
            gridLayer.lineWidth = 0.5
            graphView.layer.addSublayer(gridLayer)
        }
        
        // Draw x-axis
        let xAxisLayer = CAShapeLayer()
        let xAxisPath = UIBezierPath()
        xAxisPath.move(to: CGPoint(x: 0, y: containerSize.height))
        xAxisPath.addLine(to: CGPoint(x: containerSize.width, y: containerSize.height))
        xAxisLayer.path = xAxisPath.cgPath
        xAxisLayer.strokeColor = UIColor.lightGray.cgColor
        xAxisLayer.lineWidth = 1.0
        graphView.layer.addSublayer(xAxisLayer)
        
        // Draw markings and line graph
        for i in 0..<dataPoints.count {
            let x = CGFloat(i) * xSpacing
            let y = containerSize.height - dataPoints[i] * yScale
            
            // Draw markings
            let markingLayer = CAShapeLayer()
            let markingPath = UIBezierPath()
            markingPath.move(to: CGPoint(x: x, y: containerSize.height))
            markingPath.addLine(to: CGPoint(x: x, y: containerSize.height + 5))
            markingLayer.path = markingPath.cgPath
            markingLayer.strokeColor = UIColor.lightGray.cgColor
            markingLayer.lineWidth = 1.0
            graphView.layer.addSublayer(markingLayer)
            
            // Draw grid markings
            let gridLayer = CAShapeLayer()
            let gridPath = UIBezierPath()
            gridPath.move(to: CGPoint(x: x, y: 0))
            gridPath.addLine(to: CGPoint(x: x, y: containerSize.height))
            gridLayer.path = gridPath.cgPath
            gridLayer.strokeColor = UIColor.lightGray.cgColor
            gridLayer.lineWidth = 0.5
            graphView.layer.addSublayer(gridLayer)
            
            // Create and configure label
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 5)
            label.text = keys[i]
            label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4) // Rotate label by 45 degrees
            label.sizeToFit() // Resize label to fit the rotated text

            // Adjust label position to center it
            let labelCenterX = x + xSpacing / 2
            let labelCenterY = containerSize.height + label.bounds.width / 2 // Adjust for rotated label height
            label.center = CGPoint(x: labelCenterX, y: labelCenterY)

            graphView.addSubview(label)
            
            // Draw line graph
            if i == 0 {
                graphPath.move(to: CGPoint(x: x, y: y))
            } else {
                graphPath.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        graphLayer.path = graphPath.cgPath
        graphLayer.strokeColor = UIColor.blue.cgColor
        graphLayer.lineWidth = 2.0
        graphView.layer.addSublayer(graphLayer)
    }
}
