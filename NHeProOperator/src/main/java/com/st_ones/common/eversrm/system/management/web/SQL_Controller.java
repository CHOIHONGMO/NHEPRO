package com.st_ones.common.eversrm.system.management.web;

import com.st_ones.common.eversrm.system.management.EXECSQL_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.Reader;
import java.util.*;

@Controller
@RequestMapping("/eversrm/system/management")
public class SQL_Controller extends BaseController {

	@Autowired private SqlSessionFactory sqlSessionFactory;
	@Autowired private EXECSQL_Mapper execsql_mapper;
	@Autowired private MessageService msg;


    @RequestMapping("/EXECSQL/view")
    public String EXECSQL() {
        return "/eversrm/system/management/EXECSQL";
    }


    @RequestMapping("/EXECSQLRESULT/view")
    public String EXECSQLRESULT(EverHttpRequest req) throws Exception {

    	String sql = req.getParameter("SQL");
    	String pwd = req.getParameter("PWD");
    	String type = req.getParameter("TYPE");
    	System.err.println("=========================pwd="+pwd);
    	//if (!"stones0700333".equals(pwd)) {
    	//	throw new EverException("꺼져");
    	//}
    	
    	if (!"nhepro1qaz!@".equals(pwd)) {
    		throw new EverException("꺼져");
    	}

    	if ("S".equals(type)) {
	    	Map<String,String> param = new HashMap<String,String>();
	    	param.put("exclusion", "true"); //exclusion 을 사용하게 되면 싱글코테이션이 2 Bytes 문자로 치환되지 않음.
	    	//sql = sql.replaceAll("&#39;", "'");
	    	param.put("SQL", sql);

	    	List<Map<String,Object>> result = null;
    		ArrayList<HashMap> colunm = new ArrayList<HashMap>();
	    	try {
		    	result = execsql_mapper.search(param);
		    	if (result.size() > 0) {
		    		int tempKeySize = 0;
		    		Map<String,Object> mmm = result.get(0);

		    		Set set = mmm.keySet();
		    		Iterator iter = set.iterator();
		    		while(iter.hasNext()) {
		    			String col = String.valueOf(iter.next());
		    			System.err.println("=====col="+col);
		    			if (!colunm.contains(col)) {
		    				HashMap kkk = new HashMap();
		    				kkk.put("colm", col);
		    				colunm.add( kkk );
		    			}
		    		}
		    	} else {
					HashMap kkk = new HashMap();
					kkk.put("colm", "no data");
					colunm.add( kkk );
		    	}
	    	} catch (Exception e) {
				HashMap kkk = new HashMap();
				kkk.put("colm", "no data");
				colunm.add( kkk );
	    	} finally {
	    		req.setAttribute("COLUMN", colunm);

	    	}



    	} else if ("T".equals(type)) {
    		Map<String,String> param = new HashMap<String,String>();
    		String tempSql = sql.toLowerCase();
    		tempSql = tempSql.toUpperCase().replaceAll("DROP", "").replaceAll("--", "").replaceAll("TRUNCATE", "").replaceAll("CREATE", "");
    		System.err.println("======================xxxxxxxx=tempSql="+tempSql);
    		if (tempSql.indexOf("WHERE") < 0) {
    			throw new EverException("transaction sql must 'where'");
    		}


	    	param.put("SQL", tempSql);
    		execsql_mapper.transaction(param);
    		req.setAttribute("message", "success!");
    	}
    	return "/eversrm/system/management/EXECSQLRESULT";
    }

    @RequestMapping("/EXECSQL/doSearch")
    public void goexec(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> param = req.getFormData();
    	param.put("exclusion", "true"); //exclusion 을 사용하게 되면 싱글코테이션이 2 Bytes 문자로 치환되지 않음.
        param.put("SQL", param.get("SQL").replaceAll("&#39;", "'"));

        List<Map<String,Object>> result = execsql_mapper.search(param);
        resp.setGridObject("grid1", result);
    }

    private static SqlSessionFactory sqlMapper;
	private static Reader reader;
    public SqlSessionFactory getSession() throws Exception { // 직접 가져올때
    	reader    = Resources.getResourceAsReader("eversrm-oracle-datasource.xml");
    	sqlMapper = new SqlSessionFactoryBuilder().build(reader);
        return sqlMapper;
    }

    @RequestMapping("/EXECFILE/view")
    public String EXECFILE() {
        return "/eversrm/system/management/EXECFILE";
    }

}
