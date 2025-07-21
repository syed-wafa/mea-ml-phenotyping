% This code is from Dingle et al. 2020 iScience (DOI: 10.1016/
% j.isci.2020.101434). Code was modified for MEA analysis.

function metrics = calculate_graph_metrics(A)

%Outputs:
% 1) FinalTableNetworkData= A table summirizing the following parameters:
% N= number of nodes;
% Modularity= modularity value;
% numberModules= total number of modules;
% AverageEdgeWeight= the mean edge weight of the matrix;
% net_clus= average clustering coeficient;
% net_path= average path length;

%2)NodeDegree=A table summirizing:
% First column= the node index;
% Second column= the number of nodes that composes the modules.

% 3)ModulesComposition= A table summirizing:
% First column= the module index;
% Second column= average edge weight of the node.

%Required Codes:
% 1) avg_clus_matrix.m= a function to compute the average clusteirng coefficient for a input matrix M;
%written by Eric Bridgeford; Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057

% 2) avg_path_matrix.m = a function to compute the average path length of a given matrix using the graphallshortestpaths built-in matlab function;
%written by Eric Bridgeford;Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057  

% 3) clustering_coef_matrix.m = a modification of the clustering coefficient function provided in the brain connectivity toolbox; 
% code originally written by Mika Rubinov, UNSW, 2007-2010; modified/written by Eric Bridgeford; Muldoon, S., Bridgeford, E. & Bassett, D. Small-World Propensity and Weighted Brain Networks. Sci Rep 6, 22057 (2016). https://doi.org/10.1038/srep22057                                                                                                                                                    

%written by Mattia Bonzanni and Yu-Ting Dingle;
%Reference:
  
N=length(A);                                        %number of vertices
Degree=transpose(mean(A)*N/(N-1));                  %the average edge weight of each node in the matrix
Column=transpose([1:N]);                            %node index Nx1 vector
NodeDegree= horzcat(Column,Degree);                 %first column node index; second column edge weight
AverageEdgeWeight = mean(Degree);                   %the mean edge weight of the matrix
%% Modularity
% Algorithm: Newman's spectral optimization method:
% References: Newman (2006) -- Phys Rev E 74:036104; PNAS 23:8577-8582.
K=sum(A);                               %degree
m=sum(K);                               %number of edges
B=A-(K.'*K)/m;                          %modularity matrix
Ci=ones(N,1);                           %community indices
cn=1;                                   %number of communities
U=[1 0];                                %array of unexamined communites

ind=1:N;
Bg=B;
Ng=N;

while U(1)                              %examine community U(1)
    [V D]=eig(Bg);
    [d1 i1]=max(diag(D));               %most positive eigenvalue of Bg
    v1=V(:,i1);                         %corresponding eigenvector

    S=ones(Ng,1);
    S(v1<0)=-1;
    q=S.'*Bg*S;                         %contribution to modularity

    if q>1e-10                       	%contribution positive: U(1) is divisible
        qmax=q;                         %maximal contribution to modularity
        Bg(logical(eye(Ng)))=0;      	%Bg is modified, to enable fine-tuning
        indg=ones(Ng,1);                %array of unmoved indices
        Sit=S;
        while any(indg);                %iterative fine-tuning
            Qit=qmax-4*Sit.*(Bg*Sit); 	%this line is equivalent to:
            qmax=max(Qit.*indg);        %for i=1:Ng
            imax=(Qit==qmax);           %	Sit(i)=-Sit(i);
            Sit(imax)=-Sit(imax);       %	Qit(i)=Sit.'*Bg*Sit;
            indg(imax)=nan;             %	Sit(i)=-Sit(i);
            if qmax>q;                  %end
                q=qmax;
                S=Sit;
            end
        end

        if abs(sum(S))==Ng              %unsuccessful splitting of U(1)
            U(1)=[];
        else
            cn=cn+1;
            Ci(ind(S==1))=U(1);         %split old U(1) into new U(1) and into cn
            Ci(ind(S==-1))=cn;
            U=[cn U];
        end
    else                                %contribution nonpositive: U(1) is indivisible
        U(1)=[];
    end

    ind=find(Ci==U(1));                 %indices of unexamined community U(1)
    bg=B(ind,ind);
    Bg=bg-diag(sum(bg));                %modularity matrix for U(1)
    Ng=length(ind);                     %number of vertices in U(1)
end
s=Ci(:,ones(1,N));                      %compute modularity
Q=~(s-s.').*B/m;
Q=sum(Q(:));
Modularity=Q;

%% Module Composition
numberModules = length(unique(Ci(:,1)));                    %to count the number of modules 
TableModulesComposition=cell(numberModules,2);              %to preallocate the variable ModulesComposition
for i=1:numberModules
    Module=length(transpose(find((Ci==i))));                %to find how many elements in Ci are equal to i
    TableModulesComposition (i,:) = {i Module};             %to compile the table
end
ModulesComposition = cell2mat(TableModulesComposition);     %Output
 %% Average Path length
%net_path = avg_path_matrix(1./A);          % average path of the network

%% Calculate clustering coefficient using Onnela method (Onnela et al., Phys. Rev. E71, 065103(R)(2005))
W = A;
W(W<=0) = 0;
n = length(W);
K=sum(W~=0,2);
W = double(W);
W2 = W/max(max(W));
cyc3=diag(W2.^(1/3)^3);
K(cyc3==0)=inf;             %if no 3-cycles exist, make C=0 (via K=inf)
C=cyc3./(K.*(K-1));
net_clus = nanmean(C);

 %% Create Final Tables
FinalTableNetworkData= table(N,Modularity,numberModules,AverageEdgeWeight,net_clus); %Output

metrics.FinalTableNetworkData = FinalTableNetworkData;
metrics.NodeDegree = NodeDegree;
metrics.ModulesComposition = ModulesComposition;

end