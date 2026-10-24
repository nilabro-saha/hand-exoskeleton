clear
clc

ans_theta1 = readmatrix('../../data/theta1-inverse-mapping-500x500.xlsx');
ans_theta1_ = readmatrix('../../data/theta1_-inverse-mapping-500x500.xlsx');

steps = 500;
steps2 = 500;

extraInputs = {'interpreter','latex','fontsize',22}; % name, value pairs

shift1 = 2;
shift2 = 5;
shift3 = 2;

query_theta0_min = -56.5331 + shift1;
query_theta0_max = 42.0468 - shift2;

query_theta0__min = -71.1308 + shift3;
query_theta0__max = 31.7320 - shift3;

val_theta0 = linspace(query_theta0_min,query_theta0_max,steps);
val_theta0_ = linspace(query_theta0__min,query_theta0__max,steps2);

x = val_theta0;
y = [];
y1 = [];
for i = 1:steps
    j = steps2;
    while isnan(ans_theta1_(i,j))
        j = j - 1;
    end
    y(i) = val_theta0_(j);
    j = 1;
    while isnan(ans_theta1_(i,j))
        j = j + 1;
    end
    y1(i) = val_theta0_(j);
end

y2 = (y - y1) * (pi/180) * 15;
x2 = x * (pi/180) * 15;
x2 = x2 - x2(1) * ones(size(x2));

%%

q_theta0 = -45;
q_theta0_ = 10;
% xPlane = [q_theta0, q_theta0, q_theta0, q_theta0];
% yPlane = [-70, -70, 30, 30];
% zPlane = [0, 50, 50, 0];

% xPlane2 = [-60, -60, 40, 40];
% yPlane2 = [q_theta0_, q_theta0_, q_theta0_, q_theta0_];
% zPlane2 = [0, 50, 50, 0];

% figure;
% p = mesh(val_theta0, val_theta0_, ans_theta1.');
% hold on
% patch(xPlane, yPlane, zPlane, 'r', 'facealpha', 0.5);
% patch(xPlane2, yPlane2, zPlane2, 'r', 'facealpha', 0.5);
% xlim([query_theta0_min, query_theta0_max]);
% ylim([query_theta0__min, query_theta0__max]);

% zPlane = [-30, 60, 60, -30];
% zPlane2 = [-30, 60, 60, -30];

% figure;
% p = mesh(val_theta0, val_theta0_, ans_theta1_.');
% hold on
% patch(xPlane, yPlane, zPlane, 'r', 'facealpha', 0.5);
% patch(xPlane2, yPlane2, zPlane2, 'r', 'facealpha', 0.5);
% xlim([query_theta0_min, query_theta0_max]);
% ylim([query_theta0__min, query_theta0__max]);

% %%

% figure;
% plot(x2, y2, 'LineWidth', 1.5);
% ylim([0 y2(end)]);
% xlim([x2(1) x2(end)]);

%%

figure;
plot(x, y, x, y1, 'LineWidth', 1.5);
xlim([query_theta0_min, query_theta0_max]);
ylim([query_theta0__min, query_theta0__max]);

%%

lambda = 0;
lambda_ = 0;

previd = 0;
nextid = 0;
previd_ = 0;
nextid_ = 0;

for i = 2:steps
    if val_theta0(i) > q_theta0
        previd = i-1;
        nextid = i;
        lambda = (q_theta0 - val_theta0(i)) / (val_theta0(i-1) - val_theta0(i));
        break;
    end
end

for i = 2:steps2
    if val_theta0_(i) > q_theta0_
        previd_ = i-1;
        nextid_ = i;
        lambda_ = (q_theta0_ - val_theta0_(i)) / (val_theta0_(i-1) - val_theta0_(i));
        break;
    end
end

%%

x1 = val_theta0_;
case1_sim_theta1 = (ans_theta1(previd,:) * lambda + ans_theta1(nextid,:) * (1-lambda));
case1_sim_theta1_ = (ans_theta1_(previd,:) * lambda + ans_theta1_(nextid,:) * (1-lambda));
figure;
plot(x1, case1_sim_theta1, x1, case1_sim_theta1_, 'LineWidth', 1.5);
xlabel('theta0*');
legend({'theta1', 'theta1*'});
title('theta0 const');
%xlim([query_theta0__min, query_theta0__max]);

x2 = val_theta0;
case2_sim_theta1 = (ans_theta1(:,previd_) * lambda_ + ans_theta1(:,nextid_) * (1-lambda_));
case2_sim_theta1_ = (ans_theta1_(:,previd_) * lambda_ + ans_theta1_(:,nextid_) * (1-lambda_));
figure;
plot(x2, case2_sim_theta1, x2, case2_sim_theta1_, 'LineWidth', 1.5);
xlabel('theta0');
legend({'theta1', 'theta1*'});
title('theta0* const');
%xlim([query_theta0_min, query_theta0_max]);

%%

% theta0* constant
figure;
thumb_simulation(case1_sim_theta1, case1_sim_theta1_, [0 -1 0]);

% theta0 constant
figure;
thumb_simulation(case2_sim_theta1.', case2_sim_theta1_.', [0 0 1]);

%view([0 0 1]); % top-view
%view([0 -1 0]); % front-view
%view([-8 -5 5]); % isometric view
%view([0 -0.5 0.5]);
%view([1 0 0]); % right-view
%view([0 1 0]); % back-view