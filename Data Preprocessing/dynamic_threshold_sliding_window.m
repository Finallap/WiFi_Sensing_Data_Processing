w_length = 100;%������С
interval = 90;%�������
alpha = 0.1;%��ֵ����Ȩ��ϵ��
false_positive_interval = 4;%���ټ�����ٸ������ڽ��б���
threshold_multiple = 3;%��ֵ����

sequence = first_pca;
sequence = medfilt1(sequence,40);%��ֵ�˲�

threshold = var(sequence(1:2 * w_length -1));%�����ʼ��ֵ

plot(sequence)
hold on;

window = zeros(w_length);
array_length = fix((length(sequence)-w_length) / interval)+1;
var_array = zeros(array_length,1);
threshold_array = zeros(array_length,1);
is_abnormal_array = zeros(array_length,1);
ismember_result = 0;

%��ʼ���б������
iterations_num = 1;
for i=1:interval:length(sequence)-w_length
    window = sequence(i : i + w_length - 1);
    var_array(iterations_num) = var(window);
    
    %�ж��Ƿ����쳣��
    if( iterations_num > false_positive_interval && var(window) > threshold_multiple * threshold )
        ismember_result = ismember(1,is_abnormal_array(iterations_num - false_positive_interval +1 : iterations_num));
        
        if (ismember_result)%�жϽ������Ƿ��Ѿ����쳣�����Ѿ��쳣����д�����֮�������һ�ε���
            threshold_array(iterations_num) = threshold;%�����쳣�ڣ���������ֵ
            iterations_num = iterations_num+1;%�����쳣�ڣ����ø��µ�������
            continue;
        end
        is_abnormal_array(iterations_num) = 1;
        plot([i,i],[-40,40],'r')
    end
     
    %������ֵ
    threshold = (1-alpha) * threshold + alpha * var(window);
    threshold_array(iterations_num) = threshold;
    
    %���µ�������
    iterations_num = iterations_num+1;
end

hold off;