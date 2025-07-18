

################################################################################
#####                                                                      #####
#####                Automatisierungsprozess Mailerstellung                #####
#####                                                                      #####
################################################################################


library(emayili)
library(rmarkdown)
library(tidyverse)




## Pfade definieren ------------------------------------------------------------

Pfad_Rmd <- "C:\\Users\\Fabian Hellmold\\Desktop\\WG-Gesucht-Scraper\\Allg_Skripte\\Reporting\\Scrapingbericht_Daily_multi.Rmd"
Pfad_HTML <- tempfile(fileext = ".html")  


## Rendern der Rmd-Datei -------------------------------------------------------

render(
  input = Pfad_Rmd,
  output_file = Pfad_HTML,
  output_format = "html_document",
  quiet = TRUE
)


## Mailinhalt erstellen --------------------------------------------------------

html_inhalt <- readLines(Pfad_HTML, warn = FALSE) %>% paste(collapse = "\n")

Mail_Inhalt <- envelope(
  from = "fabian.hellmold@posteo.de",
  to = "fabian.hellmold@posteo.de",
  subject = "Daily Report Hamburg"
) %>%
  html(html_inhalt)


## Serververbindung herstellen -------------------------------------------------

# usethis::edit_r_environ()

Serververbindung <- server(
  host = "posteo.de",
  port = 465,
  username = "fabian.hellmold@posteo.de",
  password = Sys.getenv("POSTEO_PASSWORD")
)


## Mail versenden --------------------------------------------------------------

Serververbindung(Mail_Inhalt, verbose = TRUE)





################################################################################
#####                                                                      #####
#####                            Task Scheduler                            #####
#####                                                                      #####
################################################################################


## FUNKTIONIERT IN DER FORM NOCH NICHT

# library(taskscheduleR)
# 
# 
# taskscheduler_create(
#   taskname = "Scrapingbericht_Daily_Test2",
#   rscript = "Hamburg/Skripte/Scrapingbericht/Dailyreport_auto.R",
#   Rexe = "C:\\Program Files\\R\\R-4.5.0\\bin\\Rscript.exe",
#   starttime = "17:42",
#   startdate = format(Sys.Date(), "%d/%m/%Y"),
#   schedule = "DAILY"
# )
