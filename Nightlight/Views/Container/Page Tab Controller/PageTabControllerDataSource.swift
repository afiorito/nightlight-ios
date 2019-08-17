/// An object that adopts the PageTabControllerDataSource protocol is responsible for providing the data required by a page tab controller.
public protocol PageTabControllerDataSource: class {
    /**
     Asks the datasource object for the number of tabs.
     
     - parameter pageTabController: the page tab controller requesting this information.
     */
    func pageTabControllerNumberOfTabs(_ pageTabController: PageTabController) -> Int
    
    /**
     Asks the datasource object for the title of a tab at the specified index.
     
     - parameter pageTabController: the page tab controller requesting this information.
     - parameter index: the index that specifies the location of the tab.
     */
    func pageTabController(_ pageTabController: PageTabController, titleForTabAt index: Int) -> String?
}
