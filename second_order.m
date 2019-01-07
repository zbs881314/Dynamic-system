function dxdt = second_order(x)
u = x(1);
y = x(2);
z = x(3);
tau = 5;
K = 2.0;
dydt = (-y+K*u)/tau;
dzdt = (-z+y)/tau;
dxdt(1) = dydt;
dxdt(2) = dzdt;
end