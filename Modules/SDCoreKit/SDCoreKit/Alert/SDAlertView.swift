//
//  SDAlertView.swift
//  SDCoreKit
//
//  Created by Ricki Bin Yamin on 13/10/23.
//

import UIKit

public class SDAlertView {
    
    public static func createSwipeDeleteAlert(_ target: UIViewController, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: SDConstant.swipeDeleteTitle, message: SDConstant.swipeDeleteMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.swipeDeletePositiveAction, style: .destructive) { _ in
            deleteHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.swipeDeleteNegativeAction, style: .cancel) { _ in
            cancelHandler()
        })
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createSwipeMoreSheet(_ target: UIViewController, renameHandler: @escaping () -> Void, saveHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: SDConstant.swipeMoreRenameAction, style: .default) { _ in
            renameHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.swipeMoreSaveAction, style: .default) { _ in
            saveHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.swipeMoreDeleteAction, style: .destructive) { _ in
            deleteHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.swipeMoreCancelAction, style: .cancel) { _ in
            cancelHandler()
        })
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createBarDeleteAlert(_ target: UIViewController, isSingular: Bool, deleteHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: SDConstant.barDeleteTitle, message: isSingular ? SDConstant.singleBarDeleteMessage : SDConstant.pluralBarDeletelMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.barDeletePositiveAction, style: .destructive) { _ in
            deleteHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.barDeleteNegativeAction, style: .cancel))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createGalleryDeleteAlert(_ target: UIViewController, deleteHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: SDConstant.galleryDeleteTitle, message: SDConstant.galleryDeleteMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.galleryDeletePositiveAction, style: .destructive) { _ in
            deleteHandler()
        })
        ac.addAction(UIAlertAction(title: SDConstant.galleryDeleteNegativeAction, style: .cancel))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createSaveImageAlert(_ target: UIViewController, isOriginalImage: Bool = false) {
        let ac = UIAlertController(title: SDConstant.saveSuccessTitle, message: isOriginalImage ? SDConstant.saveOriginalSuccessMessage : SDConstant.saveProcessedSuccessMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.saveAction, style: .default, handler: nil))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createSaveAllImageAlert(_ target: UIViewController, count: Int) {
        let ac = UIAlertController(title: SDConstant.saveSuccessTitle, message: String(count) + (count > 1 ? SDConstant.saveAllImagesSuccessMessage : SDConstant.saveAllImageSuccessMessage) , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.saveAction, style: .default, handler: nil))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createErrorSaveImageAlert(_ target: UIViewController) {
        let ac = UIAlertController(title: SDConstant.saveErrorTitle, message: SDConstant.saveErrorDefaultMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SDConstant.saveAction, style: .default))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createRenameAlert(_ target: UIViewController, currentName: String, renameHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: SDConstant.renameTitle, message: currentName, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = SDConstant.renamePlaceholder
            textField.autocapitalizationType = .words
        }
        ac.addAction(UIAlertAction(title: SDConstant.renamePositiveAction, style: .default, handler: { _ in
            guard let newName = ac.textFields?[0].text else { return }
            renameHandler(newName)
        }))
        ac.addAction(UIAlertAction(title: SDConstant.renameNegativeAction, style: .cancel))
        
        target.present(ac, animated: true, completion: nil)
    }
    
    public static func createAddNewScanAlbumAlert(_ target: UIViewController, positiveHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: SDConstant.addNewScanAlbumTitle, message: SDConstant.addNewScanAlbumMessage, preferredStyle: .alert)
        ac.addTextField {
            $0.placeholder = SDConstant.addNewScanAlbumPlaceholder
            $0.autocapitalizationType = .words
        }
        ac.addAction(UIAlertAction(title: SDConstant.addNewScanAlbumPositiveAction, style: .default, handler: { _ in
            guard let textField = ac.textFields?[0] else { return }
            positiveHandler(textField.text ?? "")
        }))
        ac.addAction(UIAlertAction(title: SDConstant.addNewScanAlbumNegativeAction, style: .cancel))
        
        target.present(ac, animated: true, completion: nil)
    }
}

