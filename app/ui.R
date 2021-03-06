library(shinydashboard)
library(shinyjs)
library(DT)
library(stringr)

header <- dashboardHeader(
  title = "Trabajo con imágenes",
  titleWidth = 250
)

sidebar <- dashboardSidebar(
  # Menu con las pestañas
  sidebarMenu(
    menuItem("Información de las mamografías", tabName = "info", icon = icon("table"))
  ),
  width = 250
)

body <- dashboardBody(
  useShinyjs(),
  tabItems(
    tabItem(
      tabName = "info",
      h2("Información detallada"),
      fluidRow(
        box(
          dataTableOutput("info_table"),
          width = 9,
          height = 585
        ),
        box(
          # Menú con los filtros para la tabla
          h3(strong("Filtros"), style = "text-align: center;"),
          radioButtons("bg_tissue",
                       label = "Por tipo de tejido",
                       choices = c("Todos" = "", levels(info$bg_tissue))
          ),
          radioButtons("abnorm",
                       label = "Por tipo de anormalidad",
                       choices = c("Todos" = "", levels(info$abnorm))
          ),
          radioButtons("severity",
                       label = "Por diagnóstico",
                       choices = c("Todos" = "", levels(info$severity))
          ),
          width = 3,
          height = 585
        )
      ),
      h2("Visualización de las imágenes"),
      fluidRow(
        box(
          div(
            # Selección de la imagen
            sliderInput("menu", label = "Nombre del archivo",
                        min = min(img_nums), max = max(img_nums), value = 1, step = 1,
                        pre = "Imagen "),
            style = "text-align: center;"
          ),
          imageOutput("image"),
          width = 12
        ),
      )
    )
  )
)

dashboardPage(
  header, sidebar, body,
  title = "Trabajo con imágenes",
  skin = "purple"
)
