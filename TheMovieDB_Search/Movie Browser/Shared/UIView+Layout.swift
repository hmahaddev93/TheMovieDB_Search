import UIKit

public protocol LayoutContainer {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutContainer {}
extension UILayoutGuide: LayoutContainer {}

extension UIView {
    func safelyAddSubview(_ view: UIView) {
        if view.superview == nil {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    func marginToSuperviewSafeArea(top: CGFloat? = nil, bottom: CGFloat? = nil,
                                          leading: CGFloat? = nil, trailing: CGFloat? = nil) {
        guard let superview = superview else { return }
        marginToLayoutGuide(superview.safeAreaLayoutGuide, top: top, trailing: trailing, bottom: bottom, leading: leading)
    }

    func marginToSuperview(top: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil) {
        guard let superview = superview else { return }
        marginToLayoutGuide(superview, top: top, trailing: trailing, bottom: bottom, leading: leading)
    }

    func marginToLayoutGuide(_ layoutGuide: LayoutContainer, top: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil) {
        if let top = top {
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: top).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -1 * trailing).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -1 * bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: leading).isActive = true
        }
    }

    @discardableResult func centerInParent(priority: UILayoutPriority = .required) -> Self {
        alignToSuperview([ .centerX, .centerY ], priority: priority)
        return self
    }

    func alignToSuperview(_ attributes: [NSLayoutConstraint.Attribute], constant: CGFloat = 0.0, priority: UILayoutPriority = .required) {
        for attribute in attributes {
            align(attribute, toItem: self.superview, toAttribute: attribute, constant: constant, priority: priority)
        }
    }
    
    @discardableResult
    func align(_ attribute: NSLayoutConstraint.Attribute, toItem: UIView?, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func beginVerticalLayout(topMargin: CGFloat, sideMargin: CGFloat? = nil) -> UIView {
        guard let superview = superview else { return self }
        let constraint = UIView.updateOrCreateConstraintOnView(superView: superview,
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .top,
            constant: topMargin)
        NSLayoutConstraint.activate([constraint])
        if let margin = sideMargin {
          self.withHorizontalMargins(margin)
        }

        return self
    }
    
    @discardableResult func onTopOf(_ view: UIView, spacing: CGFloat, fixedHeight: CGFloat? = nil, sideMargin: CGFloat? = nil) -> UIView {
        guard let superview = superview else { return self }
        let constraint = UIView.updateOrCreateConstraintOnView(superView: superview, item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, constant: spacing)
        
        return onTopOf(with: constraint, view: view, fixedHeight: fixedHeight, sideMargin: sideMargin)
    }
    
    private func onTopOf(with spacingConstraint: NSLayoutConstraint, view: UIView, fixedHeight: CGFloat?, sideMargin: CGFloat?) -> UIView {
        var constraints = [spacingConstraint]
        
        if let fixedHeight = fixedHeight {
            let heightConstraint = UIView.updateOrCreateConstraintOnView(superView: view,
                                                                         item: view,
                                                                         attribute: .height,
                                                                         relatedBy: .equal,
                                                                         toItem: nil,
                                                                         attribute: .notAnAttribute,
                                                                         constant: fixedHeight)
            constraints.append(heightConstraint)
        }
        
        if let margin = sideMargin {
            view.withHorizontalMargins(margin)
        }
        
        NSLayoutConstraint.activate(constraints)
        return view
    }

    func finishVerticalLayout(bottomMargin: CGFloat, shouldRespectSafeArea: Bool = false) {
        guard let superview = self.superview else { return }
        if shouldRespectSafeArea {
            NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -1 * bottomMargin)
            ])
        } else {
            let constraint = UIView.updateOrCreateConstraintOnView(superView: superview,
                item: self,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self.superview,
                attribute: .bottom,
                constant: -1 * bottomMargin)
            NSLayoutConstraint.activate([constraint])
        }
    }
    
    @discardableResult func beginHorizontalLayout(leftMargin: CGFloat) -> UIView {
        let constraint = NSLayoutConstraint(item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .leading,
            multiplier: 1.0,
            constant: leftMargin)
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult func leftOf(_ view: UIView, spacing: CGFloat, fixedWidth: CGFloat? = nil) -> UIView {
        var constraints = [NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: spacing)]
        if let fixedWidth = fixedWidth {
            let widthConstraint = NSLayoutConstraint(item: view,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: fixedWidth)
            constraints.append(widthConstraint)
        }

        NSLayoutConstraint.activate(constraints)
        return view
    }
    
    @discardableResult func leftOf(_ view: UIView, spacingOfAtLeast: CGFloat, fixedWidth: CGFloat? = nil) -> UIView {
        var constraints = [NSLayoutConstraint(item: view,
                                              attribute: .leading,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: spacingOfAtLeast)]
        if let fixedWidth = fixedWidth {
            let widthConstraint = NSLayoutConstraint(item: view,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: fixedWidth)
            constraints.append(widthConstraint)
        }

        NSLayoutConstraint.activate(constraints)
        return view
    }

    func finishHorizontalLayout(rightMargin: CGFloat) {
        let constraint = NSLayoutConstraint(item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -1 * rightMargin)
        NSLayoutConstraint.activate([constraint])
    }

    static func updateOrCreateConstraintOnView(superView: UIView?,
        item view1: UIView,
        attribute attr1: NSLayoutConstraint.Attribute,
        relatedBy relation: NSLayoutConstraint.Relation,
        toItem view2: UIView?,
        attribute attr2: NSLayoutConstraint.Attribute,
        constant c: CGFloat) -> NSLayoutConstraint {

        if let matched = findConstraintOnView(superView, item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2) {
            matched.constant = c
            return matched
        }

        return NSLayoutConstraint(item: view1,
            attribute: attr1,
            relatedBy: relation,
            toItem: view2,
            attribute: attr2,
            multiplier: 1.0,
            constant: c)
    }
    
    static func findConstraintOnView(_ superView: UIView?, item view1: UIView, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, toItem view2: UIView?, attribute attr2: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {

        guard superView != nil else { return nil }
        let constraintFilter = { (c: NSLayoutConstraint) in
            return c.firstItem as? UIView == view1 &&
                c.firstAttribute == attr1 &&
                c.relation == relation &&
                c.secondItem as? UIView == view2 &&
                c.secondAttribute == attr2
        }

        return superView?.constraints.filter(constraintFilter).first
    }

    @discardableResult func withHorizontalMargins(_ margin: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let leading = NSLayoutConstraint(item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .leading,
            multiplier: 1.0,
            constant: margin)
        leading.priority = priority
        
        let trailing = NSLayoutConstraint(item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -1.0 * margin)
        trailing.priority = priority

        NSLayoutConstraint.activate([leading, trailing])
        return self
    }
}
