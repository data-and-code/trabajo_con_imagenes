# Extraer la información detallada de cada mamografía
pacman::p_load(fs, readr, dplyr, furrr, purrr, forcats, stringr, pixmap, png)

# Leer el archivo info.txt con la información detallada de cada mamografía
info <- path("extdata/all-mias/Info.txt") %>%
  # Llevar a cabo algunas correcciones para obtener de forma correcta la información dentro del archivo
  read_delim(delim = " ",
             col_names = c("ref", "bg_tissue", "abnorm", "severity", "x", "y", "approx_radius"),
             col_types = "cccciii",
             skip = 102, n_max = 330)

# Almacenar el resultado en un CSV sin pre-procesar para poder usarlo en las otras fases del proyecto
write_csv(info, file = path("extdata/all-mias/info.csv"))

# Pre-procesar el resultado para poder usarlo dentro de la app de Shiny
info <- info %>%
  # Convertir los caracteres en factores
  mutate(across(where(is.character), as.factor)) %>%
  # Re-codificar los factores
  mutate(
    bg_tissue = fct_recode(
      bg_tissue,
      "Graso" = "F",
      "Graso-glandular" = "G",
      "Glandular-denso" = "D"
    ),
    abnorm = fct_recode(
      abnorm,
      "Calcificación" = "CALC",
      "Masas bien definidas o circunscritas" = "CIRC",
      "Masa espigada" = "SPIC",
      "Otras masas o mal definidas" = "MISC",
      "Distorsión estructural" = "ARCH",
      "Asimetría" = "ASYM",
      "Normal" = "NORM"
    ),
    severity = fct_recode(
      severity,
      "Benigno" = "B",
      "Maligno" = "M"
    )
  )

# Almacenar el resultado en un archivo RData para su uso dentro de la aplicación
save(info, file = path("app/info.RData"))

# Función para convertir las imágenes en formato PGM a formato PNG para poder visualizarlas dentro de la aplicación
pnm_to_png <- function(filename, new_filename) {
  # Leer la imagen en formato PGM
  img <- read.pnm(filename)
  # Almacenar la imagen en formato PNG manteniendo sus dimensiones originales
  png(new_filename, width = img@size[1], height = img@size[2])
  plot(img)
  dev.off()
}

# Crear un nuevo directorio para almacenar las imágenes en formato PNG dentro del directorio de la aplicación
dir_create("app/img")

# Obtener la ubicación de cada imagen en formato PGM
img_paths <- dir_ls("extdata/all-mias/", glob = "*.pgm")

# Crear una nueva ubicación para cada imagen en formato PNG
new_img_paths <- path("app/img", str_extract(img_paths, pattern = "(?<=mdb0{0,2})[1-9]{1}[:digit:]{0,2}"), ext = "png")

# Paralelizar la conversión de las imágenes para que el proceso termine más rápido
plan(multisession, workers = 4)

# Convertir las imágenes en formato PGM a formato PNG
future_map2(img_paths, new_img_paths, ~ pnm_to_png(.x, .y))
