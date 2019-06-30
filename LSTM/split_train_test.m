function [X_train, y_train,  X_test, y_test] = split_train(X, y, k, ratio)
%SPLIT_TRAIN_TEST �ָ�ѵ�����Ͳ��Լ�
%  ����X�����ݾ��� y�Ƕ�Ӧ���ǩ k�������� ratio��ѵ�����ı���
%  ����ѵ����X_train�Ͷ�Ӧ�����ǩy_train ���Լ�X_test�Ͷ�Ӧ�����ǩy_test

m = size(X, 1);
y_labels = unique(y); % ȥ�أ�kӦ�õ���length(y_labels) 
d = [1:m]';

X_train = [];
y_train= [];

for i = 1:k
    comm_i = find(y == y_labels(i));
    if isempty(comm_i) % �������������ݼ��в�����
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