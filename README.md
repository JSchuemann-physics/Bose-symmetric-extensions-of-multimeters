# Bose symmetric extensions of multimeters
This notebook implements the SDP of Bose symmetric extensions for unitary classes of POVMs, accompanying the master's thesis "Symmetric Extensions and Joint Measurability: Numerical Tests for Infinite Classes of POVMs" by Jonathan Schümann.
The method presented allows one to obtain visibility bounds for POVMs for when they are jointly measurable with all of their unitary transformations. For more information see the master's thesis, in which some details on the numerical implementation are highlighted as well.

As is, this notebook only loads data from computations that were done prior and can be found in ```NOTEBOOK_PATH/data```. Cells with intensive computations have an `if False`-statement at the top. If one wishes to do new computations replace `False` with `True`.

Furthermore, this notebook requires the WolframKernel to be installed. The standard paths for Windows and Linux are set. This can be changed in the Setup section. Moreover, this notebook makes use of the commerical optimization library `mosek`. The path for a license can be set in the Setup section as well. Otherwise use the open-source alternative `cvxopt`.

The code for the random sampling of POVMs and its decomposition into extremal POVMs was written by Esteban Martínez Vargas and was slightly modified for our purposes. The original script can be found [here](https://github.com/estebanmv/Random-Sampling-Extremal-POVMs). Also see their accompanying [paper](https://doi.org/10.1038/s41598-020-65934-w). Their implementation is based on "[Decomposition of any quantum measurement into extremals](https://doi.org/10.1088/1751-8113/46/37/375302)", G. Sentís et. al.  J. Phys. A: Mat. 
Th. Vol 46  Num 37.
