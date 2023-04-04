//
//  HFCardCollectionViewLayoutDelegate.swift
//  Pods
//
//  Created by Hendrik Frahmann on 17.11.16.
//
//

import UIKit

/// Extended delegate.
@objc public protocol HFCardCollectionViewLayoutDelegate: UICollectionViewDelegate {
    /// Asks if the card at the specific index can be revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter canRevealCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canRevealCardAt indexPath: IndexPath) -> Bool

    /// Asks if the card at the specific index can be Unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter canUnrevealCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, canUnrevealCardAt indexPath: IndexPath) -> Bool

    /// Feedback when the card at the given index will be revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didRevealedCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAt indexPath: IndexPath)

    /// Feedback when the card at the given index was revealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didRevealedCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, didRevealCardAt indexPath: IndexPath)

    /// Feedback when the card at the given index will be Unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAt indexPath: IndexPath)

    /// Feedback when the card at the given index was Unrevealed.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter didUnrevealedCardAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, didUnrevealCardAt indexPath: IndexPath)

    /// The size of card.
    /// - Parameter collectionViewLayout: The current HFCardCollectionViewLayout.
    /// - Parameter sizeForItemAt: Index of the card.
    @objc optional func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}
