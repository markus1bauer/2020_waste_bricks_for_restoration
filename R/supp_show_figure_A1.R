# Show figure A1 grain size distribution ###



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ################################################################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### Packages ###
library(tidyverse)

### Start ###
rm(list = ls())
setwd("Z:/Documents/0_Ziegelprojekt/3_Aufnahmen_und_Ergebnisse/2020_waste_bricks_for_restoration/data/processed")

### Load data ###
edata <- read_table2("supp_data_processed_experiment_1.txt", col_names = T, na = "na", col_types = 
                       cols(
                         .default = col_double(),
                         substrate = col_factor(),
                         substrateAbb = col_factor()
                       )        
)



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Plotten ################################################################################################################
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
themeMB <- function(){
  theme(
    panel.background = element_rect(fill = "white"),
    panel.grid = element_line(color = "grey80"),
    text  = element_text(size=10, color = "black"),
    axis.line.y = element_line(),
    axis.line.x = element_line(),
    axis.text.x = element_text(angle = 270),
    axis.ticks.x = element_line(),
    legend.key = element_rect(fill = "white"),
    legend.position = "right",
    legend.margin = margin(0, 0, 0, 0, "cm"),
    plot.margin = margin(0, 0, 0, 0, "cm")
  )
}


ggplot(edata, aes(x = grainSize, y = grainSizeCum, color = substrateAbb)) +
  geom_line(size = 0.8) +
  scale_color_manual(values = c("red4","green4","red","green")) +
  scale_x_log10(breaks = c(0.002,0.063,0.2,0.63,2,4,8,16,25,31.5)) +
  labs(x = "Grain size [mm]", y = "Cumulative ratio [wt%]", color = "") +
  themeMB()
ggsave("figure_A1_(800dpi_16x10cm).tiff",
      dpi = 800, width = 16, height = 10, units = "cm", path = "Z:/Documents/0_Ziegelprojekt/3_Aufnahmen_und_Ergebnisse/2020_waste_bricks_for_restoration/outputs/figures/supp")
