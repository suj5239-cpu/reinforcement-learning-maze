# Q-learning Maze in MATLAB

A course project implementing tabular Q-learning in a six-state maze.

Developed for **Introduction to AI**, taught by Prof. Hyunggon Park at **Ewha Womans University, Spring 2026**. The environment and reference Q-table are based on the course’s Chapter 18 reinforcement learning exercise.

## Overview

The project explores how Q-learning updates action values and uses them to select a route to an exit. The current implementation is a single MATLAB script, [`maze_qlearning.m`](maze_qlearning.m), with adjustable learning rate, update count, and random seed.

Each run:

- Initializes a zero Q-table and performs the specified number of updates.
- Prints the learned Q-table.
- Reports the maximum error against the course reference table when `gamma = 0.8`.
- Extracts a greedy route from the selected starting room.
- Displays a Q-table heatmap.

## How to Run

Open `maze_qlearning.m` in MATLAB or upload it to MATLAB Online. Only base MATLAB is required.

Adjust the settings at the top of the script:

```matlab
nUpdates = 1000; % Number of individual Q-value updates
alpha = 0.5;     % Learning rate
gamma = 0.8;     % Discount factor
seed = 42;      % Random seed
startRoom = 3;  % Starting room for route extraction
```

Click **Run**. Each execution resets the Q-table and random seed. The script displays results without automatically saving files.

To compare settings, try `nUpdates = 100` or `1000` and `alpha = 0.1`, `0.5`, or `1.0`. Keeping the seed fixed preserves the sampled transition sequence across learning-rate comparisons. Changing `startRoom` changes the route being evaluated, not the training procedure.

## Learning Procedure

At each update, the script randomly selects a state and one legal action, then applies:

```matlab
target = R(s,a) + gamma * max(Q(a,nextActions));
Q(s,a) = Q(s,a) + alpha * (target - Q(s,a));
```

One update changes one Q-value; it is **not a complete episode**. Unavailable actions are marked by `R = -1` and excluded from both sampling and maximization.

Room 6 is EXIT. Under the course convention, entering EXIT from room 2 or 5 earns 100, and staying at EXIT also earns 100. Training therefore includes transitions from EXIT. With `gamma = 0.8`, its optimal self-loop value is `100 / (1 - 0.8) = 500`.

Route extraction follows the highest-valued legal action and stops upon reaching EXIT or detecting a repeated state. An undertrained policy may fail to reach EXIT.

## Earlier Experiment Results

An earlier implementation compared two update counts and three learning rates across five matched seeds, giving 30 runs.

All recorded runs produced shortest routes from the five non-exit starting rooms, although Q-value errors varied substantially. This illustrates that correct action ordering can produce optimal routes before the Q-values fully converge.

- [Experiment report](docs/experiments.md)
- [Summary data](results/experiments/summary.csv)
- [Individual run data](results/experiments/raw_runs.csv)

These files document the earlier implementation. Commands such as `run_demo`, `run_experiments`, and `test_maze` in that report refer to the previous version and are not available in the current repository.

## Scope

This is a small, deterministic course exercise. Its results do not establish a generally optimal learning rate or performance on larger or stochastic environments.

The reference Q-table comparison applies only to `gamma = 0.8`. The current single-file script has not yet been verified by execution in MATLAB.

## Attribution

The maze and reference Q-table come from the course exercise. Implementation and documentation were prepared with AI assistance. The saved results come from earlier MATLAB runs performed by the project owner. Original lecture slides are not redistributed.
