# 필요한 패키지 설치 및 불러오기
install.packages("readxl")
install.packages("ggplot2")
install.packages("tibble")
install.packages("tseries")

library(tseries)
library(tibble)
library(ggplot2)
library(readxl)

# 시계열도표표
# 데이터 불러오기
raw_gdp <- read_excel("C:/Users/ghkjs/Downloads/국내총생산에_대한_지출_원계열__실질__분기_및_연간__20250413230751.xlsx", sheet = "데이터")
sa_gdp  <- read_excel("C:/Users/ghkjs/Downloads/국내총생산에_대한_지출_계절조정__실질__분기__20250413230644.xlsx", sheet = "데이터")

# 첫 번째 항목 (최종소비지출)을 GDP 대표로 사용
raw_values <- as.numeric(raw_gdp[1, -1])  # 첫 행, 첫 열 제외
sa_values <- as.numeric(sa_gdp[1, -1])    # 동일하게 처리

# 날짜 생성 (분기 기준)
quarters <- seq(as.Date("1970-01-01"), by = "quarter", length.out = length(raw_values))

# 데이터프레임 생성
df <- data.frame(
  Date = quarters,
  Raw = raw_values,
  SeasonallyAdjusted = sa_values
)

# 시각화
ggplot(df, aes(x = Date)) +
  geom_line(aes(y = Raw, color = "원계열 (Raw)"), linetype = "dashed") +
  geom_line(aes(y = SeasonallyAdjusted, color = "계절조정계열"), size = 1) +
  labs(title = "실질 국내총생산: 원계열 vs 계절조정계열 (1970Q1~2024Q4)",
       x = "연도", y = "실질 GDP (십억원)", color = "계열") +
  theme_minimal()

# 스펙트럼럼
# 숫자형 시계열 추출 (첫 번째 항목 기준)
raw_series <- as.numeric(raw_gdp[1, -1])
sa_series <- as.numeric(sa_gdp[1, -1])

# 스펙트럼 분석 (주파수 영역으로 변환)
raw_spec <- spectrum(raw_series, plot = FALSE)
sa_spec <- spectrum(sa_series, plot = FALSE)

# 데이터프레임 생성
df_spec <- tibble(
  Frequency = raw_spec$freq,
  Raw = raw_spec$spec,
  SeasonallyAdjusted = sa_spec$spec
)

# 롱(long) 형태로 변환
df_long <- tidyr::pivot_longer(df_spec, cols = c("Raw", "SeasonallyAdjusted"),
                               names_to = "Series", values_to = "Power")

# 그래프 그리기
ggplot(df_long, aes(x = Frequency, y = Power, color = Series)) +
  geom_line(size = 1) +
  labs(title = "스펙트럼 분석: 실질 GDP 원계열 vs 계절조정계열",
       x = "주파수 (Frequency)", y = "스펙트럼 세기 (Power)",
       color = "계열") +
  theme_minimal()


#차분
# 날짜 생성 (분기 기준)
date_seq <- seq(as.Date("1970-01-01"), by = "quarter", length.out = length(raw_series))

# 1차 차분 계산
diff_raw <- diff(raw_series)
diff_sa <- diff(sa_series)
diff_dates <- date_seq[-1]  # 차분 시 1개 줄어듦

# 데이터 프레임 생성
df_diff <- data.frame(
  Date = diff_dates,
  원계열 = diff_raw,
  계절조정계열 = diff_sa
)

# 시각화 (ggplot2)
install.packages("ggplot2")
library(ggplot2)

ggplot(df_diff, aes(x = Date)) +
  geom_line(aes(y = 원계열, color = "원계열 (Raw)"), linetype = "dashed") +
  geom_line(aes(y = 계절조정계열, color = "계절조정계열"), size = 1) +
  labs(title = "실질 GDP 1차 차분: 원계열 vs 계절조정계열",
       x = "연도", y = "증가량 (차분값)", color = "계열") +
  theme_minimal()

#차분 ADF분석
# ADF 검정 (비차분)
cat("✅ ADF Test - 원계열 (Raw)\n")
adf.test(raw_series)

cat("\n✅ ADF Test - 계절조정계열 (Seasonally Adjusted)\n")
adf.test(sa_series)

# 1차 차분 후 ADF 검정
diff_raw <- diff(raw_series)
diff_sa  <- diff(sa_series)

cat("\n✅ ADF Test - 차분 원계열 (Diff Raw)\n")
adf.test(diff_raw)

cat("\n✅ ADF Test - 차분 계절조정계열 (Diff SA)\n")
adf.test(diff_sa)

# 자기상관도표&부분자기상관도표
# 시계열로 변환 (분기 단위, 시작 연도 조정 가능)
raw_ts <- ts(raw_series, start = c(1970, 1), frequency = 4)
sa_ts  <- ts(sa_series,  start = c(1970, 1), frequency = 4)

# ACF & PACF 시각화
par(mfrow = c(2, 2))  # 2행 2열 그래프 배열

acf(raw_ts, lag.max = 40, main = "원계열 ACF")
pacf(raw_ts, lag.max = 40, main = "원계열 PACF")

acf(sa_ts, lag.max = 40, main = "계절조정계열 ACF")
pacf(sa_ts, lag.max = 40, main = "계절조정계열 PACF")

par(mfrow = c(1, 1))  # 원래대로 복원