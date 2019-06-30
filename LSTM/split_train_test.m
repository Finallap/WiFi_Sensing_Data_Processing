function [X_train, y_train,  X_test, y_test] = split_train(X, y, k, ratio)
%SPLIT_TRAIN_TEST 分割训练集和测试集
%  参数X是数据矩阵 y是对应类标签 k是类别个数 ratio是训练集的比例
%  返回训练集X_train和对应的类标签y_train 测试集X_test和对应的类标签y_test

m = size(X, 1);
y_labels = unique(y); % 去重，k应该等于length(y_labels) 
d = [1:m]';

X_train = [];
y_train= [];

for i = 1:k
    comm_i = find(y == y_labels(i));
    if isempty(comm_i) % 如果该类别在数据集中不存在
        continue;
    end
    size_comm_i = length(comm_i);
    rp = randperm(size_comm_i); % random permutation
    rp_ratio = rp(1:floor(size_comm_i * ratio));
    ind = comm_i(rp_ratio);
    X_train = [X_train; X(ind, :)];
    y_train = [y_train; y(ind, :)];
    d = setdiff(d, ind);
end

X_test = X(d, :);
y_test = y(d, :);

end