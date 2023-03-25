load("merged_dataset.mat");
% create array with the merged dataset from the preprocessing step
merged_array=table2array(merged_dataset);

% We do not consider the ids and the fried parameter, since it is already
% used for classification in part A
clustering_data=merged_array(:,3:end);

%% Clustering with Kmedoids

%perform kmedoids for variable number of clusters
for i=1:5
    idx_1(:,i)=kmedoids(clustering_data,i);
end
%evaluate k-medoids with silhouette internal criterium
eva_1=evalclusters(clustering_data,idx_1,'silhouette');
% plot graph for evaluation score by number of clusters
subplot(2,2,1)
plot(eva_1)
title('K-medoids')
fprintf('max k-medoids evaluation score: %f\n', max(eva_1.CriterionValues));

%% Clustering with Kmeans
% do the same as with k-medoids
for i=1:5
    idx_2(:,i)=kmeans(clustering_data,i);
end

eva_2=evalclusters(clustering_data,idx_2,'silhouette');
 subplot(2,2,2)
 plot(eva_2)
title('K-means')
fprintf('max k-means evaluation score: %f', max(eva_2.CriterionValues));

%% Clustering with DBscan

% use TSNE for dimensionality reduction, making all the points 2d.
rng default
Y=tsne(clustering_data);
%show results
subplot(2,2,3)
gscatter(Y(:,1),Y(:,2),merged_array(:,2))

%estimate epsilon for dbscan 
min_points = 5;
max_points = 20;
epsilon=clusterDBSCAN.estimateEpsilon(Y,min_points,max_points)

%without estimation
%epsilon = 2;                      % change to the desired value for epsilon
min_points = 10;                   % change to the desired value for minPts

% run dbscan
clusterer = clusterDBSCAN('MinNumPoints',min_points,'Epsilon',epsilon);
idx_3 = clusterer(Y);
% plot the results
subplot(2,2,4)
plot(clusterer,Y,idx_3)
% remove outliers, marked with -1 from the data and the labels for
% evaluation score
data = clustering_data(idx_3 ~= -1,:);
labels = idx_3(idx_3 ~= -1);
% evaluation with DaviesBouldin Index (DBI)
eva_3=evalclusters(data,labels,'DaviesBouldin');
fprintf('dbscan evaluation score: %f', eva_3.CriterionValues);