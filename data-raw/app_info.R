# Extraer la información detallada de cada mamografía
pacman::p_load(fs, readr, dplyr, tidyr, forcats)

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
  mutate_if(is.character, as.factor) %>%
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
  ) %>%
  mutate(
    severity = fct_explicit_na(severity, na_level = "N/A")
  )

# Almacenar el resultado en un archivo RData para su uso dentro de la aplicacion
save(info, file = path("app/info.RData"))
