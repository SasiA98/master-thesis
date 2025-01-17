function [Performances] = CompareSegmentation(A, B)
    % Assicurati che le immagini di ingresso A e B siano binarie e abbiano le stesse dimensioni
    assert(isequal(size(A), size(B)), 'Le dimensioni delle immagini devono coincidere.');
    assert(islogical(A) && islogical(B), 'Le immagini devono essere binarie.');

    % Calcola l'intersezione e l'unione delle due immagini
    intersection = sum(sum(A & B));
    unionAB = sum(sum(A | B));

    % Intersection over Union
    IoU = intersection / unionAB;

    % Dice Coefficient
    Dice = (2 * intersection) / (sum(A(:)) + sum(B(:)));

    % Precision, Recall, and F1-Score
    TP = intersection; % True Positives
    FP = sum(B(:)) - TP; % False Positives
    FN = sum(A(:)) - TP; % False Negatives
    Precision = TP / (TP + FP);
    Recall = TP / (TP + FN);
    F1 = (2 * Precision * Recall) / (Precision + Recall);

%     % Mean Absolute Distance (MAD)
%     [x_A, y_A] = find(A);
%     [x_B, y_B] = find(B);
%     dists = zeros(length(x_A), 1);
%     for i = 1:length(x_A)
%         dists(i) = min(sqrt((x_A(i) - x_B).^2 + (y_A(i) - y_B).^2));
%     end
%     MAD = mean(dists);

    % Concatenate all the metrics into a single row vector
    Performances = [IoU, Dice, Precision, Recall, F1];%, MAD];
end