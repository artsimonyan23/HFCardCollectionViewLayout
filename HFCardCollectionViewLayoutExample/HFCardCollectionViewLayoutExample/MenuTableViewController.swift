//
//  MenuTableViewController.swift
//  HFCardCollectionViewLayoutExample
//
//  Created by Hendrik Frahmann on 31.10.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import UIKit

struct CardLayoutSetupOptions {
    var firstMovableIndex: Int = 0
    var cardHeadHeight: CGFloat = 80
    var cardShouldExpandHeadHeight: Bool = true
    var cardShouldStretchAtScrollTop: Bool = true
    var cardMaximumHeight: CGFloat = 0
    var bottomNumberOfStackedCards: Int = 5
    var bottomStackedCardsShouldScale: Bool = true
    var bottomCardLookoutMargin: CGFloat = 10
    var bottomStackedCardsMaximumScale: CGFloat = 1.0
    var bottomStackedCardsMinimumScale: CGFloat = 0.94
    var spaceAtTopForBackgroundView: CGFloat = 0
    var spaceAtTopShouldSnap: Bool = true
    var spaceAtBottom: CGFloat = 0
    var scrollAreaTop: CGFloat = 120
    var scrollAreaBottom: CGFloat = 120
    var scrollShouldSnapCardHead: Bool = false
    var scrollStopCardsAtTop: Bool = true

    var numberOfCards: Int = 15
}

class MenuTableViewController: UITableViewController {
    var hideNavigationBar = false
    var hideToolBar = false

    var defaults = CardLayoutSetupOptions()
    var numberFormatter = NumberFormatter()

    @IBOutlet var textfieldNumberOfCards: UITextField?
    @IBOutlet var textfieldFirstMovableIndex: UITextField?
    @IBOutlet var textfieldCardHeadHeight: UITextField?
    @IBOutlet var switchCardShouldExpandHeadHeight: UISwitch?
    @IBOutlet var switchCardShouldStretchAtScrollTop: UISwitch?
    @IBOutlet var textfieldCardMaximumHeight: UITextField?
    @IBOutlet var textfieldBottomNumberOfStackedCards: UITextField?
    @IBOutlet var switchBottomStackedCardsShouldScale: UISwitch?
    @IBOutlet var textfieldBottomCardLookoutMargin: UITextField?
    @IBOutlet var textfieldSpaceAtTopForBackgroundView: UITextField?
    @IBOutlet var textfieldBottomStackedCardsMinimumScale: UITextField?
    @IBOutlet var textfieldBottomStackedCardsMaximumScale: UITextField?
    @IBOutlet var switchSpaceAtTopShouldSnap: UISwitch?
    @IBOutlet var textfieldSpaceAtBottom: UITextField?
    @IBOutlet var textfieldScrollAreaTop: UITextField?
    @IBOutlet var textfieldScrollAreaBottom: UITextField?
    @IBOutlet var switchScrollShouldSnapCardHead: UISwitch?
    @IBOutlet var switchScrollStopCardsAtTop: UISwitch?

    override func viewDidLoad() {
        numberFormatter.locale = Locale(identifier: "en_US")
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
        navigationController?.isNavigationBarHidden = hideNavigationBar
        navigationController?.isToolbarHidden = hideToolBar
    }

    // MARK: Actions

    @IBAction func resetAction() {
        textfieldNumberOfCards?.text = String(defaults.numberOfCards)
        textfieldFirstMovableIndex?.text = String(defaults.firstMovableIndex)
        textfieldCardHeadHeight?.text = stringFromFloat(defaults.cardHeadHeight)
        switchCardShouldExpandHeadHeight?.isOn = defaults.cardShouldExpandHeadHeight
        switchCardShouldStretchAtScrollTop?.isOn = defaults.cardShouldStretchAtScrollTop
        textfieldCardMaximumHeight?.text = stringFromFloat(defaults.cardMaximumHeight)
        textfieldBottomNumberOfStackedCards?.text = String(defaults.bottomNumberOfStackedCards)
        switchBottomStackedCardsShouldScale?.isOn = defaults.bottomStackedCardsShouldScale
        textfieldBottomCardLookoutMargin?.text = stringFromFloat(defaults.bottomCardLookoutMargin)
        textfieldSpaceAtTopForBackgroundView?.text = stringFromFloat(defaults.spaceAtTopForBackgroundView)
        switchSpaceAtTopShouldSnap?.isOn = defaults.spaceAtTopShouldSnap
        textfieldSpaceAtBottom?.text = stringFromFloat(defaults.spaceAtBottom)
        textfieldScrollAreaTop?.text = stringFromFloat(defaults.scrollAreaTop)
        textfieldScrollAreaBottom?.text = stringFromFloat(defaults.scrollAreaBottom)
        switchScrollShouldSnapCardHead?.isOn = defaults.scrollShouldSnapCardHead
        switchScrollStopCardsAtTop?.isOn = defaults.scrollStopCardsAtTop
        textfieldBottomStackedCardsMinimumScale?.text = stringFromFloat(defaults.bottomStackedCardsMinimumScale)
        textfieldBottomStackedCardsMaximumScale?.text = stringFromFloat(defaults.bottomStackedCardsMaximumScale)
    }

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ExampleViewController {
            var layoutOptions = CardLayoutSetupOptions()
            layoutOptions.numberOfCards = getIntFromTextfield(textfieldNumberOfCards!)
            layoutOptions.firstMovableIndex = getIntFromTextfield(textfieldFirstMovableIndex!)
            layoutOptions.cardHeadHeight = getFloatFromTextfield(textfieldCardHeadHeight!)
            layoutOptions.cardShouldExpandHeadHeight = switchCardShouldExpandHeadHeight!.isOn
            layoutOptions.cardShouldStretchAtScrollTop = switchCardShouldStretchAtScrollTop!.isOn
            layoutOptions.cardMaximumHeight = getFloatFromTextfield(textfieldCardMaximumHeight!)
            layoutOptions.bottomNumberOfStackedCards = getIntFromTextfield(textfieldBottomNumberOfStackedCards!)
            layoutOptions.bottomStackedCardsShouldScale = switchBottomStackedCardsShouldScale!.isOn
            layoutOptions.bottomCardLookoutMargin = getFloatFromTextfield(textfieldBottomCardLookoutMargin!)
            layoutOptions.spaceAtTopForBackgroundView = getFloatFromTextfield(textfieldSpaceAtTopForBackgroundView!)
            layoutOptions.spaceAtTopShouldSnap = switchSpaceAtTopShouldSnap!.isOn
            layoutOptions.spaceAtBottom = getFloatFromTextfield(textfieldSpaceAtBottom!)
            layoutOptions.scrollAreaTop = getFloatFromTextfield(textfieldScrollAreaTop!)
            layoutOptions.scrollAreaBottom = getFloatFromTextfield(textfieldScrollAreaBottom!)
            layoutOptions.scrollShouldSnapCardHead = switchScrollShouldSnapCardHead!.isOn
            layoutOptions.scrollStopCardsAtTop = switchScrollStopCardsAtTop!.isOn
            layoutOptions.bottomStackedCardsMinimumScale = getFloatFromTextfield(textfieldBottomStackedCardsMinimumScale!)
            layoutOptions.bottomStackedCardsMaximumScale = getFloatFromTextfield(textfieldBottomStackedCardsMaximumScale!)

            controller.cardLayoutOptions = layoutOptions

            if segue.identifier == "AsRootController" {
                hideNavigationBar = true
                hideToolBar = true
                controller.shouldSetupBackgroundView = true
            }
            if segue.identifier == "WithinNavigationController" {
                hideNavigationBar = false
                hideToolBar = true
            }
            if segue.identifier == "WithNavigationAndToolbar" {
                hideNavigationBar = false
                hideToolBar = false
            }
        }
    }

    // MARK: Private functions

    private func getIntFromTextfield(_ textfield: UITextField) -> Int {
        if let n = numberFormatter.number(from: (textfield.text)!) {
            return n.intValue
        }
        return 0
    }

    private func getFloatFromTextfield(_ textfield: UITextField) -> CGFloat {
        if let n = numberFormatter.number(from: (textfield.text)!) {
            return CGFloat(truncating: n)
        }
        return 0
    }

    private func stringFromFloat(_ float: CGFloat) -> String {
        return String(Int(float))
    }
}
