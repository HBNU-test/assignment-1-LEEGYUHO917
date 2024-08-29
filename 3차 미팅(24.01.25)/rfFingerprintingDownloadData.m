function varargout = rfFingerprintingDownloadData(type)
%rfFingerprintingDownloadData Download data files
%   rfFingerprintingDownloadData(TYPE) downloads data files used by the
%   WLAN router impersonation detection examples. When TYPE is 'simulated',
%   the data for "Design a Deep Neural Network with Simulated Data to
%   Detect WLAN Router Impersonation" example is downloaded. When TYPE is
%   'captured', "Test a Deep Neural Network with Captured Data to Detect
%   WLAN Router Impersonation" example is downloaded. 
%
%   FN = rfFingerprintingDownloadData(TYPE) returns a list of downloaded
%   and uncompressed files in FN.

%   Copyright 2019-2023 The MathWorks, Inc.

narginchk(1,1)

type = validatestring(type,{'simulated','captured'},mfilename,'TYPE');

if strcmp(type, 'simulated')
  dataFileName = "RFFingerprintingSimulatedData_R2023a.tar";
  expFileNames = {'rfFingerprintingSimulatedDataTrainedNN_R2023a.mat'};
else
  dataFileName = "RFFingerprintingCapturedData_R2023a.tar";
  expFileNames = {'rfFingerprintingCapturedData.mat', ...
    'rfFingerprintingCapturedDataTrainedNN_R2023a.mat', ...
    'rfFingerprintingCapturedUnknownFrames.mat'};
end

url = "https://www.mathworks.com/supportfiles/spc/RFFingerprinting/" ...
  + dataFileName;

dstFolder = pwd;

fileNames = helperDownloadDataFile(url, ...
  dataFileName, ...
  expFileNames, ...
  dstFolder);

if nargout > 0
  varargout{1} = fileNames;
end
end


function fileNames = helperDownloadDataFile(url, archive, expFileNames, dstFolder)
%helperDownloadDataFile Download and uncompress data file from URL
%   FN = helperDownloadDataFile(URL,DATAFILE,EXPFILES,DST) downloads
%   and uncompresses DATAFILE from URL to DST folder. EXPFILES is a list of
%   expected uncompressed files. 


[~, ~, fExt] = fileparts(archive);

skipDownload = exist(archive, 'file') == 2;

skipExtract = true;
fileNames = expFileNames;
for p=1:length(expFileNames)
  tmpFileName = fullfile(dstFolder, expFileNames{p});
  if ~exist(tmpFileName, 'file')
    skipExtract = false;
    break
  end
end

if skipExtract
  disp("Files already exist. Skipping download.")
else
  switch fExt
    case {'.tar','.gz'}
      if skipDownload
        disp('Archive already exists. Extracting files.')
        fileNames = untar(archive, dstFolder);
        disp("Extracting files done")
      else
        fprintf("Starting download of data files from:\n\t%s\n", url)
        fileNames = untar(url, dstFolder);
        disp("Download and extracting files done")
      end
  end
end
end
