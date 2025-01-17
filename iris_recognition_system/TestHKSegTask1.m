function TestHKSegTask1()

% % Segment from scratch
opts.verbose = 0;
opts.CompDim = 64;
opts.PupilMinSize = 25;
opts.IR = 100;
opts.PR = 30;
opts.ng = 32;
opts.qf = 8;
opts.nt = 12;
opts.nr = 6;
opts.tipo = 0; % VIS = 1 / NIR = 0
opts.format = 'png';


Labels = [];
Features = [];

% ------------------------------- TASK 1 ------------------------------- %

synthetic_dire = 'tasks/task_1/hk_test/synthetic';
vis_dire = 'tasks/task_1/hk_test/VIS';

% making folder t contains normalized iris based on task1 
% image enhancement

res_dire = sprintf(strcat('tasks/task_1/hk_test/synthetic_norm_irises'));
mkdir(res_dire);

n_min_aq = 0;
n_max_aq = 14;

for subj=181:209
    % load all SYNTHETIC IMAGES
    syn_d = dir(sprintf('./%s/%.3d*.%s', synthetic_dire,subj,opts.format));

    % load all VIS IMAGES
    vis_d = dir(sprintf('./%s/%.3d*.%s', vis_dire,subj,opts.format));

    for i=1:size(syn_d,1) 
        synthetic_filename = sprintf('%s/%s', synthetic_dire, syn_d(i).name);
        vis_filename = sprintf('%s/%s', vis_dire, vis_d(i).name);

        ext = strcat('.', opts.format);
        filename_stem = erase(synthetic_filename,ext);
        k = strfind(filename_stem,'_');
        filename_stem_len = length(filename_stem);
        
        n_acq = str2num(filename_stem(k(end)+1:filename_stem_len));

        if  n_acq >= n_min_aq && n_acq <= n_max_aq  

            % extration of the iris region on visible images by performing localization on synthetic images
            [VISRGBIrisImage, SYNRGBIrisImage] = DetectEye_task1(synthetic_filename, vis_filename, opts.tipo, opts);
            
            disp(syn_d(i).name);

            %{
            [SYNFeatures] = DaugmanFeatureExtractor(SYNRGBIrisImage, 0, 0);

            try
                SYNFeatures;
            catch
                continue;
            end

            %}

            nome = syn_d(i).name;
            subid = str2num(nome(1:3));
            subid = 10*subid + double(nome(5)=='L');
            Labels = [Labels; subid];
            
            %Features = [Features; SYNFeatures];
    
    
            nome = strrep(syn_d(i).name, opts.format, 'png');
            imwrite(uint8(255*rescale(VISRGBIrisImage)), sprintf('%s/%s', res_dire, nome));
        end
    end
end

close all;


%[Statistics, DI, DE] = EseguiEsperimento(Features, Labels);

%Statistics
%Statistics.Features = Features;
%Statistics.Labels = Labels;
