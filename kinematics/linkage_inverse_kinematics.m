clear
clc

th = [-2.2; -48.38; 1.73; -82.67; 207.36; -84.75; 0; -79.20; 254.89; -31.40; 255.78; 0; -31.41; 0] * pi/180;
result = newtonRaphson(th) * 180/pi;
fprintf("[%d, %d, %d]", mod(result(7),360), mod(result(12), 360), mod(result(14), 360));

function f = constraintVector(th)
    alpha1  = 60.60 * pi/180;
    alpha2  = 64.75 * pi/180;
    alpha3  = 65.55 * pi/180;
    beta1   = 37.76 * pi/180;

    alpha4  = 34.70 * pi/180;

    l_01    = 1.500;
    l_12    = 2.500;
    l_23    = 1.581;
    l_30    = 3.167;
    l_34    = 3.800;
    l_45    = 4.250;
    l_56    = 3.100;
    l_67    = 2.600;
    l_73    = 1.933;
    l_68    = 1.900;
    l_8M    = 2.043;
    l_M7    = 2.928;
    l_59    = 3.300;
    l_910   = 3.000;
    l_10P   = 2.906;
    l_911   = 3.100;
    l_1112  = 1.400;
    l_12P   = 1.880;
    l_1113  = 2.700;
    l_13D   = 1.812;

    l_MP    = 4.500;
    l_PD    = 2.700;

    th_01   = -100.00 * pi/180;      %input
    th_30   = 136.78 * pi/180;
    th_73   = 170.00 * pi/180;
    th_M7   = 119.30 * pi/180;

    %                                            *                                      *               *
    [th_12, th_23, th_45, th_56, th_67, th_68, th_MP, th_59, th_910, th_911, th_1112, th_PD, th_1113, th_DF] = feval(@(x) x{:}, num2cell(th.'));
    f = [
        l_01*cos(th_01) + l_12*cos(th_12) + l_23*cos(th_23) + l_30*cos(th_30);
        l_01*sin(th_01) + l_12*sin(th_12) + l_23*sin(th_23) + l_30*sin(th_30);

        -l_34*cos(th_23-alpha4) + l_45*cos(th_45) + l_56*cos(th_56) + l_67*cos(th_67) + l_73*cos(th_73);
        -l_34*sin(th_23-alpha4) + l_45*sin(th_45) + l_56*sin(th_56) + l_67*sin(th_67) + l_73*sin(th_73);
        
        -l_67*cos(th_67) + l_68*cos(th_68) - l_8M*cos(th_MP+alpha1) + l_M7*cos(th_M7);
        -l_67*sin(th_67) + l_68*sin(th_68) - l_8M*sin(th_MP+alpha1) + l_M7*sin(th_M7);
        
        l_59*cos(th_59) + l_910*cos(th_910) + (l_10P*cos(th_MP-beta1) - l_8M*cos(th_MP+alpha1) - l_MP*cos(th_MP)) - l_68*cos(th_68) - l_56*cos(th_56);
        l_59*sin(th_59) + l_910*sin(th_910) + (l_10P*sin(th_MP-beta1) - l_8M*sin(th_MP+alpha1) - l_MP*sin(th_MP)) - l_68*sin(th_68) - l_56*sin(th_56);
       
        l_911*cos(th_911) + l_1112*cos(th_1112) - l_12P*cos(th_PD+alpha2) - l_10P*cos(th_MP-beta1) - l_910*cos(th_910);
        l_911*sin(th_911) + l_1112*sin(th_1112) - l_12P*sin(th_PD+alpha2) - l_10P*sin(th_MP-beta1) - l_910*sin(th_910);
        
        l_1113*cos(th_1113) - l_13D*cos(th_DF + alpha3) + (l_12P*cos(th_PD+alpha2) - l_PD*cos(th_PD)) - l_1112*cos(th_1112);
        l_1113*sin(th_1113) - l_13D*sin(th_DF + alpha3) + (l_12P*sin(th_PD+alpha2) - l_PD*sin(th_PD)) - l_1112*sin(th_1112);
        
        th_MP - (4/7)*th_PD;
        th_MP - (4/9)*th_DF;
    ];
end

function J = jacobianMatrix(th)
    alpha1  = 60.60 * pi/180;
    alpha2  = 64.75 * pi/180;
    alpha3  = 65.55 * pi/180;
    beta1   = 37.76 * pi/180;

    alpha4  = 34.70 * pi/180;

    l_01    = 1.500;
    l_12    = 2.500;
    l_23    = 1.581;
    l_30    = 3.167;
    l_34    = 3.800;
    l_45    = 4.250;
    l_56    = 3.100;
    l_67    = 2.600;
    l_73    = 1.933;
    l_68    = 1.900;
    l_8M    = 2.043;
    l_M7    = 2.928;
    l_59    = 3.300;
    l_910   = 3.000;
    l_10P   = 2.906;
    l_911   = 3.100;
    l_1112  = 1.400;
    l_12P   = 1.880;
    l_1113  = 2.700;
    l_13D   = 1.812;

    l_MP    = 4.500;
    l_PD    = 2.700;

    th_01   = -100.00 * pi/180;      %input
    th_30   = 136.78 * pi/180;
    th_73   = 170.00 * pi/180;
    th_M7   = 119.30 * pi/180;

    [th_12, th_23, th_45, th_56, th_67, th_68, th_MP, th_59, th_910, th_911, th_1112, th_PD, th_1113, th_DF] = feval(@(x) x{:}, num2cell(th.'));
    J = [
        -l_12*sin(th_12), -l_23*sin(th_23), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        l_12*cos(th_12), l_23*cos(th_23), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        
        0, l_34*sin(th_23-alpha4), -l_45*sin(th_45), -l_56*sin(th_56), -l_67*sin(th_67), 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, -l_34*cos(th_23-alpha4), l_45*cos(th_45), l_56*cos(th_56), l_67*cos(th_67), 0, 0, 0, 0, 0, 0, 0, 0, 0;
        
        0, 0, 0, 0, l_67*sin(th_67), -l_68*sin(th_68), l_8M*sin(th_MP+alpha1), 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, -l_67*cos(th_67), l_68*cos(th_68), -l_8M*cos(th_MP+alpha1), 0, 0, 0, 0, 0, 0, 0;
        
        0, 0, 0, l_56*sin(th_56), 0, l_68*sin(th_68), (-l_10P*sin(th_MP-beta1)+l_8M*sin(th_MP+alpha1)+l_MP*sin(th_MP)), -l_59*sin(th_59), -l_910*sin(th_910), 0, 0, 0, 0, 0;
        0, 0, 0, -l_56*cos(th_56), 0, -l_68*cos(th_68), (l_10P*cos(th_MP-beta1)-l_8M*cos(th_MP+alpha1)-l_MP*cos(th_MP)), l_59*cos(th_59), l_910*cos(th_910), 0, 0, 0, 0, 0;
        
        0, 0, 0, 0, 0, 0, l_10P*sin(th_MP-beta1), 0, l_910*sin(th_910), -l_911*sin(th_911), -l_1112*sin(th_1112), l_12P*sin(th_PD+alpha2), 0, 0;
        0, 0, 0, 0, 0, 0, -l_10P*cos(th_MP-beta1), 0, -l_910*cos(th_910), l_911*cos(th_911), l_1112*cos(th_1112), -l_12P*cos(th_PD+alpha2), 0, 0;
        
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, l_1112*sin(th_1112), (-l_12P*sin(th_PD+alpha2)+l_PD*sin(th_PD)), -l_1113*sin(th_1113), l_13D*sin(th_DF+alpha3);
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -l_1112*cos(th_1112), (l_12P*cos(th_PD+alpha2)-l_PD*cos(th_PD)), l_1113*cos(th_1113), -l_13D*cos(th_DF+alpha3);
        
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, -4/7, 0, 0;
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -4/9;
    ];
end

function X = newtonRaphson(th)
    X0 = th;
    X = X0;
    Xold = X0;
    
    maxIter = 1000;
    tolX = 1e-4;
    
    for i = 1:maxIter
        i
        X = X - jacobianMatrix(X) \ constraintVector(X);
        
        err(:,i) = abs(X - Xold);
        Xold = X;
        if (err(:,i) < tolX)
            break;
        end
    end
end