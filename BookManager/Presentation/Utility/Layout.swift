import Foundation
import UIKit

protocol LayoutAnchor {
    func constraint(
        equalTo anchor: Self,
        constant: CGFloat
    ) -> NSLayoutConstraint

    func constraint(
        greaterThanOrEqualTo anchor: Self,
        constant: CGFloat
    ) -> NSLayoutConstraint

    func constraint(
        lessThanOrEqualTo anchor: Self,
        constant: CGFloat
    ) -> NSLayoutConstraint
}

protocol LayoutDimension {
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}

extension NSLayoutDimension: LayoutDimension {}

struct LayoutProperty<Anchor: LayoutAnchor> {
    fileprivate let anchor: Anchor
}

struct LayoutDimensionProperty<Dimension: LayoutDimension> {
    fileprivate let dimension: Dimension
}

final class LayoutProxy {
    lazy var leading = property(anchor: view.leadingAnchor)
    lazy var trailing = property(anchor: view.trailingAnchor)
    lazy var top = property(anchor: view.topAnchor)
    lazy var bottom = property(anchor: view.bottomAnchor)
    lazy var centerX = property(anchor: view.centerXAnchor)
    lazy var centerY = property(anchor: view.centerYAnchor)
    lazy var width = property(anchor: view.widthAnchor)
    lazy var height = property(anchor: view.heightAnchor)
    lazy var widthConstant = property(dimension: view.widthAnchor)
    lazy var heightConstant = property(dimension: view.heightAnchor)

    private let view: UIView

    fileprivate init(view: UIView) {
        self.view = view
    }

    private func property<A: LayoutAnchor>(anchor: A) -> LayoutProperty<A> {
        LayoutProperty(anchor: anchor)
    }

    private func property<A: LayoutDimension>(dimension: A) -> LayoutDimensionProperty<A> {
        LayoutDimensionProperty(dimension: dimension)
    }
}

extension LayoutProperty {

    func equal(
        to otherAnchor: Anchor,
        offsetBy constant: CGFloat = 0
    ) {
        self.anchor.constraint(
            equalTo: otherAnchor,
            constant: constant
        ).isActive = true
    }

    func greaterThanOrEqual(
        to otherAnchor: Anchor,
        offsetBy constant: CGFloat = 0
    ) {
        self.anchor.constraint(
            greaterThanOrEqualTo: otherAnchor,
            constant: constant
        ).isActive = true
    }

    func lessThanOrEqual(
        to otherAnchor: Anchor,
        offsetBy constant: CGFloat = 0
    ) {
        self.anchor.constraint(
            lessThanOrEqualTo: otherAnchor,
            constant: constant
        ).isActive = true
    }
}

extension LayoutDimensionProperty {

    func equal(constant: CGFloat = 0) {
        self.dimension.constraint(
            equalToConstant: constant
        ).isActive = true
    }
}

extension UIView {

    func layout(using closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }
}

func + <A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

func - <A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

func == <A: LayoutAnchor>(
    lhs: LayoutProperty<A>,
    rhs: (A, CGFloat)
) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

func == <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}

func == <A: LayoutDimension>(lhs: LayoutDimensionProperty<A>, rhs: CGFloat) {
    lhs.equal(constant: rhs)
}

func >= <A: LayoutAnchor>(
    lhs: LayoutProperty<A>,
    rhs: (A, CGFloat)
) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func >= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}

func <= <A: LayoutAnchor>(
    lhs: LayoutProperty<A>,
    rhs: (A, CGFloat)
) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func <= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}
