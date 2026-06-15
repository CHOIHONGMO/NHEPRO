package com.st_ones.common;

import org.apache.commons.io.FileExistsException;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : FileProcessor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class FileProcessor {

    public static void main(String[] args) throws IOException {

        final String IF_FILE_PATH = "C:\\ST-OnesIDE\\workspace\\wiselog";
        final String JOB_DONE_FILE_PATH = "C:\\ST-OnesIDE\\workspace\\wiselog\\jobDoneFiles";
        String[] fileExtensions = {"txt"};

        File directory = new File(IF_FILE_PATH);
        Iterator<File> fileIterator = FileUtils.iterateFiles(directory, fileExtensions, false);
        while(fileIterator.hasNext()) {

            File f = fileIterator.next();
            List<String> stringList = FileUtils.readLines(f, "UTF-8");

            File targetDirectory = new File(JOB_DONE_FILE_PATH);
            try {
                FileUtils.moveFileToDirectory(f, targetDirectory, true);
            } catch(FileExistsException fee) {
                FileUtils.moveFile(f, targetDirectory);
            }
        }
    }
}
