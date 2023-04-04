//
//  ExampleCollectionViewCell.swift
//  HFCardCollectionViewLayoutExample
//
//  Created by Hendrik Frahmann on 02.11.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import HFCardCollectionViewLayout
import QuartzCore
import UIKit

class ExampleCollectionViewCell: HFCardCollectionViewCell {
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    @IBOutlet var buttonFlip: UIButton?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var labelText: UILabel?
    @IBOutlet var imageIcon: UIImageView?

    @IBOutlet var backView: UIView?
    @IBOutlet var buttonFlipBack: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonFlip?.isHidden = true
        tableView?.scrollsToTop = false

        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.allowsSelectionDuringEditing = false
        tableView?.reloadData()
    }

    func cardIsRevealed(_ isRevealed: Bool) {
        buttonFlip?.isHidden = !isRevealed
        tableView?.scrollsToTop = isRevealed
    }

    @IBAction func buttonFlipAction() {
        if let backView = backView {
            // Same Corner radius like the contentview of the HFCardCollectionViewCell
            backView.layer.cornerRadius = cornerRadius
            backView.layer.masksToBounds = true

            cardCollectionViewLayout?.flipRevealedCard(toView: backView)
        }
    }
}

extension ExampleCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")
        cell?.textLabel?.text = "Table Cell #\(indexPath.row)"
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // nothing
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let anAction = UITableViewRowAction(style: .default, title: "An Action") {
            _, _ -> Void in
            // code for action
        }
        return [anAction]
    }
}
