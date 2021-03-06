# Show Figure 1 ###



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# A Preparation ################################################################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### Packages ###
library(tidyverse)
library(ggbeeswarm)
library(lme4)
library(emmeans)
library(ggeffects)

### Start ###
rm(list = ls())
setwd("Z:/Documents/0_Ziegelprojekt/3_Aufnahmen_und_Ergebnisse/2020_waste_bricks_for_restoration/data/processed")

### Load data ###
environment <- read_table2("data_processed_experiment_1_environment.txt", col_names = T, na = "na", col_types = 
                       cols(
                         .default = col_double(),
                         plot = col_factor(),
                         block = col_factor(),
                         position = col_factor(),
                         brickType = col_factor(levels = c("Clean","Demolition")),
                         seedmix = col_factor(levels = c("Standard","Robust","Intermediate","Vigorous")),
                         brickRatio = col_factor(levels = c("5","30")),
                         acid = col_factor(levels = c("Control","Acid")),
                         f.watering = col_factor(levels = c("Dry", "Medium_dry", "Medium_moist","Moist"))
                       )        
)
environment$f.watering <- dplyr::recode(environment$f.watering,
                                  "Medium_dry" = "Medium dry", "Medium_moist" = "Medium moist")

#### Chosen model ###
m5 <- lmer(log(biomass) ~ (brickRatio + acid + f.watering + seedmix) +  
             brickRatio:acid + brickRatio:f.watering + brickRatio:seedmix + 
             f.watering:seedmix + acid:seedmix + 
             brickRatio:acid:seedmix + 
             (1|block), environment, REML = F)



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# B Plotten ################################################################################################################
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
themeMB <- function(){
  theme(
    panel.background = element_rect(fill = "white"),
    text  = element_text(size=10, color = "black"),
    axis.line.y = element_line(),
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.key = element_rect(fill = "white"),
    legend.position = "right",
    legend.margin = margin(0, 0, 0, 0, "cm"),
    plot.margin = margin(0, 0, 0, 0, "cm")
  )
}

### watering:seedmix ###
pdata <- ggemmeans(m5, terms = c("seedmix", "f.watering"), type = "fe")
pdata <- rename(pdata, biomass = predicted, seedmix = x, f.watering = group)
meandata <- filter(pdata, seedmix == "Standard")
pd <- position_dodge(.6)
ggplot(pdata, aes(seedmix, biomass, shape = seedmix, ymin = conf.low, ymax = conf.high))+
  geom_quasirandom(data = environment, aes(seedmix, biomass), 
                   color = "grey70", dodge.width = .6, size = 0.7)+
  geom_hline(aes(yintercept = biomass), meandata, 
             color = "grey70", size = .25) +
  geom_hline(aes(yintercept = conf.low), meandata, 
             color = "grey70", linetype = "dashed", size = .25) +
  geom_hline(aes(yintercept = conf.high), meandata, 
             color = "grey70", linetype = "dashed", size = .25) +
  geom_errorbar(position = pd, width = .0, size = .4) +
  geom_point(position = pd, size = 2.5) +
  facet_grid(~ f.watering) +
  scale_y_continuous(limits = c(0,33), breaks = seq(-100,100,5)) +
  scale_shape_manual(values = c(1,16,16,16)) +
  labs(x = "", y = expression(paste("Biomass [g]")), shape = "", color = "") +
  guides(x = guide_axis(angle = 45), shape = F)+
  themeMB()
#ggsave("figure_5_(800dpi_16x6cm).tiff",
#      dpi = 800, width = 16, height = 6, units = "cm", path = "Z:/Documents/0_Ziegelprojekt/3_Aufnahmen_und_Ergebnisse/2020_waste_bricks_for_restoration/outputs/figures")
