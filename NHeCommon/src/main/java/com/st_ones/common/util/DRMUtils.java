package com.st_ones.common.util;

import com.fasoo.adk.packager.WorkPackager;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import org.apache.commons.lang.StringUtils;

import java.io.File;

public class DRMUtils {

    public static boolean isDRMSupportFile(String sourceFile) {

        if(!new File(sourceFile).exists()) {
            return false;
        }

        String[] imageExtensions = new String[] {"jpe","jpg","jpeg","tif","gif","png"};
        if(StringUtils.endsWithAny(StringUtils.lowerCase(sourceFile), imageExtensions)) {
            return false;
        }

        WorkPackager workPackager = new WorkPackager();

        return workPackager.IsSupportFile( "/svc/nhepro/externalSW/fasoo/fsdinit",
                "0000000000010136",
                sourceFile);

    }

    public static boolean decryptFile(String sourceFile, String targetFile) {

        WorkPackager workPackager = new WorkPackager();

        workPackager.SetLogInfo(20, "/logs/nhepro/log/drm");
        workPackager.setOverWriteFlag(true);

        return workPackager.DoExtract(
                "/svc/nhepro/externalSW/fasoo/fsdinit",
                "0000000000010136",
                sourceFile,
                targetFile);
    }

    public static boolean encryptFile(String sourceFile, String targetFile, String fileName, UserInfo userInfo) {

        WorkPackager workPackager = new WorkPackager();

        workPackager.SetLogInfo(20, "/logs/nhepro/log/drm");
        workPackager.setOverWriteFlag(true);

        return workPackager.DoPackagingFsn2("/svc/nhepro/externalSW/fasoo/fsdinit",
                "0000000000010136",
                sourceFile,
                targetFile,
                fileName,
                userInfo.getUserId(),
                userInfo.getUserNm(),
                userInfo.getUserId(),
                userInfo.getUserNm(),
                userInfo.getDeptCd(),
                userInfo.getDeptNm(),
                userInfo.getUserId(),
                userInfo.getUserNm(),
                userInfo.getDeptCd(),
                userInfo.getDeptNm(),
                "1");

    }

    public static boolean isEncryptedFile(String filePath) {

        WorkPackager workPackager = new WorkPackager();
        return workPackager.IsPackageFile(filePath);
    }

}
