package com.st_ones.nosession.interfacez;

/**
 * Copyright (c) 2013 ST-Ones (http://www.st-ones.com/) All rights reserved.
 * @LastModified 17. 11. 20 오후 3:28
 */

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface PmsMapper {

    public Map<String, String> prCheck(Map<String, Object> map);


    public int insPrhd(Map<String, Object> formData);
    public int upsPrhd(Map<String, Object> formData);


    public int delPrdt(Map<String, String> formData);
    public int insPrdt(Map<String, Object> formData);

    public int insPmsPrhd(Map<String, Object> formData);
    public int insPmsPrdt(Map<String, Object> formData);


}
