function [Len] = avg_path_matrix(M)

%a function to compute the average path length of a given matrix
%using the graphallshortestpaths built-in matlab function

%written by Eric Bridgeford
M(M<=0)=0;
n = length(M);
M = sparse(M);
D = floydWarshall(M);

%checks if a node is disconnected from the system, and replaces
%its value with 0
for i = 1:n
    for j = 1:n
        if isinf(D(i,j)) == 1
            D(i,j) = 0;
        end
    end
end

Len = mean(mean(D));
end
