library(shinydashboard)
library(shinyjs)
library(DT)

header <- dashboardHeader(
  title = "Trabajo con imágenes",
  titleWidth = 250
)

sidebar <- dashboardSidebar(
  # Menú con las pestañas
  sidebarMenu(
    menuItem("Información de las mamografías", tabName = "info", icon = icon("table")),
    menuItem("Limpieza del fondo", tabName = "clean_imgs", icon = icon("image")),
    menuItem("Limpieza del músculo pectoral", tabName = "clean_imgs_2", icon = icon("image"))
  ),
  width = 250
)

body <- dashboardBody(
  useShinyjs(),
  tabItems(
    # Primera pestaña: Información detallada de las imágenes
    tabItem(
      tabName = "info",
      # Tabla principal con la información detallada
      h2("Información de todas las mamografías"),
      fluidRow(
        box(
          dataTableOutput("info_table", height = 620),
          width = 9
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
          width = 3
        )
      ),
      # Visualización de cada imagen de forma individual
      h2("Información por mamografía"),
      fluidRow(
        box(
          div(
            # Selección de la imagen
            sliderInput("img_num", label = "Número de imagen",
                        min = min(img_nums), max = max(img_nums), value = 1, step = 1,
                        animate = animationOptions(interval = 2000), pre = "Imagen "),
            style = "text-align: center;"
          ),
          # Grid con la información de cada imagen y la visualización de la propia imagen
          div(
            div(
              # Información de cada imagen
              div(h4(strong("Detalles:")), style = "text-align: center;"),
              hr(),
              h5(strong("Imagen: ")),
              p(textOutput("img_title", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de tejido: ")),
              p(textOutput("img_bg_tissue", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de anormalidad: ")),
              p(textOutput("img_abnorm", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              dataTableOutput("img_abnorm_details")
            ),
            # Visualización de la imagen
            imageOutput("image", height = "100%"),
            style = "display: grid; grid-template-columns: 1fr 1fr; grid-gap: 20px;"
          ),
          width = 12
        ),
      )
    ),
    # Segunda pestaña: Limpieza del fondo de las imágenes
    tabItem(
      tabName = "clean_imgs",
      h2("Resultado de la limpieza replicando el artículo"),
      fluidRow(
        box(
          div(
            # Selección de la imagen
            sliderInput("clean_img_num", label = "Número de imagen",
                        min = min(img_nums), max = max(img_nums), value = 1, step = 1,
                        animate = animationOptions(interval = 2000), pre = "Imagen "),
            style = "text-align: center;"
          ),
          # Grid con la información de cada imagen y la visualización de las imágenes limpias
          div(
            div(
              # Información de cada imagen
              div(h4(strong("Detalles:")), style = "text-align: center;"),
              hr(),
              h5(strong("Imagen: ")),
              p(textOutput("clean_img_title", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de tejido: ")),
              p(textOutput("clean_img_bg_tissue", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de anormalidad: ")),
              p(textOutput("clean_img_abnorm", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              dataTableOutput("clean_img_abnorm_details"),
              style = "grid-row: 1 / span 2"
            ),
            # Visualización de las imágenes
            div(
              div(h4(strong("Imagen original:")), style = "text-align: center;"),
              imageOutput("orig_img", height = "100%")
            ),
            div(
              div(h4(strong("Imagen limpia:")), style = "text-align: center;"),
              imageOutput("clean_img", height = "100%"),
            ),
            div(
              div(h4(strong("Imagen binarizada resultante:")), style = "text-align: center;"),
              imageOutput("clean_img_bin", height = "100%"),
              style = "grid-column: 2 / span 2"
            ),
            style = "display: grid; grid-template: 1fr 1fr / 1fr 1fr 1fr ; grid-gap: 20px;"
          ),
          width = 12
        ),
      )
    ),
    # Tercera pestaña: Limpieza del músculo pectoral
    tabItem(
      tabName = "clean_imgs_2",
      h2("Resultado de la limpieza replicando el artículo"),
      fluidRow(
        box(
          div(
            # Selección de la imagen
            sliderInput("clean_img_num_2", label = "Número de imagen",
                        min = min(img_nums), max = max(img_nums), value = 1, step = 1,
                        animate = animationOptions(interval = 2000), pre = "Imagen "),
            style = "text-align: center;"
          ),
          # Grid con la información de cada imagen y la visualización de las imágenes limpias
          div(
            div(
              # Información de cada imagen
              div(h4(strong("Detalles:")), style = "text-align: center;"),
              hr(),
              h5(strong("Imagen: ")),
              p(textOutput("clean_img_title_2", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de tejido: ")),
              p(textOutput("clean_img_bg_tissue_2", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              h5(strong("Tipo de anormalidad: ")),
              p(textOutput("clean_img_abnorm_2", inline = TRUE), style = "font-size: 16px; text-align: center;"),
              dataTableOutput("clean_img_abnorm_details_2"),
              style = "grid-row: 1 / span 2"
            ),
            # Visualización de las imágenes
            div(
              div(h4(strong("Imagen original:")), style = "text-align: center;"),
              imageOutput("orig_img_2", height = "100%")
            ),
            div(
              div(h4(strong("Imagen limpia:")), style = "text-align: center;"),
              imageOutput("clean_img_2", height = "100%"),
            ),
            div(
              div(h4(strong("Imagen binarizada resultante:")), style = "text-align: center;"),
              imageOutput("clean_img_bin_2", height = "100%"),
              style = "grid-column: 2 / span 2"
            ),
            style = "display: grid; grid-template: 1fr 1fr / 1fr 1fr 1fr ; grid-gap: 20px;"
          ),
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
