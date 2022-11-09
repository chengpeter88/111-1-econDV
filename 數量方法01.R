dataset <- read.csv("data_for_class_1.csv",header = TRUE)
str(dataset)
dat=dataset

miles = dat$MILES
income=dat$INCOME
age=dat$AGE
kids=dat$KIDS

lse=lm(miles~income+age+kids)
summary(lse)

##########lse made by hand
y=as.matrix(miles)  ###as matrix like numpy arrary
y
dim(y) #info of y  eg. pythonlength 

x=cbind(1,income,age,kids)  #1 chage into array and combine with other variable
x
dim(x)

###by def. we made ols beta hat 
###crossprod imply the martix mutliper 
###sovle imply the matrix to do inverse
b=crossprod(solve(crossprod(x,x)),crossprod(x,y))
b
dim(b)

e=y-x%*%b  #construct the error term
e
summary(e)   #get more info about error term

n=nrow(x) # x is a table represnt all info by nrow show the smaple size
i=as.matrix(x[,1]) #get the b0 the part of inter. all 1
m0=diag(n)-i%*%solve(crossprod(i,i))%*%t(i)  #to make the8 devation from mean 
# just like the resiual maker

sst=t(y)%*%m0%*%y   #independent variable multp.the devat. from mean
sse=crossprod(e,e)
ssr=sst-sse

R2=ssr/sst
R2

k=ncol(x)
nmk=n-k
print(nmk)

adjR2=(1-k)/nmk+(n-1)/nmk*R2  #bulid the adjust r2
adjR2

s_squard=as.numeric(sse/nmk)  ##chamge into the int.
s_squard
s=s_squard^0.5
s

vcov=s_squard*solve(crossprod(x,x))  #to make the variance and covarinace matrix
vcov

var=diag(vcov) #diag is 對角線martix   we know diag is var.
var

se=var^0.5 ###build the stand erroe
se

t_test=b/se  ##t_test
t_test

pvt=2*pt(-abs(t_test),df=nmk)
pvt

results=cbind(b,se,t_test,pvt)
colnames(results)=c("Estimate","STD.Error","t_value","Pr(>|t|)")
rownames(results)=c("intercept","income","age","kids")
round(results,digits = 4)

######to make the 假設檢定 f test
q=ncol(x)-1
q

null=matrix(0:0,q)##取出第一個col
null
ikm1=diag(q)
ikm1
R=cbind(null,ikm1)
R

r=matrix(0:0,q) ###變數上進行聯合的檢定是否有和0差別 beta 123 
r

Rbetamr=R%*%b-r
Rbetamr

f=t(Rbetamr)%*%solve(R%*%vcov%*%t(R))%*%Rbetamr/q
f
pvf=1-pf(f,df1=q,df2=nmk)
pvf


####finally data from package
vcov(lse)
coefficients(lse)
residuals(lse)
fitted.values(lse)
y-e