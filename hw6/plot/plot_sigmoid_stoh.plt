# Line width of the axes
set border linewidth 1
# Line styles

a_1 = -1.003480455497643
a_2 = 1.870776356385857
a_3 = 0.6473059192067332
a_4 = 0.8882934431265246
a_5 = -3.204962179330913

b_1 = -0.42669554293646167
b_2 = 1.4948355443761248
b_3 = -1.3593569946993547
b_4 = -1.2666377825310375
b_5 = 6.139623344604337

c_1 = 2.4547016742331116
c_2 = -5.5226479485871405
c_3 = -3.881594416052228
c_4 = 0.10046871871036701
c_5 = 6.38663927264158

d_1 = 0.353343013004848
d_2 = -0.28995940332384995
d_3 = -0.637488766136956
d_4 = 0.29955553578634075
d_5 = 0.22957950143819572

alpha_1(x) = 1 / (1 + exp(b_1*(x-a_1)))
beta_1(x) = 1 / (1 + exp(d_1*(x-c_1)))

alpha_2(x) = 1 / (1 + exp(b_2*(x-a_2)))
beta_2(x) = 1 / (1 + exp(d_2*(x-c_2)))

alpha_3(x) = 1 / (1 + exp(b_3*(x-a_3)))
beta_3(x) = 1 / (1 + exp(d_3*(x-c_3)))

alpha_4(x) = 1 / (1 + exp(b_4*(x-a_4)))
beta_4(x) = 1 / (1 + exp(d_4*(x-c_4)))

alpha_5(x) = 1 / (1 + exp(b_5*(x-a_5)))
beta_5(x) = 1 / (1 + exp(d_5*(x-c_5)))

plot alpha_1(x) title 'alpha' with lines, \
     beta_1(x) title "beta" with lines, \
     alpha_2(x) title 'alpha2' with lines, \
     beta_2(x) title "beta2" with lines, \
     alpha_3(x) title 'alpha3' with lines, \
     beta_3(x) title "beta3" with lines, \
     alpha_4(x) title 'alpha4' with lines, \
     beta_4(x) title "beta4" with lines, \
     alpha_5(x) title 'alpha5' with lines, \
     beta_5(x) title "beta5" with lines, \