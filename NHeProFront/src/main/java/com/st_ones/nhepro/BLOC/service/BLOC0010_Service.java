package com.st_ones.nhepro.BLOC.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.nhepro.BLOC.BLOC0010_Mapper;

@Service(value = "BLOC0010_Service")
public class BLOC0010_Service {
Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
    @Autowired BLOC0010_Mapper bloc0010_Mapper;
    @Autowired MessageService msg;
    
	public List<Map<String, Object>> bloc0030_doSearch(Map<String, String> param) {
		// TODO Auto-generated method stub
		return bloc0010_Mapper.bloc0030_doSearch(param);
	}

	public List<Map<String, Object>> bloc0020_doSearch(Map<String, String> param) {
		// TODO Auto-generated method stub
		return bloc0010_Mapper.bloc0020_doSearch(param);
	}

}
