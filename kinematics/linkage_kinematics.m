clear
clc



alpha1  = 60.60 * pi/180;
alpha2  = 64.75 * pi/180;
alpha3  = 65.55 * pi/180;
beta1   = 37.76 * pi/180;
alpha4  = 34.70 * pi/180;

e = 0.3;
e2 = 0.2;
l_01 = 1.500 + e;
l_12 = 2.500 + e;
l_23 = 1.581;
l_24 = 2.6868;
l_34 = 3.800;
l_45 = 4.250;
l_56 = 3.100 + e2;
l_67 = 2.600 + e2;
l_68 = 1.900 + e2;
l_59 = 3.300;
l_910 = 3.000;
l_911 = 3.100;
l_1112 = 1.400;
l_1113 = 2.700;

l_MP = 4.500;
l_PD = 2.700;
l_DF = 2.6513;

l_M8 = 2.043;
l_810 = 1.1842;
l_10P = 2.906;
l_P12 = 1.880;
l_D13 = 1.812;

steps = 100;
theta0 = [];

theta1_max = -107;
theta1 = linspace(0, theta1_max, steps);
theta2 = linspace(0, theta1_max * 3/4, steps);
theta3 = linspace(0, theta1_max * 2/4, steps);

% theta1 = -30*sin(linspace(0, 30, steps));
% theta2 = -30*cos(linspace(0, -30, steps));
% theta3 = -30*sin(linspace(0, -30, steps));

M = [0; 0];
K_0 = R(138.52 * pi/180) * [7.6897; 0];
K_3 = R(139.72 * pi/180) * [4.4022; 0];
K_7 = R(120.86 * pi/180) * [2.8857; 0];

for i = 1:steps
    T_MP = T(theta1(i) * pi/180, l_MP);
    T_PD = T(theta2(i) * pi/180, l_PD);
    T_DF = T(theta3(i) * pi/180, l_DF);
    
    K = [1, 0, 0, 0; 0, 1, 0, 0];
    P = K * T_MP * [0; 0; 0; 1];
    D = K * T_MP * T_PD * [0; 0; 0; 1];
    F = K * T_MP * T_PD * T_DF * [0; 0; 0; 1];
    
    K_8 = (l_M8/l_MP) * R(alpha1) * (P - M) + M;
    K_10 = (l_10P/l_MP) * R(-beta1) * (M - P) + P;
    K_12 = (l_P12/l_PD) * R(alpha2) * (D - P) + P;
    K_13 = (l_D13/l_DF) * R(alpha3) * (F - D) + D;
    
    K_11 = position_analysis(K_13, K_12, l_1113, l_1112, +1);
    K_9 = position_analysis(K_11, K_10, l_911, l_910, +1);
    K_6 = position_analysis(K_7, K_8, l_67, l_68, -1);
    K_5 = position_analysis(K_6, K_9, l_56, l_59, -1);
    K_4 = position_analysis(K_5, K_3, l_45, l_34, +1);
    
    K_2 = (l_23/l_34) * R(alpha4) * (K_4 - K_3) + K_3;
    K_1 = position_analysis(K_0, K_2, l_01, l_12, +1);
    
    v_10 = K_1 - K_0;
    theta0(i) = atan2(v_10(2), v_10(1)) * 180/pi;
    
    linkMP = [M, P];
    linkPD = [P, D];
    linkDF = [D, F];
    linkM8 = [M, K_8];
    link810 = [K_8, K_10];
    link10P = [K_10, P];
    linkP12 = [P, K_12];
    link12D = [K_12, D];
    linkD13 = [D, K_13];
    link13F = [K_13, F];
    link67 = [K_6, K_7];
    link68 = [K_6, K_8];
    link910 = [K_9, K_10];
    link911 = [K_9, K_11];
    link1112 = [K_11, K_12];
    link1113 = [K_11, K_13];
    link56 = [K_5, K_6];
    link59 = [K_5, K_9];
    link34 = [K_3, K_4];
    link45 = [K_4, K_5];
    link23 = [K_2, K_3];
    link24 = [K_2, K_4];
    link12 = [K_1, K_2];
    link01 = [K_0, K_1];

    plot(linkMP(1, :), linkMP(2, :), ...
        linkPD(1, :), linkPD(2, :), ...
        linkM8(1, :), linkM8(2, :), ...
        link810(1, :), link810(2, :), ...
        link10P(1, :), link10P(2, :), ...
        linkP12(1, :), linkP12(2, :), ...
        link12D(1, :), link12D(2, :), ...
        linkD13(1, :), linkD13(2, :), ...
        link13F(1, :), link13F(2, :), ...
        link67(1, :), link67(2, :), ...
        link68(1, :), link68(2, :), ...
        link910(1, :), link910(2, :), ...
        link911(1, :), link911(2, :), ...
        link1112(1, :), link1112(2, :), ...
        link1113(1, :), link1113(2, :), ...
        link56(1, :), link56(2, :), ...
        link59(1, :), link59(2, :), ...
        link34(1, :), link34(2, :), ...
        link45(1, :), link45(2, :), ...
        link23(1, :), link23(2, :), ...
        link24(1, :), link24(2, :), ...
        link12(1, :), link12(2, :), ...
        link01(1, :), link01(2, :), ...
        linkDF(1, :), linkDF(2, :));
    xlim([-8 12]);
    ylim([-10 8]);
    pause(0.02);
end

theta0_ = theta0.';
theta1_ = theta1.';
theta0(8)
theta1(8)
theta2(8)
theta3(8)
%plot(1:steps, theta0, 1:steps, theta1, 1:steps, theta2, 1:steps, theta3);

fprintf("Available range for theta0: [%d, %d]\n", theta0(1), theta0(steps));

% val_theta0 = -47.9;
% for i=1:steps
%     if theta0(i+1) > val_theta0
%         break;
%     end
% end

% prev = theta0(i);
% next = theta0(i+1);
% lambda = (val_theta0 - next) / (prev - next);

% val_theta1 = lambda * theta1(i) + (1 - lambda) * theta1(i+1);
% val_theta2 = lambda * theta2(i) + (1 - lambda) * theta2(i+1);
% val_theta3 = lambda * theta3(i) + (1 - lambda) * theta3(i+1);

% fprintf("theta0 = %d    => [theta1 = %d, theta2 = %d, theta3 = %d]\n", val_theta0, val_theta1, val_theta2, val_theta3);

% val_thetaMP = val_theta1;
% val_thetaPD = val_thetaMP + val_theta2;
% val_thetaDF = val_thetaPD + val_theta3;

% fprintf("               => [thetaMP = %d, thetaPD = %d, thetaDF = %d]\n", val_thetaMP, val_thetaPD, val_thetaDF);
% fprintf("ratio: thetaDF/thetaMP = %d, thetaPD/thetaMP = %d\n", val_thetaDF/val_thetaMP, val_thetaPD/val_thetaMP);

function M = R(angle)
    M = [ cos(angle), -sin(angle);
          sin(angle), cos(angle) ];
end

function p = position_analysis(p1, p2, l1, l2, sgn)
    R = sqrt( (p2 - p1).' * (p2 - p1) );
    a = (l1^2 - l2^2) / (2 * R^2);
    b = 0.5 * sqrt( 2 * (l1^2+l2^2) / R^2 - (l1^2 - l2^2)^2 / R^4 - 1 );
    
    I = [1, 0; 0, 1];
    B = [0, -1; 1, 0];
    
    p = ( 0.5*[I, I] + (-a*I + sgn*b*B)*[I, -I] ) * [p1; p2];
end

function p_dot = velocity_analysis(p1, p2, p3, p1_dot, p2_dot)
    P = [ (p3 - p1).' ; (p3 - p2).' ];
    p_dot = P \ [ (p3 - p1).' * p1_dot ; (p3 - p2).' * p2_dot ];
end

function p_ddot = acceleration_analysis(p1, p2, p3, p1_dot, p2_dot, p3_dot, p1_ddot, p2_ddot)
    P = [ (p3 - p1).' ; (p3 - p2).' ];
    q = [ (p3-p1).' * p1_ddot - (p3_dot-p1_dot).' * (p3_dot-p1_dot);
          (p3-p2).' * p2_ddot - (p3-dot-p2_dot).' * (p3_dot-p2_dot) ];
    p_ddot = P \ q;
end

function transf = T(angle, distance)
    transf = [ cos(angle), -sin(angle), 0, distance * cos(angle);
               sin(angle), cos(angle), 0, distance * sin(angle);
               0, 0, 1, 0;
               0, 0, 0, 1 ];
end