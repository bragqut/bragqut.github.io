---
layout: post
title: Subsetting Dataframes by Column Name with Regular Expressions
author: brfitzpatrick
---


### Description
Selecting columns of a dataframe with regular expressions.

### Code Snippet/Console Buffer Yank

Lets make a test set of data.
Column names that follow some sort of system will make this example easier to understand.

``` r
> CN.df <- expand.grid(LETTERS, month.abb)
> 
> head(CN.df)
  Var1 Var2
1    A  Jan
2    B  Jan
3    C  Jan
4    D  Jan
5    E  Jan
6    F  Jan
> 
> tail(CN.df)
    Var1 Var2
307    U  Dec
308    V  Dec
309    W  Dec
310    X  Dec
311    Y  Dec
312    Z  Dec
> 
> CN.df$CN <- paste(CN.df$Var1, CN.df$Var2, sep = '_')
> 
> CN.df$CN
  [1] "A_Jan" "B_Jan" "C_Jan" "D_Jan" "E_Jan" "F_Jan" "G_Jan" "H_Jan" "I_Jan"
 [10] "J_Jan" "K_Jan" "L_Jan" "M_Jan" "N_Jan" "O_Jan" "P_Jan" "Q_Jan" "R_Jan"
 [19] "S_Jan" "T_Jan" "U_Jan" "V_Jan" "W_Jan" "X_Jan" "Y_Jan" "Z_Jan" "A_Feb"
 [28] "B_Feb" "C_Feb" "D_Feb" "E_Feb" "F_Feb" "G_Feb" "H_Feb" "I_Feb" "J_Feb"
 [37] "K_Feb" "L_Feb" "M_Feb" "N_Feb" "O_Feb" "P_Feb" "Q_Feb" "R_Feb" "S_Feb"
 [46] "T_Feb" "U_Feb" "V_Feb" "W_Feb" "X_Feb" "Y_Feb" "Z_Feb" "A_Mar" "B_Mar"
 [55] "C_Mar" "D_Mar" "E_Mar" "F_Mar" "G_Mar" "H_Mar" "I_Mar" "J_Mar" "K_Mar"
 [64] "L_Mar" "M_Mar" "N_Mar" "O_Mar" "P_Mar" "Q_Mar" "R_Mar" "S_Mar" "T_Mar"
 [73] "U_Mar" "V_Mar" "W_Mar" "X_Mar" "Y_Mar" "Z_Mar" "A_Apr" "B_Apr" "C_Apr"
 [82] "D_Apr" "E_Apr" "F_Apr" "G_Apr" "H_Apr" "I_Apr" "J_Apr" "K_Apr" "L_Apr"
 [91] "M_Apr" "N_Apr" "O_Apr" "P_Apr" "Q_Apr" "R_Apr" "S_Apr" "T_Apr" "U_Apr"
[100] "V_Apr" "W_Apr" "X_Apr" "Y_Apr" "Z_Apr" "A_May" "B_May" "C_May" "D_May"
[109] "E_May" "F_May" "G_May" "H_May" "I_May" "J_May" "K_May" "L_May" "M_May"
[118] "N_May" "O_May" "P_May" "Q_May" "R_May" "S_May" "T_May" "U_May" "V_May"
[127] "W_May" "X_May" "Y_May" "Z_May" "A_Jun" "B_Jun" "C_Jun" "D_Jun" "E_Jun"
[136] "F_Jun" "G_Jun" "H_Jun" "I_Jun" "J_Jun" "K_Jun" "L_Jun" "M_Jun" "N_Jun"
[145] "O_Jun" "P_Jun" "Q_Jun" "R_Jun" "S_Jun" "T_Jun" "U_Jun" "V_Jun" "W_Jun"
[154] "X_Jun" "Y_Jun" "Z_Jun" "A_Jul" "B_Jul" "C_Jul" "D_Jul" "E_Jul" "F_Jul"
[163] "G_Jul" "H_Jul" "I_Jul" "J_Jul" "K_Jul" "L_Jul" "M_Jul" "N_Jul" "O_Jul"
[172] "P_Jul" "Q_Jul" "R_Jul" "S_Jul" "T_Jul" "U_Jul" "V_Jul" "W_Jul" "X_Jul"
[181] "Y_Jul" "Z_Jul" "A_Aug" "B_Aug" "C_Aug" "D_Aug" "E_Aug" "F_Aug" "G_Aug"
[190] "H_Aug" "I_Aug" "J_Aug" "K_Aug" "L_Aug" "M_Aug" "N_Aug" "O_Aug" "P_Aug"
[199] "Q_Aug" "R_Aug" "S_Aug" "T_Aug" "U_Aug" "V_Aug" "W_Aug" "X_Aug" "Y_Aug"
[208] "Z_Aug" "A_Sep" "B_Sep" "C_Sep" "D_Sep" "E_Sep" "F_Sep" "G_Sep" "H_Sep"
[217] "I_Sep" "J_Sep" "K_Sep" "L_Sep" "M_Sep" "N_Sep" "O_Sep" "P_Sep" "Q_Sep"
[226] "R_Sep" "S_Sep" "T_Sep" "U_Sep" "V_Sep" "W_Sep" "X_Sep" "Y_Sep" "Z_Sep"
[235] "A_Oct" "B_Oct" "C_Oct" "D_Oct" "E_Oct" "F_Oct" "G_Oct" "H_Oct" "I_Oct"
[244] "J_Oct" "K_Oct" "L_Oct" "M_Oct" "N_Oct" "O_Oct" "P_Oct" "Q_Oct" "R_Oct"
[253] "S_Oct" "T_Oct" "U_Oct" "V_Oct" "W_Oct" "X_Oct" "Y_Oct" "Z_Oct" "A_Nov"
[262] "B_Nov" "C_Nov" "D_Nov" "E_Nov" "F_Nov" "G_Nov" "H_Nov" "I_Nov" "J_Nov"
[271] "K_Nov" "L_Nov" "M_Nov" "N_Nov" "O_Nov" "P_Nov" "Q_Nov" "R_Nov" "S_Nov"
[280] "T_Nov" "U_Nov" "V_Nov" "W_Nov" "X_Nov" "Y_Nov" "Z_Nov" "A_Dec" "B_Dec"
[289] "C_Dec" "D_Dec" "E_Dec" "F_Dec" "G_Dec" "H_Dec" "I_Dec" "J_Dec" "K_Dec"
[298] "L_Dec" "M_Dec" "N_Dec" "O_Dec" "P_Dec" "Q_Dec" "R_Dec" "S_Dec" "T_Dec"
[307] "U_Dec" "V_Dec" "W_Dec" "X_Dec" "Y_Dec" "Z_Dec"
> 
> Data <- matrix(data = rnorm(n = 100*nrow(CN.df), mean = 0, sd = 1), ncol = nrow(CN.df))
> 
> dim(Data)
[1] 100 312
> 
> colnames(Data) <- CN.df$CN
```
We're now going to select columns using regular expressions.

Let's practise this just with the column names themselves first:

``` r
> grep(pattern = 'Feb', x = colnames(Data))
 [1] 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51
[26] 52
```
and we get the element numbers in the vector colnames(Data) that contain the string Feb


``` r
> colnames(Data)[grep(pattern = 'Feb', x = colnames(Data))]
 [1] "A_Feb" "B_Feb" "C_Feb" "D_Feb" "E_Feb" "F_Feb" "G_Feb" "H_Feb" "I_Feb"
[10] "J_Feb" "K_Feb" "L_Feb" "M_Feb" "N_Feb" "O_Feb" "P_Feb" "Q_Feb" "R_Feb"
[19] "S_Feb" "T_Feb" "U_Feb" "V_Feb" "W_Feb" "X_Feb" "Y_Feb" "Z_Feb"
```

these are also column numbers in the dataframe Data...

``` r
> head(Data[, grep(pattern = 'Feb', x = colnames(Data))])
          A_Feb      B_Feb      C_Feb       D_Feb      E_Feb      F_Feb
[1,] -0.6841265 -1.1817348  1.6807043 -0.39257311 -0.9515360  0.8008152
[2,] -0.6779050 -0.9164804  1.9647272  0.07364766 -1.4755660 -1.6456495
[3,] -0.1795740 -3.8315958  0.1533694  0.21030433  1.4679366  0.6412827
[4,] -0.7233379  1.3716940  0.1337730  0.04705661  1.5007768  0.6619927
[5,]  0.5472112  1.7222713 -0.5200483  1.18211624 -0.7153904  0.2553364
[6,] -1.0596905 -1.0081476 -0.6045363  0.62751178  1.5831821 -0.5330454
          G_Feb      H_Feb      I_Feb       J_Feb      K_Feb      L_Feb
[1,]  1.1841829  0.2329420 -2.1188408 -0.25214828 -0.1864550  0.5949313
[2,]  1.9144663 -0.4707447 -0.9954586 -1.66399634  0.5760829  0.1251184
[3,]  0.2713321  0.1858492  0.5804353  0.01503721  0.4025628  0.1949168
[4,] -0.3175766 -1.6206853  0.4731099 -0.88368914 -1.1853159 -0.7878871
[5,]  0.6669143 -0.5031496 -1.8234294 -0.79414369 -0.2683703  0.3607956
[6,] -1.0852894  1.4511176  1.1685282  0.71199378  0.7478227 -0.2974355
          M_Feb      N_Feb       O_Feb      P_Feb      Q_Feb       R_Feb
[1,] -1.3881478  0.2735816 -1.76074556 -1.0148078 -0.6016140  1.32945170
[2,]  0.6753580 -1.1201647 -0.55614611  0.7881342 -0.7993316  1.42795248
[3,]  1.6042324 -0.3887248  0.73089443 -0.4796499 -0.2507031 -1.36970289
[4,]  0.3604392 -1.6558602 -1.18762489  0.4725448 -1.8988363  0.14019003
[5,]  0.2355033  3.3008920  2.10665129  0.6767839  0.4951569  2.13241527
[6,] -1.5474530  0.4436130  0.02131928 -0.7797122  0.8099167  0.06482327
            S_Feb       T_Feb      U_Feb      V_Feb      W_Feb      X_Feb
[1,]  0.880824846 -0.51746541  1.0710203 -1.1793858 -0.5530662 -0.4860293
[2,]  0.002691101 -0.09073245  0.8086777  1.6553748 -0.4882194  2.8290856
[3,] -1.305339790  0.84129879 -0.2418693 -0.5594489  0.5807339 -1.5567147
[4,]  1.639555249  0.01454536 -0.3562965 -0.3608921  0.3614061  0.1387805
[5,] -0.429934749 -0.31134244 -1.4999730 -0.4752920 -0.3603784  1.1385050
[6,]  0.241391062  1.31354226  0.1322101  1.3959864 -0.5923838  0.6377891
          Y_Feb      Z_Feb
[1,]  1.0007115  0.2933871
[2,] -0.4424484 -0.9198374
[3,] -0.3196309 -1.1980152
[4,]  1.0302725  0.4518252
[5,]  0.6680153  0.7511440
[6,]  0.2369676 -0.6112372
```

Let's now extract all the column names that begin with F.
Note: we can't just search for all column names that contain the upper case letter F because we'll get all the columns that contain 'Feb' in their names...

``` r
> colnames(Data)[grep(pattern = 'F', x = colnames(Data))]
 [1] "F_Jan" "A_Feb" "B_Feb" "C_Feb" "D_Feb" "E_Feb" "F_Feb" "G_Feb" "H_Feb"
[10] "I_Feb" "J_Feb" "K_Feb" "L_Feb" "M_Feb" "N_Feb" "O_Feb" "P_Feb" "Q_Feb"
[19] "R_Feb" "S_Feb" "T_Feb" "U_Feb" "V_Feb" "W_Feb" "X_Feb" "Y_Feb" "Z_Feb"
[28] "F_Mar" "F_Apr" "F_May" "F_Jun" "F_Jul" "F_Aug" "F_Sep" "F_Oct" "F_Nov"
[37] "F_Dec"
```

we need a simple regular expression

``` r
> colnames(Data)[grep(pattern = '^F', x = colnames(Data))]
 [1] "F_Jan" "F_Feb" "F_Mar" "F_Apr" "F_May" "F_Jun" "F_Jul" "F_Aug" "F_Sep"
[10] "F_Oct" "F_Nov" "F_Dec"
```

the ^ means start of line

``` r
> F.Data <- Data[,grep(pattern = '^F', x = colnames(Data))]
> 
> head(F.Data)
          F_Jan      F_Feb       F_Mar      F_Apr        F_May      F_Jun
[1,] -0.2745363  0.8008152 -0.21815602  0.1210484 -0.005076821 0.01058365
[2,] -0.2679376 -1.6456495 -0.69573333  0.7255740  1.231271980 1.32665308
[3,] -0.4451868  0.6412827 -0.50548581 -2.6556828  0.046676109 2.68229178
[4,] -1.2374888  0.6619927 -1.46774735 -0.5745960 -0.923580718 0.97393985
[5,] -1.2218576  0.2553364 -0.02558555 -0.5925002  1.644321061 0.11406815
[6,]  0.8826744 -0.5330454 -0.11360542 -0.6938523  0.758702611 0.76233907
           F_Jul      F_Aug      F_Sep      F_Oct       F_Nov       F_Dec
[1,]  1.55740051 -0.9127755  0.8580327 -0.4472975  0.81835698  1.02912905
[2,]  0.05448689  2.0270125 -0.4244351 -0.1366634  0.03534011 -0.67561827
[3,]  0.21931733 -1.0393318  0.4258849 -1.1134557  0.12469384  0.90877361
[4,] -0.28482266 -1.4338899 -0.4850225 -1.3333187  0.18724145 -0.26304415
[5,]  0.26891692  1.3171009  0.4208927 -0.4915738 -0.92508066  0.03629915
[6,] -0.55537607  1.3738066  1.4363442 -2.3209636  0.90170461 -0.20421596
```

perhaps we no longer want all the columns in F.Data to have column names the start with F_

``` r 
> F.Data.CN <- unlist(strsplit(x = colnames(F.Data), split = '_'))
> 
> F.Data.CN[!F.Data.CN == 'F']
 [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"
> 
> colnames(F.Data) <- F.Data.CN[!F.Data.CN == 'F']
> 
> head(F.Data)
            Jan        Feb         Mar        Apr          May        Jun
[1,] -0.2745363  0.8008152 -0.21815602  0.1210484 -0.005076821 0.01058365
[2,] -0.2679376 -1.6456495 -0.69573333  0.7255740  1.231271980 1.32665308
[3,] -0.4451868  0.6412827 -0.50548581 -2.6556828  0.046676109 2.68229178
[4,] -1.2374888  0.6619927 -1.46774735 -0.5745960 -0.923580718 0.97393985
[5,] -1.2218576  0.2553364 -0.02558555 -0.5925002  1.644321061 0.11406815
[6,]  0.8826744 -0.5330454 -0.11360542 -0.6938523  0.758702611 0.76233907
             Jul        Aug        Sep        Oct         Nov         Dec
[1,]  1.55740051 -0.9127755  0.8580327 -0.4472975  0.81835698  1.02912905
[2,]  0.05448689  2.0270125 -0.4244351 -0.1366634  0.03534011 -0.67561827
[3,]  0.21931733 -1.0393318  0.4258849 -1.1134557  0.12469384  0.90877361
[4,] -0.28482266 -1.4338899 -0.4850225 -1.3333187  0.18724145 -0.26304415
[5,]  0.26891692  1.3171009  0.4208927 -0.4915738 -0.92508066  0.03629915
[6,] -0.55537607  1.3738066  1.4363442 -2.3209636  0.90170461 -0.20421596
```

How about some slightly more involved regular expressions?

``` r 
> colnames(Data)[grep(pattern = '(^F|^Z).Feb$', x = colnames(Data))]
[1] "F_Feb" "Z_Feb"
> 
> colnames(Data)[grep(pattern = '(^F|^Z).(Feb$|Ma.$)', x = colnames(Data))]
[1] "F_Feb" "Z_Feb" "F_Mar" "Z_Mar" "F_May" "Z_May"
> 
> head(Data[, grep(pattern = '(^F|^Z).(Feb$|Ma.$)', x = colnames(Data))])
          F_Feb      Z_Feb       F_Mar     Z_Mar        F_May      Z_May
[1,]  0.8008152  0.2933871 -0.21815602 -1.568861 -0.005076821 -0.7032838
[2,] -1.6456495 -0.9198374 -0.69573333  1.918501  1.231271980 -0.1727215
[3,]  0.6412827 -1.1980152 -0.50548581  1.080280  0.046676109  1.5011851
[4,]  0.6619927  0.4518252 -1.46774735 -1.477020 -0.923580718  0.4603256
[5,]  0.2553364  0.7511440 -0.02558555  1.215124  1.644321061 -1.9630911
[6,] -0.5330454 -0.6112372 -0.11360542 -1.192837  0.758702611  0.2811076
```

That concludes this example.

Read more about regular expressions in R with:

``` r
> ?regexp
```

