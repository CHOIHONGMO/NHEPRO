package com.st_ones.common.util.clazz;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
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
 * @File Name : EverConverter.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class EverConverter {

    private static Logger logger = LoggerFactory.getLogger(EverConverter.class);

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private static final Set<String> IGNORE_CHECK_INJECTION_KEYS = new HashSet<>(Arrays.asList(
        "SQL", "ITEM_DESC", "ITEM_SPEC", "moduleName", "methodName", "actionCode", "PACKAGE_NM",
        "action_cd", "DATABASE_CD", "sqlQuery", "_sqlQuery_", "value", "SQL_TEXT", "sql",
        "TEXT_CONTENTS", "CONTENTS_TEXT_NUM", "CONTENTS", "approvalFormData", "approvalGridData",
        "attachFileDatas", "OPINION", "BID_AMT_CERTV", "GUAR_AMT_CERTV", "ADJ_CERTV",
        "VID_RANDOM", "SIGN_VALUE", "SIGN_RANDOM", "ADJ_VID_RANDOM"
    ));

    private static volatile String stringMergeOperator = null;

    // convertInjection 최적화를 위한 프리컴파일 패턴들
    private static final Pattern PATTERN_UNION = Pattern.compile("UNION(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_PERCENT = Pattern.compile("%");
    private static final Pattern PATTERN_SELECT = Pattern.compile("SELECT(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_FROM = Pattern.compile("(?<=\\s)FROM(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_WHERE = Pattern.compile("(?<=\\s)WHERE(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_LIMIT = Pattern.compile("(?<=\\s)LIMIT(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_AND = Pattern.compile("(?<=\\s)AND(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_DASHES = Pattern.compile("--");
    private static final Pattern PATTERN_PIPE = Pattern.compile("\\|\\|");
    private static final Pattern PATTERN_AMP = Pattern.compile("&&");
    private static final Pattern PATTERN_LT = Pattern.compile("<");
    private static final Pattern PATTERN_GT = Pattern.compile(">");
    private static final Pattern PATTERN_INSERT = Pattern.compile("INSERT(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_UPDATE = Pattern.compile("UPDATE(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_DELETE = Pattern.compile("DELETE(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_CREATE = Pattern.compile("CREATE(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_DROP = Pattern.compile("DROP(?=\\s)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PATTERN_IF = Pattern.compile("IF(?=\\s)", Pattern.CASE_INSENSITIVE);

    /**
     * Object를 JSONString으로 변환
     * Convert Object to JSONString
     *
     * @param jsonBean
     * @return String
     * @throws Exception
     */
    public static String getJsonString(Object jsonBean) throws Exception {
        return OBJECT_MAPPER.writeValueAsString(jsonBean);
    }

    /**
     * JSONString을 읽어 객체로 반환
     * Convert JSONString to Object
     *
     * @param jsonStr
     * @param objType
     * @return <T>
     * @throws Exception
     */
    public static <T> T readJsonObject(String jsonStr, Class<T> objType) throws Exception {
        return OBJECT_MAPPER.readValue(jsonStr, objType);
    }

    /**
     * MultiSearchCondition을 위한 method
     * For Multi Serch Condition
     *
     * @param map
     * @return Map<String, Object>
     * @throws Exception
     */
    public static Map<String, Object> forDynamicQuery(Map<String, Object> map) throws Exception {

        List<String> multiKeys = new ArrayList<String>();
        Set<String> keySet = map.keySet();

        for (String key : keySet) {
            Object value = map.get(key);
            if (!(value instanceof String)) {
                continue;
            }

            boolean isIgnoreCheckInjection = IGNORE_CHECK_INJECTION_KEYS.contains(key);
            String searchValue = (String) value;

            if (isIgnoreCheckInjection) {
                map.put(key, searchValue);
            } else {
                map.put(key, EverString.CheckInjection(searchValue));
            }

            multiKeys.add(key);
        }

        for (String key : multiKeys) {
            String value = (String) map.get(key);
            String mode = "L";
            value = value.trim();
            logger.debug("EverConverter: Mode:{} /key: {} : {}", mode, key, value);
            
            boolean isIgnoreCheckInjection = IGNORE_CHECK_INJECTION_KEYS.contains(key);
            if (isIgnoreCheckInjection) {
                map.put(key, value);
            } else {
                map.put(key, convertInjection(value));
            }
            map.putAll(makeDynamicStatement(mode, key, value));
        }
        return map;
    }

    /**
     * MultiSearchCondition을 위한 method
     * For Multi Serch Condition
     *
     * @param mode
     * @param key
     * @param value
     * @return Map<String, Object>
     */
    private static String getStringMergeOperator() throws Exception {
        if (stringMergeOperator == null) {
            synchronized (EverConverter.class) {
                if (stringMergeOperator == null) {
                    String databaseId = PropertiesManager.getString("eversrm.system.database");
                    if ("OR".equals(databaseId)) {
                        stringMergeOperator = "||";
                    } else if ("MS".equals(databaseId)) {
                        stringMergeOperator = "+";
                    } else {
                        throw new Exception("illegal database id. databaseId: " + databaseId);
                    }
                }
            }
        }
        return stringMergeOperator;
    }

    private static Map<String, String> makeDynamicStatement(String mode, String key, String value) throws Exception {
        Map<String, String> map = new HashMap<String, String>();
        String left = "";
        String right = "";
        String mergeOp = getStringMergeOperator();

        switch (mode) {
            case "E":
                right = " = '%s'";
                break;
            case "D":
                right = " != '%s'";
                break;
            case "L":
                left = "UPPER(";
                right = ") LIKE '%%' " + mergeOp + " UPPER('%s') " + mergeOp + " '%%'";
                break;
            case "NL":
                left = "UPPER(";
                right = ") NOT LIKE '%%' " + mergeOp + " UPPER('%s') " + mergeOp + " '%%'";
                break;
            case "B":
                right = " > '%s'";
                break;
            case "BE":
                right = " >= '%s'";
                break;
            case "S":
                right = " < '%s'";
                break;
            case "SE":
                right = " <= '%s'";
                break;
            case "IN":
                right = " IS NULL";
                break;
            case "INN":
                right = " IS NOT NULL";
                break;
            case "I":
                right = " IN " + EverString.forInQuery(value, ",");
                break;
            case "NI":
                right = " NOT IN " + EverString.forInQuery(value, ",");
                break;
            default:
                break;
        }

        /* 멀티서치 로직은 myBatis에서 #가 아닌 $를 사용해서 붙이므로 SQL Injection 공격에 취약하다. */
        String escapedValue = EverString.changeCharacterSetApp2DbString(value.replaceAll("&#39;", "''").replaceAll("'", "''"));
        left = String.format(left, escapedValue);
        right = String.format(right, escapedValue);

        if (key == null || key.length() < 2) {
            map.put(key + "_L", left);
            map.put(key + "_R", right);
            return map;
        }

        String subStringKey = key.substring(key.length() - 2);
        if (subStringKey.equalsIgnoreCase("_L") || subStringKey.equalsIgnoreCase("_R")) {
            return map;
        } else {
            map.put(key + "_L", left);
            map.put(key + "_R", right);
        }
        return map;
    }

    /**
     * null check
     *
     * @param str
     * @return String
     */
    public static String nullChk(String str) {

        String rtnVal = "";
        if (str == null) {
            rtnVal = "";
        } else {
            try {
                rtnVal = URLDecoder.decode(str, StandardCharsets.UTF_8.name());
            } catch (UnsupportedEncodingException unsupportedencodingexception) {
                logger.error(unsupportedencodingexception.getMessage(), unsupportedencodingexception);
            }
        }
        return rtnVal;
    }

    public static String convertInjection(String ori) {
        if (ori == null) {
            return null;
        }
        String str = ori;

        str = PATTERN_UNION.matcher(str).replaceAll("");
        str = PATTERN_PERCENT.matcher(str).replaceAll("％");
        str = PATTERN_SELECT.matcher(str).replaceAll("");
        str = PATTERN_FROM.matcher(str).replaceAll("");
        str = PATTERN_WHERE.matcher(str).replaceAll("");
        str = PATTERN_LIMIT.matcher(str).replaceAll("");
        str = PATTERN_AND.matcher(str).replaceAll("");
        str = PATTERN_DASHES.matcher(str).replaceAll("");
        str = PATTERN_PIPE.matcher(str).replaceAll("");
        str = PATTERN_AMP.matcher(str).replaceAll("");
        str = PATTERN_LT.matcher(str).replaceAll("");
        str = PATTERN_GT.matcher(str).replaceAll("");
        str = PATTERN_INSERT.matcher(str).replaceAll("");
        str = PATTERN_UPDATE.matcher(str).replaceAll("");
        str = PATTERN_DELETE.matcher(str).replaceAll("");
        str = PATTERN_CREATE.matcher(str).replaceAll("");
        str = PATTERN_DROP.matcher(str).replaceAll("");
        str = PATTERN_IF.matcher(str).replaceAll("");

        return str;
    }
}