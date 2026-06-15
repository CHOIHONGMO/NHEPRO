package com.st_ones.nosession;

/**
 * Copyright (c) 2013 ST-Ones (http://www.st-ones.com/) All rights reserved.
 * @LastModified 17. 11. 20 오후 3:28
 */

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface VendorMapper {
    public Map<String, String> getVendorInfo(Map<String, String> map);
}
