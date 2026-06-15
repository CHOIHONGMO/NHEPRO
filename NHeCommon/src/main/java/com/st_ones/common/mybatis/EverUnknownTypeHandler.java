package com.st_ones.common.mybatis;

import com.st_ones.common.util.clazz.EverString;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedTypes;
import org.apache.ibatis.type.ObjectTypeHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Clob;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverUnknownTypeHandler.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 * parameterType, resultType 이 hashmap 등으로, 명확하게 데이터형이 정해져있지 않은 파라미터일 경우 호출되는 핸들러이다.
 */
@MappedTypes(value = {Object.class})
public class EverUnknownTypeHandler extends ObjectTypeHandler {

    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Override
    public void setParameter(PreparedStatement ps, int i, Object parameter, JdbcType jdbcType) throws SQLException {

        Object newParameter = null;
        if(parameter != null) {
            if(parameter instanceof String) {
                newParameter = EverString.changeCharacterSetApp2DbString((String)parameter);
            } else {
                newParameter = parameter;
            }
        }

        try {
            ps.setObject(i, newParameter);
        } catch(SQLException se) {
            logger.error("{}", se);
        }
    }

    @Override
    public Object getResult(ResultSet rs, String columnName) throws SQLException {

        Object value = rs.getObject(columnName);
        if(value instanceof String) {
            String result = EverString.changeCharacterSetDb2AppString(rs.getString(columnName));
            return result;

        } else if(value instanceof Clob) {
            return EverString.changeCharacterSetDb2AppString(rs.getString(columnName));
        } else {
            return super.getResult(rs, columnName);
        }
    }
}