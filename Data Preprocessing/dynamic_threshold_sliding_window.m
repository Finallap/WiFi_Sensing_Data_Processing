w_length = 100;%������С
interval = 90;%�������
alpha = 0.1;%��ֵ����Ȩ��ϵ��
false_positive_interval = 4;%���ټ�����ٸ������ڽ��б���
threshold_multiple =  3;%��ֵ����

sequence = first_pca;
sequence = medfilt1(sequence,40);%��ֵ�˲�
threshold = var(sequence(1:w_length));%������ֵ

plot(sequence)
hold on;

window = zeros(w_length);
var_array_length = fix((length(sequence)-w_length) / interval)+1;
var_array = zeros(var_array_length,1);
threshold_array = zeros(var_array_length,1);
is_abnormal_array = zeros(var_array_length,1);
ismember_result = 0;

%��ʼ���б������
iterations_num = 1;
for i=1:interval:length(sequence)-w_length
    window = sequence(i : i + w_length - 1);
    var_array(iterations_num) = var(window);
    
    %������ֵ
    threshold = (1-alpha) * threshold + alpha * var(window);
    threshold_array(iterations_num) = threshold;
    
    %�ж��Ƿ����쳣��
    if( var(window) > threshold_multiple * threshold )
        ismember_result = ismember(1,is_abnormal_array(iterations_num - false_positive_interval:iterations_num));
        
        if (ismember_result)
            continue;
        end
        is_abnormal_array(iterations_num) = 1;
        plot([i,i],[-40,40],'r')
    end
     
    %���µ�������
    iterations_num = iterations_num+1;
end

hold off;