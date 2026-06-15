package com.st_ones.common.mybatis;

import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.util.StringUtil;
import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.mapping.ParameterMapping;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StopWatch;

import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverSqlLogger.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class EverSqlLogger {

	private static final String FOREACH_KEY = "__frch_";
	private static String[] encryptTargetWords = {/*"USER",*/ "TEL", "ADDR", /*"EMAIL", "CELL",*/ "FAX", "IRS", "EMPLOYEE", "ZIP_CD"
												 ,/*"user",*/ "tel", "addr", /*"email", "cell",*/ "fax", "irs", "employee", "zip_cd"};
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private Map<String, Object> parameter = null;
	private String id;
	private String sql;
	private final List<String> paramList;
	private String property;

	@SuppressWarnings("unchecked")
	public EverSqlLogger(String _id, String _sql, Object _parameter) {

		this.paramList = new ArrayList<String>();
		this.id = "/* "+_id + " */\n";
		this.sql = this.id + _sql;

		if (_parameter instanceof Map) {
			this.parameter = (Map<String, Object>)_parameter;
		} else {
			this.parameter = new BeanMap(_parameter);
		}
	}

	@SuppressWarnings({"rawtypes"})
	public void logging(List<ParameterMapping> paramMapping, StopWatch stopWatch, int resultCount) {

		for (ParameterMapping parameterMapping : paramMapping) {
			this.property = parameterMapping.getProperty();

			Object parameterValue = getParameterValue();
			if (parameterValue instanceof Map) {
				addMapToParamList((Map)parameterValue);
			} else if (parameterValue instanceof String) {
				addStringToParamList((String)parameterValue);
			} else if (parameterValue instanceof List) {
				addListToParamList((List)parameterValue);
			} else if (parameterValue == null) {
				addNullToParamListNull();
			} else {
				addStringToParamList(parameterValue.toString());
				logger.debug("Parameter [{}] is not String type. (Type -> {})", property, parameterValue.getClass().getName());
			}
		}

		sql = StringUtil.replace(sql, "?", "'%s'");

    	for (String param : paramList) {
			if (param == null) {
				sql = StringUtils.replaceOnce(sql, "'%s'", "null");
			} else {
				sql = StringUtils.replaceOnce(sql, "%s", param);
			}
		}

		sql = sql + System.getProperty("line.separator") +
				"-- " + resultCount + " row(s), executed in " + stopWatch.getTaskInfo()[0].getTimeMillis() + "ms";

		sql = trimSpace(sql);

		try {
			logger.info(new String((System.getProperty("line.separator") + sql).getBytes("UTF-8"), "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		}
	}

	@SuppressWarnings("rawtypes")
	private void addListToParamList(List parameterValue) {
		int listIndex = getListIndex();
		listIndex = listIndex % parameterValue.size();
		if (parameterValue.size() > listIndex) {
			Object element = parameterValue.get(listIndex);
			if (element instanceof LinkedHashMap) {
				paramList.add((String)((LinkedHashMap)element).get(getPropertyNameAfterDot()));
			} else if (element instanceof Map) {
				paramList.add((String)((Map)element).get(getPropertyNameAfterDot()));
			} else if (element instanceof String) {
				paramList.add((String)element);
			} else { // Bean
				paramList.add((String)new BeanMap(element).get(getPropertyNameAfterDot()));
			}
		}
	}

	private int getListIndex() {
		String listItemKey = property;
		if (property.contains(".")) {
			listItemKey = getPropertyBeforeDot();
		}
		String listIndexString = listItemKey.substring(listItemKey.lastIndexOf("_") + 1);
		return Integer.parseInt(listIndexString);
	}

	private void addNullToParamListNull() {
		logger.info("Parameter [{}] is null.", property);
		paramList.add(null);
	}

	private Object getParameterValue() {
		if (property.contains(FOREACH_KEY)) {
			return parameter.get(getListTypeKey());
		} else if (property.contains(".")) {
			return new BeanMap(parameter.get(getPropertyBeforeDot()));
		}
		return parameter.get(property);
	}

	@SuppressWarnings("rawtypes")
	private void addMapToParamList(Map parameterValue) {

		String propName = getPropertyNameAfterDot();
		String value;
		if (PropertiesManager.getBoolean("eversrm.sql.logging.personalInfo.encrypt") && !PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
			if(StringUtils.indexOfAny(this.property, encryptTargetWords) > -1) {
				try {
					value = EverString.setEncryptedString((String) parameterValue.get(propName), "A");
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					value = (String) parameterValue.get(propName);
				}
			} else {
				value = (String) parameterValue.get(propName);
			}
		} else {
			value = (String) parameterValue.get(propName);
		}

		paramList.add(value);
	}

	private String getPropertyBeforeDot() {
		return property.substring(0, property.indexOf("."));
	}

	private String getPropertyNameAfterDot() {
		return property.substring(property.indexOf(".") + 1);
	}

	private void addStringToParamList(String parameterValue) {
		if (PropertiesManager.getBoolean("eversrm.sql.logging.personalInfo.encrypt") && !PropertiesManager.getBoolean("eversrm.system.developmentFlag")) {
//			logger.info("{} : {} => {}", this.property, this.encryptTargetWords, StringUtils.indexOfAny(this.property, this.encryptTargetWords) > -1);
			if(StringUtils.indexOfAny(this.property, encryptTargetWords) > -1) {
				try {
					parameterValue = EverString.setEncryptedString(parameterValue, "A");
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			paramList.add(parameterValue);
		} else {
			paramList.add(parameterValue);
		}
	}

	private String trimSpace(String query) {
		String sqlQuery;
		sqlQuery = query.replaceAll("\n\\s{3,}\n", "\n");
		sqlQuery = sqlQuery.replaceAll("\n\\s{3,},\\s*\n", ",\n");
		sqlQuery = sqlQuery.replaceAll("    ", "\t");
		sqlQuery = sqlQuery.replaceAll("\n\t\t", "\n");
		sqlQuery = sqlQuery.replaceAll("^", "\t");
		sqlQuery = sqlQuery.replaceAll("\n", "\n\t");
		return sqlQuery;
	}

	private String getListTypeKey() {
		Set<String> keySet = parameter.keySet();
		List<String> listTypeKeys = new ArrayList<String>();
		for (String key : keySet) {
			if (key.contains("param")) {
				continue;
			}
			if (parameter.get(key) instanceof List) {
				listTypeKeys.add(key);
			}
		}

		if (listTypeKeys.size() == 1) {
			return listTypeKeys.get(0);
		}

		for (String listTypeKey : listTypeKeys) {
			if (listTypeKey.toUpperCase().contains(property.toUpperCase())) {
				return listTypeKey;
			}
		}

		logger.error("listTypeKeys: " + listTypeKeys);
		logger.error("property: " + property);
		if (listTypeKeys.size() == 0) {
			throw new IllegalArgumentException("doesn't have list element in param");
		}

		throw new IllegalArgumentException("myBatis Mapper has more than 2 foreach element and doesnt match container and element id. Do not use 'param' as foreach collection key");
	}
}
