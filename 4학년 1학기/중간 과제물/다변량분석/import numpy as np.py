import numpy as np
import matplotlib.pyplot as plt
import stemgraphic

# 난수 생성
np.random.seed(0)
data = np.random.standard_t(df=5, size=100)

# 히스토그램 그리기
plt.figure(figsize=(6, 4))
plt.hist(data, bins=15, edgecolor='black')
plt.title('Histogram of t-distributed random numbers (df=5)')
plt.xlabel('Value')
plt.ylabel('Frequency')
plt.grid(True)
plt.show()

# 상자 그림 그리기
plt.figure(figsize=(6, 2))
plt.boxplot(data, vert=False)
plt.title('Boxplot of t-distributed random numbers (df=5)')
plt.xlabel('Value')
plt.grid(True)
plt.show()

# 줄기-잎 그림 그리기
fig, ax = stemgraphic.stem_graphic(
    data,
    scale=1,
)
fig.set_size_inches(10, 5)
plt.show()