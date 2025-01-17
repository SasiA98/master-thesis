function [Statistics, Features, Labels] = TestMicheSegTask1()

dire = 'tasks/task_1/miche_test';

isis_masks = strcat(dire,'/isis_masks');
isis_unb_masks = strcat(dire,'/isis_unb_masks');
wind_masks = strcat(dire,'/wind_masks');
manual_masks = strcat(dire,'/manual_masks');
dire_dataset = strcat(dire,'/jpg');
SegPerf = [];


count = 0;
for k=1:75
    d = dir(sprintf('./%s/%.3d*.%s', dire_dataset,k,'jpg'));
    for i=1:size(d,1)
            filename = sprintf('%s/%s', dire_dataset, d(i).name);

            %disp(d(i).name);

             % Carichiamo le maschere di segmentazione manuale
            filename_manual_msk = sprintf('%s/%s', manual_masks, strrep(d(i).name, 'jpg', 'png'));
            filename_wind_msk = sprintf('%s/%s', wind_masks, strrep(d(i).name, 'jpg', 'png'));
            filename_isis_msk = sprintf('%s/%s', isis_masks, strrep(d(i).name, 'jpg', 'png'));
            filename_isis_unb_msk = sprintf('%s/%s', isis_unb_masks, strrep(d(i).name, 'jpg', 'png'));


            if  exist(filename_manual_msk,'file') && exist(filename_isis_unb_msk,'file') && exist(filename_wind_msk,'file')  && exist(filename_isis_msk,'file') 
                
                M = imread(filename_manual_msk);
                A = imread(filename_isis_unb_msk);
                
                M = imbinarize(M);
                A = imbinarize(A);

                %C = imbinarize(255-C);
            
                [Performances] = CompareSegmentation(M, A);
                SegPerf = [SegPerf; Performances];
                count = count +1;
            end
    end
end

disp('n acquisitions: ');
disp(count);

disp('Metriche:');
disp('     IoU,      Dice,   Precision,  Recall,    F1 (mean)');
disp(mean(SegPerf));
disp('     IoU,      Dice,   Precision,  Recall,    F1 (std)');
disp(std(SegPerf));

