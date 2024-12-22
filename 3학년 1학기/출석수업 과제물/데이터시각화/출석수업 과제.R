setwd("C:\\Users\\ghkjs\\OneDrive\\바탕 화면\\Rtest")


library(datarium)
library(ggplot2)

marketing

ggplot(marketing, aes(facebook, sales))+
  geom_point()


ggplot(marketing, aes(x = facebook, y = sales)) +
  geom_point() +                             
  geom_smooth(method = "lm") +
  ggtitle("202234-153799")

headache

ggplot(headache)+
  geom_boxplot(aes(treatment, pain_score))+
  ggtitle("202234-153799")