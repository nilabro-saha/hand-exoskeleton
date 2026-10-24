import sympy as sym
import numpy as np
from matplotlib.pyplot import *
import math

x_P1O_R, y_P1O_R, x_P2O_R, y_P2O_R, t = sym.symbols('x_P1O_R y_P1O_R x_P2O_R y_P2O_R t')

# independent joint variables
th1 = sym.Function('th1')(t)
th2 = sym.Function('th2')(t)

# ax, ay, l1, l2, m1, m2, J_C1Z_L1, J_C2Z_L2, M_e1, M_e2, g__ = symbols('ax, ay, l1, l2, m1, m2, J_C1Z_L1, J_C2Z_L2, M_e1, M_e2, g')
# ax, ay ---> coordinates of joint Q
# l1, l2 ---> length of links
# m1, m2 ---> mass of links
# J_C1Z_L1, J_C2Z_L2 ---> moments of inertia of links wrt centre of mass about z-axis
# M_e1, M_e2 ---> external moments on joints
# g ---> gravitational acceleration
ax, ay = 0,0
l1, l2 = 0.1,0.1
m1, m2 = 0.3602528315,0.3602528315
M_e1, M_e2 = 0,0
g__ = 9.80665
J_C1Z_L1, J_C2Z_L2 = 2.3595417611E-05,2.3595417611E-05

# joint positions p1 and p2
p1 = sym.Matrix([[x_P1O_R],[y_P1O_R],[th1]])
p2 = sym.Matrix([[x_P2O_R],[y_P2O_R],[th2]])
p = sym.Matrix([[p1],[p2]])

# constraint position equation
g = sym.Matrix([
        [x_P1O_R - ax + l1 * sym.cos(th1)],
        [y_P1O_R - ay + l1 * sym.sin(th1)],
        [x_P2O_R - ax + l1 * sym.cos(th1) + l2 * sym.cos(th2)],
        [y_P2O_R - ay + l1 * sym.sin(th1) + l2 * sym.sin(th2)],
    ])
#pprint(g)

# constraint jacobian matrix
G = g.jacobian(p)
#pprint(G)

# spatial inertia matrices of links
M1 = sym.Matrix([
        [m1, 0, -0.5 * m1 * l1 * sym.sin(th1)],
        [0, m1, 0.5 * m1 * l1 * sym.cos(th1)],
        [0.5 * m1 * l1 * sym.sin(th1), -0.5 * m1 * l1 * sym.cos(th1), J_C1Z_L1 + 0.25 * m1 * l1 * l1]
    ])
M2 = sym.Matrix([
        [m2, 0, -0.5 * m2 * l2 * sym.sin(th2)],
        [0, m2, 0.5 * m2 * l2 * sym.cos(th2)],
        [0.5 * m2 * l2 * sym.sin(th2), -0.5 * m2 * l2 * sym.cos(th2), J_C2Z_L2 + 0.25 * m2 * l2 * l2]
    ])
(m, n) = M1.shape
M = sym.Matrix([
    [M1, sym.zeros(m,n)],
    [sym.zeros(m,n), M2]
])
#pprint(M)

# constraint acceleration equation: G . p'' = beta(p, p')
th1_ = th1.diff(t)
th2_ = th2.diff(t)
beta = sym.Matrix([
    [l1 * sym.cos(th1) * (th1_**2)],
    [l2 * sym.sin(th1) * (th2_**2)],
    [l1 * sym.cos(th1) * (th1_**2) + l2 * sym.cos(th2) * (th2_**2)],
    [l1 * sym.sin(th1) * (th1_**2) + l2 * sym.sin(th2) * (th2_**2)]
])
#pprint(beta)

# joint forces and torques
A_RL1 = sym.Matrix([
    [sym.cos(th1), -sym.sin(th1), 0],
    [sym.sin(th1), sym.cos(th1), 0],
    [0, 0, 1]
])

A_RL2 = sym.Matrix([
    [sym.cos(th2), -sym.sin(th2), 0],
    [sym.sin(th2), sym.cos(th2), 0],
    [0, 0, 1]
])

F_W1_R = sym.Matrix([[0],[-m1*g__],[0]])
F_W1_L1 = A_RL1.T * F_W1_R

F_W2_R = sym.Matrix([[0],[-m2*g__],[0]])
F_W2_L2 = A_RL2.T * F_W2_R 

M_W1_L1 = sym.Matrix([[0,0,0],[0,0,-l1/2],[0,l1/2,0]]) * F_W1_L1
M_W2_L2 = sym.Matrix([[0,0,0],[0,0,-l1/2],[0,l1/2,0]]) * F_W2_L2

M_e_L1 = sym.Matrix([[0], [0], [M_e1 - M_e2]])
M_e_L2 = sym.Matrix([[0], [0], [M_e2]])

f = sym.Matrix([
    [F_W1_R[0]],
    [F_W1_R[1]],
    [M_e_L1[2] + M_W1_L1[2]],
    [F_W2_R[0]],
    [F_W2_R[1]],
    [M_e_L2[2] + M_W2_L2[2]]
])

qG = sym.Matrix([
    [0.5 * m1 * l1 * sym.cos(th1) * th1_**2],
    [0.5 * m1 * l1 * sym.sin(th1) * th1_**2],
    [0],
    [0.5 * m2 * l2 * sym.cos(th2) * th2_**2],
    [0.5 * m2 * l2 * sym.sin(th2) * th2_**2],
    [0]
])
#pprint(f)

# vector of dependent joint coordinates
p_dep = sym.Matrix([[x_P1O_R], [y_P1O_R], [x_P2O_R], [y_P2O_R]])
#pprint(p_dep)

# vector of independent joint coordinates
p_ind = sym.Matrix([[th1], [th2]])

# explicit constraint position equation
h = sym.Matrix([
    [ax - l1 * sym.cos(th1)],
    [ay - l1 * sym.sin(th1)],
    [th1],
    [ax - l1 * sym.cos(th1) - l2 * sym.cos(th2)],
    [ay - l1 * sym.sin(th1) - l2 * sym.sin(th2)],
    [th2]
])

# explicit constraint jacobian matrix
h_pind = h.jacobian(p_ind)
#pprint(h_pind)

# Global projector J_v
T = sym.Identity(6)
T_ind = sym.Identity(2)
J_v = T.inv() * h_pind * T_ind
#pprint(J_v)

J_v_dot = sym.Derivative(J_v, t, evaluate=True)
#pprint(J_v_dot)

M_ind = sym.simplify(J_v.T * M * J_v)
#pprint(M_ind)

v_ind = sym.Matrix([[th1_], [th2_]])
f_ind = sym.simplify(J_v.T * f - J_v.T * M * J_v_dot * v_ind)
#pprint(f_ind)

qG_ind = sym.simplify(J_v.T * qG)
#pprint(qG_ind)

theta_DDot = sym.simplify(M_ind.inv() * (f_ind + qG_ind))
#print(theta_DDot)

f1 = theta_DDot[0]
f2 = theta_DDot[1]

x1, x2, y1, y2 = sym.symbols('x1 x2 y1 y2')
f1 = f1.subs([(th1_, x2), (th2_, y2)]).subs([(th1, x1), (th2, y1)])
f2 = f2.subs([(th1_, x2), (th2_, y2)]).subs([(th1, x1), (th2, y1)])

# euler's method to numerically solve system to 2nd order coupled ODE
x1_n = [0.0]
x2_n = [0.0]
y1_n = [0.0]
y2_n = [0.0]
z1_n = []
z2_n = []
step = 0.001
time_ = [ i for i in np.arange(0, 2 + step, step) ]
time__ = [ i for i in np.arange(0, 2 + 0.001, 0.001) ]
for j in range(1, len(time_)):
    z1_n = z1_n + [f1.subs([(x1, x1_n[j-1]), (x2, x2_n[j-1]), (y1, y1_n[j-1]), (y2, y2_n[j-1])])]
    z2_n = z2_n + [f2.subs([(x1, x1_n[j-1]), (x2, x2_n[j-1]), (y1, y1_n[j-1]), (y2, y2_n[j-1])])]
    x2_n = x2_n + [x2_n[j-1] + step * z1_n[j-1]] 
    y2_n = y2_n + [y2_n[j-1] + step * z2_n[j-1]] 
    x1_n = x1_n + [x1_n[j-1] + step * x2_n[j-1]] 
    y1_n = y1_n + [y1_n[j-1] + step * y2_n[j-1]] 

z1_n = z1_n + [z1_n[-1]]
z2_n = z2_n + [z2_n[-1]]

# animation
def c(var):
    return np.array([math.cos(i) for i in var])

def s(var):
    return np.array([math.sin(i) for i in var])

x_p1 = ax - l1 * c(x1_n)
y_p1 = ay - l1 * s(x1_n)
x_p2 = ax - l1 * c(x1_n) - l2 * c(y1_n)
y_p2 = ax - l1 * s(x1_n) - l2 * s(y1_n)

from matplotlib.animation import FuncAnimation
from matplotlib.animation import FFMpegWriter

fig, ax = subplots()
gca_ = gca()
ln, = plot([],[], marker='o')

def init():
    ax.set_xlim(-(l1+l2+0.1), (l1+l2+0.1))
    ax.set_ylim(-(l1+l2+0.1), (l1+l2+0.1))
    gca_.set_aspect(1)
    return ln,

def update(i):
    ln.set_data([0, x_p1[i], x_p1[i], x_p2[i]], [0, y_p1[i], y_p1[i], y_p2[i]])
    return ln,

ani = FuncAnimation(fig, update, frames=[i for i in range(0, len(time_))], init_func=init, blit=True)
ani.save('douple_pendulum.mp4', fps=60)

# plot(time_, (ax + x_p1)/2, label='Link 1: CM.Position_X')
# plot(time_, (ay + y_p1)/2, label='Link 1: CM.Position_Y')
# legend()
# show()

# import openpyxl as xl
# Optional Adams center-of-mass comparison workbook from the original project folder.
# ws = wb['manipulator_cm_pos']
# adams_c1_x = np.array([cell[0].value for cell in ws['B2':'B2002']])
# adams_c1_y = np.array([cell[0].value for cell in ws['C2':'C2002']])
# adams_c2_x = np.array([cell[0].value for cell in ws['D2':'D2002']])
# adams_c2_y = np.array([cell[0].value for cell in ws['E2':'E2002']])

# plot(time_, (y_p1 + y_p2)/2, label='LINK2.CM_Position.Y (Python)')
# plot(time__, adams_c2_y, label='LINK2.CM_Position.Y (ADAMS)')
# legend()
# show()