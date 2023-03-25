
load("final_data.mat");

% remove variables that are not wanted in the classification 
classification_data = removevars(final_data,{'part_id','weight_loss', ...
 'exhaustion_score','gait_speed_slower','grip_strength_abnormal','low_physical_activity'});


% split dataset into x(variables) and y(labels, fried parameter)
x = classification_data(:, 2:end);
y = classification_data(:, 1);


%% 1st method: Classification tree and KFold for the partition

k=5; 
cv = cvpartition(538, 'KFold', k); % split the classification data
                                   % into training and test sets

accuracies = zeros(k, 1); 

for i = 1:k                             %loop through the folds and 
    x_train_1 = x(cv.training(i), :); 
    y_train_1 = y(cv.training(i),1);
    x_test_1 = x(cv.test(i), :);
    y_test_1 = y(cv.test(i),1);

    tree = ClassificationTree.fit(x_train_1, y_train_1); % here we train 
                                                         % the model

    y_pred_1 = tree.predict(x_test_1); % prediction of the class labels for 
                                       % the test set

    accuracy_1 = mean(y_pred_1 == table2array(y_test_1));
    accuracies(i) = accuracy_1;
end

mean_accuracy_1 = mean(accuracies);
std_accuracy_1 = std(accuracies);

fprintf(['Accuracy of Classification Tree: %.2f with standard deviation ' ...
         '+/- %.2f\n'], mean_accuracy_1, std_accuracy_1);

%% 2nd method: Support Vector Machine (SVM) and Holdout for partition

cv = cvpartition(538, 'Holdout', 0.2);
x_train_2 = x(cv.training, :);
y_train_2 = y(cv.training,1);
x_test_2 = x(cv.test, :);
y_test_2 = y(cv.test,1);

svm = fitcecoc(x_train_2, y_train_2);

y_pred_2 = predict(svm, x_test_2);

accuracy_2 = mean(y_pred_2 == table2array(y_test_2));

fprintf('Accuracy of SVM: %.2f\n', accuracy_2);