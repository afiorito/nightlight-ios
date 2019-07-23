public protocol PageTabsViewDataSource: class {
    func pageTabsViewNumberOfTabs(_ pageTabsView: PageTabsView) -> Int
    func pageTabsViewController(_ pageTabsView: PageTabsView, titleForTabAt index: Int) -> String?
}
