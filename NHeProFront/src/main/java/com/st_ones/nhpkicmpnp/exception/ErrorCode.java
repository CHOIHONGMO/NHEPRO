package com.st_ones.nhpkicmpnp.exception;

public class ErrorCode {

//Dapp
public static final int ERR_FAIL_GET_DATA 		= 1200;						// 데이터 없음(입력값 없음)
public static final int ERR_BLOCKCHAIN_CERT_VERIFY_FAIL = 1300;				// 인증서 검증 실패
public static final int ERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_FAIL = 1400;	// 사용자 인증서 상태 검증 실패
public static final int ERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_ERROR = 1500;	// 사용자 인증서 상태 검증 에러



public static final String msgERR_FAIL_GET_DATA = "Empty_Data";
public static final String msgERR_BLOCKCHAIN_CERT_VERIFY_FAIL = "ERR_BLOCKCHAIN_CERT_VERIFY_FAIL";
public static final String msgERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_FAIL = "ERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_FAIL";
public static final String msgERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_ERROR = "ERR_BLOCKCHAIN_USERCERT_STATUS_VERIFY_ERROR";


//was
public static final int ERR_WAS_IOEXCEPTION		= 9200;
public static final int ERR_WAS_MalformedURLException = 9400;
public static final int ERR_WAS_ProtocolException = 9500;
public static final int ERR_WAS_JsonException = 9600;
public static final int ERR_WAS_DBException = 9700;

public static final int ERR_WAS_DBSelectException = 6001;

public static final String msgERR_WAS_IOEXCEPTION = "ERR_WAS_IOEXCEPTION";
public static final String msgERR_WAS_MalformedURLException = "ERR_WAS_MalformedURLException";
public static final String msgERR_WAS_ProtocolException = "ERR_WAS_ProtocolException";
public static final String msgERR_WAS_JsonException = "ERR_WAS_JsonException";
public static final String msgERR_WAS_DBException = "ERR_WAS_DBException";

public static final String msgERR_WAS_DBSelectException = "만료/폐기 되지 않은 인증서가 존재합니다."; //   만료/폐기 되지 않은 인증서가 존재합니다. '인증서폐기' 후 인증서를 재발급 받을 수 있습니다.
}