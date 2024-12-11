function saveFile(filename,tablehead,z)
   fid=fopen(filename,'w');
   fprintf(fid,'ncols %d\n',tablehead.ncols);
   fprintf(fid,'nrows %d\n',tablehead.nrows);
   fprintf(fid,'xllcorner %f\n',tablehead.xllcorner);
   fprintf(fid,'yllcorner %f\n',tablehead.yllcorner);
   fprintf(fid,'cellsize %d\n',tablehead.cellsize);
   fprintf(fid,'NODATA_value %d\n',-9999);
   dlmwrite(filename, z, '-append','delimiter', '\t', 'precision', '%.4f');
   fclose(fid);
end