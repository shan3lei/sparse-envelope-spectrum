function [data,filename]=slgetfile()
%�����������ͨ��UI��ȡ���ݣ�
[filename, pathname] = uigetfile();
if isequal(filename,0)
   disp('User selected Cancel')
else
   disp(['User selected ', fullfile(pathname, filename)])
end
wj=fullfile(pathname,filename);

try
    data=importdata(wj);
    if ~isa(data,'double')
        disp('��ȡ�����ݲ���double���ͣ�������д��󣬽�����һ��');
    end
catch
    disp('�޷�ͨ��importdata��������,���ڷ��ص����ļ�����λ��');
    data=wj;
end