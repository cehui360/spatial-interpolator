The data and code for the manuscript: Terrain breakline-aware smoothing interpolation for producing high-accuracy digital elevation models from LiDAR data.
We share the publicly available airborne LiDAR benchmark dataset, provided by the International Society for Photogrammetry and Remote Sensing (ISPRS) (../spatial-interpolator/ISPRS_data) for demonstration purposes.
A step-by-step instruction titled 'Instruction for model.docx' is provided (../spatial-interpolator/Instruction for model.docx), utilizing the ISPRS dataset to illustrate expected findings. 

1.Environments: 
-MATLAB R2022a

2.Description of data files:
In folder '../spatial-interpolator/ISPRS_data/':
- 's_ _.txt': ISPRS dataset.
- 's_ _-modeling.txt': 90% of the data was used for generating DEMs.
- 's_ _-checking.txt': 10% of the data was utilized to evaluate the accuracy of the DEMs.
Notice: Each row in the above tables represents x-coordinate, y-coordinate, and z-coordinate.

3.Description of codes: The code for model is stored in the '../spatial-interpolator/code' folder. 
-MCS.m: Code for calculating the normals and curvatures.
-calculateODs.m: Code for calculating the orthogonal distance from the point to the plane.
-triple_kernalCompute.m: Code for computing the trilateral kernel function.
-quadruple_kernalCompute.m: Code for computing the quadrilateral kernel function.
-triple_predictLocal.m: Code for estimating the elevations of all DEM grid cells by the trilateral kernel function.
-quadruple_predictLocal.m: Code for estimating the elevations of all DEM grid cells by the quadrilateral kernel function.
-saveFile.m: Code for saving the output file.
-'main.m': Code for starting the proposed method.


