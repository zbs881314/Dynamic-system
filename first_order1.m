function dydt = first_order1(x)
u = x(1);
y = x(2);
tau = 5;
K = 2.0;
dydt = (-y+K*u)/tau;
end