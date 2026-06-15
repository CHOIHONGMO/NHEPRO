package com.st_ones.common.combo;

import com.st_ones.common.util.clazz.EverString;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.SqlSource;
import org.apache.ibatis.scripting.xmltags.XMLLanguageDriver;
import org.apache.ibatis.session.Configuration;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SqlBuilder.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "sqlBuilder")
public class SqlBuilder {

    public String getSql(Map<String, Object> param) {

        BoundSql boundSql;
        Configuration configuration = (Configuration)param.get("configuration");
        SqlSource sqlQuery_ = new XMLLanguageDriver().createSqlSource(configuration, "<script>"+param.get("_sqlQuery_")+"</script>", Map.class);

        Map<String, String> param1 = (Map<String, String>)param.get("param");
        boundSql = sqlQuery_.getBoundSql(param1);

        StringBuilder sql = new StringBuilder(boundSql.getSql());
        for (ParameterMapping pm : boundSql.getParameterMappings()) {
            String property = pm.getProperty();
            int index = sql.indexOf("?");
            sql.replace(index, index + 1, "'" + EverString.CheckInjection(param1.get(property)) + "'");
        }

        return sql.toString();
    }
}
