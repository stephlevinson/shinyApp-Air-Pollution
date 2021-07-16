
# SERVER------------------------------------------
shinyServer(function(input, output){

# (1) TREE CHART TAB ----------------------------

    treegroup=reactive({
                pollution %>% filter(Year==input$year1,Type=="country") %>% 
                        group_by(Country,Year,Parent) %>% 
                        summarise(total=sum(get(paste0(input$metric, input$pollutant1)))) %>% 
                        select(Country,Parent,total) %>% 
                        arrange(desc(total)) %>% 
                        head(20)

    })
    output$tree = renderGvis({
                gvisTreeMap(data = treegroup(), 
                        idvar = "Country" , 
                        parentvar = "Parent", 
                        sizevar = "total",
                        colorvar = "total",
                        options = list(headerColor="FFFFFF",
                                    headerColor="FFFFFF",
                                    maxColor="08a142",
                                    minColor="#ffffff",
                                    showScale=TRUE)
            )
    })

    
# (2) MAP TAB ------------------------------------
    
    gCountry = reactive({
                pollution %>% 
                filter(Type=="country", Year==input$year2,Region!="ALL")
    })
    
    output$eMap = renderGvis({
                gvisGeoChart(gCountry(), "Country", 
                            paste0("Exposure",input$mPollutant), 
                            options=list(region="world", 
                            displayMode="regions",
                            resolution="countries",
                            width="auto", height="450px"))
    })   

    output$dMap = renderGvis({        
                gvisGeoChart(gCountry(), "Country", 
                            paste0("Death",input$mPollutant), 
                            options=list(region="world", 
                            displayMode="regions",
                            resolution="countries",
                            width="auto", height="450px"))
    })      
    
# (3) TREND TAB --------------------------------------
    

    
    ## Region Exposure    
        
    ylabel = reactive({
            if (input$pollutant2=="PM") {
                "Particulate Matter 2.5 ug/m3"
            } else if (input$pollutant2=="HAP"){
                "Household Air Pollution from solid fuels"
            } else if (input$pollutant2=="Oz") {
                "Ambient Ozone Pollution ('ppb')"
            } else {
                "All Pollutants"
            }
    })
    output$eRegion = renderPlot({
                    pollution %>% 
                    filter(Type=="aggregated",Region!="ALL") %>% 
                    group_by(Region, Year) %>%
                    summarise(total=sum(get(paste0("Exposure.", input$pollutant2)))) %>% 
                    ggplot(aes(x=Year, y=total))+
                    geom_line(aes(color=Region))+
                    theme_minimal()+
                    ylab(paste0("Exposure to ", ylabel()))+
                    theme(legend.position ="bottom", legend.title=element_blank())
    })
    
    output$eRegion2 = renderPlot({
                    pollution %>% 
                    filter(Type =="aggregated",
                           Year==1990|Year==1995|Year==2000|Year==2005|Year==2010|Year==2015) %>%
                    group_by(Region, Year) %>%
                    summarise(total=sum(get(paste0("Exposure.",input$pollutant2)))) %>% 
                    ggplot(aes(x=Year,y=total))+
                    geom_col(aes(fill=Region))+
                    theme_minimal()+
                    ylab(paste0("Exposure to ", ylabel()))+
                    theme(legend.position="bottom", legend.title=element_blank())
    })    
    
    ## Region Death Rate
    output$dRegion=renderPlot({
                    pollution %>% 
                    filter(Type=="aggregated",Region!="ALL") %>% 
                    group_by(Region, Year) %>%
                    summarise(total=sum(get(paste0("Death.", input$pollutant2)))) %>% 
                    ggplot(aes(x=Year, y=total))+
                    geom_line(aes(color=Region))+
                    theme_minimal()+
                    ylab("Death Rate")+
                    theme(legend.position="bottom", legend.title=element_blank())
    })  
    
    output$dRegion2 = renderPlot({
                    pollution %>% 
                    filter(Type =="aggregated",
                           Year==1990|Year==1995|Year==2000|Year==2005|Year==2010|Year==2015) %>%
                    group_by(Region, Year) %>%
                    summarise(total=sum(get(paste0("Death.",input$pollutant2)))) %>% 
                    ggplot(aes(x=Year,y=total))+
                    geom_col(aes(fill=Region))+
                    theme_minimal()+
                    ylab("Death Rate")+
                    theme(legend.title=element_blank(),legend.position = "bottom")

    })
    
    ## SDI Exposure
    output$eSDI = renderPlot({
                    pollution %>%
                    filter(Type=="country",Region!="ALL") %>%
                    group_by(Region, Year) %>%
                    summarise(total=sum(get(paste0("Exposure.", input$pollutant2)))) %>% 
                    ggplot(aes(x=Year, y=total))+
                    geom_line(aes(color=Region))+
                    theme_minimal()+
                    ylab(paste0("Exposure to ", ylabel()))+
                    labs(color="SDI")+
                    theme(legend.position ="bottom", legend.title=element_blank())+
                    scale_color_discrete(
                                breaks=c("High SDI", "High-middle SDI", "Middle SDI", 
                                        "Low-middle SDI", "Low SDI"),
                                labels=c("High SDI", "High-middle SDI", "Middle SDI", 
                                        "Low-middle SDI", "Low SDI"))
    })
    ## SDI Exposure Rate 2
    output$eSDI2 = renderPlot({
                    pollution %>% 
                    filter(Type =="country",Region!="ALL",
                           Year==1990|Year==1995|Year==2000|Year==2005|Year==2010|Year==2015) %>%
                    group_by(Region,Year) %>%
                    summarise(total=sum(get(paste0("Exposure.",input$pollutant2)))) %>% 
                    ggplot(aes(x=Year,y=total))+
                    geom_col(aes(fill=Region))+
                    theme_minimal()+
                    ylab(paste0("Exposure to ", ylabel()))+
                    theme(legend.position="bottom", legend.title=element_blank())+
                    scale_fill_discrete(
                                breaks=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"),
                                labels=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"))
    })
    ## SDI Death Rate
    output$dSDI = renderPlot({
                    pollution %>% 
                    filter(Type =="country",Region!="ALL") %>%
                    group_by(Region,Year) %>%
                    summarise(total=sum(get(paste0("Death.",input$pollutant2)))) %>% 
                    ggplot(aes(x=Year, y=total))+
                    geom_line(aes(color=Region))+
                    theme_minimal()+
                    ylab("Death Rate")+
                    theme(legend.position="bottom", legend.title=element_blank())+
                    scale_color_discrete(
                                breaks=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"),
                                labels=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"))
    }) 
    ## SDI Death Rate 2
    output$dSDI2 = renderPlot({
                    pollution %>% 
                    filter(Type =="country",Region!="ALL",
                    Year==1990|Year==1995|Year==2000|Year==2005|Year==2010|Year==2015) %>% 
                    group_by(Region,Year) %>%
                    summarise(total=sum(get(paste0("Death.",input$pollutant2)))) %>% 
                    ggplot(aes(x=Year,y=total))+
                    geom_col(aes(fill=Region))+
                    theme_minimal()+
                    ylab("Death Rate")+
                    theme(legend.position="bottom", legend.title=element_blank())+
                    scale_fill_discrete(
                                breaks=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"),
                                labels=c("High SDI", "High-middle SDI", "Middle SDI", 
                                         "Low-middle SDI", "Low SDI"))
    })      

# (4) DATA TAB -------------------------------
    
    output$table = DT::renderDataTable({
        datatable(pollution, filter = "top", rownames=TRUE) 
    }) 
    
})
