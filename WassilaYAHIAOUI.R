#USA (New castle et albany) dataset utilisant le webscrapin et une API qui recupére des informations pour chaque ville de l`USA  ###

install.packages(c("polite","tidyverse","xml2","rvest","jsonlite"))
library(polite)
library(tidyverse)
library(rvest)
library(jsonlite)


# 1. web scrapping pour recuperer les codes postales et les informations des deux villes New castle et albany.

#New castle
url_newcastle <- "https://www.zip-codes.com/county/de-new-castle.asp"
#Albany
url_albany <- "https://www.zip-codes.com/county/ny-albany.asp"

# Make our intentions known to the website
webpage1 <- read_html(url_newcastle)
session1 <- bow(url_newcastle, user_agent="Wassila",force=TRUE)
url_newcastle <- nod(session1, url_newcastle) %>% scrape(verbose = TRUE)


webpage2 <- read_html(url_albany )
session2 <- bow(url_albany , user_agent="Wassila",force=TRUE)
url_albany <- nod(session2, url_albany ) %>% scrape(verbose = TRUE)

#les information récupérées du 1 er URL (New castle)
zip_code_newcastle <- url_newcastle %>% read_html() %>% 
  html_nodes('.dtl+ .statTable .label') %>% html_text()
zip_code_newcastle <-zip_code_newcastle [-1]
zip_code_newcastle <- substr(zip_code_newcastle,10,nchar(zip_code_newcastle))

classification_newcastle<- read_html(url_newcastle) %>%
  html_nodes('.label+ .info , .label+ .info strong')%>% html_text()
classification_newcastle <-classification_newcastle [-1][-1]



city_newcastle<- read_html(url_newcastle) %>% html_nodes('.info:nth-child(3)') %>% html_text()
city_newcastle <-city_newcastle [-1]

population_newcastle<- url_newcastle %>% read_html() %>% html_nodes('.label+ .info strong , .info:nth-child(4)') %>% html_text()
population_newcastle<-population_newcastle [-1][-1]

area_code_newcastle<-url_newcastle %>% read_html() %>% html_nodes('.info:nth-child(6) , .info:nth-child(6) strong') %>% html_text()
area_code_newcastle<-area_code_newcastle [-1][-1]

county_newcastle="NEW CASTLE County, DE "

################################albany#######################
#les information récupérées du 2em URL (Albany)

zip_code_albany <- url_albany %>% read_html() %>% html_nodes('.label :nth-child(1)') %>% html_text()
zip_code_albany <-zip_code_albany [-1]
zip_code_albany <- substr(zip_code_albany,10,nchar(zip_code_albany))

classification_albany<- read_html(url_albany) %>% html_nodes('.label+ .info , .label+ .info strong') %>% html_text()
classification_albany <-classification_albany [-1][-1]



city_albany<- read_html(url_albany) %>% html_nodes('.info:nth-child(3)') %>% html_text()
city_albany <-city_albany [-1]

population_albany<- url_albany %>% read_html() %>% html_nodes('.label+ .info strong , .info:nth-child(4)') %>% html_text()
population_albany<-population_albany [-1][-1]


area_code_albany<-url_albany%>% read_html() %>% html_nodes('.info:nth-child(6) , .info:nth-child(6) strong') %>% html_text()
area_code_albany<-area_code_albany [-1][-1]
county_albany="ALBANY County, NY  "



#deux Sous data Frames de web scraping
NewCastleData <- data.frame("zip_code"=zip_code_newcastle,"classification"=classification_newcastle,
                            "city"=city_newcastle,"population"=population_newcastle,"area_code"=area_code_newcastle,"County"=county_newcastle)

AlbanyData <- data.frame("zip_code"=zip_code_albany,"classification"=classification_albany, 
                         "city"=city_albany,"population"=population_albany,"area_code"=area_code_albany,"County"=county_albany)

#dataFrame (concaténation des deux)
ScrapingData <- rbind(AlbanyData,NewCastleData)




