//
//  ExampleViewController.swift
//  HFCardCollectionViewLayoutExample
//
//  Created by Hendrik Frahmann on 28.10.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import HFCardCollectionViewLayout
import UIKit

struct CardInfo {
    var color: UIColor
    var icon: UIImage
}

class ExampleViewController: UICollectionViewController {
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    @IBOutlet var backgroundView: UIView?
    @IBOutlet var backgroundNavigationBar: UINavigationBar?

    var cardLayoutOptions: CardLayoutSetupOptions?
    var shouldSetupBackgroundView = false

    var cardArray: [CardInfo] = []

    override func viewDidLoad() {
        setupExample()
        super.viewDidLoad()
    }

    // MARK: CollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! ExampleCollectionViewCell
        cell.backgroundColor = cardArray[indexPath.item].color
        cell.imageIcon?.image = cardArray[indexPath.item].icon
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cardCollectionViewLayout?.revealedIndexPath != nil {
            cardCollectionViewLayout?.unrevealCard()
        } else {
            cardCollectionViewLayout?.revealCardAt(indexPath: indexPath)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = cardArray[sourceIndexPath.item]
        cardArray.remove(at: sourceIndexPath.item)
        cardArray.insert(tempItem, at: destinationIndexPath.item)
    }

    // MARK: Actions

    @IBAction func goBackAction() {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func addCardAction() {
        let indexPath = IndexPath(item: 0, section: 0)
        let newItem = createCardInfo()
        cardArray.insert(newItem, at: 0)
        collectionView?.insertItems(at: [indexPath])

        if cardArray.count == 1 {
            cardCollectionViewLayout?.revealCardAt(indexPath: indexPath)
        }
    }

    @IBAction func deleteCardAtIndex0orSelected() {
        var index = 0
//        if cardCollectionViewLayout!.revealedIndexPath >= 0 {
//            index = cardCollectionViewLayout!.revealedIndex
//        }
        cardCollectionViewLayout?.flipRevealedCardBack(completion: {
            self.cardArray.remove(at: index)
            self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        })
    }

    // MARK: Private Functions

    private func setupExample() {
        if let cardCollectionViewLayout = collectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardCollectionViewLayout
        }
        if shouldSetupBackgroundView == true {
            setupBackgroundView()
        }
        if let cardLayoutOptions = cardLayoutOptions {
            cardCollectionViewLayout?.firstMovableIndex = cardLayoutOptions.firstMovableIndex
            cardCollectionViewLayout?.cardHeadHeight = cardLayoutOptions.cardHeadHeight
            cardCollectionViewLayout?.cardShouldExpandHeadHeight = cardLayoutOptions.cardShouldExpandHeadHeight
            cardCollectionViewLayout?.cardShouldStretchAtScrollTop = cardLayoutOptions.cardShouldStretchAtScrollTop
            cardCollectionViewLayout?.cardMaximumHeight = cardLayoutOptions.cardMaximumHeight
            cardCollectionViewLayout?.bottomNumberOfStackedCards = cardLayoutOptions.bottomNumberOfStackedCards
            cardCollectionViewLayout?.bottomStackedCardsShouldScale = cardLayoutOptions.bottomStackedCardsShouldScale
            cardCollectionViewLayout?.bottomCardLookoutMargin = cardLayoutOptions.bottomCardLookoutMargin
            cardCollectionViewLayout?.spaceAtTopForBackgroundView = cardLayoutOptions.spaceAtTopForBackgroundView
            cardCollectionViewLayout?.spaceAtTopShouldSnap = cardLayoutOptions.spaceAtTopShouldSnap
            cardCollectionViewLayout?.spaceAtBottom = cardLayoutOptions.spaceAtBottom
            cardCollectionViewLayout?.scrollAreaTop = cardLayoutOptions.scrollAreaTop
            cardCollectionViewLayout?.scrollAreaBottom = cardLayoutOptions.scrollAreaBottom
            cardCollectionViewLayout?.scrollShouldSnapCardHead = cardLayoutOptions.scrollShouldSnapCardHead
            cardCollectionViewLayout?.scrollStopCardsAtTop = cardLayoutOptions.scrollStopCardsAtTop
            cardCollectionViewLayout?.bottomStackedCardsMinimumScale = cardLayoutOptions.bottomStackedCardsMinimumScale
            cardCollectionViewLayout?.bottomStackedCardsMaximumScale = cardLayoutOptions.bottomStackedCardsMaximumScale

            let count = cardLayoutOptions.numberOfCards

            for index in 0 ..< count {
                cardArray.insert(createCardInfo(), at: index)
            }
        }
        collectionView?.reloadData()
    }

    private func createCardInfo() -> CardInfo {
        let icons: [UIImage] = [#imageLiteral(resourceName: "Icon1.pdf"), #imageLiteral(resourceName: "Icon2.pdf"), #imageLiteral(resourceName: "Icon3.pdf"), #imageLiteral(resourceName: "Icon4.pdf"), #imageLiteral(resourceName: "Icon5.pdf"), #imageLiteral(resourceName: "Icon6.pdf")]
        let icon = icons[Int(arc4random_uniform(6))]
        let newItem = CardInfo(color: getRandomColor(), icon: icon)
        return newItem
    }

    private func setupBackgroundView() {
        if cardLayoutOptions?.spaceAtTopForBackgroundView == 0 {
            cardLayoutOptions?.spaceAtTopForBackgroundView = 44 // Height of the NavigationBar in the BackgroundView
        }
        if let collectionView = collectionView {
            collectionView.backgroundView = backgroundView
            backgroundNavigationBar?.shadowImage = UIImage()
            backgroundNavigationBar?.setBackgroundImage(UIImage(), for: .default)
        }
    }

    private func getRandomColor() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

extension ExampleViewController: HFCardCollectionViewLayoutDelegate {
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAt indexPath: IndexPath) {
        if let cell = collectionView?.cellForItem(at: indexPath) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = cardCollectionViewLayout
            cell.cardIsRevealed(true)
        }
    }

    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAt indexPath: IndexPath) {
        if let cell = collectionView?.cellForItem(at: indexPath) as? ExampleCollectionViewCell {
            cell.cardCollectionViewLayout = cardCollectionViewLayout
            cell.cardIsRevealed(false)
        }
    }
}
