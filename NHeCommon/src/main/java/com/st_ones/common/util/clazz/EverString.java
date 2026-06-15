package com.st_ones.common.util.clazz;

import com.st_ones.common.util.SpringContextUtil;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.commons.lang3.text.StrBuilder;
import org.json.simple.JSONObject;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.security.SecureRandom;
import java.util.*;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverString.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class EverString {

    private static Logger logger = LoggerFactory.getLogger(EverString.class);

    /**
     * EverWebGrid 의 ImageText 컴포넌트에서 TEXT 만 추출한다. .<br>
     * return Object(TEXT 를 Return)
     * @param mapData 의 Object Data(map.get("XXX"))
     * @return Object
     */
    public static Object getCellValueGridImageText(Object mapData) {
        return new JSONObject((Map) mapData).get("text");
    }

    /**
     * str에서 sub의 반복 횟수를 반환 합니다.<br>
     * return matching sub string count
     * @param str  확인할 문자열 null이 들어 올 수도 있습니다.
     * source string
     * @param sub  count 할 부분 문자열 null이 들어 올 수도 있습니다.
     * target String
     * @return int
     */
    public static int countMatches(String str, String sub) {
        return StringUtils.countMatches(str, sub);
    }

    /**
     * 문자열이 비었거나 null인지 확인 합니다.
     * NOTE: white space에 대한 검사는 하지 않습니다.<br>
     * return true when String is null or empty<br>
     * @param str  확인할 문자열 null일 수 있습니다.
     * @return 문자열이 null이거나 빈문자열 일 경우 {@code true}를 반환 합니다.
     */
    public static boolean isEmpty(String str) {
        return StringUtils.isEmpty(str);
    }

    /**
     * 문자열이 비었거나 null인지 확인 합니다.<br>
     * return false when String is null or empty
     * @param str  확인할 문자열 null일 수 있습니다.
     * @return 문자열이 null 또는 공백이 아닐 경우 {@code true}를 반환 합니다.
     */
    public static boolean isNotEmpty(String str) {
        return StringUtils.isNotEmpty(str);
    }

    /**
     * String Array를 한 문자열로 합침니다.
     * 처음과 끝은 separator가 추가 되지 않습니다.
     * separator null 인 경우 빈문자열과 같이 취급 됩니다.<br>
     *
     * concat string array
     * Beginning and end of the String will not be added separator.
     *  separator null will be treated as empty string.
     * @param array  한 문자열로 합쳐질 배열
     * source
     * @param separator 구분자, null일 경우 빈문자열로 취급
     * seprator
     * @return String
     */
    public static String combinationArr(String[] array, String separator) {
        return StringUtils.join(array, separator);
    }

    /**
     * 왼쪽에 문자열 길이가 파라미터의 길이가 될때 까지 repChar를 채웁니다.<br>
     * add left with given character and length
     * @param str  패딩을 할 대상 문자열
     * source
     * @param length  문자열 길이
     * length
     * @param repChar  채울 물자열
     * fill character
     * @return String
     */
    public static String lpad(String str, int length, String repChar) {
        return StringUtils.leftPad(str, length, repChar);
    }

    /**
     * 오른쪽에 문자열 길이가 length가 될때 까지 repChar를 채웁니다.<br>
     * add right with given character and length
     * @param str  패딩을 할 대상 문자열
     * source
     * @param length  문자열 길이
     * length
     * @param repChar  채울 물자열
     * fill character
     * @return String
     */
    public static String rpad(String str, int length, String repChar) {
        return StringUtils.rightPad(str, length, repChar);
    }

    // parseValue??, WiseString.parse, WiseString.StrToArray
    /**
     * str을 separatorChars 문자열로 잘라 문자열 배열을 만듭니다.<br>
     * str to string array with separator
     * @param str  자를 문자열
     * @param separatorChars  구분자
     * @return String[]
     */
    public static String[] strToArray(String str, String separatorChars) {
        return StringUtils.split(str, separatorChars);
    }

    /**
     * compare String
     * @param foo
     * @param bar
     * @return when same StringValue then reutrn true else false
     */
    public static boolean equals(String foo, String bar) {
        return StringUtils.equals(foo, bar);
    }

    /**
     * compare String
     * @param foo
     * @param bar
     * @return when not same StringValue then reutrn true else false
     */
    public static boolean notEquals(String foo, String bar) {
        return !StringUtils.equals(foo, bar);
    }

    /**
     * String foo의 값이 "true" 이면 fos "false" 이면 neg 둘다 아니면 foo를 반환<br>
     * return fos's value when foo's value is "true"
     * return neg's value when foo's value is "false"
     * else return foo's value
     * @param foo String
     * @param pos String
     * @param neg String
     * @return String
     * @throws Exception
     */
    public static String repToStr(String foo, String pos, String neg) {
        if (StringUtils.isEmpty(foo) || StringUtils.equals(foo, "null")) {
            return "";
        }
        if (StringUtils.equals(foo, "true")) {
            return pos;
        }
        if (StringUtils.equals(foo, "false")) {
            return neg;
        }
        return foo;
    }

    /**
     * 무작위 문자열을 randomStringLength 만큼 type으로 생성<br>
     * create random string
     * @param randomStringLength int 무작위 문자열을 만들 길이
     * string length
     * @param type String N: 숫자만, S: 문자열만, NS: 문자,숫자 혼합
     * N: only number, S:  only character, NS: number or character
     * @return String
     */
    public static String getRandomString(int randomStringLength, String type) {
        if ("N".equals(type)) {
            return RandomStringUtils.randomNumeric(randomStringLength);
        }
        if ("S".equals(type)) {
            return RandomStringUtils.randomAlphabetic(randomStringLength);
        }
        if ("NS".equals(type)) {
            return RandomStringUtils.randomAlphanumeric(randomStringLength);
        }
        return null;
    }

    // wise.util.JSPUtil
    /**
     * 문자열 중에 del문자열 제거<br>
     * remove del in str
     * @param str String
     * @param del String
     * @return String
     */
    public static String ignoreSeparator(String str, String del) {
        return StringUtils.replace(str, del, "");
    }

    // wise.util.WiseString
    /**
     * exception 정보를 String 형태로 return<br>
     * return exception infomation as String
     * @param throwable Throwable
     * @return String
     */
    public static String getStackTrace(Throwable throwable) {
        return ExceptionUtils.getStackTrace(throwable);
    }

    /**
     * 문자 코드
     * org.owasp.esapi.codecs.HTMLEntityCodec 에서 추출해서 사용
     * http://owasp-esapi-java.googlecode.com/svn/trunk/src/main/java/org/owasp/esapi/codecs/HTMLEntityCodec.java
     * @param str
     * @return
     */
    public static String replaceInjectionString(String str){

        Map<Character, String> map = new HashMap<Character,String>(252);
        map.put((char)34,       "\"");        /* quotation mark */
        map.put((char)39,       "\'");        /* single quotation mark */
//      map.put((char)38,       "＆");        /* & mark */
        map.put((char)60,       "&lt;");      /* less-than sign */
        map.put((char)62,       "&gt;");      /* greater-than sign */

        if(str == null) return null;
        map.keySet();
        for (Character ch : map.keySet()) {
            str = str.replaceAll(ch.toString(), map.get(ch));
        }

        String stringValue = str;

        if (stringValue.toUpperCase().indexOf("JAVASCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("JAVASCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 10);
            stringValue = replace(stringValue, temp_str, "ＪＡＶＡＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("JSCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("JSCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = replace(stringValue, temp_str, "ＪＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("VBSCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = replace(stringValue, temp_str, "ＶＢＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("SCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("SCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = replace(stringValue, temp_str, "ＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("IFRAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("IFRAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = replace(stringValue, temp_str, "ＩＦＲＡＭＥ");
        }
        if (stringValue.toUpperCase().indexOf("FRAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("FRAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, "ＦＲＡＭＥ");
        }
        if (stringValue.toUpperCase().indexOf("EXPRESSION") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("EXPRESSION");
            String temp_str = stringValue.substring(instr_location, instr_location + 10);
            stringValue = replace(stringValue, temp_str, "ＥＸＰＲＥＳＳＩＯＮ");
        }
        if (stringValue.toUpperCase().indexOf("ALERT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ALERT");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, "ＡＬＥＲＴ");
        }
        if (stringValue.toUpperCase().indexOf(".OPEN") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf(".OPEN");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, ".ＯＰＥＮ");
        }
        if (stringValue.toUpperCase().indexOf("DECALRE") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("DECALRE");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "DＥCＡLRＥ");
        }
        if (stringValue.toUpperCase().indexOf("COLUMN_NAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("COLUMN_NAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＣＯＬUMN_ＮAＭE");
        }
        if (stringValue.toUpperCase().indexOf("TABLE_NAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("TABLE_NAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＴＡBLE_ＮAＭE");
        }
        if (stringValue.toUpperCase().indexOf("OPENROWSET") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("OPENROWSET");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＯＰENROWＳET");
        }
        /*if (stringValue.toUpperCase().indexOf("XP") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("XP_");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＸＰ_");
        }*/
        if (stringValue.toUpperCase().indexOf("SYSOBJECTS") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("SYSOBJECTS");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＳYSＯBJECTS");
        }
        if (stringValue.toUpperCase().indexOf("SYSCOLUMNS") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("SYSCOLUMNS");
            String temp_str = stringValue.substring(instr_location, instr_location + 4);
            stringValue = replace(stringValue, temp_str, "ＳYSCＯLUMNS");
        }
        if (stringValue.toUpperCase().indexOf("&#") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("&#");
            String temp_str = stringValue.substring(instr_location, instr_location + 2);
            stringValue = replace(stringValue, temp_str, "＆＃");
        }
        if (stringValue.toUpperCase().indexOf("COOKIE") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("COOKIE");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("VBSCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("APPLET") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("APPLET");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("OBJECT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("OBJECT");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("BGSOUND") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("BGSOUND");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONBLUR") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONBLUR");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONCHANGE") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONCHANGE");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONCLICK") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONCLICK");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONDBLCLICK") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONDBLCLICK");
            String temp_str = stringValue.substring(instr_location, instr_location + 10);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONERROR") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONERROR");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONFOCUS") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONFOCUS");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONLOAD") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONLOAD");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }
        if (stringValue.toUpperCase().indexOf("ONMOUSE") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONMOUSE");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }

        if (str.toUpperCase().indexOf("ONSCROLL") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONSCROLL");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }

        if (str.toUpperCase().indexOf("ONSUBMIT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONSUBMIT");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }

        if (str.toUpperCase().indexOf("ONUNLOAD") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ONUNLOAD");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = EverString.replace(stringValue, temp_str, "");
        }

        return stringValue;
    }

    public static String replaceInjectionRichTextEdit(String str){

        Map<Character, String> map = new HashMap<Character,String>(252);
        map.put((char)39,       "＇");        /* single quotation mark */

        if(str == null) return null;
        map.keySet();
        for (Character ch : map.keySet()) {
            str = str.replaceAll(ch.toString(), map.get(ch));
        }

        String stringValue = str;

        if (stringValue.toUpperCase().indexOf("--") != -1) {
            stringValue = replace(stringValue, "--", "－－");
        }
        if (stringValue.toUpperCase().indexOf("%") != -1) {
            stringValue = replace(stringValue, "%", "％");
        }
        if (stringValue.toUpperCase().indexOf("JAVASCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("JAVASCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 10);
            stringValue = replace(stringValue, temp_str, "ＪＡＶＡＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("JSCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("JSCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 7);
            stringValue = replace(stringValue, temp_str, "ＪＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("VBSCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 8);
            stringValue = replace(stringValue, temp_str, "ＶＢＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("SCRIPT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("SCRIPT");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = replace(stringValue, temp_str, "ＳＣＲＩＰＴ");
        }
        if (stringValue.toUpperCase().indexOf("IFRAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("IFRAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 6);
            stringValue = replace(stringValue, temp_str, "ＩＦＲＡＭＥ");
        }
        if (stringValue.toUpperCase().indexOf("FRAME") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("FRAME");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, "ＦＲＡＭＥ");
        }
        if (stringValue.toUpperCase().indexOf("EXPRESSION") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("EXPRESSION");
            String temp_str = stringValue.substring(instr_location, instr_location + 10);
            stringValue = replace(stringValue, temp_str, "ＥＸＰＲＥＳＳＩＯＮ");
        }
        if (stringValue.toUpperCase().indexOf("ALERT") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf("ALERT");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, "ＡＬＥＲＴ");
        }
        if (stringValue.toUpperCase().indexOf(".OPEN") != -1) {
            int instr_location = stringValue.toUpperCase().indexOf(".OPEN");
            String temp_str = stringValue.substring(instr_location, instr_location + 5);
            stringValue = replace(stringValue, temp_str, ".ＯＰＥＮ");
        }

        if (stringValue.toUpperCase().indexOf("&#") != -1) {
//            int instr_location = stringValue.toUpperCase().indexOf("&#");
//            String temp_str = stringValue.substring(instr_location, instr_location + 2);
//			stringValue = replace(stringValue, temp_str, "＆＃");
        }

        return stringValue;
    }

    public static Map<String, Object> forTransactionQuery(Map<String, Object> param) throws UserInfoNotFoundException { //throws UserInfoNotFoundException {

        Map<String, Object> resultParam = new HashMap<String, Object>();

        Iterator<Entry<String, Object>> it = param.entrySet().iterator();

        String fieldID = "";
        Object fieldValue = "";
        String stringValue = "";

        while (it.hasNext()) {

            Entry<String, Object> entry = it.next();

            fieldID = toEmpty(entry.getKey());
            fieldValue = param.get(entry.getKey());

            stringValue = "";
            if (fieldValue instanceof String) {
                //stringValue = encoder.encodeForSQL(oracleCodec, toEmpty((String)fieldValue));
                stringValue = toEmpty((String)fieldValue);
            }

            if (!isEmpty(stringValue)) {

                if (stringValue.toUpperCase().indexOf("JAVASCRIPT") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("JAVASCRIPT");
                    String temp_str = stringValue.substring(instr_location, instr_location + 10);
                    stringValue = replace(stringValue, temp_str, "ＪＡＶＡＳＣＲＩＰＴ");
                }
                if (stringValue.toUpperCase().indexOf("JSCRIPT") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("JSCRIPT");
                    String temp_str = stringValue.substring(instr_location, instr_location + 7);
                    stringValue = replace(stringValue, temp_str, "ＪＳＣＲＩＰＴ");
                }
                if (stringValue.toUpperCase().indexOf("VBSCRIPT") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("VBSCRIPT");
                    String temp_str = stringValue.substring(instr_location, instr_location + 8);
                    stringValue = replace(stringValue, temp_str, "ＶＢＳＣＲＩＰＴ");
                }
                if (stringValue.toUpperCase().indexOf("SCRIPT") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("SCRIPT");
                    String temp_str = stringValue.substring(instr_location, instr_location + 6);
                    stringValue = replace(stringValue, temp_str, "ＳＣＲＩＰＴ");
                }
                if (stringValue.toUpperCase().indexOf("IFRAME") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("IFRAME");
                    String temp_str = stringValue.substring(instr_location, instr_location + 6);
                    stringValue = replace(stringValue, temp_str, "ＩＦＲＡＭＥ");
                }
                if (stringValue.toUpperCase().indexOf("FRAME") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("FRAME");
                    String temp_str = stringValue.substring(instr_location, instr_location + 5);
                    stringValue = replace(stringValue, temp_str, "ＦＲＡＭＥ");
                }
                if (stringValue.toUpperCase().indexOf("EXPRESSION") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("EXPRESSION");
                    String temp_str = stringValue.substring(instr_location, instr_location + 10);
                    stringValue = replace(stringValue, temp_str, "ＥＸＰＲＥＳＳＩＯＮ");
                }
                if (stringValue.toUpperCase().indexOf("ALERT") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("ALERT");
                    String temp_str = stringValue.substring(instr_location, instr_location + 5);
                    stringValue = replace(stringValue, temp_str, "ＡＬＥＲＴ");
                }
                if (stringValue.toUpperCase().indexOf(".OPEN") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf(".OPEN");
                    String temp_str = stringValue.substring(instr_location, instr_location + 5);
                    stringValue = replace(stringValue, temp_str, ".ＯＰＥＮ");
                }
                if (stringValue.toUpperCase().indexOf("&#") != -1) {
                    int instr_location = stringValue.toUpperCase().indexOf("&#");
                    String temp_str = stringValue.substring(instr_location, instr_location + 2);
                    stringValue = replace(stringValue, temp_str, "＆＃");
                }

                resultParam.put(fieldID, stringValue);

            } else {

                resultParam.put(fieldID, fieldValue);

                if (UserInfoManager.getUserInfoImpl() != null) {
                    (resultParam).put("ses", UserInfoManager.getUserInfoImpl());
                }

            }

        }

        return resultParam;

    }

    public static String toEmpty(String str) {

        String rtnVal = "";
        byte[] byteRes = null;

        if (str == null) {
            rtnVal = "";
        } else {
            try {
                //rtnVal = URLDecoder.decode(str, "UTF-8");
                byteRes = str.getBytes("UTF-8");
                rtnVal = new String(byteRes, "UTF-8");
            } catch (UnsupportedEncodingException e) {
                logger.error(e.getMessage(), e);
            }
        }
        return rtnVal;
    }

    /**
     * 널 문자열이 들어오면 빈 문자열을 return
     * 아닐 경우는 입력 값을 return<br>
     * if input is  null then return empty String
     * else return input
     * @param str
     * @return String
     */
    public static String nullToEmptyString(String str) {
        if (isEmpty(str)) {
            return "";
        }
        return str;
    }


    public static String CheckInjection(String str) {
        //return  replaceJavascriptInjectionString(encoder.encodeForSQL(oracleCodec, str));
        return  replaceInjectionString(str);
    }

    public static String CheckInjectionRichTextEdit(String str) {
        //return  replaceJavascriptInjectionString(encoder.encodeForSQL(oracleCodec, str));
        return  replaceInjectionRichTextEdit(str);
    }


    public static String nullToEmptyString(Object obj) {
        if (isEmpty((String)obj)) {
            return "";
        }
        return (String)obj;
    }

    /**
     * 널 또는 빈 문자열의 경우 디폴트 스트링을 반환
     * @param target
     * @param defaultString
     * @return
     */
    public static String defaultIfEmpty(String target, String defaultString) {
        return StringUtils.defaultIfEmpty(target, defaultString);
    }

    public static String replace(String text, String searchString, String replacement) {
        return StringUtils.replace(text, searchString, replacement);
    }

    @Test
    public void testReplace() {
        String s = "TO_DATE: 20200221, FROM_DATE: 20200221,";
//      System.out.println(s.substring(0, s.length() - 1));
//      System.err.println(replace("AA,BB,CC,DD,AA,BB", "AA", "**"));
    }

    public static String replaceAll(String text, String searchString, String replacement) {
        if (text == null) return "";
        String returnText = "";
        returnText = text;
        for (int i = 0; i < returnText.length(); i++) {
            if (String.valueOf(returnText.charAt(i)).equals(searchString)) {
                returnText = returnText.replace(searchString, replacement);
            }
        }

        return returnText;
    }

    /**
     * 2차원 문자열 배열에서 해당 문자열의 인덱스를 반환<br>
     * return searchString index in Dimension String array
     * from wiseframework getIndex
     * difference: 첫번째 인덱스를 넘기고 두번째 인덱스만 리턴 받음
     * @param strComplexArray
     * @param searchString
     * @return String
     */
    public static int[] getIndexFromDimensionStringArray(String[][] strComplexArray, String searchString) {
        for (int i = 0; i < strComplexArray.length; i++) {
            for (int j = 0; j < strComplexArray.length; j++) {
                if (strComplexArray[i][j].equals(searchString)) {
                    return new int[] {i, j};
                }
            }
        }
        return new int[] {-1, -1};
    }

    /**
     * convert \n to &lt;br/&gt;
     * @param str
     * @return String
     */
    public static String nToBr(String str) {
        return StringUtils.replace(str, "\n", "<br/>");
    }

    /**
     * convert &lt;br/&gt; to \n
     * @param str
     * @return String
     */
    public static String brToN(String str) {
        return StringUtils.replace(str, "<br/>", "\n");
    }

    /**
     * 문자열 내에 delimeter 로 구분된 항목 들을 sql in 절에 맞는 형태로 변형(for in query)<br>
     * convert string with delimeter as Sql IN Statement
     * @param str
     * @param delimeter
     * @return String
     */
    public static String forInQuery(String str, String delimeter) {
        if(StringUtils.isEmpty(str)) {
            return null;
        }
        String[] split = StringUtils.split(str, delimeter);
        String join = StringUtils.join(split, "', '");
        return String.format("('%s')", join);
    }

    /**
     * Url encoding
     * @param str
     * @return String
     */
    public static String encodeUrl(String str) {
		/* @formatter:off */
        String[][] replaceMapArray = { {"%", "%25"}, {"#", "%23"}, {"&", "%26"}, {"'", "%27"}, {"+", "%2B"}, {":", "%3A"}, {";", "%3B"}, {"=", "%3D"}, {"\"", "%22"}, {" ", "+"}, {"\\n", "<br>"} };
		/* @formatter:on */

        StrBuilder strBuilder = new StrBuilder(str);
        for (String[] replaceMap : replaceMapArray) {
            strBuilder.replaceAll(replaceMap[0], replaceMap[1]);
        }
        return strBuilder.toString();
    }

    /**
     * Url decodeUrl
     * @param str
     * @return String
     */
    public static String decodeUrl(String str) {
		/* @formatter:off */
        String[][] replaceMapArray = { {" ", "+"} };
		/* @formatter:on */

        StrBuilder strBuilder = new StrBuilder(str);
        for (String[] replaceMap : replaceMapArray) {
            strBuilder.replaceAll(replaceMap[0], replaceMap[1]);
        }
        return strBuilder.toString();
    }

    /**
     * 문자열 덧셈<br>
     * Add number String
     * @param value1
     * @param value2
     * @return String
     */
    public static String add(String value1, String value2) {
        return new BigDecimal(value1).add(new BigDecimal(value2)).toString();
    }

    /**
     * 문자열 뺄셈<br>
     * subtract number String
     * @param value1
     * @param value2
     * @return String
     */
    public static String subtract(String value1, String value2) {
        return new BigDecimal(value1).subtract(new BigDecimal(value2)).toString();
    }

    /**
     * 문자열 곱셈<br>
     * multiply number String
     * @param value1
     * @param value2
     * @return String
     */
    public static String multiply(String value1, String value2) {
        return new BigDecimal(value1).multiply(new BigDecimal(value2)).toString();
    }

    /**
     * 문자열 나눗셈 rounding 모드와 자릿수 지정<br>
     * divide number String with rounding mode and digits
     * @param value1
     * @param value2
     * @param scale
     * @param roundMode
     * @return String
     */
    public static String divide(String value1, String value2, int scale, int roundMode) {
        return new BigDecimal(value1).divide(new BigDecimal(value2), scale, roundMode).toString();
    }

    /**
     * 문자열 나눗셈 반올림 할 자리수 지정<br>
     *  divide number String with rounding digits
     * @param value1
     * @param value2
     * @param scale
     * @return String
     */
    public static String divide(String value1, String value2, int scale) {
        return divide(value1, value2, scale, BigDecimal.ROUND_HALF_UP).toString();
    }

    /**
     * 문자열 나눗셈 소숫점 둘째 자리 까지<br>
     * divide number Up to two decimal places
     * @param value1
     * @param value2
     * @return String
     */
    public static String divide(String value1, String value2) {
        return divide(value1, value2, 2);
    }

    /**
     * 문자열 나머지(mod, %)<br>
     * mod number String
     * @param value1
     * @param value2
     * @return String
     */
    public static String remainder(String value1, String value2) {
        return new BigDecimal(value1).remainder(new BigDecimal(value2)).toString();
    }

    /**
     * 문자열을 srcEncodingType에서 targetEncodingType으로 변환<br>
     * convert String Encoding
     * @param str
     * @param srcEncodingType
     * @param targetEncodingType
     * @return String
     * @throws UnsupportedEncodingException
     */
    public static String convertEncoding(String str, String srcEncodingType, String targetEncodingType) throws UnsupportedEncodingException {
//        return StringUtils.toEncodedString(str.getBytes(srcEncodingType), Charset.forName(targetEncodingType));
    	return new String(str.getBytes(srcEncodingType), targetEncodingType);
    }

    /**
     * 8859_1문자열을 KSC5601로 변환
     * 변환에 실패하면 null을 반환<br>
     * convert String 8859_1 when fail convert to KSC5601
     * @param str
     * @return String
     */
    public static String e2k(String str) {
        try {
            return convertEncoding(str, "8859_1", "KSC5601");
        } catch (UnsupportedEncodingException e) {
            return null;
        }
    }

    /**
     * KSC5601문자열을 8859_1로 변환<br>
     * convert KSC5601 String to 8859_1
     * 변환에 실패하면 null을 반환
     * @param str
     * @return String
     */
    public static String k2e(String str) {
        try {
            return convertEncoding(str, "KSC5601", "8859_1");
        } catch (UnsupportedEncodingException e) {
            return null;
        }
    }

    public static ArrayList<String> chopSplitString(String data, int length) throws Exception {

        ArrayList<String> list = new ArrayList<String>();

        String ui = data;
        int dataLength = getLengthb(ui);

        while (dataLength > 0) {
            list.add(getSubString(ui, 0, length));
            ui = getSubString(ui, length, dataLength);
            dataLength = getLengthb(ui);
        }

        return list;
    }

    public static String getSubString(String str, int start, int end) {
        if (str == null) return "";
        int rSize = 0;
        int len = 0;

        StringBuffer sb = new StringBuffer();

        for (; rSize < str.length(); rSize++) {
            if (str.charAt(rSize) > 0x007F) {
                len += 2;
            } else {
                len++;
            }

            if ((len > start) && (len <= end)) {
                sb.append(str.charAt(rSize));
            }
        }

        return sb.toString();
    }

    public static int getLengthb(String str) {
        int rSize = 0;
        int len = 0;

        for (; rSize < str.length(); rSize++) {
            if (str.charAt(rSize) > 0x007F) {
                len += 2;
            } else {
                len++;
            }
        }

        return len;
    }

    public static String getDBLinkName(String tableName, String dbLinkName) throws Exception {
        String databaseId = SpringContextUtil.getUtilService().getDatabaseCode();
        if ("OR".equals(databaseId)) {
            return tableName + dbLinkName;
        } else if ("MS".equals(databaseId)) {
            return dbLinkName + tableName;
        } else {
            return tableName;
        }
    }

    /**
     * @Method Name : makeGridTextLinkStyle
     * @Author daguri
     * @Date 2014. 11. 3.
     * @Version 1.0
     * @Param :
     * @Return : void
     * @Description
     * @param resp
     * @param grid
     * @param columnName
     */
    public static void makeGridTextLinkStyle(EverHttpResponse resp, String grid, String columnName) {
        resp.setGridColStyle(grid, columnName, "cursor", "pointer");
        resp.setGridColStyle(grid, columnName, "color", "#000DFF");
        resp.setGridColStyle(grid, columnName, "text-decoration", "underline");
    }

    /**
     * @Method Name : preventSqlInjection
     * @Author daguri
     * @Date 2014. 10. 31.
     * @Version 1.0
     * @Param :
     * @Return : String
     * @Description
     * @param value
     * @return
     */
    public static String preventSqlInjection(String value) {

        if(value == null) {
            return null;
        }

        Map<Character, String> guideMap = new HashMap<Character, String>();
        guideMap.put((char)60, "&lt;");
        guideMap.put((char)62, "&gt;");
        guideMap.put((char)34, "\"");
        guideMap.put((char)39, "''");
        for(Character ch : guideMap.keySet()) {
            value = value.replaceAll(ch.toString(), guideMap.get(ch));
        }

        return value;
    }

    /**
     * @Method Name : rePreventSqlInjection
     * @Author daguri
     * @Date 2014. 10. 31.
     * @Version 1.0
     * @Param :
     * @Return : String
     * @Description
     * @param value
     * @return
     */
    public static String rePreventSqlInjection(String value) {
        if(value == null) {
            return null;
        }

        Map<String, String> guideMap = new HashMap<String, String>();
        guideMap.put("&lt;", "<");
        guideMap.put("&gt;", ">");
        guideMap.put("&#39;", "'");

        for(String ch : guideMap.keySet()) {
            value = value.replaceAll(ch, guideMap.get(ch));
        }

        return value;
    }

	public static void makeGridTextBlueStyle(EverHttpResponse resp, String grid, String columnName) {
		resp.setGridColStyle(grid, columnName, "cursor", "pointer");
		resp.setGridColStyle(grid, columnName, "color", "#000DFF");
	}

	public static String replaceToXmlString(String str) {
		String xmlStr = str;

		xmlStr = replace(xmlStr, "&", "&amp;");
		xmlStr = replace(xmlStr, "<", "&lt;");
		xmlStr = replace(xmlStr, ">", "&gt;");
		xmlStr = replace(xmlStr, "'", "&apos;");
		xmlStr = replace(xmlStr, "\"", "&quot;");

		return xmlStr;
	}

	public static String replaceStringFromXml(String xmlStr) {
		String str = xmlStr;

		str = replace(str, "&amp;", "&");
		str = replace(str, "&lt;", "<");
		str = replace(str, "&gt;", ">");
		str = replace(str, "&apos;", "'");
		str = replace(str, "&quot;", "\"");

		return str;
	}

    public static Map<String, String> getDataMap(EverHttpRequest req) {

        Map<String, String> mRequest = new HashMap<String, String>();
        Enumeration e = req.getRequest().getParameterNames();

        while( e.hasMoreElements() ) {
            String paramName = e.nextElement().toString();
            String paramValue = req.getRequest().getParameter(paramName);
            if ( paramName == null || paramValue == null ) continue;
            paramName = paramName.toUpperCase().replace("AMP;", "");

            mRequest.put(paramName, paramValue);
        }

        return mRequest;
    }

    public static String changeCharacterSetDb2AppString(String sourceStr) {

//    	if(! PropertiesManager.getBoolean("eversrm.system.database.encoding.useFlag")) {
//    		return sourceStr;
//    	}

        if(StringUtils.isEmpty(sourceStr)) {
            return "";
        }
/*
    	String dbValue = PropertiesManager.getString("eversrm.system.database.encoding.db.value");
    	String appValue = PropertiesManager.getString("eversrm.system.database.encoding.app.value");

        try {
            sourceStr = new String(sourceStr.getBytes(dbValue), appValue);
        } catch (UnsupportedEncodingException e) {
            logger.error(e.getMessage(), e);
        }
*/
        return sourceStr;
    }

    public static String changeCharacterSetApp2DbString(String sourceStr) {
    	if(! PropertiesManager.getBoolean("eversrm.system.database.encoding.useFlag")) {
    		return sourceStr;
    	}
        if(StringUtils.isEmpty(sourceStr)) {
            return "";
        }

        String dbValue = PropertiesManager.getString("eversrm.system.database.encoding.db.value");
        String appValue = PropertiesManager.getString("eversrm.system.database.encoding.app.value");

        try {
            sourceStr = new String(nullToEmptyString(sourceStr).getBytes(appValue), dbValue);
        } catch (UnsupportedEncodingException e) {
            logger.error(e.getMessage(), e);
        }
        return sourceStr;
    }

    /**
     * 보안정책에 의한 마스킹 처리
     * @param str
     * @param type
     * @return
     * @throws Exception
     */
    public static String setEncryptedString(String str, String type) throws Exception {

        String resultStr = "";

        if(str == null) {
            return str;
        }

	    if(type != null) {
            if (type.equals("N")) { /** Name */
                StringBuilder s = new StringBuilder(str);
                try {
                    s.setCharAt(1, '*');
                } catch(StringIndexOutOfBoundsException se) {
                    return s.toString();
                }
                resultStr = s.toString();
            } else if (type.equals("A")) { /** All */
                resultStr = StringUtils.replacePattern(str, ".", "*");
            } else if (type.equals("E")) { /** Etc. */

                if (str.indexOf("@") > -1) {
                    String[] sArr = str.split("@");
                    String s = sArr[0];

                    try {
                        s = s.replace(s.substring(1, s.length()), renderStar(s.length())) + "@" + sArr[1];
                    } catch (StringIndexOutOfBoundsException se) {
                        resultStr = s;
                    }
                    resultStr = s;
                } else {
                    resultStr = str;
                }
            }
        } else {
            resultStr = str;
        }

        return resultStr;
    }

    public static String renderStar(int length) {
        String regExp = "";

        for(int i = 0; i < length; i++) {
            if(i != 0) regExp += "*";
        }

        return regExp;
    }

    @Test
    public void doTestEncryptedString() throws Exception {

        String alphabet = "ABCD";
        System.err.println(setEncryptedString(alphabet, "A"));
        System.err.println(setEncryptedString(alphabet, "N"));
        System.err.println(setEncryptedString(alphabet, "E"));

    }

    public static String getRandomPassword(int cnt) {

        char pwCollection[] = new char[] {
                '1','2','3','4','5','6','7','8','9','0',
//                'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
//                '!','@','#','$','%','^','*','(',')','+'
        };//배열에 선언

        char pwCollectionD[] = new char[] {
                '1','2','3','4','5','6','7','8','9','0'
        };

        char pwCollectionS[] = new char[] {
                '!','@','#','$','%','^','*','(',')','+'
        };

        char pwCollectionU[] = new char[] {
                'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
        };//배열에 선언

        char pwCollectionL[] = new char[] {
                'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
        };//배열에 선언

        String ranPw = "";



        /* 아무거나 8자리 */
        for (int i = 0; i < cnt; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollection.length));
            ranPw += pwCollection[selectRandomPw];
        }

        /* 숫자 1자리 */
        /*for (int i = 0; i < 1; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollectionD.length));
            ranPw += pwCollectionD[selectRandomPw];
        }*/

        /* 아무거나 4자리 */
        /*for (int i = 0; i < 5; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollection.length));
            ranPw += pwCollection[selectRandomPw];
        }*/

        /* 대문자 1자리 */
        /*for (int i = 0; i < 1; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollectionS.length));
            ranPw += pwCollectionU[selectRandomPw];
        }*/

        /* 소문자 3자리 */
        /*for (int i = 0; i < 3; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollectionS.length));
            ranPw += pwCollectionL[selectRandomPw];
        }*/

        /* 특수문자 1자리 */
        /*for (int i = 0; i < 1; i++) {
            int selectRandomPw = (int)(new SecureRandom().nextDouble()*(pwCollectionS.length));
            ranPw += pwCollectionS[selectRandomPw];
        }*/

        return ranPw;
    }

    /**
     * 보안정책에 의한 마스킹 처리
     * 섬영 : 홍*동 (성 뒤 이름의 첫 자리 마스킹)
     * 전화번호 또는 휴대폰 전화번호 : 010-****-1234 (국번 마스킹)
     * 주소 : 서울 영등포구 여의도동 **-** (읍.면.동 또는 이후 주소 마스킹)
     * 인터넷 주소 : 123.123.***.123 (버전 4의 경우 17~24비트영역, 버전 6의 경우 113~128비트영역)
     * 패스워드 : ****** (전체자리 마스킹)
     * @param str
     * @param type("A":전체(비밀번호),"N":성명,"T":전화번호,"M":이메일,"I":IP Address
     * @return
     * @throws Exception
     */
    public static String setMaskString(String str, String type) throws Exception {

        if(EverString.isEmpty(str) || "null".equals(str)) {
            return "";
        }

        if(type != null) {
            if (type.equals("A")) { /** All(전체 : 비밀번호) */
                str = StringUtils.replacePattern(str, ".", "*");
            } else if (type.equals("N")) { /** 홍*동 (성 뒤 이름의 첫 자리 마스킹) */
                try {
                    str = maskName(str);
                } catch(Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    return ex.toString();
                }
            } else if (type.equals("T")) { /** 010-****-1234 (국번 마스킹) */
                try {
                    str = maskPhoneNum(str);
                } catch(Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    return ex.toString();
                }
            } else if (type.equals("M")) { /** ho*****@naver.com (3자리부터 @ 앞까지 마스킹) */
                try {
                    str = maskEmail(str);
                } catch(Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    return ex.toString();
                }
            } else if (type.equals("I")) { /** 123.123.***.123 (버전 4의 경우 17~24비트영역, 버전 6의 경우 113~128비트영역) */
                try {
                    str = maskIp(str);
                } catch(Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    return ex.toString();
                }
            } else if (type.equals("USER_ID")) { /* KHA**** 사용자 ID 일부만 표시한다. */
                try {
                    str = maskUserId(str);
                } catch(Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    return ex.toString();
                }
            }
        } else {
            throw new Exception("No type specified!");
        }

        return str;
    }

    /**
     * 사용자ID 마스킹 처리(aaaa******)
     * @param str
     * @return
     */
    private static String maskUserId(String str) {
        String LASTNAME_PATTERN = "(?<=.{0}).";

        if(str.length() < 4) {
            return str;
        } else {
            return str.substring(0, 4) + str.substring(4).replaceAll(LASTNAME_PATTERN, "*");
        }
    }

    /**
     * 이름 마스킹 처리(홍*동)
     * @param str
     * @return
     */
    public static String maskName(String str) {
        String replaceString = str;

        String pattern = "";
        if(str.length() == 2) {
            pattern = "^(.)(.+)$";
        } else {
            pattern = "^(.)(.+)(.)$";
        }

        Matcher matcher = Pattern.compile(pattern).matcher(str);
        if(matcher.matches()) {
            replaceString = "";
            for(int i=1;i<=matcher.groupCount();i++) {
                String replaceTarget = matcher.group(i);
                if(i == 2) {
                    char[] c = new char[replaceTarget.length()];
                    Arrays.fill(c, '*');

                    replaceString = replaceString + String.valueOf(c);
                } else {
                    replaceString = replaceString + replaceTarget;
                }
            }
        }
        return replaceString;
    }

    /**
     * 전화번호 마스킹 처리
     * @param str
     * @return
     */
    public static String maskPhoneNum(String str) {
        String replaceString = str.trim();
        Matcher matcher = Pattern.compile("^(\\d{3})-?(\\d{3,4})-?(\\d{4})$").matcher(str); //휴대전화(010-1111-2222)
        if(matcher.matches()) {
            replaceString = makeMaskPhone(str, matcher);
        } else {
            matcher = Pattern.compile("^(\\d{2,3})-?(\\d{3,4})-?(\\d{4})$").matcher(str); //일반전화(02-3333-4444)
            if(matcher.matches()) {
                replaceString = makeMaskPhone(str, matcher);
            }
        }

        return replaceString;
    }

    public static String makeMaskPhone(String str, Matcher matcher) {
        String replaceString = "";
        boolean isHyphen = false;
        if(str.indexOf("-") > -1) {
            isHyphen = true;
        }
        for(int i=1;i<=matcher.groupCount();i++) {
            String replaceTarget = matcher.group(i);
            if(i == 2) {
                char[] c = new char[replaceTarget.length()];
                Arrays.fill(c, '*');
                replaceString = replaceString + String.valueOf(c);
            } else {
                replaceString = replaceString + replaceTarget;
            }
            if(isHyphen && i < matcher.groupCount()) {
                replaceString = replaceString + "-";
            }
        }

        return replaceString;
    }

    /**
     * 이메일 마스킹 처리
     * @param str
     * @return
     */
    public static String maskEmail(String str) {
        String replaceString = str;

        Matcher matcher = Pattern.compile("^(..)(.*)([@]{1})(.*)$").matcher(str);
        if(matcher.matches()) {
            replaceString = "";
            for(int i = 1; i <= matcher.groupCount(); i++) {
                String replaceTarget = matcher.group(i);
                if(i == 2) {
                    char[] c = new char[replaceTarget.length()];
                    Arrays.fill(c, '*');
                    replaceString = replaceString + String.valueOf(c);
                } else {
                    replaceString = replaceString + replaceTarget;
                }
            }
        }
        return replaceString;
    }

    /**
     * IP 마스킹 처리
     * @param str
     * @return
     */
    public static String maskIp(String str) {
        String replaceString = "";
        String[] strArr = str.split("[.]", 0);
        for( int i = 0; i < strArr.length; i++ ) {
            if( i == 2 ){
                strArr[i] = "***";
            }
            replaceString += (i > 0 ? "." : "") + strArr[i];
        }
        return replaceString;
    }

    public static String getClientIP() {

        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

        String ip = request.getHeader("X-FORWARDED-FOR");

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        // ipv6 (ipv4 127.0.0.1) localhost로 접속했을시
        if("0:0:0:0:0:0:0:1".equals(ip)){
            ip = "127.0.0.1";
        }

        return EverString.nullToEmptyString(ip);
    }
    public static ArrayList forInQueryArrayList(String str, String delimeter) {
    	ArrayList returnArrayList = new ArrayList();
        if(StringUtils.isEmpty(str)) {
            return null;
        }
        String[] split = StringUtils.split(str, delimeter);

        for(int k=0;k<split.length;k++) {
        	returnArrayList.add(split[k]);
        }

        return returnArrayList;
    }

    public static Map<String, String> replaceInjection(Map<String, String> param) throws Exception {

        Map<String, String> paramInfo = new HashMap<>();
        Iterator<String> keys = param.keySet().iterator();
        while ( keys.hasNext() ) {
            String key   = keys.next();
            String value = param.get(key);
            //if(key.toUpperCase().indexOf("CALLBACK") > -1) {
            value = EverString.preventSqlInjection(value);
            //}
            paramInfo.put(key, value);
        }

        return paramInfo;
    }

    public static String cleanString(String aString) {
        if (aString == null) return null;
        String cleanString = "";

        // 보안점검 취약점 보완
        if(aString.indexOf("//") > -1) {
            aString = EverString.nullToEmptyString(aString).replaceAll("//", "");
        }
        else if(aString.indexOf("\\.") > -1) {
            aString = EverString.nullToEmptyString(aString).replaceAll("\\.", "");
        }
        else if(aString.indexOf("../") > -1) {
            aString = EverString.nullToEmptyString(aString).replaceAll("../", "");
        }
        else if(aString.indexOf("\\\\") > -1) {
            aString = EverString.nullToEmptyString(aString).replaceAll("\\\\", "");
        }

        for (int i = 0; i < aString.length(); ++i) {
            cleanString += cleanChar(aString.charAt(i));
        }
        return cleanString;
    }

    private static char cleanChar(char aChar) {
        // 0 - 9
        for (int i = 48; i < 58; ++i) {
            if (aChar == i) return (char) i;
        }
        // 'A' - 'Z'
        for (int i = 65; i < 91; ++i) {
            if (aChar == i) return (char) i;
        }
        // 'a' - 'z'
        for (int i = 97; i < 123; ++i) {
            if (aChar == i) return (char) i;
        }

        // other valid characters
        switch (aChar) {
            case '/':
                return '/';
            case '.':
                return '.';
            case '-':
                return '-';
            case '_':
                return '_';
            case ' ':
                return ' ';
            case ':':
                return ':';
            case '\\':
                return '\\';
        }
        return '%';
    }
}