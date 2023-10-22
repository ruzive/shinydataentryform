header <- tagList(
  img(src = "img/dft1.ico", class = "logo"),
  div(Text(variant = "xLarge", "Morbidity and Mortality"), class = "title"),
  CommandBar(
    items = list(
      CommandBarItem("New","Add",subitems = list(
        CommandBarItem("Record","Record")
      )),
      CommandBarItem("Share data","Share"),
      CommandBarItem("Download data","Download")
    ),
    farItems = list(
      CommandBarItem("Grid view","Tiles", iconOnly = TRUE),
      CommandBarItem("Info", "Info", iconOnly = TRUE)
    ),
    style = list(width = "100%")
    )
  )

navigation <- Nav(
  groups = list(
    list(links = list(
      list(name = 'Home', url = '#!/', key = 'home', icon = 'Home'),
      list(name = 'Analysis', url = '#!/other', key = 'analysis', icon = 'AnalyticsReport')
    ))
  ),
  initialSelectedKey = 'home',
  styles = list(
    root = list(
      height = '100%',
      boxSizing = 'border-box',
      overflowY = 'auto'
    )
  )
)


footer <- Stack(
  horizontal = TRUE,
  horizontalAlign = 'space-between',
  tokens = list(childrenGap = 20),
  Text(variant = "medium", "Built with ❤️ by DFT", block = TRUE),
  Text(variant = "medium", nowrap = FALSE, "All rights reserved.")
)