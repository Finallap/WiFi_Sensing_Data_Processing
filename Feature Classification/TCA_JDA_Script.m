[acc,acc_ite] = JDA(lab_train,lab_label,meeting_train,meeting_label,options)

[meeting_train_new,lab_train_new,A] = TCA(meeting_train,lab_train,options);
lab_new = [lab_train_new,lab_label];
meeting_new = [meeting_train_new,meeting_label];

meeting_fit = trainedModel.predictFcn(meeting_train_new);
acc = sum(meeting_fit == meeting_label)./numel(meeting_label)
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(meeting_label,meeting_fit);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

lab_fit = trainedModel.predictFcn(lab_train_new);
acc = sum(lab_fit == lab_label)./numel(lab_label)
figure('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(lab_label,lab_fit);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';