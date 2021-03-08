library(shinydashboard)
library(shinyjs)
library(DT)
library(fs)
library(dplyr)
library(forcats)

function(input, output, session) {
  # Activar/Desactivar el menú con la selección del diagnóstico
  observe({
    toggleState("severity", input$abnorm != "Normal")
  })

  # Filtrar la tabla de acuerdo con lo que seleccione el usuario
  info_filtered <- reactive({
    info_current <- info

    if (input$bg_tissue != "") {
      info_current <- filter(info_current, bg_tissue == input$bg_tissue)
    }

    if (input$abnorm != "") {
      info_current <- filter(info_current, abnorm == input$abnorm)
    }

    if (input$severity != "" & input$abnorm != "Normal") {
      info_current <- filter(info_current, severity == input$severity)
    }

    info_current
  })

  # Mostrar la tabla con la información detallada de cada imagen
  output$info_table <- renderDataTable(
    # Aplicar modificaciones a la tabla para su presentación
    info_filtered() %>%
      # Seleccionar las columnas adecuadas de la tabla
      select(ref:approx_radius) %>%
      # Obtener del nombre del archivo el número de cada imagen, y modificar su presentación
      mutate(across(ref, ~ paste0("Imagen: ", ref, ".pgm"))) %>%
      # Modificar los valores vacíos de las columnas para hacer evidente los NA's visualmente
      mutate(across(where(is.factor), fct_explicit_na, na_level = "<i>N/A</i>")) %>%
      mutate(across(where(is.numeric), ~ if_else(is.na(.x), "<i>N/A</i>", as.character(.x)))) %>%
      # Opciones definidas para la presentación de la tabla
      datatable(
        options = list(
          dom = "ftip",
          rowGroup = list(dataSrc = 0),
          columnDefs = list(list(targets = 0, visible = FALSE)),
          pageLength = 6,
          scrollX = TRUE
        ),
        rownames = FALSE,
        container = info_col_containers,
        escape = FALSE,
        selection = "none",
        extensions = "RowGroup"
      )
  )

  # Visualizar la imagen seleccionada por el usuario
  output$image <- renderImage({
    list(
      src = path("img/", input$img_num, ext = "png"),
      width = "80%",
      alt = paste0("Imagen ", input$img_num),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  # Filtrar la información de la imagen seleccionada por el usuario
  selected_img <- reactive({
    slice(info_per_image, input$img_num)
  })

  # Visualizar la información de la imagen seleccionada por el usuario
  # Visualizar el título de la imagen seleccionada por el usuario
  output$img_title <- renderText({
    paste0(selected_img()$ref, ".pgm")
  })

  output$img_bg_tissue <- renderText({
    selected_img()$bg_tissue
  })

  output$img_abnorm <- renderText({
    selected_img()$abnorm
  })

  output$img_abnorm_details <- renderDataTable({
    # Sólo se despliega la información de las anormalidades si la imagen contiene alguna
    if (selected_img()$abnorm != "Normal") {
      # Opciones definidas para la presentación de la tabla
      datatable(
        selected_img()$details[[1]],
        options = list(dom = "t"),
        rownames = FALSE,
        container = abnorm_details_containers,
        selection = "none"
      )
    } else {
      NULL
    }
  })
}
