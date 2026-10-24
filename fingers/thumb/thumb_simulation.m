function sim = thumb_simulation(theta1, theta1_, view_vector)
    len1 = size(theta1);
    len2 = size(theta1_);

    steps = len1(2);
    steps2 = len2(2);

    table = readtable('../../data/linkage_model_data.xlsx');
    params = table2array(table(1:43, 7));

    [l_01, l_12, l_23, l_30, l_24, l_34, l_45, l_56, l_67, l_73, l_68, l_M8, l_MS, l_59, l_910, l_911, l_1112, l_1113, l_MP, l_PD, l_DF, l_810, l_10P, l_P12, l_D13, l_D12, l_F13, h_0, h_3, h_7, alpha1, alpha2, alpha3, alpha4, beta1, l_M0, l_M3, theta_M0, theta_M3, theta_MS, l_7S, l_M10, l_P8] ...
        = feval(@(x) x{:}, num2cell(params.'));

    params = table2array(table(1:19, 12));
    [l_01_, l_12_, l_23_, l_24_, l_34_, l_45_, d_p5_k_, h_0_, h_3_, l_M0_, l_M3_, theta_M0_, theta_M3_, z_p, lk_MP5, lk_PP5] ...
        = feval(@(x) x{:}, num2cell(params.'));

    %e = [2.2,1.6,0.4,1.8,3.6,0.5,0.4,-0.4,1.8,1,-0.6,1.6,1.8,0.2,1.4,0,0];
    %e = [2.2,1.6,0.4,1.8,3.6,2.4,0.4,-0.6,1.8,1,-0.6,4.4,1.8,-0.6,1.4,0.4,1.8];
    e = [2.2,1.6,0.4,1.8,4.8,2.4,0.4,-0.6,2.2,1,-0.6,4.8,2.2,-0.6,1.4,0.4,1.8];

    l_67 = l_67 + e(1);
    l_68 = l_68 + e(2);
    l_56 = l_56 + e(3);
    l_59 = l_59 + e(4);
    l_45_ = l_45_ + e(5);
    l_24_ = l_24_ + e(6);
    l_34_ = l_34_ + e(7);
    l_23_ = l_23_ + e(8);
    l_45 = l_45 + e(9);
    l_910 = l_910 + e(10);
    l_911 = l_911 + e(11);
    l_24 = l_24 + e(12);
    l_34 = l_34 + e(13);
    l_23 = l_23 + e(14);
    l_1112 = l_1112 + e(15);
    l_1113 = l_1113 - e(15);
    l_12 = l_12 + e(16);
    l_12_ = l_12_ + e(17);

    theta2 = (5/4) * theta1;
    theta3 = (1/2) * theta1;

    A = [1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, 1, 0];
    M_h = [0; 0; 0; 1];

    M = [0; 0; 0];
    K_0 = A * (rot(0, theta_M0 * pi/180, 0) * trans(l_M0, 0, 0) * M_h);
    K_3 = A * (rot(0, theta_M3 * pi/180, 0) * trans(l_M3, 0, 0) * M_h);
    S = A * (rot(0, theta_MS * pi/180, 0) * trans(l_MS, 0, 0) * M_h);

    P_0 = A * (rot(0, 0, theta_M0_ * pi/180) * trans(l_M0_, 0, 0) * M_h) + [0; 0; z_p];
    P_3 = A * (rot(0, 0, theta_M3_ * pi/180) * trans(l_M3_, 0, 0) * M_h) + [0; 0; z_p];

    x = [];
    y = [];
    z = [];
    index = 0;

    for i = 1:steps
        if (i == 1) && isnan(theta1(i))
            continue;
        elseif (i > 1) && isnan(theta1(i)) && isnan(theta1(i-1))
            continue;
        elseif isnan(theta1(i))
            break;
        end

        if (i == 1) && isnan(theta1_(i))
            continue;
        elseif (i > 1) && isnan(theta1_(i)) && isnan(theta1_(i-1))
            continue;
        elseif isnan(theta1_(i))
            break;
        end

        thetaMP = theta1(i) * pi/180;
        thetaPD = (theta1(i) + theta2(i)) * pi/180;
        thetaDF = (theta1(i) + theta2(i) + theta3(i)) * pi/180;
        P = -l_MP * [cos(thetaMP); 0; sin(thetaMP)];
        D = P - l_PD * [cos(thetaPD); 0; sin(thetaPD)];
        F = D - l_DF * [cos(thetaDF); 0; sin(thetaDF)];

        K_8 = circle_circle_xz(M, P, l_M8, l_P8, +1);
        K_10 = circle_circle_xz(M, P, l_M10, l_10P, +1);
        K_12 = circle_circle_xz(P, D, l_P12, l_D12, +1);
        K_13 = circle_circle_xz(D, F, l_D13, l_F13, +1);

        K_11 = circle_circle_xz(K_13, K_12, l_1113, l_1112, -1);
        K_9 = circle_circle_xz(K_11, K_10, l_911, l_910, -1);
        
        S_ = A * (rot(0, 0, -theta1_(i) * pi/180) * [S; 1]);
        K_7 = [S_(1) - sqrt(l_7S^2 - S_(2)^2); 0; h_7];

        K_6 = circle_circle_xz(K_7, K_8, l_67, l_68, +1);
        K_5 = circle_circle_xz(K_6, K_9, l_56, l_59, +1);

        P_5p = circle_circle_xz(M, P, lk_MP5, lk_PP5, +1);

        P_5p = A * (rot(0, 0, theta1_(i) * pi/180) * [P_5p; 1]);
        P    = A * (rot(0, 0, theta1_(i) * pi/180) * [P; 1]);
        D    = A * (rot(0, 0, theta1_(i) * pi/180) * [D; 1]);
        F    = A * (rot(0, 0, theta1_(i) * pi/180) * [F; 1]);
        K_5  = A * (rot(0, 0, theta1_(i) * pi/180) * [K_5; 1]);
        K_6  = A * (rot(0, 0, theta1_(i) * pi/180) * [K_6; 1]);
        K_7  = A * (rot(0, 0, theta1_(i) * pi/180) * [K_7; 1]);
        K_8  = A * (rot(0, 0, theta1_(i) * pi/180) * [K_8; 1]);
        K_9  = A * (rot(0, 0, theta1_(i) * pi/180) * [K_9; 1]);
        K_10 = A * (rot(0, 0, theta1_(i) * pi/180) * [K_10; 1]);
        K_11 = A * (rot(0, 0, theta1_(i) * pi/180) * [K_11; 1]);
        K_12 = A * (rot(0, 0, theta1_(i) * pi/180) * [K_12; 1]);
        K_13 = A * (rot(0, 0, theta1_(i) * pi/180) * [K_13; 1]);

        P_5 = P_5p + d_p5_k_ * [-sin(theta1_(i) * pi/180); cos(theta1_(i) * pi/180); 0];

        K_4 = circle_circle_xz([K_5(1); 0; K_5(3)], K_3, sqrt(l_45^2 - K_5(2)^2), l_34, -1);

        K_2 = circle_circle_xz(K_3, K_4, l_23, l_24, +1);
        K_1 = circle_circle_xz(K_0, K_2, l_01, l_12, -1);

        v_10 = K_1 - K_0;
        theta0 = atan2(v_10(3), sqrt(v_10(1)^2 + v_10(2)^2)) * 180/pi;

        P_4 = circle_circle_xy( [P_5(1); P_5(2); 0], P_3, sqrt( l_45_^2 - (z_p-P_5(3))^2 ), l_34_, -1) + [0; 0; z_p];
        P_2 = circle_circle_xy(P_4, P_3, l_24_, l_23_, -1) + [0; 0; z_p];
        P_1 = circle_circle_xy(P_2, P_0, l_12_, l_01_, +1) + [0; 0; z_p];

        v_10_ = P_1 - P_0;
        theta0_ = atan2(v_10_(2), v_10_(1)) * 180/pi;

        if i==1
            fprintf("(%d, %d)\n", theta0, theta0_);
        end

        linkS7   = [S   , K_7];
        linkMP   = [M   , P];
        linkPD   = [P   , D];
        linkDF   = [D   , F];
        linkM8   = [M   , K_8];
        link810  = [K_8 , K_10];
        link10P  = [K_10, P];
        linkP12  = [P   , K_12];
        link12D  = [K_12, D];
        linkD13  = [D   , K_13];
        link13F  = [K_13, F];
        link67   = [K_6 , K_7];
        link68   = [K_6 , K_8];
        link910  = [K_9 , K_10];
        link911  = [K_9 , K_11];
        link1112 = [K_11, K_12];
        link1113 = [K_11, K_13];
        link56   = [K_5 , K_6];
        link59   = [K_5 , K_9];
        link34   = [K_3 , K_4];
        link45   = [K_4 , K_5];
        link23   = [K_2 , K_3];
        link24   = [K_2 , K_4];
        link12   = [K_1 , K_2];
        link01   = [K_0 , K_1];

        link_k_P5 = [P_5p, P_5];
        link_K8_P5p = [K_8, P_5p];
        link_K10_P5p = [K_10, P_5p];
        link45_ = [P_4, P_5];
        link34_ = [P_3, P_4];
        link23_ = [P_2, P_3];
        link24_ = [P_2, P_4];
        link12_ = [P_1, P_2];
        link01_ = [P_0, P_1];

        index = index + 1;
        x(index) = F(1);
        y(index) = F(2);
        z(index) = F(3);

        plot3(linkS7(1, :),   linkS7(2, :),   linkS7(3, :),   '-o', ...
            linkMP(1, :),   linkMP(2, :),   linkMP(3, :),   '-o', ...
            linkPD(1, :),   linkPD(2, :),   linkPD(3, :),   '-o', ...
            linkM8(1, :),   linkM8(2, :),   linkM8(3, :),   '-o', ...
            link810(1, :),  link810(2, :),  link810(3, :),  '-o', ...
            link10P(1, :),  link10P(2, :),  link10P(3, :),  '-o', ...
            linkP12(1, :),  linkP12(2, :),  linkP12(3, :),  '-o', ...
            link12D(1, :),  link12D(2, :),  link12D(3, :),  '-o', ...
            linkD13(1, :),  linkD13(2, :),  linkD13(3, :),  '-o', ...
            link13F(1, :),  link13F(2, :),  link13F(3, :),  '-o', ...
            link67(1, :),   link67(2, :),   link67(3, :),   '-o', ...
            link68(1, :),   link68(2, :),   link68(3, :),   '-o', ...
            link910(1, :),  link910(2, :),  link910(3, :),  '-o', ...
            link911(1, :),  link911(2, :),  link911(3, :),  '-o', ...
            link1112(1, :), link1112(2, :), link1112(3, :), '-o', ...
            link1113(1, :), link1113(2, :), link1113(3, :), '-o', ...
            link56(1, :),   link56(2, :),   link56(3, :),   '-o', ...
            link59(1, :),   link59(2, :),   link59(3, :),   '-o', ...
            link34(1, :),   link34(2, :),   link34(3, :),   '-o', ...
            link45(1, :),   link45(2, :),   link45(3, :),   '-o', ...
            link23(1, :),   link23(2, :),   link23(3, :),   '-o', ...
            link24(1, :),   link24(2, :),   link24(3, :),   '-o', ...
            link12(1, :),   link12(2, :),   link12(3, :),   '-o', ...
            link01(1, :),   link01(2, :),   link01(3, :),   '-o', ...
            linkDF(1, :),   linkDF(2, :),   linkDF(3, :),   '-o', ...
            link45_(1,:),   link45_(2,:),   link45_(3,:),   '-o', ...
            link34_(1,:),   link34_(2,:),   link34_(3,:),   '-o', ...
            link23_(1,:),   link23_(2,:),   link23_(3,:),   '-o', ...
            link24_(1,:),   link24_(2,:),   link24_(3,:),   '-o', ...
            link12_(1,:),   link12_(2,:),   link12_(3,:),   '-o', ...
            link01_(1,:),   link01_(2,:),   link01_(3,:),   '-o', ...
            link_K8_P5p(1,:), link_K8_P5p(2,:), link_K8_P5p(3,:), '-o', ...
            link_K10_P5p(1,:), link_K10_P5p(2,:), link_K10_P5p(3,:), '-o', ...
            link_k_P5(1,:), link_k_P5(2,:), link_k_P5(3,:), '-o', ... 
            x, y, z, '.', 'MarkerSize', 3, 'LineWidth', 1.5  );
        daspect([1 1 1]);
        xlim([-15 5]);
        ylim([-8 8]);
        zlim([-14 12]);

        view(view_vector);

        %view([0 0 1]); % top-view
        %view([0 -1 0]); % front-view
        %view([0 -0.5 0.5]);
        %view([1 0 0]); % right-view
        %view([0 1 0]); % back-view
        if (i == 1)
            pause(4);
        end
        pause(0.001);
    end

function p = circle_circle_xz(p1, p2, l1, l2, sgn)
    % position analysis in xz plane

    % transformation matrix to convert [x; 0; z] to [x; z]
    A = [1, 0, 0; 
         0, 0, 1];
    p1 = A * p1;
    p2 = A * p2;

    R = sqrt( (p2 - p1).' * (p2 - p1) );
    a = (l1^2 - l2^2) / (2 * R^2);
    b = 0.5 * sqrt( 2 * (l1^2+l2^2) / R^2 - (l1^2 - l2^2)^2 / R^4 - 1 );
    
    I = [1, 0; 0, 1];
    B = [0, -1; 1, 0];
    
    p = A.' * (( 0.5*[I, I] + (-a*I + sgn*b*B)*[I, -I] ) * [p1; p2]);

function p = circle_circle_xy(p1, p2, l1, l2, sgn)
    % position analysis in xy plane

    % transformation matrix to convert [x; y; 0] to [x; y]
    A = [1, 0, 0; 0, 1, 0];
    p1 = A * p1;
    p2 = A * p2;

    R = sqrt( (p2 - p1).' * (p2 - p1) );
    a = (l1^2 - l2^2) / (2 * R^2);
    b = 0.5 * sqrt( 2 * (l1^2+l2^2) / R^2 - (l1^2 - l2^2)^2 / R^4 - 1 );
    
    I = [1, 0; 0, 1];
    B = [0, -1; 1, 0];
    
    p = A.' * (( 0.5*[I, I] + (-a*I + sgn*b*B)*[I, -I] ) * [p1; p2]);

function R = rot(deg_x, deg_y, deg_z)
    Rx = [1, 0, 0, 0;
          0, cos(deg_x), -sin(deg_x), 0;
          0, sin(deg_x), cos(deg_x), 0;
          0, 0, 0, 1];
    
    Ry = [cos(deg_y), 0, -sin(deg_y), 0;
          0, 1, 0, 0;
          sin(deg_y), cos(deg_y), 1, 0;
          0, 0, 0, 1];
    
    Rz = [cos(deg_z), -sin(deg_z), 0, 0;
          sin(deg_z), cos(deg_z), 0, 0;
          0, 0, 1, 0;
          0, 0, 0, 1];
    
    R = Rz * Ry * Rx;

function T = trans(trans_x, trans_y, trans_z)
    T = [1, 0, 0, trans_x;
         0, 1, 0, trans_y;
         0, 0, 1, trans_z;
         0, 0, 0, 1];