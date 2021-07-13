

#UI ---------------------------------------------------------------------------
shinyUI(dashboardPage(
    
# (1) HEADER ------------------------------------------------------------------
    
    dashboardHeader(title="Global Air Pollution"),
    ski="green",
    
    
# (2) SIDEBAR -----------------------------------------------------------------
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Introduction", tabName="intro", icon=icon("intro")),
            menuItem("Top Countries", tabName="top", icon=icon("radiation")),
            menuItem("Global View", tabName="map", icon=icon("globe")),
            menuItem("Annual Trends", tabName="trend", icon=icon("chart-line")),
            menuItem("Data Source", tabName="data", icon=icon("database"))
        )
    ),
    
# (3) BODY --------------------------------------------------------------------
    
    dashboardBody(tabItems(
        
# (4) INTRODUCTION  ---------------------------------------------------

        tabItem(tabName="intro",
                h1(strong("Analysis of Global Air Pollution and Related Fatalities"),align="center"),
                br(),
                fluidRow(
                    column(width=12,
                           align="center",
                           img(src="https://www.studyfinds.org/wp-content/uploads/2019/08/AdobeStock_264610442.jpeg",height=400,width=500)
                    )
                ),
                br(),
                fluidRow(
                    column(width=12,
                        box(status="success",
                            solidHeader = TRUE,
                            width=12,
                            h4(p(strong("As the world faces a respiratory pandemic, it has become more apparent how important 
                            it is to breathe clean air. The WHO estimates that about 7 million people worldwide die every year 
                            from air pollution (1). In addition, the WHO data reflects that 9 out of 10 people breathe air that is 
                            above the WHO guidelines (1).")),
                            br(),
                            p("While air pollution also poses a major threat to the climate and sustainability 
                            of our planet, this analysis will focus on the health impacts associated with exposure to various 
                            air pollutants. Given that exposure to air pollution can lead to death, this app will help identify
                            areas around the world most impacted from high levels of air pollution and identify which pollutants are the 
                            biggest concern in each location. This could help guide organizations like the WHO to properly allocate
                            resources and come up with strategies on how to mitigate avoidable exposure to pollution."),
                            br(),
                            br(),
                            p("Air pollution can be categorized by 'Ambient Air Pollution' (outdoors) and 'Household Air Pollution' (indoors). 
                            We will be looking at two types of ambient air pollution, 'Particulate Matter 2.5 (ug/m3)' and 'Amient Ozone Pollution (ppb)',
                            and indoor air pollution caused from using solid fuels, 'Household Air Pollution (HAP)'."))
                        )
                    )
                ),
            fluidRow(
                column(width = 12,
                       p("Reference:"),
                       p(em("(1) https://www.who.int/health-topics/air-pollution#tab=tab_1"))
                )
            )
        ),

# (5) TOP COUNTRIES TAB -----------------------------------------------
        
        tabItem(tabName = "top",
                h2("Top 20 Most Polluted Countries Over"), br(),
                
        # SELECT OPTIONS -----------------------------
                fluidRow(
                    box(width=4,
                        title = "Select Year:",
                        height=100,
                        solidHeader=TRUE,
                        status="success",
                        selectInput(
                            inputId = "year1",
                            label=NULL,
                            choices=years)
                    ),
                    box(width=4,
                        title = "Select Pollutant:",
                        height=100,
                        solidHeader=TRUE,
                        status="success",
                        selectizeInput(
                            inputId = "pollutant1",
                            label=NULL,
                            choices=c("All Pollutants" = ".Total",
                                      "Particulate Matter 2.5" = ".PM",
                                      "Ozone" = ".Oz",
                                      "Household Air Pollutants" = ".HAP"))
                    ),
                    box(width=4,
                        title = strong("Exposure/Death Rate:"),
                        height=100,
                        solidHeader=TRUE,
                        status="success",
                        selectizeInput(
                            inputId="metric",
                            label=NULL,
                            choices=c("Exposure" = "Exposure","Death Rate" = "Death"))
                    )
                ),
                fluidRow(
                    column(width=12,
                           align="center",
                           htmlOutput("tree"),
                           br())
                ),
                fluidRow(
                    box(width=3, 
                        title="Highest Exposure",
                        status="success",
                        height=275, 
                        htmlOutput("eTop5")
                    ),
                    box(width=3, 
                        title="Lowest Exposure",
                        status="success",
                        height=275, 
                        htmlOutput("eBottom5")
                    ),
                    box(width=3, title="Highest Death Rate",
                        status="success",
                        height=275, 
                        htmlOutput("dTop5")
                    ),
                    box(width=3, 
                        title="Lowest Death Rate",
                        status="success",
                        height=275, 
                        htmlOutput("dBottom5")
                    )
                )
        ),      
        
# (6) MAP TAB -----------------------------------------------------
        
        tabItem(tabName = "map",
                h2("Global View of Air Pollution by Country"), br(),
                fluidRow(
                    
        # SELECT MAP POLLUTANT -----------------------------            
                    box(width=4,
                        title = "Select Pollutant:",
                        status="success", 
                        solidHeader=TRUE,
                        radioButtons("mPollutant", "",
                                     c("All Pollutants" = ".Total",
                                       "Particulate Matter 2.5" = ".PM",
                                       "Ozone" = ".Oz",
                                       "Household Air Pollutants" = ".HAP")
                        )
                    ),
                    
        # SELECT MAP YEAR ----------------------------------
                    box(width=8,
                        title = "Select Year:",
                        height=190,
                        status="success",
                        solidHeader=TRUE,
                        sliderTextInput(
                            inputId = "year2",
                            label="",
                            choices=years,
                            grid=FALSE)
                    )
                ),
        # GOOGLE MAP OUTPUT --------------------------------
            
                fluidRow(
                    box(width=12,
                        background="green",
                        h5("This tab is used to observe the changing dynamics of air pollution over 
                        time for each country. This can be used as a way to measure potential changes due to 
                        new policy changes or programs put in place to mitigate exposure and ultimately fatalities On the 
                        other end, this tool can be used to alert relevant groups of locations where exposure and 
                        deaths are increasing at high rates so that they can be prioritized."))
                ),                
                fluidRow(
                    tabBox(width=12, 
                           tabPanel("Exposure",htmlOutput("eMap"), width=1200, height=250),
                           tabPanel("Health Impact", htmlOutput("dMap"))
                    )  
                )
        ),
        
# (7) TREND TAB ----------------------------------------------
        
        tabItem(tabName = "trend",
                h2("Annual Trends by Region and Socio-Demographic Index"),br(),
                fluidRow(
                    
        # SELECT POLLUTANT ------------------------
                    box(width = 12,
                        status="success", 
                        selectizeInput(
                            inputId = "pollutant2",
                            label="Select Pollutant:",
                            choices =c("All Pollutants" = "Total",
                                       "Particulate Matter 2.5" = "PM",
                                       "Ozone" = "Oz",
                                       "Household Air Pollutants" = "HAP")
                        )
                    )
                ),
        
                fluidRow(
                    box(width=12,background = "green",
                        h5("The exhibits below reflect the annual trends of exposure and death rates 
                                  by pollutant and region. From this tool we can see that generally higher levels 
                                  of exposure to pollutants are found in Asia and Africa, and found in countries
                                  that are middle-low on the socio-demographic index. It is also evident that Africa
                                  has the highest exposure to household air pollution which comes from cooking with
                                  solid fuels. By focusing efforts to educate on better cooking methods, this could
                                  help reduce exposures and ultimately avoid pre-mature death."))
                ),
                
        # EXPOSURE GRAPHS OUTPUT ---------------------------
                fluidRow(
                    column(width=12,
                    tabsetPanel(tabPanel("By Region",
                                        fluidRow(
                                                box(plotOutput("eRegion"), width=6),
                                                box(plotOutput("dRegion"), width=6)),
                                        fluidRow(
                                                box(plotOutput("eRegion2"), width=6),
                                                box(plotOutput("dRegion2"), width=6))
                                ),
                                tabPanel("By Socio-Demographic Index", 
                                        fluidRow(
                                                box(plotOutput("eSDI"), width=6),
                                                box(plotOutput("dSDI"), width=6)),
                                        fluidRow(
                                                box(plotOutput("eSDI2"), width=6),
                                                box(plotOutput("dSDI2"), width=6))
                                )
                    )
                    )
                )
        ),
        
# (8) DATA TAB ------------------------------
        
        tabItem(tabName = "data",
                h2("Data Source"), br(),
                fluidRow(box(width = 12, DT::dataTableOutput("table"))),
                fluidRow(column(width = 12, em("Source: http://ghdx.healthdata.org/gbd-results-tool")))
        )
    )
    )
)
)

