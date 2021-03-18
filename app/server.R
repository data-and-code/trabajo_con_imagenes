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

  # Filtrar la información de la imagen seleccionada por el usuario
  selected_img <- reactive({
    slice(info_per_image, input$img_num)
  })

  # Visualizar la imagen seleccionada por el usuario
  output$image <- renderImage({
    list(
      src = path("img/", input$img_num, ext = "png"),
      width = "80%",
      alt = paste0("Imagen ", input$img_num),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  # Visualizar la información de la imagen seleccionada por el usuario
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

  # Filtrar la información de la imagen seleccionada por el usuario (Pestaña 2)
  selected_clean_img <- reactive({
    slice(info_per_image, input$clean_img_num)
  })

  # Visualizar las imágenes limpias seleccionadas por el usuario
  output$orig_img <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num, "_scale"), ext = "png"),
      width = "50%",
      alt = paste0("Imagen ", input$clean_img_num),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  output$clean_img <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num, "_clean"), ext = "png"),
      width = "50%",
      alt = paste0("Imagen ", input$clean_img_num),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  output$clean_img_bin <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num, "_bin_clean"), ext = "png"),
      width = "25%",
      alt = paste0("Imagen ", input$clean_img_num),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  # Visualizar la información de la imagen seleccionada por el usuario
  output$clean_img_title <- renderText({
    paste0(selected_clean_img()$ref, ".pgm")
  })

  output$clean_img_bg_tissue <- renderText({
    selected_clean_img()$bg_tissue
  })

  output$clean_img_abnorm <- renderText({
    selected_clean_img()$abnorm
  })

  output$clean_img_abnorm_details <- renderDataTable({
    # Sólo se despliega la información de las anormalidades si la imagen contiene alguna
    if (selected_clean_img()$abnorm != "Normal") {
      # Opciones definidas para la presentación de la tabla
      datatable(
        selected_clean_img()$details[[1]],
        options = list(dom = "t"),
        rownames = FALSE,
        container = abnorm_details_containers,
        selection = "none"
      )
    } else {
      NULL
    }
  })

  # Filtrar la información de la imagen seleccionada por el usuario (Pestaña 3)
  selected_clean_img_2 <- reactive({
    slice(info_per_image, input$clean_img_num_2)
  })

  # Visualizar las imágenes limpias seleccionadas por el usuario
  output$orig_img_2 <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num_2, "_scale"), ext = "png"),
      width = "50%",
      alt = paste0("Imagen ", input$clean_img_num_2),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  output$clean_img_2 <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num_2, "_clean_2"), ext = "png"),
      width = "50%",
      alt = paste0("Imagen ", input$clean_img_num_2),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  output$clean_img_bin_2 <- renderImage({
    list(
      src = path("img/", paste0(input$clean_img_num_2, "_bin_clean_2"), ext = "png"),
      width = "25%",
      alt = paste0("Imagen ", input$clean_img_num_2),
      style = "display: block; margin-left: auto; margin-right: auto"
    )
  }, deleteFile = FALSE)

  # Visualizar la información de la imagen seleccionada por el usuario
  output$clean_img_title_2 <- renderText({
    paste0(selected_clean_img_2()$ref, ".pgm")
  })

  output$clean_img_bg_tissue <- renderText({
    selected_clean_img_2()$bg_tissue
  })

  output$clean_img_abnorm_2 <- renderText({
    selected_clean_img_2()$abnorm
  })

  output$clean_img_abnorm_details_2 <- renderDataTable({
    # Sólo se despliega la información de las anormalidades si la imagen contiene alguna
    if (selected_clean_img_2()$abnorm != "Normal") {
      # Opciones definidas para la presentación de la tabla
      datatable(
        selected_clean_img_2()$details[[1]],
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
