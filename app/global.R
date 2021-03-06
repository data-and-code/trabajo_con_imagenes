library(fs)
library(tidyr)
library(dplyr)

# Importar y modificar detalles de la tabla con la información de las imágenes
load("info.RData")

info <- info %>%
  # Agregar a la tabla la ubicación de cada imagen
  mutate(img_path = path("../extdata/all-mias/", ref, ext = "pgm"))

# Obtener del nombre del archivo el número de cada imagen
img_nums <- as.integer(str_extract(info$ref, "[:digit:]{3}"))

# Contenedor HTML con los encabezados de la tabla para su visualización en la aplicación
info_col_containers <- withTags(
  table(
    class = "cell-border stripe",
    thead(
      tr(
        th(rowspan = 2, "Imagen"),
        th(rowspan = 2, "Tipo de tejido"),
        th(rowspan = 2, "Tipo de anormalidad"),
        th(rowspan = 2, "Diagnóstico"),
        th(colspan = 3, "Coordenadas de la anormalidad en la imagen")
      ),
      tr(
        th("X"),
        th("Y"),
        th("Radio aprox.")
      )
    )
  )
)
