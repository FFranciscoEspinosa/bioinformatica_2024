library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")

##FIJAR DIRECTORIO DE TRABAJO
setwd("~/bioinformatica_2024")
##IMPORTAR ARCHIVO CUATROC.BIOM
merged_metagenomes <- import_biom("tax.biom")
##VER LA CLASE Y OBSERVAR MERGED_METAGENOMES
class(merged_metagenomes)
View(merged_metagenomes@tax_table@.Data)
##QUITA LOS PRIMEROS CUATRO CARACTEERES
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
##CAMBIAR NOMBRE DE COLUMNAS DE ACUERDO A NIVEL TAXONOMICO
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
##VER LOS UNICOS DE CADA COLUMNA
unique(merged_metagenomes@tax_table@.Data[,"Phylum"])
#CONTAR CUANTOS ELEMENTOS DIFERENTES DE UNA COLUMNA HAY DE ACUERDO A UNA COINCIDENCIA
sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Firmicutes")
#VER CUANTOS HAY POR MUESTRA
View(merged_metagenomes@otu_table@.Data)
## QUEDARSE SOLO CON BACTERIAS
merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
##OBTENER INDICE ALPHA con n row pone las graficas en n
##filas, title el titulo y sortby las ordena de acuerdo
##a OBSERVED CHAO1 O SHANNON

plot_richness(physeq = merged_metagenomes, title = "Alpha diversidad",
              measures = c("Observed","Chao1","Shannon"), nrow = 3) 


merged_metagenomes <- subset_taxa(merged_metagenomes, Genus != "")
percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )


meta_ord <- ordinate(physeq = percentages, method = "NMDS", 
                     distance = "bray")

plot_ordination(physeq = percentages, ordination = meta_ord)



###################EXPLORAR DATOS A DIFERENTES NIVELES TAXONOMICOS
percentages_glom <- tax_glom(percentages, taxrank = 'Phylum') #solo se queda a los que tienen nivel hasta filo y normaliza
View(percentages_glom@tax_table@.Data)
percentages_df <- psmelt(percentages_glom) #obtener el data frame de los datos

absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Phylum")#comparando con datos sin normalizar
absolute_df <- psmelt(absolute_glom)
str(absolute_df)

#Se preparan los datos para gráficar desde los datos no normalizados
absolute_df$Phylum <- as.factor(absolute_df$Phylum)
phylum_colors_abs<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_df$Phylum))) #Se crea la paleta de colores

absolute_plot <- ggplot(data= absolute_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_abs) #Se crea la grafica en la variable

#AHORA PARA LOS NORMALIZADOS
percentages_df$Phylum <- as.factor(percentages_df$Phylum)
phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_rel)
absolute_plot
relative_plot

#CREANDO GRAFICA PARA DESPRECIAR A AQUELLOS MENORES A 0.5
percentages_df$Phylum <- as.character(percentages_df$Phylum) # Return the Phylum column to be of type character
percentages_df$Phylum[percentages_df$Abundance < 0.5] <- "Phyla < 0.5% abund."
unique(percentages_df$Phylum)

percentages_df$Phylum <- as.factor(percentages_df$Phylum)
phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Phylum))+ 
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = phylum_colors_rel)
absolute_plot 

relative_plot



##EJRECICIO A DIFERNETE NIVEL DIGAMOS FAMILY
cyanos <- subset_taxa(merged_metagenomes, Phylum == "Cyanobacteria")
unique(cyanos@tax_table@.Data[,2])
cyanos_percentages <- transform_sample_counts(cyanos, function(x) x*100 / sum(x) )
cyanos_glom <- tax_glom(cyanos_percentages, taxrank = "Genus")
cyanos_df <- psmelt(cyanos_glom)
cyanos_df$Genus[cyanos_df$Abundance < 10] <- "Genera < 10.0 abund"
cyanos_df$Genus <- as.factor(cyanos_df$Genus)
genus_colors_cyanos<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(cyanos_df$Genus)))  
plot_cyanos <- ggplot(data=cyanos_df, aes(x=Sample, y=Abundance, fill=Genus))+ geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = genus_colors_cyanos)
plot_cyanos


###Explorar genero de phylum Bacteroidetes
proteo <- subset_taxa(merged_metagenomes, Phylum == "Bacteroidetes")
proteo_percentages <- transform_sample_counts(proteo, function(x) x*100 / sum(x) )
proteo_glom <- tax_glom(proteo_percentages, taxrank = "Genus")
proteo_df <- psmelt(proteo_glom)
proteo_df$Genus[proteo_df$Abundance < 3] <- "Genera < 3% abund"
proteo_df$Genus <- as.factor(proteo_df$Genus)
genus_colors_proteo<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(proteo_df$Genus)))

plot_proteo <- ggplot(data=proteo_df, aes(x=Sample, y=Abundance, fill=Genus))+
  geom_bar(aes(), stat="identity", position="stack")+
  scale_fill_manual(values = genus_colors_proteo)
plot_proteo