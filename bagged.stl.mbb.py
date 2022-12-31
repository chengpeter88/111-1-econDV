import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from statsmodels.tsa.seasonal import STL
from scipy.stats import boxcox
from scipy.special import inv_boxcox
from statsmodels.tsa.exponential_smoothing.ets import ETSModel
from sktime.forecasting.ets import AutoETS 
from itertools import product
import warnings 


plt.style.use('ggplot')
m3 = [8000,5120,4720,7020,3840,7360,5040,10800,6580,8520,9460,7560,7060,4560,4660,6040, 4260,5840,5020,
       10040,10060,9100,5840,6660,5680,5820, 3280, 3000,3800,6040,5040,7100,8140,6820,9000,6840,5020,	
       3020,6960,3980,3660,2740,4760,8520,4220,7160,7040,4640,7440,3900,6800,4840,3080,5220,3840,2860,	
       6780,5480,3700,4460,4180,4520,3900,3580,2120,4560,4500,5660,4240,10160,7500,7180,7800,5240,5480,	
       3900,2920,4100,4540,	2520,4920	
    ]
###一維度 dataframe tX1
m3= pd.Series(
    m3, index=pd.date_range("10-1-1984", periods=len(m3), freq="M"), name="m3"
    )
m3.describe()
T=len(m3)
m3.plot()
plt.show(block=True)

stl=STL(m3,seasonal=13)
res=stl.fit()
trend = res.trend
seasonal = res.seasonal
res.plot()
dir(res)

def mbb(x,l):  #l block size
    n=len(x) #the length of data
    nb=np.int(n/l)+2
    idx=np.random.randint(n-l,size=nb)
    z=[]
    for ii in idx:
        z=z+list(x[ii:ii+l]) 
    z=z[np.random.randint(l):]
    z=z[:n]
    return(z)

z =mbb(res.resid,8)
z=pd.Series(z,index=m3.index)
z.plot()
plt.show(block=True)

# third step: moving block bootstrap
l = 24 # block size
B = 10 # number of bootstrapped series
T1=len(m3)+len(range(1,13))
fcast_h=list(range(1,13))

bt_m3 = pd.DataFrame(np.zeros((len(m3),B)),index=m3.index) #
m3_fcast=pd.DataFrame(np.zeros((T1,B)),index=pd.date_range(start=m3.index[0],periods=T1,freq="M")) 

for bb in range(B):
    z = mbb(res.resid,l) #boostrapped residuals
    bt_m3.iloc[:,bb]= np.array(z)+trend+seasonal
    #autoETS store the forcasting  to co2_fcast.iloc[len(co2),bb] bb=0,1,2,3,...
    m3_fcast.iloc[len(m3):,bb]=AutoETS(auto=True,n_jobs=-1,sp=12,maxiter=5000).fit_predict(bt_m3.iloc[:,bb],fh=fcast_h)
    #orginal co2 data 
    m3_fcast.iloc[:len(m3),bb]=m3
m3_fcast["1984":].plot(legend=False,figsize=(10,8))






