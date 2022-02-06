//
//  ViewController.swift
//  StudyTraining
//
//  Created by tw on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    let testModel = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "<"]
    
    let keyPathData: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    
    var disposeBag = DisposeBag()
    
    // 0206
    
    var firstKeyPath: [Int] = []
    
    var secondKeyPath: [Int] = []
                         
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        keyPathData
            .withUnretained(self)
            .subscribe(onNext: { owner, info in
                guard let info = info else { return }
                
                switch info {
                case -1:
                    
                    if owner.firstKeyPath.count == 6 && owner.secondKeyPath.count > 0 {
                        switch owner.secondKeyPath.count {
                        case 1...6:
                            owner.secondKeyPath.removeLast()
                            
                            print("first", owner.firstKeyPath)
                            print("second", owner.secondKeyPath)
                        case 0:
                            break
                        default:
                            return
                        }
                    } else {
                        switch owner.firstKeyPath.count {
                        case 1...6:
                            owner.firstKeyPath.removeLast()
                            
                            print("first", owner.firstKeyPath)
                            print("second", owner.secondKeyPath)
                        default:
                            return
                        }
                    }
                    
                    
                default:
                    
                    // 입력시
                    if owner.firstKeyPath.count < 6 {
                        owner.firstKeyPath.append(info)
                    } else {
                        owner.secondKeyPath.append(info)
                    }
                    
                    // 두번째 비밀번호 입력텍스트
                    if owner.firstKeyPath.count >= 6 {
                        owner.passwordLabel.text = "비밀번호를 다시 한 번 눌러주세요."
                    }
                    
                    
                    if owner.firstKeyPath.count >= 6 && owner.secondKeyPath.count >= 6 {
                        // 비밀번호 일치처리
                        
                        if owner.firstKeyPath.elementsEqual(owner.secondKeyPath) {
                            owner.passwordLabel.text = "성공"
                        } else {
                            owner.passwordLabel.text = "비밀번호가 일치하지 않습니다\n다시 입력해주세요."
                        }
                        
                        return
                    }
                    
                    print("first", owner.firstKeyPath)
                    print("second", owner.secondKeyPath)
                }
            }).disposed(by: disposeBag)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        cell.labels.text = testModel[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch testModel[indexPath.row] {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
            
            if let transformNumber = Int(testModel[indexPath.row]) {
                keyPathData.accept(transformNumber)
            }
            
        case "<":
            keyPathData.accept(-1)
        default:
            return
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labels: UILabel!
    
}
