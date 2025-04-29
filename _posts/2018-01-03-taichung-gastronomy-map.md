---
layout: post
author: Dingyi Lai
---

# Introduction
As a special municipality being famed for its delicious food, Taichung attracts a large number of tourists every year. But where could we accommodate to own the most practical traffic for gastronomy? Codes without accessing to details are presented in [this repo](https://github.com/Dingyi-Lai/Data-Science/blob/main/%5BProject%5DTaichung_Gastronomy_Map.Rmd)

# Goal
Find the best accommodation point for gastronomy in Taichung.

# Procedure
1. Clean the platform
2. Change the directory
3. Read the data
4. Change columns name
5. Observe the structure of data
6. Install necessary packages
7. Clean data, limit the latitude and longitude and store it as new
8. Kmeans clustering
9. Store the results into new
10. Observe result of clustering
11. Clustering Visualization
![ClusterPlot](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/TGM_ClusterPlot.png)
12. Find the median of latitude and longitude for each group
13. Store them into data.frame as knew
14. Scatter Plot for grouped data
![ScatterPlot_Groups](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/TGM_ScatterPlot_Groups.png)
15. Scatter Plot for clustering
![ScatterPlot_kmeans](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/TGM_ScatterPlot_kmeans.png)
16. Zoom in
![ScatterPlot_kmeans_ZoomIn](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/TGM_ScatterPlot_kmeans_ZoomIn.png)

# Conclusion
The best accommodations for foodies are Tunghai Night Market, Fengjia Night Market, Yizhong Night Market, Gongyi Rd., where customers can enjoy the top gastronomy in Taichung. If considering practical traffic, the overlapping areas as the result of kmeans clustering is Fengjia Night Market.