%% write_atom_pdb.m
% * This function writes an pdb file from the atom struct
%
%% Version
% 2.06
%
%% Contact
% Please report bugs to michael.holmboe@umu.se
%
%% Examples
% # write_atom_pdb(atom,Box_dim,filename_out)
%
function write_atom_pdb(atom,Box_dim,filename_out,varargin)

if regexp(filename_out,'.pdb') ~= false
    filename_out = filename_out;
else
    filename_out = strcat(filename_out,'.pdb');
end

if numel(Box_dim)==1
    Box_dim(1)=Box_dim(1);
    Box_dim(2)=Box_dim(1);
    Box_dim(3)=Box_dim(1);
end

nAtoms=length(atom);
Atom_section=cell(nAtoms,10);
fid = fopen(filename_out, 'wt');

fprintf(fid, '%s\n','REMARK    GENERATED BY MATLAB');
fprintf(fid, '%s\n','REMARK    THIS IS A SIMULATION BOX');
fprintf(fid, '%s\n','MODEL        1');

% % %  1 -  6       Record name    "CRYST1"
% % %  7 - 15       Real(9.3)      a (Angstroms)
% % % 16 - 24       Real(9.3)      b (Angstroms)
% % % 25 - 33       Real(9.3)      c (Angstroms)
% % % 34 - 40       Real(7.2)      alpha (degrees)
% % % 41 - 47       Real(7.2)      beta (degrees)
% % % 48 - 54       Real(7.2)      gamma (degrees)
% % % 56 - 66       LString        Space group
% % % 67 - 70       Integer        Z value
% % %
% % % Example:
% % %
% % %          1         2         3         4         5         6         7
% % % 1234567890123456789012345678901234567890123456789012345678901234567890
% % % CRYST1  117.000   15.000   39.000  90.00  90.00  90.00 P 21 21 21    8

% % % CRYST1   31.188   54.090   20.000  90.00  90.00  90.00 P1          1
disp('Assuming P1 space group. Box can still be triclinic')
if length(Box_dim)==3
%     fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', Box_dim(1:3), 90.00, 90.00, 90.00, 'P1', 1);
    fprintf(fid, '%6s%9.4f%9.4f%9.4f%7.2f%7.2f%7.2f %10s\n','CRYST1', Box_dim(1:3), 90.00, 90.00, 90.00, 'P1'); % For mercury
elseif length(Box_dim)==9
    
    Box_dim(Box_dim<0.00001&Box_dim>-0.00001)=0;
%     if sum(find(Box_dim(4:end)))<0.0001;
%         Box_dim=Box_dim(1:3);
%     end
    
    lx=Box_dim(1);
    ly=Box_dim(2);
    lz=Box_dim(3);
    xy=Box_dim(6);
    xz=Box_dim(8);
    yz=Box_dim(9);
    
    a=lx;
    b=(ly^2+xy^2)^.5;
    c=(lz^2+xz^2+yz^2)^.5;
    alfa=rad2deg(acos((ly*yz+xy*xz)/(b*c)));
    beta=rad2deg(acos(xz/c));
    gamma=rad2deg(acos(xy/b));
    
    %     a=Box_dim(1);
    %     b=Box_dim(2);
    %     c=Box_dim(3);
    %     xy=Box_dim(6);
    %     xz=Box_dim(8);
    %     yz=Box_dim(9);
    %     lx = a;
    %     ly = (b^2-xy^2)^.5;
    %     lz = (c^2 - xz^2 - yz^2)^0.5;
    %     alfa=rad2deg(acos((ly*yz+xy*xz)/(b*c)))
    %     beta=rad2deg(acos(xz/c));
    %     gamma=rad2deg(acos(xy/b));
%     fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', a, b, c, alfa, beta, gamma, 'P1', 1);
      fprintf(fid, '%6s%9.4f%9.4f%9.4f%7.2f%7.2f%7.2f %10s\n','CRYST1', a, b, c, alfa, beta, gamma, 'P1'); % For mercury
else
    disp('No proper box_dim information')
end

% See http://deposit.rcsb.org/adit/docs/pdb_atom_format.html
% COLUMNS        DATA  TYPE    FIELD        DEFINITION
% -------------------------------------------------------------------------------------
% 1 -  6         Record name   "ATOM  "
% 7 - 11         Integer       Serial       Atom  serial number.
% 13 - 16        Atom          Atom type    Atom name.   ->17 by MH
% 17             Character     AltLoc       Alternate location indicator.
% 18 - 20        Residue name  ResName      Residue name.
% 22             Character     ChainID      Chain identifier.
% 23 - 26        Integer       ResSeq       Residue sequence number.
% 27             AChar         Code         Code for insertion of residues.
% 31 - 38        Real(8.3)     X            Orthogonal coordinates for X in Angstroms.
% 39 - 46        Real(8.3)     Y            Orthogonal coordinates for Y in Angstroms.
% 47 - 54        Real(8.3)     Z            Orthogonal coordinates for Z in Angstroms.
% 55 - 60        Real(6.2)     Occupancy    Occupancy.
% 61 - 66        Real(6.2)     TempFactor   Temperature  factor.
% 73 - 76        LString(4)    Segment identifier, left-justified. % Not used
% 77 - 78        LString(2)    Element      Element symbol, right-justified.
% 79 - 80        LString(2)    Charge       Charge on the atom.

% .pqr format usually something like
% Field_name Atom_number Atom_name Residue_name Chain_ID Residue_number X Y Z Charge Radius
if ~isfield(atom,'occupancy')
    [atom.occupancy]=deal(1);
end
    


for i=1:size(atom,2)
    if strncmp(atom(i).type,{'Si'},2);atom(i).element={'Si'};atom(i).formalcharge=4;
    elseif strncmpi(atom(i).type,{'SY'},2);atom(i).element={'Si'};atom(i).formalcharge=4;
    elseif strncmpi(atom(i).type,{'SC'},2);atom(i).element={'Si'};atom(i).formalcharge=4;
    elseif strncmpi(atom(i).type,{'S'},1);atom(i).element={'S'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'AC'},2);atom(i).element={'Al'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'AY'},2);atom(i).element={'Al'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'Al'},2);atom(i).element={'Al'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'Mg'},2);atom(i).element={'Mg'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'Fe'},2);atom(i).element={'Fe'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'O'},1);atom(i).element={'O'};atom(i).formalcharge=-2;
    elseif strncmpi(atom(i).type,{'H'},1);atom(i).element={'H'};atom(i).formalcharge=1;
    elseif strncmpi(atom(i).type,{'K'},1);atom(i).element={'K'};atom(i).formalcharge=1;
    elseif strncmpi(atom(i).type,{'Na'},1);atom(i).element={'Na'};atom(i).formalcharge=0;
    elseif strncmpi(atom(i).type,{'Cl'},2);atom(i).element={'Cl'};atom(i).formalcharge=-1;
    elseif strncmpi(atom(i).type,{'Br'},2);atom(i).element={'Br'};atom(i).formalcharge=-1;
    elseif strncmpi(atom(i).type,{'Ca'},2);atom(i).element={'Ca'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'C'},1);atom(i).element={'C'};atom(i).formalcharge=0;
    else
        [atom(i).element]=atom(i).type;atom(i).formalcharge=0;
    end
end

% ATOM      1   Na  Na A   1       9.160   6.810   1.420  1.00  1.00          Na 0
% ATOM      1  Si  MMT A   1       2.140   8.380   2.710  1.00  0.00           S


%% Remove this if you do not need it...
for i = 1:nAtoms
    if size(atom(i).type{1},2) > 4
        disp('Hey, this atom type name is actually too long for pdb')
        disp('chopping it down to 4 characters')
        [atom(i).index atom(i).type]
        atom(i).type=atom(i).type{1}(1:4);
    end
end

% Try also this if problems arise
% fprintf(fid,'%-6s%5i %4s %3s %1s%4i    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s\n',Atom_section{1:12});
%
for i = 1:nAtoms
    Atom_section(1:12) = ['ATOM  ', atom(i).index, atom(i).type, atom(i).resname, 'A',atom(i).molid, atom(i).x, atom(i).y, atom(i).z,atom(i).occupancy,1,atom(i).element];
    fprintf(fid,'%-6s%5i  %-4s%3s %1s%4i    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s\n',Atom_section{1:12});
end

% for i = 1:nAtoms
%     Atom_section(1:13) = ['ATOM  ', atom(i).index, atom(i).type, atom(i).resname, 'A',atom(i).molid, atom(i).x, atom(i).y, atom(i).z,1,1,atom(i).element,atom(i).formalcharge];
%     fprintf(fid,'%-6s%5i %-4s %3s %1s%4i    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s%2i\n',Atom_section{1:13});
% end

% Write conect records

if nargin>3
    if nargin>4
        short_r=cell2mat(varargin(1));
        long_r=cell2mat(varargin(2));
    else
        short_r=1.25;
        long_r=2.25;
    end
    
    short_r
    long_r
    
    atom=bond_angle_atom(atom,Box_dim,short_r,long_r);
    %     assignin('caller','Dist_matrix',Dist_matrix);
    assignin('caller','Bond_index',Bond_index);
    assignin('caller','Angle_index',Angle_index);
    assignin('caller','nBonds',nBonds);
    assignin('caller','nAngles',nAngles);
    
    B=[Bond_index(:,1:2); Bond_index(:,2) Bond_index(:,1)];
    b1=sortrows(B);
    for i=min(b1(:,1)):max(b1(:,1))
        ind=find(b1(:,1)==i);
        b2=b1(ind,2);
        fprintf(fid,'CONECT%5i%5i%5i%5i%5i%5i%5i',[i;b2]);
        fprintf(fid,'\n');
    end
    fprintf(fid,'MASTER    %5i%5i%5i%5i%5i%5i%5i%5i%5i%5i%5i%5i\n',[0    0    0    0    0    0    0    0 nAtoms    0 i    0]);
    fprintf(fid,'END');
    fprintf(fid,'\n');
else
    fprintf(fid, '%s\n','TER');
    fprintf(fid, '%s\n','ENDMDL');
end
fclose(fid);
disp('.pdb structure file written')
%
% assignin('caller','Bond_index',Bond_index);
% assignin('caller','Angle_index',Angle_index);


