/// An object that adopts the PageTabControllerDataSource protocol is responsible for providing the data required by a page tabs view.
public protocol PageTabsViewDataSource: class {
    /**
     Asks the datasource object for the number of tabs.
     
     - parameter pageTabsView: the page tabs view requesting this information.
     */
    func pageTabsViewNumberOfTabs(_ pageTabsView: PageTabsView) -> Int
    
    /**
     Asks the datasource object for the title of a tab at the specified index.
     
     - parameter pageTabsView: the page tabs view requesting this information.
     - parameter index: the index that specifies the location of the tab.
     */
    func pageTabsView(_ pageTabsView: PageTabsView, titleForTabAt index: Int) -> String?
}
