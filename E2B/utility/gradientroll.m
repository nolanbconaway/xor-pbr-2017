function result  = gradientroll(data,operation)
% ------------------------------------------------------------------------
% This script is used to convert vector lists of generalization data into
% gradients that ca be imaged. 4D data is not supported.
% 
% gradientroll(A,'roll') will convert a maxtrix A into a 3D array of
% square gradients, the size of which is determined by sqrt(size(A,1)).
% 
% gradientroll(A,'unroll') will turn a square matrix A (which can be
% stacked in 3D) into a vector or matrix list of vectors.
% ------------------------------------------------------------------------

% convert matrix into vector
	if strcmp(operation,'unroll')
		ngradients = size(data,3);
		nelements = size(data,1) * size(data,2);
		
		result = rot90(data,3);
		result=reshape(result,[nelements,ngradients]);
		
% 	convert a vector into a set of 2d matrices
	elseif strcmp(operation,'roll')
		side = sqrt(size(data,1));
		ngradients = size(data,2);
		
		result=rot90(reshape(data,[side,side,ngradients]));
	end
end
