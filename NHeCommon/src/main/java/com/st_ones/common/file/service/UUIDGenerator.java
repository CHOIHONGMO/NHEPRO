package com.st_ones.common.file.service;

import org.apache.commons.lang3.StringUtils;

import java.util.Map;
import java.util.Random;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : UUIDGenerator.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class UUIDGenerator {

    public static String getUUID(String uuidType) {

        int length = 20;
        if(!StringUtils.equals(uuidType, "UUID")) {
            length = 50;
        }

        int index;
        char[] charSet = new char[] {
                '0','1','2','3','4','5','6','7','8','9'
                ,'A','B','C','D','E','F','G','H','I','J','K','L','M'
                ,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
                ,'a','b','c','d','e','f','g','h','i','j','k','l','m'
                ,'n','o','p','q','r','s','t','u','v','w','x','y','z'
                ,'_'};

        long seed = System.currentTimeMillis();
        Random rand = new Random(seed);

        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < length; i++) {
            // java.lang.Math의 random() 메소드 대신 java.util.Random 클래스에서 기본값으로 현재시간을 기반으로 조합하여 매번 변경되는 시드(Seed)값 사용
            //index = (int) (charSet.length * Math.random());
            index = (int) (charSet.length * rand.nextDouble());
            sb.append(charSet[index]);
        }

        return sb.toString();
    }
}
