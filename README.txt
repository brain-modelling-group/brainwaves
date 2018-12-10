MATLAB Code accompanying:

Roberts JA, Gollo LL, Abeysuriya R, Roberts G, Mitchell PB, Woolrich MW, Breakspear M (2018). Metastable brain waves.

Version 20181207 (paper resubmission)


--------------------------------------------
Copyright 2018 James Roberts, QIMR Berghofer

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--------------------------------------------


Dependencies:
-------------

MATLAB
    - tested on R2017a.
    - in principle should work on any OS that MATLAB supports; tested on Windows 7.

Brain Dynamics Toolbox, http://www.bdtoolbox.org/
    - this code has been tested with version 2017c, available at:
      https://github.com/breakspear/bdtoolkit/releases/download/2017c/bdtoolkit-2017c.zip

CNEM, https://m2p.cnrs.fr/sphinxdocs/cnem/index.html
    - used version (v03, 2014-05-04) available here: https://ff-m2p.cnrs.fr/frs/?group_id=14
    - aka cnemlib: https://au.mathworks.com/matlabcentral/linkexchange/links/3875

A connectivity matrix
    - an n-by-n matrix giving the connectivity weights between each pair of n nodes, with zeros on the
      diagonal (no self connections). We normalized the connection weights by the maximum weight (i.e., so
      that max(weights)=1); while not required, it does determine the scale of the global coupling c.


Installation:
-------------

Unzip and add to the MATLAB path. If dependencies are installed the installation time is negligible.


Contents:
---------

brainwaves_sim.m - script to simulate the model, using the Brain Dynamics Toolbox.

cohcorrgram.m - function to calculate the time-windowed cross-correlation between the phase coherences of 
                two groups of nodes (e.g. left hemisphere vs right hemisphere).

corrgram.m - (lightly modified) version of corrgram.m from the MATLAB File Exchange, URL:
             https://au.mathworks.com/matlabcentral/fileexchange/15299-windowed-cross-correlation--corrgram-

phases_nodes.m - helper function to calculate instantaneous phase for all nodes of the network.

phaseflow_cnem.m - function to calculate phase flow (velocity vector field) at all points (uses CNEM).

traceStreamScattered.m - function to calculate streamlines for a velocity vector field sampled at scattered 
                         points in 3-D (uses CNEM).

grad_cnem.m - helper function to calculate gradient for scattered points (uses CNEM).

grad_B_cnem.m - helper function to calculate the B matrix for grad_cnem (uses CNEM).


Instructions/demos:
-------------------

(A) To simulate the model on your connectivity matrix:

Assuming you have a variable normW in the workspace, containing your connectivity matrix, run:

>> brainwaves_sim

Expected output, a 1000 ms run for coupling c=0.6 and delay tau=1 ms, with the V variable sampled with a 
timestep of 1 ms, plotted in a figure (time series plotted for all nodes on the same axes).

To choose your own parameters, edit the parameter definitions in the code as desired.

Runtime ~3 minutes for a 513-node network (dde23 is particularly slow for large networks, may wish to use
a more optimized integrator).


(B) To calculate the interhemispheric cross-correlation function:

Assuming you have time series y in the workspace, where y is an Ntimepoints-by-Nnodes matrix, and you have 
partitioned your network into partitions n1 and n2 (indices of the nodes within each partition), run:

>> CC = cohcorrgram(y,n1,n2);

Expected output:

CC = 

  struct with fields:

      cc: [nlags × nwindows double] - cross-correlation function
      cl: [nlags × 1 double]        - lags
      ct: [nwindows × 1 double]     - window times
    opts: [1×1 struct]
      n1: [1×length(n1) double]
      n2: [1×length(n2) double]

Runtime <1 s for the 1001 × 513 input matrix provided in exampletimeseries.mat.

To plot the output:

>> figure, imagesc(CC.ct,CC.cl,CC.cc), set(gca,'YDir','normal'), colormap jet

For setting options (e.g. time step, window length, etc.), see comments within cohcorrgram.m.


(C) To calculate the phase flow at each region:

Assuming you have time series y in the workspace, where y is an Ntimepoints-by-Nnodes matrix, and you have
the node centroid coordinates loc and the timestep dt, run:

>> yphase = phases_nodes(y);
>> v = phaseflow_cnem(yphase,loc,dt);

Expected output:

v= 

  struct with fields:

   vnormp: [Ntimepoints × nnodes double] - instantaneous speed at each node and time point
      vxp: [Ntimepoints × nnodes double] - x component of velocity at each node and time point
      vyp: [Ntimepoints × nnodes double] - y component of velocity at each node and time point
      vzp: [Ntimepoints × nnodes double] - z component of velocity at each node and time point

Runtime <1 s for the 1001 × 513 input matrix provided in exampletimeseries.mat.


