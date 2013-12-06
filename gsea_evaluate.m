function sig = gsea_evaluate(rank)
% GSEA_EVALUATE perform GSEA on a ranked gene list, given the pathway
% information
% 
% input:
%     rank: a structure with ranking information, generated by GSEA_RANKCPCA
%         .gene: cell, the ranked genes
%         .path: cell, the corresponding pathways of the genes
%         .score: vector, ranking score
% output:
%     sig: vector, the multi-comparison adjusted significances (p-values)
%           of each pathway

%% control and global parameters
rng('default'); % control random generator behavior
nPerm = 1000;   % times of permutation
p = 1;

pathList = rank.path(:);            % ranked list of pathways
pathUni  = sort(unique(pathList));  % unique pathway in sorted fashion
scores   = zscore(rank.score(:));
nGene    = length(pathList);

% generate _nPerm_ rows of random pathway sequence from _nGene_ unique pathways
randSeq = zeros(nPerm,nGene);
for i = 1:nPerm
    randSeq(i,:) = randperm(nGene);
end

es = zeros(length(pathUni), nPerm + 1); % enrichment score array
for i = 1:length(pathUni)
    es(i,1) = enrichScore(pathList, pathUni{i});
    for j = 1:nPerm
        es(i,j+1) = enrichScore(pathList(randSeq(j,:)), pathUni{i});
    end
end

for i = 1:length(pathUni)
    sig.(pathUni{i}) = sum(es(i,1) < es(i,2:end))/nPerm;
end


%% nested function
    function es = enrichScore(paths,path)
        % calculate enrichment score given a ranking score distribution
        idx = strcmp(paths,path);
        nh  = sum(idx);
        
        %running score
        rScore = -ones(nGene,1)/(nGene-nh);
        rScore(idx) = ( abs(scores(idx)) .^ p ) /sum(abs(scores(idx)));
        es = max(cumsum(rScore));
    end

end