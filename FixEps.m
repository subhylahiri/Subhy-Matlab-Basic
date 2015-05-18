function FixEps( filename )
%FIXEPS(filename) fix eps files made with print in Matlab R2014b
%   replace \n with \r\n in Windows

eps = fileread(filename);
fd = fopen(f, 'wt');
fwrite(fd, eps);
fclose(fd);

end

