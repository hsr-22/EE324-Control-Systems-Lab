% This is how we roll
M_p = 0.027;
l_p = 0.153;
L_p = 0.191;
r = 0.08260;
J_m = 3e-5;
M_arm = 0.028;
g = 9.810;
J_eq = 1.23e-4;
J_p = 1.1e-4;
B_eq = 0;
B_p = 0;
R_m = 3.30;
K_t = 0.02797;
K_m = 0.02797;
%%%%%%%%%%%%%%%%%%%%%%%%
denom = J_p * J_eq + M_p * J_eq * (l_p^2) + J_p *M_p *(r^2);
var1 = (r * ((M_p * l_p)^2) * g)/(denom);
var2 = K_t * K_m * (J_p + M_p * (l_p^2))/(denom * R_m);
var3 = M_p * l_p * g * (J_eq + M_p * (r^2))/denom;
var4 = -M_p * l_p * K_t * r * K_m/(denom * R_m);
var5 = K_t * (J_p + M_p * (l_p^2))/(denom * R_m);
var6 = M_p * l_p * K_t * r/(denom * R_m);

A = [0 0     1     0; 
     0 0     0     1;
     0 var1 -var2  0;
     0 var3  var4  0];
B = [ 0;
      0;
      var5;
      var6];
C = [1 0 0 0 ;0 1 0 0;0 0 1 0;0 0 0 1];   
D = [0;0;0;0];
%x is actually [theta, alpha, theta', alpha'] 
%where theta is arm, alpha is pendulum
Q = [   410    0   0    0;
        0      4     0    0;
        0      0   50     0;
        0      0   0    100];
R = 14;

N=0;
   
[K, S, P] = lqr(A, B, Q, R, N);
sys1 = ss(A-B*K,B,C,D);
step(sys1)