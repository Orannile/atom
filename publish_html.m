%% This file is used to generate the html-documentation

dirs={...
    'build_functions';...
    'custom_functions';...
    'export_functions';...
    'forcefield_functions';...
    'general_functions';...
    'import_functions';...
    'neigh_functions';...
    'variables';...
    'structures';...
    'variables';...
    'examples/Basic_examples';...
    };

for j=1:size(dirs,1)
    
    cd(char(dirs(j)))
    filelist = dir('*.m')
    
    
    for i=1:size(filelist,1)
        publish(filelist(i).name,'createThumbnail',true,'maxWidth',1200,'evalCode',false,'outputDir','/Users/miho0052/Dropbox/MATLAB/Matlab_scripts/functions/atom/html')
    end
    
    cd ..
    
end