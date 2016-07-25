# fpnets-classification
Classification of Fixed Point Network Dynamics From Multiple Node Timeseries Data

The repository includes: 
* Benchmark dataset for supervised classification of FP network dynamics (recorded from antennal lobe - olfactory network)
* Code implementing classification and recognition using Exclusive Threshold Reduction and Optimal Exclusive Threshold Reduction
  
Please refer to:  
  Classification of Fixed Point Network Dynamics From Multiple Node Timeseries Data  
  D. Blaszka, E. Sanders, J. Riffell, and E. Shlizerman  
for more information.  
  
The paper has to be cited in any use or modification of the dataset or the code.  
  
The code is written in Matlab and for Optimal Exclusive Threshold Reduction requires the CVX package for convex optimization.  
https://github.com/cvxr/CVX  
  
After install set up CVX in MATLAB as follows:  
addpath /path/to/cvx  
addpath /path/to/cvx/structures  
addpath /path/to/lib  
addpath /path/to/functions  
addpath /path/to/commands  
addpath /path/to/builtins  
cvx_setup  
cvx_solver sdpt3  
  
ICA modes were obtained using:  
  
Higuera A.A.F, Garcia R.A.B., and Bermudez R.V.G. Python version of infomax independent component analysis. https:// github.com/alvarouc/ica/, 2015–2016.

#Dataset
```matlab
18stim_benchmark.mat
```

#Run  
  
For classification space and classifier run:  
```matlab
runClassification  
```
For recognition run:  
```matlab
runClassification_recognition
```
