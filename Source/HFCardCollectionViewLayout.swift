//
//  HFCardCollectionViewLayout.swift
//  HFCardCollectionViewLayout
//
//  Created by Hendrik Frahmann on 02.11.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import UIKit

/// Layout attributes for the HFCardCollectionViewLayout
open class HFCardCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    /// Specifies if the CardCell is revealed.
    public var isRevealed = false

    /// Overwritten to copy also the 'isRevealed' flag.
    override open func copy(with zone: NSZone? = nil) -> Any {
        let attribute = super.copy(with: zone) as! HFCardCollectionViewLayoutAttributes
        attribute.isRevealed = isRevealed
        return attribute
    }
}

/// The HFCardCollectionViewLayout provides a card stack layout not quite similar like the apps Reminder and Wallet.
open class HFCardCollectionViewLayout: UICollectionViewLayout, UIGestureRecognizerDelegate {
    // MARK: Public Variables

    /// Only cards with index equal or greater than firstMovableIndex can be moved through the collectionView.
    ///
    /// Default: 0
    @IBInspectable open var firstMovableIndex: Int = 0

    /// Specifies the height that is showing the cardhead when the collectionView is showing all cards.
    ///
    /// The minimum value is 20.
    ///
    /// Default: 80
    @IBInspectable open var cardHeadHeight: CGFloat = 80 {
        didSet {
            if cardHeadHeight < 20 {
                cardHeadHeight = 20
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Specifies the height of card, when not implemented the delegate sizeForItemAt
    ///
    /// Default: 300
    @IBInspectable open var defaultCardHeight: CGFloat = 250 {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// When th collectionView is showing all cards but there are not enough cards to fill the full height,
    /// the cardHeadHeight will be expanded to equally fill the height.
    ///
    /// Default: true
    @IBInspectable open var cardShouldExpandHeadHeight: Bool = true {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Stretch the cards when scrolling up
    ///
    /// Default: true
    @IBInspectable open var cardShouldStretchAtScrollTop: Bool = true {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Specifies the maximum height of the cards.
    ///
    /// But the height can be less if the frame size of collectionView is smaller.
    ///
    /// Default: 0 (no height specified)
    @IBInspectable open var cardMaximumHeight: CGFloat = 0 {
        didSet {
            if cardMaximumHeight < 0 {
                cardMaximumHeight = 0
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Count of bottom stacked cards when a card is revealed.
    ///
    /// Value must be between 0 and 10
    ///
    /// Default: 5
    @IBInspectable open var bottomNumberOfStackedCards: Int = 5 {
        didSet {
            if bottomNumberOfStackedCards < 0 {
                bottomNumberOfStackedCards = 0
                return
            }
            if bottomNumberOfStackedCards > 10 {
                bottomNumberOfStackedCards = 10
                return
            }
            collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: nil)
        }
    }

    /// All bottom stacked cards are scaled to produce the 3D effect.
    ///
    /// Default: true
    @IBInspectable open var bottomStackedCardsShouldScale: Bool = true {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// The minimum scale for the bottom cards.
    ///
    /// Default: 0.94
    @IBInspectable open var bottomStackedCardsMinimumScale: CGFloat = 0.94 {
        didSet {
            if bottomStackedCardsMinimumScale < 0.0 {
                bottomStackedCardsMinimumScale = 0.0
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// The maximum scale for the bottom cards.
    ///
    /// Default: 0.94
    @IBInspectable open var bottomStackedCardsMaximumScale: CGFloat = 1.0 {
        didSet {
            if bottomStackedCardsMaximumScale > 1.0 {
                bottomStackedCardsMaximumScale = 1.0
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Specifies the margin for the top margin of a bottom stacked card.
    ///
    /// Value can be between 0 and 20
    ///
    /// Default: 10
    @IBInspectable open var bottomCardLookoutMargin: CGFloat = 10 {
        didSet {
            if bottomCardLookoutMargin < 0 {
                bottomCardLookoutMargin = 0
                return
            }
            if bottomCardLookoutMargin > 20 {
                bottomCardLookoutMargin = 20
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// An additional topspace to show the top of the collectionViews backgroundView.
    ///
    /// Default: 0
    @IBInspectable open var spaceAtTopForBackgroundView: CGFloat = 0 {
        didSet {
            if spaceAtTopForBackgroundView < 0 {
                spaceAtTopForBackgroundView = 0
                return
            }
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Snaps the scrollView if the contentOffset is on the 'spaceAtTopForBackgroundView'
    ///
    /// Default: true
    @IBInspectable open var spaceAtTopShouldSnap: Bool = true

    /// Additional space at the bottom to expand the contentsize of the collectionView.
    ///
    /// Default: 0
    @IBInspectable open var spaceAtBottom: CGFloat = 0 {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// Area the top where to autoscroll while moving a card.
    ///
    /// Default 120
    @IBInspectable open var scrollAreaTop: CGFloat = 120 {
        didSet {
            if scrollAreaTop < 0 {
                scrollAreaTop = 0
                return
            }
        }
    }

    /// Area ot the bottom where to autoscroll while moving a card.
    ///
    /// Default 120
    @IBInspectable open var scrollAreaBottom: CGFloat = 120 {
        didSet {
            if scrollAreaBottom < 0 {
                scrollAreaBottom = 0
                return
            }
        }
    }

    /// The scrollView should snap the cardhead to the top.
    ///
    /// Default: false
    @IBInspectable open var scrollShouldSnapCardHead: Bool = false

    /// Cards are stopping at top while scrolling.
    ///
    /// Default: true
    @IBInspectable open var scrollStopCardsAtTop: Bool = true {
        didSet {
            collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }

    /// All cards are collapsed at bottom.
    ///
    /// Default: false
    @IBInspectable open var collapseAllCards: Bool = false {
        didSet {
            flipRevealedCardBack(completion: {
                self.collectionView?.isScrollEnabled = !self.collapseAllCards
                var previousRevealedIndexPath: IndexPath?
                if let revealedIndexPath = self.revealedIndexPath {
                    previousRevealedIndexPath = revealedIndexPath
                    self.delegate?.cardCollectionViewLayout?(self, willUnrevealCardAt: revealedIndexPath)
                    self.revealedIndexPath = nil
                }
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: { _ in
                    if let previousRevealedIndexPath = previousRevealedIndexPath {
                        self.delegate?.cardCollectionViewLayout?(self, didUnrevealCardAt: previousRevealedIndexPath)
                    }
                })
            })
        }
    }

    /// Contains the revealed indexPath.
    /// ReadOnly.
    open private(set) var revealedIndexPath: IndexPath?

    /// Contains the revealed index.
    /// ReadOnly.
    open var revealedIndex: Int? {
        if let revealedIndexPath = revealedIndexPath {
            return cardCollectionViewLayoutAttributes[revealedIndexPath]?.zIndex
        }
        return nil
    }

    // MARK: Public Actions

    /// Action for the InterfaceBuilder to flip back the revealed card.
    @IBAction open func flipBackRevealedCardAction() {
        flipRevealedCardBack()
    }

    /// Action for the InterfaceBuilder to Unreveal the revealed card.
    @IBAction open func unrevealRevealedCardAction() {
        unrevealCard()
    }

    /// Action to collapse all cards.
    @IBAction open func collapseAllCardsAction() {
        collapseAllCards = true
    }

    // MARK: Public Functions

    /// Reveal a card at the given index.
    ///
    /// - Parameter index: The index of the card.
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func revealCardAt(indexPath: IndexPath, completion: (() -> Void)? = nil) {
        if revealedIndexPath == nil && collapseAllCards == true {
            collapseAllCards = false
            return
        }

        if delegate?.cardCollectionViewLayout?(self, canRevealCardAt: indexPath) == false {
            revealedIndexPath = nil
//            collectionView?.isScrollEnabled = true
            deinitializeRevealedCard()
            return
        }

        let reveal = {
            self.revealedIndexPath = indexPath
            self.delegate?.cardCollectionViewLayout?(self, willRevealCardAt: indexPath)
//            self.collectionView?.isScrollEnabled = false

            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: { _ in
                _ = self.initializeRevealedCard()
                self.delegate?.cardCollectionViewLayout?(self, didRevealCardAt: indexPath)
                completion?()
            })
        }

        if revealedCardIsFlipped {
//            collectionView?.isScrollEnabled = false
            flipRevealedCardBack(completion: {
                reveal()
            })
        } else {
            reveal()
        }
    }

    /// Unreveal the revealed card
    ///
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func unrevealCard(completion: (() -> Void)? = nil) {
        guard let revealedIndexPath = revealedIndexPath else {
            completion?()
            return
        }

        if delegate?.cardCollectionViewLayout?(self, canUnrevealCardAt: revealedIndexPath) == false {
            return
        }
        let unreveal = {
//            self.collectionView?.isScrollEnabled = true
            self.deinitializeRevealedCard()
            self.delegate?.cardCollectionViewLayout?(self, willUnrevealCardAt: revealedIndexPath)
            self.revealedIndexPath = nil
            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: { _ in
                self.delegate?.cardCollectionViewLayout?(self, didUnrevealCardAt: revealedIndexPath)
                completion?()
            })
        }

        if revealedCardIsFlipped {
//            collectionView?.isScrollEnabled = false
            flipRevealedCardBack(completion: {
                unreveal()
            })
        } else {
            unreveal()
        }
    }

    /// Flips the revealed card to the given view.
    /// The frame for the view will be the same as the cell
    ///
    /// - Parameter toView: The view for the backview of te card.
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func flipRevealedCard(toView: UIView, completion: (() -> Void)? = nil) {
        if revealedCardIsFlipped == true {
            return
        }
        if let cardCell = revealedCardCell {
            toView.removeFromSuperview()
            revealedCardFlipView = toView
            toView.frame = CGRect(x: 0, y: 0, width: cardCell.frame.width, height: cardCell.frame.height)
            toView.isHidden = true
            cardCell.addSubview(toView)

            revealedCardIsFlipped = true
            UIApplication.shared.keyWindow?.endEditing(true)
            let originalShouldRasterize = cardCell.layer.shouldRasterize
            cardCell.layer.shouldRasterize = false

            UIView.transition(with: cardCell, duration: 0.5, options: [.transitionFlipFromRight], animations: { () -> Void in
                cardCell.contentView.isHidden = true
                toView.isHidden = false
            }, completion: { _ -> Void in
                cardCell.layer.shouldRasterize = originalShouldRasterize
                completion?()
            })
        }
    }

    /// Flips the flipped card back to the frontview.
    ///
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func flipRevealedCardBack(completion: (() -> Void)? = nil) {
        if revealedCardIsFlipped == false {
            completion?()
            return
        }
        if let cardCell = revealedCardCell {
            if let flipView = revealedCardFlipView {
                let originalShouldRasterize = cardCell.layer.shouldRasterize
                UIApplication.shared.keyWindow?.endEditing(true)
                cardCell.layer.shouldRasterize = false

                UIView.transition(with: cardCell, duration: 0.5, options: [.transitionFlipFromLeft], animations: { () -> Void in
                    flipView.isHidden = true
                    cardCell.contentView.isHidden = false
                }, completion: { _ -> Void in
                    flipView.removeFromSuperview()
                    cardCell.layer.shouldRasterize = originalShouldRasterize
                    self.revealedCardFlipView = nil
                    self.revealedCardIsFlipped = false
                    completion?()
                })
            }
        }
    }

    open func willInsert(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let revealedIndexPath = revealedIndexPath, indexPath <= revealedIndexPath {
                collectionViewTemporaryTop += cardHeadHeight
                self.revealedIndexPath = indexPath
            }
        }
    }

    open func willDelete(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath == revealedIndexPath {
                unrevealCard()
            }
            if let revealedIndexPath = revealedIndexPath, indexPath <= revealedIndexPath {
                collectionViewTemporaryTop -= cardHeadHeight
                self.revealedIndexPath = indexPath
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////                                  Private                                       //////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // MARK: Private Variables

    private var collectionViewIsInitialized = false
    private var collectionViewItemCount: Int = 0
    private var collectionViewTapGestureRecognizer: UITapGestureRecognizer?
    private var collectionViewIgnoreBottomContentOffsetChanges: Bool = false
    private var collectionViewLastBottomContentOffset: CGFloat = 0
    private var collectionViewDeletedIndexPaths = [IndexPath]()
    private var collectionViewTemporaryTop: CGFloat = 0

    private var cardCollectionBoundsSize: CGSize = .zero
    private var cardCollectionViewLayoutAttributes = [IndexPath: HFCardCollectionViewLayoutAttributes]()
    private var cardCollectionBottomCardsSet: [Int] = []
    private var cardCollectionBottomCardsRevealedIndex: Int = 0
    private func cardCollectionCellSize(for indexPath: IndexPath) -> CGSize {
        guard let collectionView = collectionView else { return .zero }
        if let size = delegate?.cardCollectionViewLayout?(self, sizeForItemAt: indexPath) {
            return size
        }
        let w = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        var h = delegate?.cardCollectionViewLayout?(self, heightForItemAt: indexPath) ?? defaultCardHeight
        let size = CGSize(width: w, height: h)
        return size
    }

    private var revealedCardCell: UICollectionViewCell? {
        if let revealedIndexPath = revealedIndexPath, let collectionView = collectionView {
            return collectionView.cellForItem(at: revealedIndexPath)
        }
        return nil
    }

    private var revealedCardPanGestureRecognizer: UIPanGestureRecognizer?
    private var revealedCardPanGestureTouchLocationY: CGFloat = 0
    private var revealedCardFlipView: UIView?
    private var revealedCardIsFlipped: Bool = false

    private var movingCardSelectedIndex: Int = -1
    private var movingCardGestureRecognizer: UILongPressGestureRecognizer?
    private var movingCardActive: Bool = false
    private var movingCardGestureStartLocation: CGPoint = .zero
    private var movingCardGestureCurrentLocation: CGPoint = .zero
    private var movingCardCenterStart: CGPoint = .zero
    private var movingCardSnapshotCell: UIView?
    private var movingCardLastTouchedLocation: CGPoint = .zero
    private var movingCardLastTouchedIndexPath: IndexPath?
    private var movingCardStartIndexPath: IndexPath?

    private var autoscrollDisplayLink: CADisplayLink?
    private var autoscrollDirection: HFCardCollectionScrollDirection = .unknown

    private var delegate: HFCardCollectionViewLayoutDelegate? {
        return collectionView?.delegate as? HFCardCollectionViewLayoutDelegate
    }

    // MARK: Private calculated Variable

    private var contentInset: UIEdgeInsets {
        if #available(iOS 11, *) {
            return self.collectionView!.adjustedContentInset
        } else {
            return collectionView!.contentInset
        }
    }

    private var contentOffsetTop: CGFloat {
        return collectionView!.contentOffset.y + contentInset.top
    }

    private var bottomCardCount: CGFloat {
        return CGFloat(min(collectionViewItemCount, min(bottomNumberOfStackedCards, cardCollectionBottomCardsSet.count)))
    }

    private var contentInsetBottom: CGFloat {
        if collectionViewIgnoreBottomContentOffsetChanges == true {
            return collectionViewLastBottomContentOffset
        }
        collectionViewLastBottomContentOffset = contentInset.bottom
        return contentInset.bottom
    }

    private var scalePerCard: CGFloat {
        let maximumScale = bottomStackedCardsMaximumScale
        let minimumScale = (maximumScale < bottomStackedCardsMinimumScale) ? maximumScale : bottomStackedCardsMinimumScale
        return (maximumScale - minimumScale) / CGFloat(bottomNumberOfStackedCards)
    }

    // MARK: Initialize HFCardCollectionViewLayout

    internal func installMoveCardsGestureRecognizer() {
        movingCardGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(movingCardGestureHandler))
        movingCardGestureRecognizer?.minimumPressDuration = 0.49
        movingCardGestureRecognizer?.delegate = self
        collectionView?.addGestureRecognizer(movingCardGestureRecognizer!)
    }

    private func initializeCardCollectionViewLayout() {
        collectionViewIsInitialized = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)

        collectionViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collectionViewTapGestureHandler))
        collectionViewTapGestureRecognizer?.delegate = self
        collectionView?.addGestureRecognizer(collectionViewTapGestureRecognizer!)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        collectionViewIgnoreBottomContentOffsetChanges = true
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        collectionViewIgnoreBottomContentOffsetChanges = false
    }

    // MARK: UICollectionViewLayout Overrides

    /// The width and height of the collection view’s contents.
    override open var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
            return super.collectionViewContentSize
        }
        let section = collectionView.numberOfSections - 1
        let item = collectionView.numberOfItems(inSection: section) - 1
        let lastCellSize = cardCollectionCellSize(for: IndexPath(item: item, section: section))
        let contentWidth = collectionView.frame.width - (contentInset.left + contentInset.right)
        let contentHeight = cardHeadHeight * CGFloat(collectionViewItemCount - 1) + lastCellSize.height + self.spaceAtTopForBackgroundView + self.spaceAtBottom
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override open func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateDataSourceCounts {
            collectionViewItemCount = 0
            if let collectionView = collectionView, collectionView.numberOfSections > 0 {
                let sections = collectionView.numberOfSections
                collectionViewItemCount = (0 ..< sections).reduce(0) { total, current -> Int in
                    total + collectionView.numberOfItems(inSection: current)
                }
            }
        }
        super.invalidateLayout(with: context)
    }

    /// Tells the layout object to update the current layout.
    override open func prepare() {
        super.prepare()

        if collectionViewIsInitialized == false {
            initializeCardCollectionViewLayout()
        }

        cardCollectionViewLayoutAttributes = generateCardCollectionViewLayoutAttributes()
    }

    /// A layout attributes object containing the information to apply to the item’s cell.
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cardCollectionViewLayoutAttributes[indexPath]
    }

    /// An array of UICollectionViewLayoutAttributes objects representing the layout information for the cells and views. The default implementation returns nil.
    ///
    /// - Parameter rect: The rectangle
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = cardCollectionViewLayoutAttributes.filter { $1.frame.intersects(rect) }.compactMap({ $1 })
        return attributes
    }

    /// true if the collection view requires a layout update or false if the layout does not need to change.
    ///
    /// - Parameter newBounds: The new bounds of the collection view.
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    /// The content offset that you want to use instead.
    ///
    /// - Parameter proposedContentOffset: The proposed point (in the collection view’s content view) at which to stop scrolling. This is the value at which scrolling would naturally stop if no adjustments were made. The point reflects the upper-left corner of the visible content.
    /// - Parameter velocity: The current scrolling velocity along both the horizontal and vertical axes. This value is measured in points per second.
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedContentOffsetY = proposedContentOffset.y + contentInset.top
        if spaceAtTopShouldSnap == true && spaceAtTopForBackgroundView > 0 {
            if proposedContentOffsetY > 0 && proposedContentOffsetY < spaceAtTopForBackgroundView {
                let scrollToTopY = spaceAtTopForBackgroundView * 0.5
                if proposedContentOffsetY < scrollToTopY {
                    return CGPoint(x: 0, y: 0 - contentInset.top)
                } else {
                    return CGPoint(x: 0, y: spaceAtTopForBackgroundView - contentInset.top)
                }
            }
        }
        if scrollShouldSnapCardHead == true && proposedContentOffsetY > spaceAtTopForBackgroundView && collectionView!.contentSize.height > collectionView!.frame.height + cardHeadHeight {
            let startIndex = Int((proposedContentOffsetY - spaceAtTopForBackgroundView) / cardHeadHeight) + 1
            let positionToGoUp = cardHeadHeight * 0.5
            let cardHeadPosition = (proposedContentOffsetY - spaceAtTopForBackgroundView).truncatingRemainder(dividingBy: cardHeadHeight)
            if cardHeadPosition > positionToGoUp {
                let targetY = (CGFloat(startIndex) * cardHeadHeight) + (spaceAtTopForBackgroundView - contentInset.top)
                return CGPoint(x: 0, y: targetY)
            } else {
                let targetY = (CGFloat(startIndex) * cardHeadHeight) - cardHeadHeight + (spaceAtTopForBackgroundView - contentInset.top)
                return CGPoint(x: 0, y: targetY)
            }
        }
        return proposedContentOffset
    }

    /// This method is called when there is an update with deletes to the collection view.
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        collectionViewDeletedIndexPaths.removeAll(keepingCapacity: false)

        for update in updateItems {
            switch update.updateAction {
            case .delete:
                collectionViewDeletedIndexPaths.append(update.indexPathBeforeUpdate!)
            default:
                return
            }
        }
    }

    /// Custom animation for deleting cells.
    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)

        if collectionViewDeletedIndexPaths.contains(itemIndexPath) {
            if let attrs = attrs {
                attrs.alpha = 0.0
                attrs.transform3D = CATransform3DScale(attrs.transform3D, 0.001, 0.001, 1)
            }
        }

        return attrs
    }

    /// Remove deleted indexPaths
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        collectionViewDeletedIndexPaths.removeAll(keepingCapacity: false)
    }

    // MARK: Private Functions for UICollectionViewLayout

    @objc internal func collectionViewTapGestureHandler() {
        if let tapLocation = collectionViewTapGestureRecognizer?.location(in: collectionView) {
            if let indexPath = collectionView?.indexPathForItem(at: tapLocation) {
                collectionView?.delegate?.collectionView?(collectionView!, didSelectItemAt: indexPath)
            }
        }
    }

    private func generateCardCollectionViewLayoutAttributes() -> [IndexPath: HFCardCollectionViewLayoutAttributes] {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else { return [:] }
        var cardCollectionViewLayoutAttributes = [IndexPath: HFCardCollectionViewLayoutAttributes]()
        var shouldReloadAllItems = false
        if !self.cardCollectionViewLayoutAttributes.isEmpty && collectionViewItemCount == self.cardCollectionViewLayoutAttributes.count {
            cardCollectionViewLayoutAttributes = self.cardCollectionViewLayoutAttributes
        } else {
            shouldReloadAllItems = true
        }

        var startIndex = Int((collectionView.contentOffset.y + contentInset.top - spaceAtTopForBackgroundView + collectionViewTemporaryTop) / cardHeadHeight) - 10
        var endBeforeIndex = Int((collectionView.contentOffset.y + collectionView.frame.size.height + collectionViewTemporaryTop) / cardHeadHeight) + 5

        if startIndex < 0 {
            startIndex = 0
        }
        if endBeforeIndex > collectionViewItemCount {
            endBeforeIndex = collectionViewItemCount
        }
        if shouldReloadAllItems == true {
            startIndex = 0
            endBeforeIndex = collectionViewItemCount
        }

        cardCollectionBottomCardsSet = generateBottomIndexes()

        var itemsIdx = 0
        var bottomIndex = 0
        for sec in 0 ..< collectionView.numberOfSections {
            let count = collectionView.numberOfItems(inSection: sec)
            if itemsIdx + count - 1 < startIndex {
                itemsIdx += count
                continue
            }
            for item in 0 ..< count {
                if itemsIdx >= startIndex {
                    let indexPath = IndexPath(item: item, section: sec)
                    let cardLayoutAttribute = HFCardCollectionViewLayoutAttributes(forCellWith: indexPath)
                    cardLayoutAttribute.zIndex = itemsIdx

                    if revealedIndexPath == nil && collapseAllCards == false {
                        collectionView.contentOffset.y += collectionViewTemporaryTop
                        collectionViewTemporaryTop = 0
                        generateNonRevealedCardsAttribute(cardLayoutAttribute)
                    } else if revealedIndexPath == cardLayoutAttribute.indexPath && collapseAllCards == false {
                        generateRevealedCardAttribute(cardLayoutAttribute)
                    } else {
                        generateBottomCardsAttribute(cardLayoutAttribute, bottomIndex: &bottomIndex)
                    }
                    cardCollectionViewLayoutAttributes[indexPath] = cardLayoutAttribute
                }
                itemsIdx += 1
            }
        }
        return cardCollectionViewLayoutAttributes
    }

    private func generateBottomIndexes() -> [Int] {
        guard let revealedIndex = revealedIndex else {
            if collapseAllCards == false {
                return []
            } else {
                let startIndex: Int = Int((contentOffsetTop + collectionViewTemporaryTop) / cardHeadHeight)
                let endIndex = max(0, startIndex + bottomNumberOfStackedCards - 2)
                return Array(startIndex ... endIndex)
            }
        }

        let half = Int(bottomNumberOfStackedCards / 2)
        var minIndex = revealedIndex - half
        var maxIndex = revealedIndex + half

        if minIndex < 0 {
            minIndex = 0
            maxIndex = revealedIndex + half + abs(revealedIndex - half)
            if bottomNumberOfStackedCards % 2 == 1 {
                maxIndex += 1
            }
        } else if maxIndex >= collectionViewItemCount {
            minIndex = (collectionViewItemCount - 2 * half) - 1
            maxIndex = collectionViewItemCount - 1
            if bottomNumberOfStackedCards % 2 == 1 {
                minIndex -= 1
            }
        } else if bottomNumberOfStackedCards % 2 == 1 {
            if minIndex > 0 {
                minIndex -= 1
            } else {
                maxIndex += 1
            }
        }
        minIndex = max(0, minIndex)
        maxIndex = min(collectionViewItemCount - 1, maxIndex)
        cardCollectionBottomCardsRevealedIndex = revealedIndex - minIndex

        return Array(minIndex ... maxIndex).filter({ $0 != revealedIndex })
    }

    private func generateNonRevealedCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes) {
        let cardHeadHeight = calculateCardHeadHeight()

        let startIndex = Int((contentOffsetTop + collectionViewTemporaryTop - spaceAtTopForBackgroundView) / cardHeadHeight)
        let currentIndex = attribute.zIndex
        if currentIndex == movingCardSelectedIndex {
            attribute.alpha = 0.0
        } else {
            attribute.alpha = 1.0
        }

        let currentFrame = CGRect(origin: CGPoint(x: 0, y: spaceAtTopForBackgroundView + cardHeadHeight * CGFloat(currentIndex)), size: cardCollectionCellSize(for: attribute.indexPath))
        if contentOffsetTop >= 0 && contentOffsetTop <= spaceAtTopForBackgroundView {
            attribute.frame = currentFrame
        } else if contentOffsetTop > spaceAtTopForBackgroundView {
            attribute.isHidden = (scrollStopCardsAtTop == true && currentIndex < startIndex)

            if movingCardSelectedIndex >= 0 && currentIndex + 1 == movingCardSelectedIndex {
                attribute.isHidden = false
            }
            if scrollStopCardsAtTop == true && ((currentIndex != 0 && currentIndex <= startIndex) || (currentIndex == 0 && (contentOffsetTop - spaceAtTopForBackgroundView) > 0)) {
                var newFrame = currentFrame
                newFrame.origin.y = contentOffsetTop
                attribute.frame = newFrame
            } else {
                attribute.frame = currentFrame
            }
            if attribute.isHidden == true && currentIndex < startIndex - 5 {
                attribute.frame = currentFrame
                attribute.frame.origin.y = collectionView!.frame.height * -1.5
            }
        } else {
            if cardShouldStretchAtScrollTop == true {
                let stretchMultiplier: CGFloat = (1 + (CGFloat(currentIndex + 1) * -0.2))
                var newFrame = currentFrame
                newFrame.origin.y = newFrame.origin.y + CGFloat(contentOffsetTop * stretchMultiplier)
                attribute.frame = newFrame
            } else {
                attribute.frame = currentFrame
            }
        }
        attribute.isRevealed = false
    }

    private func generateRevealedCardAttribute(_ attribute: HFCardCollectionViewLayoutAttributes) {
        attribute.isRevealed = true
        let cellSize = cardCollectionCellSize(for: attribute.indexPath)
        if collectionViewItemCount == 1 {
            attribute.frame = CGRect(origin: CGPoint(x: 0, y: contentOffsetTop + spaceAtTopForBackgroundView + 0.01), size: cellSize)
        } else {
            attribute.frame = CGRect(origin: CGPoint(x: 0, y: contentOffsetTop + 0.01), size: cellSize)
        }
    }

    private func generateBottomCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes, bottomIndex: inout Int) {
        let index = attribute.zIndex
        let cellSize = cardCollectionCellSize(for: attribute.indexPath)
        let posY = cardHeadHeight * CGFloat(index)
        let currentFrame = CGRect(origin: CGPoint(x: collectionView!.frame.origin.x, y: posY), size: cellSize)
        let maxY = collectionView!.contentOffset.y + collectionView!.frame.height
        let contentFrame = CGRect(x: 0, y: collectionView!.contentOffset.y, width: collectionView!.frame.width, height: maxY)
        if cardCollectionBottomCardsSet.contains(index) {
            let margin: CGFloat = bottomCardLookoutMargin
            let baseHeight = (collectionView!.frame.height + collectionView!.contentOffset.y) - contentInsetBottom - (margin * bottomCardCount)
            let scale: CGFloat = calculateCardScale(forIndex: bottomIndex)
            let yAddition: CGFloat = (cellSize.height - (cellSize.height * scale)) / 2
            let yPos: CGFloat = baseHeight + (CGFloat(bottomIndex) * margin) - yAddition
            attribute.frame = CGRect(origin: CGPoint(x: 0, y: yPos), size: cellSize)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            bottomIndex += 1
        } else if contentFrame.intersects(currentFrame) {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect(origin: CGPoint(x: 0, y: maxY), size: cellSize)
        } else {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect(origin: CGPoint(x: 0, y: posY), size: cellSize)
        }
        attribute.isRevealed = false
    }

    private func calculateCardScale(forIndex index: Int, scaleBehindCard: Bool = false) -> CGFloat {
        if bottomStackedCardsShouldScale == true {
            let scalePerCard = self.scalePerCard
            let addedDownScale: CGFloat = (scaleBehindCard == true && CGFloat(index) < bottomCardCount) ? scalePerCard : 0.0
            return min(1.0, bottomStackedCardsMaximumScale - (((CGFloat(index) + 1 - bottomCardCount) * -1) * scalePerCard) - addedDownScale)
        }
        return 1.0
    }

    private func calculateCardHeadHeight() -> CGFloat {
        var cardHeadHeight = self.cardHeadHeight
        if cardShouldExpandHeadHeight == true {
            cardHeadHeight = max(self.cardHeadHeight, (collectionView!.frame.height - (contentInset.top + contentInsetBottom + spaceAtTopForBackgroundView)) / CGFloat(collectionViewItemCount))
        }
        return cardHeadHeight
    }

    // MARK: Revealed Card

    private func initializeRevealedCard() -> Bool {
        if let revealedCardCell = revealedCardCell {
            revealedCardPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(revealedCardPanGestureHandler))
            revealedCardPanGestureRecognizer?.delegate = self
            revealedCardCell.addGestureRecognizer(revealedCardPanGestureRecognizer!)
            return true
        }
        return false
    }

    private func deinitializeRevealedCard() {
        if let revealedCardCell = revealedCardCell, revealedCardPanGestureRecognizer != nil {
            revealedCardCell.removeGestureRecognizer(revealedCardPanGestureRecognizer!)
            revealedCardPanGestureRecognizer = nil
        }
    }

    @objc internal func revealedCardPanGestureHandler() {
        if collectionViewItemCount == 1 || revealedCardIsFlipped == true {
            return
        }
        if let revealedCardPanGestureRecognizer = revealedCardPanGestureRecognizer, let revealedCardCell = revealedCardCell {
            let gestureTouchLocation = revealedCardPanGestureRecognizer.location(in: collectionView)
            let shiftY: CGFloat = (gestureTouchLocation.y - revealedCardPanGestureTouchLocationY > 0) ? gestureTouchLocation.y - revealedCardPanGestureTouchLocationY : 0

            switch revealedCardPanGestureRecognizer.state {
            case .began:
                UIApplication.shared.keyWindow?.endEditing(true)
                revealedCardPanGestureTouchLocationY = gestureTouchLocation.y
            case .changed:
                let scaleTarget = calculateCardScale(forIndex: cardCollectionBottomCardsRevealedIndex, scaleBehindCard: true)
                let scaleDiff: CGFloat = 1.0 - scaleTarget
                let scale: CGFloat = 1.0 - min((shiftY * scaleDiff) / (collectionView!.frame.height / 2), scaleDiff)
                let transformY = CGAffineTransform(translationX: 0, y: shiftY)
                let transformScale = CGAffineTransform(scaleX: scale, y: scale)
                revealedCardCell.transform = transformY.concatenating(transformScale)
            default:
                let isNeedReload = (shiftY > revealedCardCell.frame.height / 7) ? true : false
                let resetY = isNeedReload ? collectionView!.frame.height : 0
                let scale: CGFloat = isNeedReload ? calculateCardScale(forIndex: cardCollectionBottomCardsRevealedIndex, scaleBehindCard: true) : 1.0

                let transformScale = CGAffineTransform(scaleX: scale, y: scale)
                let transformY = CGAffineTransform(translationX: 0, y: resetY * (1.0 + (1.0 - scale)))

                UIView.animate(withDuration: 0.3, animations: {
                    revealedCardCell.transform = transformY.concatenating(transformScale)
                }, completion: { finished in
                    if isNeedReload && finished {
                        self.unrevealCard()
                    }
                })
            }
        }
    }

    // MARK: Moving Card

    @objc internal func movingCardGestureHandler() {
        let moveUpOffset: CGFloat = 20

        if let movingCardGestureRecognizer = movingCardGestureRecognizer {
            switch movingCardGestureRecognizer.state {
            case .began:
                movingCardGestureStartLocation = movingCardGestureRecognizer.location(in: collectionView)
                if let indexPath = collectionView?.indexPathForItem(at: movingCardGestureStartLocation), let attr = cardCollectionViewLayoutAttributes[indexPath] {
                    movingCardActive = true
                    if attr.zIndex < firstMovableIndex {
                        movingCardActive = false
                        return
                    }
                    if let cell = collectionView?.cellForItem(at: indexPath) {
                        movingCardStartIndexPath = indexPath
                        movingCardCenterStart = cell.center
                        movingCardSnapshotCell = cell.snapshotView(afterScreenUpdates: false)
                        movingCardSnapshotCell?.frame = cell.frame
                        movingCardSnapshotCell?.alpha = 1.0
                        movingCardSnapshotCell?.layer.zPosition = cell.layer.zPosition
                        collectionView?.insertSubview(movingCardSnapshotCell!, aboveSubview: cell)
                        cell.alpha = 0.0
                        movingCardSelectedIndex = attr.zIndex
                        UIView.animate(withDuration: 0.2, animations: {
                            self.movingCardSnapshotCell?.frame.origin.y -= moveUpOffset
                        })
                    }
                } else {
                    movingCardActive = false
                }
            case .changed:
                if movingCardActive == true {
                    movingCardGestureCurrentLocation = movingCardGestureRecognizer.location(in: collectionView)
                    var currentCenter = movingCardCenterStart
                    currentCenter.y += (movingCardGestureCurrentLocation.y - movingCardGestureStartLocation.y - moveUpOffset)
                    movingCardSnapshotCell?.center = currentCenter
                    if movingCardGestureCurrentLocation.y > ((collectionView!.contentOffset.y + collectionView!.frame.height) - spaceAtBottom - contentInsetBottom - scrollAreaBottom) {
                        setupScrollTimer(direction: .down)
                    } else if (movingCardGestureCurrentLocation.y - collectionView!.contentOffset.y) - contentInset.top < scrollAreaTop {
                        setupScrollTimer(direction: .up)
                    } else {
                        invalidateScrollTimer()
                    }

                    var tempIndexPath = collectionView?.indexPathForItem(at: movingCardGestureCurrentLocation)
                    if tempIndexPath == nil {
                        tempIndexPath = collectionView?.indexPathForItem(at: movingCardLastTouchedLocation)
                    }

                    if let currentTouchedIndexPath = tempIndexPath, let attr = cardCollectionViewLayoutAttributes[currentTouchedIndexPath] {
                        movingCardLastTouchedLocation = movingCardGestureCurrentLocation
                        if attr.zIndex < firstMovableIndex {
                            return
                        }
                        if movingCardLastTouchedIndexPath == nil && currentTouchedIndexPath != movingCardStartIndexPath! {
                            movingCardLastTouchedIndexPath = movingCardStartIndexPath
                        }
                        if movingCardLastTouchedIndexPath != nil && movingCardLastTouchedIndexPath! != currentTouchedIndexPath {
                            let movingCell = collectionView?.cellForItem(at: currentTouchedIndexPath)
                            let movingCellAttr = collectionView?.layoutAttributesForItem(at: currentTouchedIndexPath)

                            if movingCell != nil {
                                let cardHeadHeight = calculateCardHeadHeight()
                                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                                    movingCell?.frame.origin.y -= cardHeadHeight
                                }, completion: { _ in
                                    movingCellAttr?.frame.origin.y -= cardHeadHeight
                                })
                            }

                            movingCardSelectedIndex = attr.zIndex
                            collectionView?.dataSource?.collectionView?(collectionView!, moveItemAt: currentTouchedIndexPath, to: movingCardLastTouchedIndexPath!)
                            UIView.performWithoutAnimation {
                                self.collectionView?.moveItem(at: currentTouchedIndexPath, to: self.movingCardLastTouchedIndexPath!)
                            }

                            movingCardLastTouchedIndexPath = currentTouchedIndexPath
                            if let belowCell = collectionView?.cellForItem(at: currentTouchedIndexPath) {
                                movingCardSnapshotCell?.removeFromSuperview()
                                collectionView?.insertSubview(movingCardSnapshotCell!, belowSubview: belowCell)
                                movingCardSnapshotCell?.layer.zPosition = belowCell.layer.zPosition
                            } else {
                                collectionView?.sendSubviewToBack(movingCardSnapshotCell!)
                            }
                        }
                    }
                }
            case .ended:
                invalidateScrollTimer()
                if movingCardActive == true {
                    var indexPath = movingCardStartIndexPath!
                    if movingCardLastTouchedIndexPath != nil {
                        indexPath = movingCardLastTouchedIndexPath!
                    }
                    if let cell = collectionView?.cellForItem(at: indexPath) {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.movingCardSnapshotCell?.frame = cell.frame
                        }, completion: { _ in
                            self.movingCardActive = false
                            self.movingCardLastTouchedIndexPath = nil
                            self.movingCardSelectedIndex = -1
                            self.collectionView?.reloadData()
                            self.movingCardSnapshotCell?.removeFromSuperview()
                            self.movingCardSnapshotCell = nil
                            if self.movingCardStartIndexPath == indexPath {
                                UIView.animate(withDuration: 0, animations: {
                                    self.invalidateLayout()
                                })
                            }
                        })
                    } else {
                        fallthrough
                    }
                }
            case .cancelled:
                movingCardActive = false
                movingCardLastTouchedIndexPath = nil
                movingCardSelectedIndex = -1
                collectionView?.reloadData()
                movingCardSnapshotCell?.removeFromSuperview()
                movingCardSnapshotCell = nil
                invalidateLayout()
            default:
                break
            }
        }
    }

    // MARK: AutoScroll

    enum HFCardCollectionScrollDirection: Int {
        case unknown = 0
        case up
        case down
    }

    private func setupScrollTimer(direction: HFCardCollectionScrollDirection) {
        if autoscrollDisplayLink != nil && autoscrollDisplayLink!.isPaused == false {
            if direction == autoscrollDirection {
                return
            }
        }
        invalidateScrollTimer()
        autoscrollDisplayLink = CADisplayLink(target: self, selector: #selector(autoscrollHandler(displayLink:)))
        autoscrollDirection = direction
        autoscrollDisplayLink?.add(to: .main, forMode: .common)
    }

    private func invalidateScrollTimer() {
        if autoscrollDisplayLink != nil && autoscrollDisplayLink!.isPaused == false {
            autoscrollDisplayLink?.invalidate()
        }
        autoscrollDisplayLink = nil
    }

    @objc internal func autoscrollHandler(displayLink: CADisplayLink) {
        let direction = autoscrollDirection
        if direction == .unknown {
            return
        }

        let scrollMultiplier = generateScrollSpeedMultiplier()
        let frameSize = collectionView!.frame.size
        let contentSize = collectionView!.contentSize
        let contentOffset = collectionView!.contentOffset
        let contentInset = self.contentInset
        var distance: CGFloat = CGFloat(rint(scrollMultiplier * displayLink.duration))
        var translation = CGPoint.zero

        switch direction {
        case .up:
            distance = -distance
            let minY: CGFloat = 0.0 - contentInset.top
            if (contentOffset.y + distance) <= minY {
                distance = -contentOffset.y - contentInset.top
            }
            translation = CGPoint(x: 0.0, y: distance)
        case .down:
            let maxY: CGFloat = max(contentSize.height, frameSize.height) - frameSize.height + contentInsetBottom
            if (contentOffset.y + distance) >= maxY {
                distance = maxY - contentOffset.y
            }
            translation = CGPoint(x: 0.0, y: distance)
        default:
            break
        }

        collectionView!.contentOffset = cgPointAdd(contentOffset, translation)
        movingCardGestureHandler()
    }

    private func generateScrollSpeedMultiplier() -> Double {
        var multiplier: Double = 250.0
        if let movingCardGestureRecognizer = movingCardGestureRecognizer {
            let touchLocation = movingCardGestureRecognizer.location(in: collectionView)
            let maxSpeed: CGFloat = 600
            if autoscrollDirection == .up {
                let touchPosY = min(max(0, scrollAreaTop - (touchLocation.y - contentOffsetTop)), scrollAreaTop)
                multiplier = Double(maxSpeed * (touchPosY / scrollAreaTop))
            } else if autoscrollDirection == .down {
                let offsetTop = ((collectionView!.contentOffset.y + collectionView!.frame.height) - spaceAtBottom - contentInsetBottom - scrollAreaBottom)
                let touchPosY = min(max(0, touchLocation.y - offsetTop), scrollAreaBottom)
                multiplier = Double(maxSpeed * (touchPosY / scrollAreaBottom))
            }
        }
        return multiplier
    }

    private func cgPointAdd(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        return CGPoint(x: point1.x + point2.x, y: point1.y + point2.y)
    }

    // MARK: UIGestureRecognizerDelegate

    /// Return true no card is revealed.
    ///
    /// - Parameter gestureRecognizer: The gesture recognizer.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == movingCardGestureRecognizer || gestureRecognizer == collectionViewTapGestureRecognizer {
            if revealedIndexPath != nil {
                return false
            }
        }

        if gestureRecognizer == revealedCardPanGestureRecognizer {
            let velocity = revealedCardPanGestureRecognizer?.velocity(in: revealedCardPanGestureRecognizer?.view)
            let result = abs(velocity!.y) > abs(velocity!.x)
            return result
        }
        return true
    }
}
