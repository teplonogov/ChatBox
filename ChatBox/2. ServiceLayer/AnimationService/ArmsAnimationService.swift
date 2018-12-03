//
//  ArmsAnimationService.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 02/12/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IArmsAnimationService {
    func setupView(view: UIView)
}

class ArmsAnimationService: IArmsAnimationService {

    let emitter = CAEmitterLayer()

    weak var view: UIView?

    lazy var gestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.touchScreen(sender:)))
    }()

    deinit {
        view?.removeGestureRecognizer(gestureRecognizer)
    }

    func setupView(view: UIView) {
        emitter.emitterShape = .circle
        emitter.emitterSize = CGSize(width: 20, height: 20)
        emitter.emitterPosition = view.center
        emitter.isOpaque = false
        emitter.opacity = 0
        emitter.emitterCells = [createEmitterCell()]
        view.addGestureRecognizer(gestureRecognizer)
        view.layer.addSublayer(emitter)
        self.view = view
    }

    @objc func touchScreen(sender: UIPanGestureRecognizer) {
        guard let unwrappedView = view else {
            return
        }

        switch sender.state {
        case .began:
            beginEmitting(position: sender.location(ofTouch: 0, in: unwrappedView))
        case .changed:
            changePosition(to: sender.location(ofTouch: 0, in: unwrappedView))
        case .ended, .cancelled:
            stopEmitting()
        default:
            return
        }

    }

    func beginEmitting(position: CGPoint) {
        changePosition(to: position)
        emitter.opacity = 1
    }

    func changePosition(to position: CGPoint) {
        emitter.emitterPosition = position
    }

    func stopEmitting() {
        emitter.opacity = 0
    }

    func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 7
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi * 2
        cell.emissionRange = CGFloat.pi * 2
        cell.spin = 3
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.07

        let image = #imageLiteral(resourceName: "tinkoffLogo")
        cell.contents = image.cgImage
        return cell
    }

}
