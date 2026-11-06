%% Q-learning maze: change the settings and run one experiment at a time
clear; clc;

%% 1. Settings
nUpdates = 1000; % Try 100 or 1000
alpha = 0.5;     % Try 0.1, 0.5, or 1.0
gamma = 0.8;
seed = 42;      % Keep fixed when comparing settings
startRoom = 3;
rng(seed, 'twister');

%% 2. Reward matrix: row = current room, column = next room
% -1 = unavailable move; room 6 = EXIT.
% This is the lecture model: staying at EXIT also gives reward 100.
R = [-1 -1 -1 -1   0  -1;
     -1 -1 -1  0  -1 100;
     -1 -1 -1  0  -1  -1;
     -1  0  0 -1   0  -1;
      0 -1 -1  0  -1 100;
     -1  0 -1 -1   0 100];
Q = zeros(6);

%% 3. Learning: one iteration updates one Q-value
for k = 1:nUpdates
    s = randi(6);
    actions = find(R(s,:) >= 0);
    a = actions(randi(length(actions)));
    nextActions = find(R(a,:) >= 0);
    target = R(s,a) + gamma * max(Q(a,nextActions));
    Q(s,a) = Q(s,a) + alpha * (target - Q(s,a));
end
disp('Learned Q-table:');
disp(Q);

%% 4. Compare with the lecture's exact answer (valid for gamma = 0.8)
Qstar = [0 0 0 0 400 0; 0 0 0 320 0 500; 0 0 0 320 0 0;
         0 400 256 0 400 0; 320 0 0 320 0 500; 0 400 0 0 400 500];
if gamma == 0.8
    maxQError = max(abs(Q(R >= 0) - Qstar(R >= 0)));
    fprintf('Updates: %d, alpha: %.1f, max Q error: %.6g\n', ...
        nUpdates, alpha, maxQError);
end

%% 5. Follow the best learned action from startRoom
s = startRoom;
path = s;
for k = 1:6
    if s == 6, break; end
    actions = find(R(s,:) >= 0);
    values = Q(s,actions);
    % When values tie, select the lowest room number.
    s = actions(find(abs(values - max(values)) <= 1e-8, 1));
    repeated = any(path == s);
    path(end+1) = s;
    if repeated, break; end % Stop instead of looping forever.
end
disp('Greedy route (6 = EXIT):');
disp(path);
if path(end) ~= 6
    disp('The learned route did not reach EXIT. Try more updates.');
end

%% 6. View the learned Q-table
Qplot = Q;
Qplot(R < 0) = NaN; % Hide unavailable moves.
labels = {'1','2','3','4','5','EXIT'};
figure;
h = heatmap(labels, labels, Qplot);
h.Title = sprintf('%d updates, alpha = %.1f', nUpdates, alpha);
h.XLabel = 'Next room (action)';
h.YLabel = 'Current room';
