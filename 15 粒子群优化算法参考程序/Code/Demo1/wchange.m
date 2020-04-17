ws = 0.9;
we = 0.4;
maxgen = 300;
hold on;

for k = 1:maxgen
    w(k) = ws - (ws-we)*(k/maxgen);
end
plot(w,'linewidth',1.5);

for k = 1:maxgen
    w(k) = ws - (ws-we)*(k/maxgen)^2;
end
plot(w,'r-.','linewidth',1.5);

for k = 1:maxgen
    w(k) = ws - (ws-we)*(2*k/maxgen-(k/maxgen)^2);
end
plot(w,'g:','linewidth',1.5);

for k = 1:maxgen
    w(k) = we * (ws/we)^(1/(1+10*k/maxgen));
end
plot(w,'y--','linewidth',1.5);

legend('Rule-1','Rule-2','Rule-3','Rule-4')
xlabel('迭代次数')
ylabel('速度更新权重W')