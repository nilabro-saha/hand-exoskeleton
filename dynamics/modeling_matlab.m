syms x_P1O_R y_P1O_R th1(t) x_P2O_R y_P2O_R th2(t);

% coordinates of joint Q
ax = 0;
ay = 0;

% length of links
l1 = 10;
l2 = 10;

% mass of links
m1 = 10;
m2 = 10;

% moments of inertia of links wrt centre of mass about z-axis
J_C1Z_L1 = 10;
J_C2Z_L2 = 10;

% joints P1 and P2
p1 = [x_P1O_R; y_P1O_R; th1];
p2 = [x_P2O_R; y_P2O_R; th2];

p = [p1; p2];

% constraint position equation
g = [x_P1O_R - ax + l1 * cos(th1); ...
    y_P1O_R - ay + l1 * sin(th1); ...
    x_P2O_R - ax + l1 * cos(th1) + l2 * cos(th2); ...
    y_P2O_R - ay + l1 * sin(th1) + l2 * sin(th2)];

% constraint jacobian matrix
syms t1 t2;
G = [diff(g, p(1)), diff(g, p(2)), diff(g, p(3)), diff(g, p(4)), diff(g, p(5)), diff(g, p(6))]

% spatial inertia matrices of links
M1 = [m1,                   0,                      -0.5*m1*l1*sin(th1); ...
      0,                    m1,                     0.5*m1*l1*cos(th1); ...
      0.5*m1*l1*sin(th1),   -0.5*m1*l1*cos(th1),    J_C1Z_L1 + 0.25*m1*l1*l1];

M2 = [m2,                   0,                      -0.5*m2*l2*sin(th2); ...
      0,                    m2,                     0.5*m2*l2*cos(th2); ...
      0.5*m2*l2*sin(th2),   -0.5*m2*l2*cos(th2),    J_C2Z_L2 + 0.25*m2*l2*l2];

% generalized mass matrix
M = blkdiag(M1, M2);

%%



