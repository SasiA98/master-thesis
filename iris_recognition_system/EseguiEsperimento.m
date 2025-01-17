function [Statistics, DI, DE] = EseguiEsperimento(Features, Labels)

DI = 0;
DE = 0;
cnt_i = 0;
cnt_e = 0;

Features(isnan(Features(:)))=0;

for i=1:length(Labels)
    for j=i+1:length(Labels)
        if(Labels(i) == Labels(j))
            cnt_i = cnt_i + 1;
            DI(cnt_i) = pdist2(Features(i,:), Features(j,:));%, 'correlation');
%             DI(cnt_i) = gethammingdistance(Features(i,:), 0*Features(i,:), Features(j,:), 0*Features(j,:), 1);
        else
            cnt_e = cnt_e + 1;
            DE(cnt_e) = pdist2(Features(i,:), Features(j,:));%, 'correlation');
%             DE(cnt_e) = gethammingdistance(Features(i,:), 0*Features(i,:), Features(j,:), 0*Features(j,:), 1);
        end
    end
%     decidability = abs(mean(DI) - mean(DE))/sqrt(0.5*(std(DI)^2 + std(DE)^2));
%     figure(1005);
%     clf;
%     subplot(1,2,1)
%     hold on;
%     [he,x] = hist(DE,50);
%     plot(x, he/max(he), 'r');
%     [hi,x] = hist(DI,50);
%     plot(x, hi/max(hi), 'g');
%     %         axis([0 1 0 1.2*max([he, hi])]);
%     subplot(1,2,2)
%     bar(10, decidability);
end

mv=max(max(DI(:)),max(DE(:)));
DI=DI./mv;
DE=DE./mv;

Statistics = struct;

DI(isnan(DI(:)))=0;
DE(isnan(DE(:)))=0;
Statistics.decidability = abs(mean(DI) - mean(DE))/sqrt(0.5*(std(DI)^2 + std(DE)^2));

FAR = [];
GAR = [];
cnt = 0;
for th=min([DI,DE]):0.05:max([DI,DE])
    cnt=cnt+1;
    FAR(cnt) = sum(DE<th)/length(DE);
    GAR(cnt) = sum(DI<th)/length(DI);
end

Statistics.GAR = GAR;
Statistics.FAR = FAR;

t = abs(FAR+GAR-1);
t = find(t==min(t),1);
Statistics.EER = FAR(t);

figure(1);
hold on
grid on
plot(FAR, GAR, 'r*-');
xlabel('FAR');
ylabel('GAR');
title('ROC curve');