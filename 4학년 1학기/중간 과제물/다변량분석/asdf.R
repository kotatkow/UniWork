# 1. 패키지 설치 (최초 1회만)
install.packages("psych")

# 2. 패키지 불러오기
library(psych)

# 3. 데이터 불러오기
data <- read.csv("C:/Users/ghkjs/Downloads/연습문제자료/favoritesujects.csv")
head(data)

# 4. SUBJECT 변수 제거
data <- data[, -1]

# 5. 상관행렬 확인
cor(data)

# 6. 유의한 인자의 수 확인 (고유값 기반)
fa.parallel(data, fa = "fa", n.iter = 100)

# 7. 인자분석 (2개 인자, varimax 회전)
fa_varimax <- fa(data, nfactors = 2, rotate = "varimax", fm = "ml")
print(fa_varimax)

# 8. 인자분석 (2개 인자, promax 회전)
fa_promax <- fa(data, nfactors = 2, rotate = "promax", fm = "ml")
print(fa_promax)
