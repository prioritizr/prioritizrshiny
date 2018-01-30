# prioritizrshiny
Eventual home of the prioritizrshiny package, which will be a GUI for solving prioritizr problems

Merged with prioritizr package

#Installation
```
if (!require(devtools))
  install.packages("devtools")
devtools::install_github("prioritizr/prioritizrshiny")
```

#Example usage
```
# load package
library(prioritizrshiny)
```


```
#list available shiny apps
prshiny()

#run base Shiny app
prshiny("base_app", launch.browser = TRUE)
```
