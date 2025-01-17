function [Statistics, Features, Labels] = TestHKRecTask2NTask3NFinalAssessment(approach)

dire = 'tasks/task_2Ntask_3NFinal_Assessment/hk_test/synthetic/';

% approach = 1 : evaluation through matrices (task 2 or task 3)
% approach = 2 : evaluation through images (task 2, but deprecated)

verbose = 0;

opts.format = 'png';
if approach == 1
    opts.format = 'mat';
end

Labels = [];
SubjFeatures = [];

n_min_aq = 0;
n_max_aq = 14;

hw = waitbar(0,'Extracting Features...');

for subj=181:209
    d = dir(sprintf('./%s/%.3d*.%s', dire,subj,opts.format));

    for i=1:size(d,1) 
            
            filename = sprintf('%s/%s', dire, d(i).name);
            
            ext = strcat('.', opts.format);
            filename_stem = erase(filename,ext);
            k = strfind(filename_stem,'_');
            filename_stem_len = length(filename_stem);
            
            n_acq = str2num(filename_stem(k(end)+1:filename_stem_len));

            if  n_acq >= n_min_aq && n_acq <= n_max_aq  

                [Features] = DaugmanFeatureExtractor(filename, approach, verbose);
        
                disp(d(i).name);

                try
                    Features;
                catch
                    continue;
                end
    
                nome = d(i).name;
                subid = str2num(nome(1:3));
                subid = 10*subid + double(nome(5)=='L');
                Labels = [Labels; subid];
                SubjFeatures = [SubjFeatures; Features];
        
                waitbar(subj/209,hw,'Extracting Features');
            
            end
    end
end


close(hw);

close all;
[Statistics, DI, DE] = EseguiEsperimento(SubjFeatures, Labels);

Statistics
Statistics.Features = Features;
Statistics.Labels = Labels;

