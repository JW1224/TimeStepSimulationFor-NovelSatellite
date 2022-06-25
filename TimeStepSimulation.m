clc
clear
%All angular parameters in using minutes eg rad/min & rad/min^2
found = 1;
T_prod_array_x = [];
T_prod_array_y = [];
wcurf_array_x = [];
wcurf_array_y = [];

%Satellite Stats
ms = 330911.977; %kg
rs = 84.9706; %m
wcurs = [0,0]; %Initial w
Ixs = 0.25*ms*(rs^2);
Angle = 0;
angle_after_stage1 = [0,0];

%Flywheel Stats
density_wheel = 2810; %kg/m3
thickness_wheel = 0.1; %m
rf = 2.5; %m
mf = density_wheel*(pi*(rf^2)*thickness_wheel); %kg
Ixf = 0.25*mf*(rf^2);
wcurf = [0,0];


%Sun
wsun = [0.005236,0];  %rad/s
tmax = 800;        %s   
Td_initial = 10^-5;

%Other parameters
wcurs_array_x = [];
wcurs_array_y = [];
Td_array_x = [];
Td_array_y = [];
T_max = 0;
T_min = 0;


for t = 0:1:tmax
    a_req = wsun-wcurs;
    Td = [Td_initial*sin(t),Td_initial*sin(t+90)];
    T_req = (a_req.*Ixs)+Td;
    
    Tf = T_req./2;
    af = Tf./Ixf;
    wf = af + wcurf; %Change in time = 1s therefore a = w
    wcurf = wf;
    Ek = (abs(af).*(af))*(Ixf/2);
    
    if Ek(1) > 560000
        Ek(1) = 560000;
    elseif Ek(1) < -560000
        Ek(1) = -560000;
    end
    if Ek(2) > 560000
        Ek(2) = 560000;
    elseif Ek(2) < -560000
        Ek(2) = -560000;
    end
    
    signs = ((Ek/(Ixf/2))./abs(Ek/(Ixf/2)));
    w_prod = (abs(Ek/(Ixf/2)).^(0.5)).*signs;
    a_prod = w_prod;
    T_prod = a_prod*Ixf;
    T_prod_s = T_prod.*2;
    a_prod_s = T_prod_s/Ixs;

    wcurs = wcurs + a_prod_s;
    wcurs_array_x = [wcurs_array_x,wcurs(1)];
    wcurs_array_y = [wcurs_array_y,wcurs(2)];
    wcurf_array_x = [wcurf_array_x,w_prod(1)];
    wcurf_array_y = [wcurf_array_y,w_prod(2)];
    T_prod_array_x = [T_prod_array_x,T_prod(1)];
    T_prod_array_y = [T_prod_array_y,T_prod(2)];
    
    if T_prod_s > T_max
        T_max = T_prod_s;
    elseif T_prod_s < T_min
        T_min = T_prod_s;
    end
    Angle = Angle+wcurs;
    if abs(a_req(1)) < 0.1 && found == 1
        angle_after_stage1 = Angle;
        found = 0;
    end
    if (Angle(1)+angle_after_stage1(1)) > 3.139 && (Angle(1)+angle_after_stage1(1)) < 3.141
        wsun = [0,0];
    end
end

xaxis = 0:1:length(wcurs_array_x)-1;
xaxis2 = 0:1:length(Td_array_x)-1;

figure(1)
plot(xaxis,wcurs_array_x)
title("Angular Velocity in the x axis")
xlabel("Time s")
ylabel("Angular Velocity rad/s")

figure(2)
plot(xaxis,wcurs_array_y)
title("Angular Velocity in the y axis")
xlabel("Time s")
ylabel("Angular Velocity rad/s")

figure(3)
plot(xaxis,T_prod_array_x)
title("Reaction wheel Torque in the x axis")
xlabel("Time s")
ylabel("Torque Nm")

figure(4)
plot(xaxis,T_prod_array_y)
title("Reaction wheel Torque in the y axis")
xlabel("Time s")
ylabel("Torque Nm")

figure(5)
plot(xaxis,wcurf_array_x)
title("Reaction wheel angular velocity in the x axis")
xlabel("Time s")
ylabel("Angular Velocity rad/s")

figure(6)
plot(xaxis,wcurf_array_y)
title("Reaction wheel angular velocity in the y axis")
xlabel("Time s")
ylabel("Angular Velocity rad/s")

