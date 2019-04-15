sequence = amplitudeA(:,2);
sequence = medfilt1(sequence,40);%中值滤波

w_length = 128;%滑窗大小
interval = 96;%滑窗间隔
threshold = 20;%方差阈值

plot(sequence)
hold on;

window = zeros(w_length);
var_array_length = fix((length(sequence)-w_length) / interval)+1;
var_array = zeros(var_array_length,1);

iterations_num = 1;
for i=1:interval:length(sequence)-w_length
    window = sequence(i : i + w_length - 1);
    var_array(iterations_num) = var(window);
    iterations_num = iterations_num+1;
    
    if(var(window)>threshold)
        plot([i,i],[0,40],'r')
    end
end

hold off;
var_array = var_array';