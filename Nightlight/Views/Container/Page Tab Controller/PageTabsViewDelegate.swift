/// Methods that allow you to manage the interactions with tabs.
public protocol PageTabsViewDelegate: class {
    /**
     Tells the delegate that a tab is selected.
     
     - parameter pageTabsView: a page tabs view object informing about the tab selection.
     - parameter index: the index of the selected tab.
     */
    func pageTabsView(_ pageTabsView: PageTabsView, didSelectTabAt index: Int)
}
