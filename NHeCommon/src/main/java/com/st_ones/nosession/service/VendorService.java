package com.st_ones.nosession.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nosession.VendorMapper;

@Service
public class VendorService extends BaseService {

    @Autowired
    VendorMapper vendormapper;

    public Map<String, String> getVendorInfo(Map<String, String> param) {
        return vendormapper.getVendorInfo(param);
    }


}
