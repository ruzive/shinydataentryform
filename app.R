#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shiny.fluent)
library(tibble)
library(dplyr)
library(glue)
library(plotly)
library(sass)
library(shiny.router)

#library(icd)
header <- "header"
navigation <- "navigation"
footer <- "footer"

layout <- function(mainUI){
  div(class = "grid-container",
      div(class = "header",header),
      div(class = "sidenav",navigation),
      div(class = "main",mainUI),
      div(class = "footer",footer)
  )
}

makePage <- function(title, subtitle, contents){
  tagList(div(
    class = "page-title",
    span(title, class = "ms-fontSize-32 ms-fontWeight-semibold", style = "color: #323130"),
    span(subtitle, class = "ms-fontSize-14 ms-fontWeight-regular", style = "color: #605E5C; margin: 14px;")
  ),
  contents
  )
}

causes_options <- list(
  list(key = "Car", text = "Car"),
  list(key = "Chainsaw", text = "Chainsaw"),
  list(key = "Broken heart", text = "Broken heart")
)

gender_options <- list(
  list(key = "Male", text = "Male"),
  list(key = "Female", text = "Female")
)

marital_options <- list(
  list(key = "Married", text = "Married"),
  list(key = "Single", text = "Single"),
  list(key = "Widow", text = "Widow"),
  list(key = "Divorced", text= "Divorced")
)


basicInfo <- Stack(
  tokens = list(childrenGap = 10),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 5),
      TextField.shinyInput("Name",
                           label = "Name of the deceased"),
      TextField.shinyInput("nrc",
                           label = "NRC of the deceased")
    ),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 5),
    TextField.shinyInput("occupation",
                         label = "Occupation of the deceased")
  ),
  Slider.shinyInput(
    "ageSlider",
    value = 0, min = 0, max = 100, step = 1,
    label = "Age",
    valueFormat = JS("function(x) { return  x + ' years'}"),
    snapToStep = TRUE
  ),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 10),
    DatePicker.shinyInput("dob",value = as.Date('2020/01/01'),label = "Date of Birth"),
    DatePicker.shinyInput("dod",value = as.Date('2020/12/31'),label = "Date of Death"),
  ),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 10),
    ChoiceGroup.shinyInput("MaritalStatus",value = "Married",options = marital_options, label = "Marital Status"),
    ChoiceGroup.shinyInput("gender",
                           value = "Male",options = gender_options,
                           label = "Gender")
  ),
  Separator(),
  Text(
    variant = "large",
    div(
      class = "ms-fontWeight-bold",
    "Next of Kin details"),
    block = TRUE
  ),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 10),
      TextField.shinyInput("nextofkin",
                           label = "Next of Kin details Name"),
      TextField.shinyInput("nextofkinNRC",
                           label = "Next of Kin details NRC")),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 10),
      TextField.shinyInput("nextofkinPhone",
                           label = "Next of Kin details Phone"),
      TextField.shinyInput("nextofkinAddress",
                           label = "Next of Kin details Address")
  ),
  Separator(),
  Text(
    variant = "large",
    div(
      class = "ms-fontWeight-bold",
    "Locator details"),
    block = TRUE
  ),
  Stack(
  horizontal = TRUE,
  tokens = list(childrenGap = 10),
  TextField.shinyInput("gps",
                       label = "Location"),
  TextField.shinyInput("placeofdeath",
                       label = "Place of Death")
  )
)
# icd::icd10cm2019$short_desc
medicalInfo <- Stack(
  tokens = list(childrenGap = 10),
  Stack(
    horizontal = FALSE,
    tokens = list(childrenGap = 5),
    TextField.shinyInput("Circumstances",
                         label = "Circumstances Surrounding Death"),
    TextField.shinyInput("diagnosis",
                         label = "Diagnosis of the patient"),
    Text(
      variant = "medium",
      "Select Cause of death",
      block = TRUE
    ),
    ComboBox.shinyInput(
      "cause",
      value = list(text = "add the cause or select"),
      options = causes_options,
      allowFreeform = TRUE
    ),
    textOutput("causeValue")
  ),
  Text(
    variant = "medium",
    "Select Cause of death ICD code",
    block = TRUE
  ),
  ComboBox.shinyInput(
    "causeICDCode",
    value = list(text = "select ICD Code"),
    options = causes_options,
    allowFreeform = FALSE
  ),
  textOutput("causeICDCodeValue"),
  Slider.shinyInput(
    "durationSlider",
    value = 0, min = 0, max = 24, step = 1,
    label = "Duration of Admission",
    valueFormat = JS("function(x) { return  x + ' months'}"),
    snapToStep = TRUE
  ),
  Separator(),
  Text(
    variant = "large",
    div(
      class = "ms-fontWeight-bold",
    "Medical personnel Remarks (Verbal autopsy)"),
    block = TRUE
  ),
  Stack(
    horizontal = FALSE,
    tokens = list(childrenGap = 5),
    TextField.shinyInput("grief",
                         label = "Notes on grief Counselling for the family",
                         multiline = TRUE),
    TextField.shinyInput("medicalHistory",
                         label = "Medical History",
                         multiline = TRUE),
    TextField.shinyInput("medicalremarks",
                         label = "Medical Practitioner remarks",
                         multiline = TRUE),
    TextField.shinyInput("referral",
                         label = "Referral information (from Facility)",
                         multiline = TRUE),
    TextField.shinyInput("social",
                         label = "Social autopsy",
                         multiline = TRUE)
  ),
  
)

ActionBtn <- Stack(
  horizontal = TRUE,
  tokens = list(childrenGap = 10),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 5),
    PrimaryButton.shinyInput(
      "btnSave",
      text = "Submit"
    )
  )
)



makeCard <- function(title, content, size = 12, style = ""){
  div(
    class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
    style = style,
    Stack(
      tokens = list(childrenGap = 5),
      Text(variant = "large", 
           div(
             class = "ms-fontWeight-bold",
           title)
           , block = TRUE),
      content
    )
  )
}

data_entry_page <- makePage(
  "Data Entry for Morbidity and Mortality Statistics",
  "facility entry form",
  div(
    Stack(
      tokens = list(childrenGap = 10), horizontal = TRUE,
      makeCard("Particulars of the deceased",basicInfo, size = 4),
      makeCard("Medical details", medicalInfo, size = 8 ),
    ),
    makeCard("",ActionBtn,size = 12),
    reactOutput("modal")
  )
)

# Define UI for application that draws a histogram
ui <- fluentPage(
  layout(data_entry_page),
  tags$head(
    tags$link(href = "style.css",
              rel = "stylesheet",
              type = "text/css")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  modalVisible <- reactiveVal(FALSE)
  observeEvent(input$btnSave, modalVisible(TRUE))
  observeEvent(input$hideModal, modalVisible(FALSE))
  output$modal <- renderReact({
    Modal(isOpen = modalVisible(),
          Stack(tokens = list(padding = "15px", childrenGap = "10px"),
            div(style = list(display = "flex"),
                Text("SRS collected Data", variant = "large"),
                div(style = list(flexGrow = 1)),
                IconButton.shinyInput("hideModal",iconProps = list(iconName = "Cancel")
                                      ),
                ),
            div(
              Text(
                variant = "large",
                div(
                  class = "ms-fontWeight-bold",
                  "Particulars of the deceased"),
                block = TRUE
              ),
              Stack(
                horizontal = TRUE,
                tokens = list(childrenGap = 10),
                p(textOutput("nameValue")),
                p(textOutput("nrcValue")),
                p(textOutput("occupationValue")),
              ),
              Stack(
                horizontal = TRUE,
                tokens = list(childrenGap = 10),
                p(textOutput("dobValue")),
                p(textOutput("ageSliderValue")),
                p(textOutput("dodValue"))
              ),
              Stack(
                horizontal = TRUE,
                tokens = list(childrenGap = 10),
                p(textOutput("MaritalStatusValue")),
                p(textOutput("genderValue")),
                p(textOutput("nextofkinValue"))
              ),
              # Stack(
              #   horizontal = TRUE,
              #   tokens = list(childrenGap = 10),
              #   p(textOutput("nextofkinNRCValue")),
              #   p(textOutput("nextofkinPhoneValue")),
              #   p(textOutput("nextofkinAddressValue"))
              # ),
              # Stack(
              #   horizontal = TRUE,
              #   tokens = list(childrenGap = 10),
              #   p(textOutput("gpsValue")),
              #   p(textOutput("placeofdeathValue")),
              #   p(textOutput("CircumstancesValue"))
              # ),
              # Stack(
              #   horizontal = TRUE,
              #   tokens = list(childrenGap = 10),
              #   p(textOutput("diagnosisValue")),
              #   p(textOutput("causeICDCodeValue")),
              #   p(textOutput("causeValue"))
              # ),
              # Stack(
              #   horizontal = TRUE,
              #   tokens = list(childrenGap = 10),
              #   p(textOutput("durationSliderValue")),
              #   p(textOutput("griefValue")),
              #   p(textOutput("medicalHistoryValue"))
              # ),
              # Stack(
              #   horizontal = TRUE,
              #   tokens = list(childrenGap = 10),
              #   p(textOutput("medicalremarksValue")),
              #   p(textOutput("referralValue")),
              #   p(textOutput("socialValue"))
              # )
            )
          )
    )
  })
  output$nameValue <- renderText({
    sprintf("The deceased's name is: %s",input$Name)
  })
  output$nrcValue <- renderText({
    sprintf("The deceased's nrc is: %s",input$nrc)
  })
  output$occupationValue <- renderText({
    sprintf("The deceased's occupation is: %s",input$occupation)
  })
  output$ageSliderValue <- renderText({
    sprintf("The deceased's name is: %s",input$ageSlider)
  })
  output$dobValue <- renderText({
    sprintf("The deceased's name is: %s",input$dob)
  })
  output$dodValue <- renderText({
    sprintf("The deceased's name is: %s",input$dod)
  })
  output$MaritalStatusValue <- renderText({
    sprintf("The deceased's name is: %s",input$MaritalStatus)
  })
  output$genderValue <- renderText({
    sprintf("The deceased's name is: %s",input$gender)
  })
  output$nextofkinValue <- renderText({
    sprintf("The deceased's name is: %s",input$nextofkin)
  })
  # output$nextofkinNRCValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$nextofkinNRC)
  # })
  # output$nextofkinAddressValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$nextofkinAddress)
  # })
  # output$gpsValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$gps)
  # })
  # output$placeofdeathValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$placeofdeath)
  # })
  # output$CircumstancesValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$Circumstances)
  # })
  # output$diagnosisValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$diagnosis)
  # })
  # output$causeICDCodeValue <- renderText({
  #   sprintf("The deceased's name is: %s",input$causeICDCode)
  # })
  # output$causeValue <- renderText({
  #   sprintf("The cause is: %s",input$cause)
  # })
  # output$durationSliderValue <- renderText({
  #   sprintf("duration is: %s",input$durationSlider)
  # })
  # output$griefValue <- renderText({
  #   sprintf("grief is: %s",input$grief)
  # })
  # output$medicalHistoryValue <- renderText({
  #   sprintf("medical History is: %s",input$medicalHistory)
  # })
  # output$medicalremarksValue <- renderText({
  #   sprintf("medical remarks is: %s",input$medicalremarks)
  # })
  # output$referralValue <- renderText({
  #   sprintf("referral is: %s",input$referral)
  # })
  # output$socialValue <- renderText({
  #   sprintf("social is: %s",input$social)
  # })
}

# Run the application 
shinyApp(ui = ui, server = server)
