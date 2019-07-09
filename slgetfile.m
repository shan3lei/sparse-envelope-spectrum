function [data,filename]=slgetfile()
%这个函数用来通过UI读取数据，
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
        disp('读取的数据不是double类型，多半是有错误，建议检查一下');
    end
catch
    disp('无法通过importdata导入数据,现在返回的是文件绝对位置');
    data=wj;
end