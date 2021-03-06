#!/usr/bin/env Rscript
# This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.

library(scales)
library(ggplot2)
library(tikzDevice)
library(Rsundials)

codingspectator_svn_folder <- Sys.getenv("CODINGSPECTATOR_SVN_FOLDER")
udc_distributions_folder <- paste(codingspectator_svn_folder, "Experiment", "UDCData", "TimestampedUDCData", "AllUsers", "Distributions", sep = "/")
oopsla_2012_folder <- paste(codingspectator_svn_folder, "Papers", "2012-OOPSLA-VakilianETAL", "Paper", "Figures", sep = "/")

csv_file_name <- paste(udc_distributions_folder, "users-distinct-refactorings.csv", sep = "/")
cat("Analyzing ", csv_file_name, "\n")
table <- read.table(file = csv_file_name, header = TRUE, sep = ",")
number_of_distinct_refactorings <- table$DISTINCT_REFACTORINGS
users <- table$USERS
total_number_of_refactoring_users <- sum(table$USERS)

png_file_name <- paste(udc_distributions_folder, "distribution-of-distinct-refactorings.png", sep = "/")
png(filename = png_file_name, width = 1400, height = 1400, res = 100)
data <- data.frame(number_of_distinct_refactorings, users)
ggplot(data, stat = "identity", aes(x = number_of_distinct_refactorings, y = users)) +
geom_point() +
scale_x_continuous(name = "Number of Distinct Refactorings", breaks = number_of_distinct_refactorings) +
scale_y_log10("Number of Programmers (log-scaled)") +
geom_text(aes(vjust = -1, label = sprintf("%.4f%%", users / total_number_of_refactoring_users * 100)), size = 3) +
ggtitle("Distribution of Distinct Refactorings")
dev.off()

cumulative_percentage_users <- cumsum(table$USERS) / total_number_of_refactoring_users
data <- data.frame(number_of_distinct_refactorings, cumulative_percentage_users)
p <- ggplot(data, stat = "identity", aes(x = number_of_distinct_refactorings, y = cumulative_percentage_users)) +
geom_point() +
scale_x_continuous(name = "Maximum Number of Distinct Refactorings Used", breaks = number_of_distinct_refactorings) +
geom_path() +
scale_y_continuous(name="Proportion of Refactoring Users", labels = percent) +
geom_text(data = data.frame(number_of_distinct_refactorings[1:5], cumulative_percentage_users[1:5]), aes(x = number_of_distinct_refactorings[1:5], y = cumulative_percentage_users[1:5], hjust = -0.2, vjust = 1, label = sprintf("%.1f%%", 100 * cumulative_percentage_users[1:5])), size = 3) +
ggtitle("Cumulative Distribution of Distinct Refactorings") +
theme(plot.title = element_text(face = "bold", size = 13))

png_file_name <- paste(udc_distributions_folder, paste("cumulative-distribution-of-distinct-refactorings", "png", sep = "."), sep = "/")
png(filename = png_file_name, width = 600, height = 600, res = 100)
p 
dev.off()

tex_file_name <- paste(oopsla_2012_folder, paste("CumulativeDistributionOfDistinctRefactorings", "tex", sep = "."), sep = "/")
tikz(file = tex_file_name, width = 3.5, height = 3.5, sanitize = TRUE, bareBones = TRUE, documentDeclaration = options(tikzDocumentDeclaration = "\\documentclass[10pt]{article}"), pointsize = 10)
p 
dev.off()

csv_file_name <- paste(udc_distributions_folder, "refactoring-frequencies.csv", sep = "/")
cat("Analyzing ", csv_file_name, "\n")
table <- read.table(file = csv_file_name, header = TRUE, sep = ",", stringsAsFactors = FALSE)
refactorings <- table$REFACTORING[-1]
frequency <- table$FREQUENCY[-1]
sum_frequency <- sum(frequency)
cumulative_percentage_frequency <- cumsum(frequency) / sum_frequency * 100

png_file_name <- paste(udc_distributions_folder, "frequencies-of-refactorings.png", sep = "/")
png(filename = png_file_name, width = 1000, height = 1000, res = 100)
data <- data.frame(refactorings, frequency)
ggplot(data, stat = "identity", aes(x = reorder(x = refactorings, X = frequency, FUN = sum), y = frequency)) +
geom_point() +
coord_flip() +
scale_x_discrete("Refactoring") +
scale_y_log10("Frequency (log-scaled)") +
geom_text(aes(y = 1.5 * frequency, label = sprintf("%.2f%%", frequency / sum_frequency * 100)), size = 3) +
ggtitle("Frequencies of Refactorings")
dev.off()

png_file_name <- paste(udc_distributions_folder, "cumulative-distribution-of-the-frequencies-of-refactorings.png", sep = "/")
png(filename = png_file_name, width = 1000, height = 1000, res = 100)
data <- data.frame(refactorings, cumulative_percentage_frequency)
ggplot(data, stat = "identity", aes(x = reorder(x = refactorings, X = cumulative_percentage_frequency, FUN = sum), y = cumulative_percentage_frequency)) +
geom_point() +
coord_flip() +
scale_x_discrete("Refactoring") +
scale_y_continuous("Frequency (%)") +
geom_text(aes(label = sprintf("%.2f%%", cumulative_percentage_frequency), vjust = -1), size = 3) +
ggtitle("Cumulative Distribution of the Frequencies of Refactorings")
dev.off()

csv_file_name <- paste(udc_distributions_folder, "user-refactoring-frequencies.csv", sep = "/")
cat("Analyzing ", csv_file_name, "\n")
table <- read.table(file = csv_file_name, header = TRUE, sep = ",", stringsAsFactors = FALSE)
refactorings <- table$ALL_REFACTORINGS

png_file_name <- paste(udc_distributions_folder, "users-all-refactorings.png", sep = "/")
png(filename = png_file_name, width = 1000, height = 1000, res = 100)
data <- data.frame(refactorings)
binwidth <- 50
breaks <- seq(0 - binwidth / 2, max(refactorings) + binwidth / 2, by = binwidth)
ticks <- breaks + binwidth / 2
ggplot(data, stat = "identity", aes(x = refactorings)) +
stat_bin(aes(y = ..count..), breaks = breaks, geom = "point", position = "identity") +
scale_x_continuous("Number of Refactorings", breaks = ticks) +
scale_y_log10("Number of Users (log-scaled)") +
ggtitle(sprintf("Distribution of the Number of Users of Each Number of Refactorings\nBin Width = %d", binwidth))
dev.off()

csv_file_name <- paste(udc_distributions_folder, "users-all-refactorings.csv", sep = "/")
cat("Analyzing ", csv_file_name, "\n")
table <- read.table(file = csv_file_name, header = TRUE, sep = ",")
number_of_all_refactorings <- table$REFACTORINGS
users <- table$USERS
total_number_of_refactoring_users <- sum(table$USERS)
cumulative_proportion_of_users_in_percent <- cumsum(table$USERS) / total_number_of_refactoring_users

data <- data.frame(number_of_all_refactorings = number_of_all_refactorings[seq(from = 10, to = 200, by = 10)], cumulative_proportion_of_users_in_percent = cumulative_proportion_of_users_in_percent[seq(from = 10, to = 200, by = 10)])
p <- ggplot(data, stat = "identity", aes(x = number_of_all_refactorings, y = cumulative_proportion_of_users_in_percent)) +
geom_point() +
scale_x_continuous(name = "Maximum Number of Refactoring Invocations") +
geom_path() +
scale_y_continuous(name="Proportion of Refactoring Users", labels = percent) +
geom_text(data = data.frame(number_of_all_refactorings[seq(from = 10, to = 50, by = 10)], cumulative_proportion_of_users_in_percent[seq(from = 10, to = 50, by = 10)]), aes(x = number_of_all_refactorings[seq(from = 10, to = 50, by = 10)], y = cumulative_proportion_of_users_in_percent[seq(from = 10, to = 50, by = 10)], hjust = -0.2, vjust = 1, label = sprintf("%.1f%%", 100 * cumulative_proportion_of_users_in_percent[seq(from = 10, to = 50, by = 10)])), size = 3) +
ggtitle("Cumulative Distribution of Refactorings") +
theme(plot.title = element_text(face = "bold", size = 13))

png_file_name <- paste(udc_distributions_folder, paste("cumulative-distribution-of-all-refactorings", "png", sep = "."), sep = "/")
png(filename = png_file_name, width = 600, height = 600, res = 100)
p
dev.off()

tex_file_name <- paste(oopsla_2012_folder, paste("CumulativeDistributionOfAllRefactorings", "tex", sep = "."), sep = "/")
tikz(file = tex_file_name, width = 3.5, height = 3.5, sanitize = TRUE, bareBones = TRUE, documentDeclaration = options(tikzDocumentDeclaration = "\\documentclass[10pt]{article}"), pointsize = 10)
p
dev.off()

