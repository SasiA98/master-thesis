function phi = eye_quality_metric(filename, eye_info, verbose)

    alpha = 1/3;
    beta = 1/3;
    gamma = 1/3;

    % get pupil information 
    r_pupil = eye_info.PupilInfo.RPupil;
    x_pupil = round(eye_info.PupilInfo.CxPupil);
    y_pupil = round(eye_info.PupilInfo.CyPupil);

    % get iris information 
    r_iris = eye_info.IrisInfo.RIris;
    x_iris = round(eye_info.IrisInfo.CxIris);
    y_iris = round(eye_info.IrisInfo.CyIris);
    
    % get the image from filename and convert it into a grayscale image 
    image = imread(filename);    
    [image_xdim, image_ydim, ~] = size(image);

    %if(size(size(image),2) == 3)
    image = rgb2gray(image);
    %end   

    if verbose > 0
        figure('Name','eye_quality_metric');
    
        subplot(2,2,1);
        imshow(image);
        axis on
        hold on;
    
        % plot pupil's coordinate 
        plot(x_pupil,y_pupil, 'r+', 'MarkerSize', 2, 'LineWidth', 2);

    end

    % separability values of pupil and iris  
    D_pupil = 0;
    D_iris = 0;
    %img = double(image);
    
    step = 2*pi/360;
    i = 1;

    for theta = 0:step:2*pi
        
        %  pupil's sD computation
        r_in_pupil = r_pupil * 0.9;
        r_ex_pupil = r_pupil * 1.1;

        Cx_pupil_in = y_pupil + round(r_in_pupil *  cos(theta));
        Cy_pupil_in = x_pupil + round(r_in_pupil *  sin(theta));
        Cx_pupil_ex = y_pupil + round(r_ex_pupil *  cos(theta));
        Cy_pupil_ex = x_pupil + round(r_ex_pupil *  sin(theta));


        if (Cx_pupil_ex < image_xdim) && (Cy_pupil_ex < image_ydim)  &&  ...
           (Cx_pupil_in < image_xdim) && (Cy_pupil_in < image_ydim) && ...
            (Cx_pupil_in > 0) && (Cy_pupil_in > 0) && ...
            (Cx_pupil_ex > 0) && (Cy_pupil_ex > 0) 

            D_pupil(i) = abs(image(Cx_pupil_ex,Cy_pupil_ex) - image(Cx_pupil_in,Cy_pupil_in));
                      
            if verbose > 0
                plot(Cy_pupil_in,Cx_pupil_in, 'o', 'MarkerSize', 2, 'LineWidth', 0.2, 'Color', 'blue');
                plot(Cy_pupil_ex,Cx_pupil_ex, 'o', 'MarkerSize', 2, 'LineWidth', 0.2, 'Color','green');
            end 

        end
        
        %  iris's sD computation   
        r_in_iris = r_iris * 0.9;
        r_ex_iris = r_iris * 1.1;

        Cx_iris_in = y_iris + round(r_in_iris *  cos(theta));
        Cy_iris_in = x_iris + round(r_in_iris *  sin(theta));
        Cx_iris_ex = y_iris + round(r_ex_iris *  cos(theta));
        Cy_iris_ex = x_iris + round(r_ex_iris *  sin(theta));


        if (Cx_iris_ex < image_xdim) & (Cy_iris_ex < image_ydim) & ...
           (Cx_iris_in < image_xdim) & (Cy_iris_in < image_ydim) & ...
            (Cx_iris_in > 0) & (Cy_iris_in > 0) & ...
            (Cx_iris_ex > 0) & (Cy_iris_ex > 0) 
            
            D_iris(i) = abs(image(Cx_iris_ex,Cy_iris_ex) - image(Cx_iris_in,Cy_iris_in));

            if verbose > 0
                plot(Cy_iris_in,Cx_iris_in, 'o', 'MarkerSize', 2, 'LineWidth', 0.2, 'Color', 'blue');
                plot(Cy_iris_ex,Cx_iris_ex, 'o', 'MarkerSize', 2, 'LineWidth', 0.2, 'Color','green');
            end
        end
        i = i+1;
    end

    % sD formulas
    %sD_pupil = mean(D_pupil) / (std(D_pupil) + 1);
    %sD_iris = mean(D_iris) / (std(D_iris) + 1);


    % ----------- uso isolamento del prof  ----------- %

    sD_pupil = isolamento(image, x_pupil, y_pupil, r_pupil);
    sD_iris = isolamento(image, x_iris, y_iris, r_iris);

    % SP and SI calculation 
    SP = 1 - (1 / (sD_pupil + 1));
    SI = 1 - (1 / (sD_iris  + 1));
 

    % Gdist calculation 
    n_bins = 255;

    if verbose > 1 
        subplot(2,2,2); 
        imhist(image, n_bins);
    end

    [h, ~] = imhist(image, n_bins);

    % normalize value in [0;1]
    h = (h - min(h))/(max(h) - min(h));

    % compute max value in h
    h_max = max(h);
    lvl = min(find(h==h_max));


    % Gaussian distribution hypotesis

    if verbose > 1 
        subplot(2,2,3);
        plot(h, 'b');
    end 

    c = mean(h);
    v = std(h);

    % definiamo un vettore con 'livelli_ist' che vanno da 0 ad 1
    values = linspace(0,1,n_bins);
    
    % calculate the best funtion that fits the histogram 
    y = exp(-0.5*((values - lvl/n_bins)/(0.2*v)).^2);

    if verbose > 1 
        subplot(2,2,3);
        %plot y
        hold on;
        plot(y, 'r');
    end

    % calculate G_dist by measuring the distance between the ideal Gaussian function and the y-function
    G_dist = 1/(1 + sum(abs(h' - y).^2));
    er = 1 - G_dist;
    
    if verbose > 1
        subplot(2,2,4);
        x= [G_dist er];
        explode = [1 0];
        pie3(x,explode)
    end
    
   % accuracy index
   phi = round(alpha * SP + beta * SI + gamma * G_dist,3);    

end