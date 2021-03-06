library(shinydashboard)
library(shinyjs)
library(DT)
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
      mutate(across(ref, ~ paste0("Imagen ", as.numeric(str_extract(ref, "[:digit:]{3}"))))) %>%
      # Modificar los valores vacíos de las columnas para hacer evidente los NA's visualmente
      mutate(across(where(is.factor), fct_explicit_na, na_level = "<i>N/A</i>")) %>%
      mutate(across(where(is.numeric), ~ if_else(is.na(.x), "<i>N/A</i>", as.character(.x)))) %>%
      # Opciones definidas para la presentación de la tabla
      datatable(
        options = list(
          dom = "tip",
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

  # Visualizar las imágenes
  output$image <- renderImage({
    list(
      src = "../extdata/all-mias/mdb001.pgm"
    )
  }, deleteFile = FALSE)
}
