library(htmltools)
library(tidyr)
library(dplyr)
library(stringr)

# Importar y modificar detalles de la tabla con la información de las imágenes
load("info.RData")

# Obtener del nombre del archivo el número de cada imagen
img_nums <- as.integer(str_extract(info$ref, "[:digit:]{3}"))

# Crear una nueva tabla agrupando la información por imagen
info_per_image <- info %>%
  # Convertir los factores a caracteres
  mutate(across(where(is.factor), as.character)) %>%
  # Crear una columna de tipo lista agrupando la información de las anormalidades
  nest(details = -c(ref, bg_tissue, abnorm))

# Contenedor HTML con los encabezados de la tabla principal para su visualización en la aplicación
info_col_containers <- withTags(
  table(
    class = "cell-border stripe",
    thead(
      tr(
        th(rowspan = 2, "Archivo"),
        th(rowspan = 2, "Tipo de tejido"),
        th(rowspan = 2, "Tipo de anormalidad"),
        th(rowspan = 2, "Diagnóstico"),
        th(colspan = 3, "Coordenadas de las anormalidades en la mamografía")
      ),
      tr(
        th("X"),
        th("Y"),
        th("Radio aprox.")
      )
    )
  )
)

# Contenedor HTML con los encabezados de la tabla con los detalles de las anormalidades
# en cada imagen para su visualización en la aplicación
abnorm_details_containers <- withTags(
  table(
    class = "cell-border stripe",
    thead(
      tr(
        th(colspan = 4, "Detalles de las anormalidades:")
      ),
      tr(
        th(rowspan = 2, "Diagnóstico"),
        th(colspan = 3, "Coordenadas de las anormalidades en la mamografía")
      ),
      tr(
        th("X"),
        th("Y"),
        th("Radio aprox.")
      )
    )
  )
)
