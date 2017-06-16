function out = ind2subVect (siz,ndx)

[out{1:length(siz)}] = ind2sub(siz,ndx);
% out = cell2mat(cellfun(@(x) x',out,'UniformOutput',false));
out = cell2mat(cellfun(@transpose,out,'UniformOutput',false));