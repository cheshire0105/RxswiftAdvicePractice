//
//  View.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AdviceViewController: UIViewController {
    // UI Elements
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    private let authorProfileLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }()

    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Advice", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.accessibilityIdentifier = "activityIndicator"  // Identifier 설정
        return indicator
    }()


    // ViewModel and DisposeBag
    let viewModel: AdviceViewModel
    let disposeBag = DisposeBag()

    // Custom initializer to inject ViewModel
    init(viewModel: AdviceViewModel = AdviceViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // Setup UI elements using SnapKit
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add subviews
        view.addSubview(cardView)
        cardView.addSubview(messageLabel)
        cardView.addSubview(authorLabel)
        cardView.addSubview(authorProfileLabel)
        view.addSubview(fetchButton)
        view.addSubview(activityIndicator)

        // Set up constraints using SnapKit
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50) // Slightly above center
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(20)
            make.leading.equalTo(cardView).offset(20)
            make.trailing.equalTo(cardView).inset(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.equalTo(cardView).offset(20)
            make.trailing.equalTo(cardView).inset(20)
        }

        authorProfileLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalTo(cardView).offset(20)
            make.trailing.equalTo(cardView).inset(20)
            make.bottom.equalTo(cardView).inset(20)
        }

        fetchButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // Bind ViewModel to UI
    private func bindViewModel() {
        // 로딩 상태 표시
        let isLoading = BehaviorRelay<Bool>(value: false)

        isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        // 명언이 로드될 때 UI 업데이트
        viewModel.advice
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                isLoading.accept(false)  // 데이터 로드 완료 후 로딩 인디케이터 숨김
            }, onSubscribe: {
                isLoading.accept(true)  // 로딩 시작 시 로딩 인디케이터 표시
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] advice in
                self?.messageLabel.text = advice.message
                self?.authorLabel.text = advice.author
                self?.authorProfileLabel.text = advice.authorProfile
            })
            .disposed(by: disposeBag)

        // 에러 처리
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("Error: \(error)")
                isLoading.accept(false)  // 에러 발생 시 로딩 인디케이터 숨김
            })
            .disposed(by: disposeBag)

        // 버튼 클릭 시 ViewModel의 fetchAdvice() 메서드 호출
        fetchButton.rx.tap
            .bind { [weak self] in
                isLoading.accept(true)  // 요청 시작 시 로딩 상태로 설정
                self?.viewModel.fetchAdvice()
            }
            .disposed(by: disposeBag)
    }
}
