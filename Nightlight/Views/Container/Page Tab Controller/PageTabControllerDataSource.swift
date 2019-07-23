public protocol PageTabControllerDataSource: class {
    func pageTabControllerNumberOfTabs(_ pageTabController: PageTabController) -> Int
    func pageTabController(_ pageTabController: PageTabController, titleForTabAt index: Int) -> String?
}
