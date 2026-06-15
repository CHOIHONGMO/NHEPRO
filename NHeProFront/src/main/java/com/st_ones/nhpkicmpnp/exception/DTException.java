/*========================================================
*Copyright(c) 2008 DreamSecurity
*@FileName     : ARCException.java
*@FileTitle    : 예외처리
*
*Change history
*@LastModifyDate    : 20080407
*@LastVersion       : 0.1
*---------------------------------------------
*    2008-04-07       0.1      최초 생성
=========================================================*/
package com.st_ones.nhpkicmpnp.exception;

public class DTException extends Exception {

    /**
     * Error code
     */
    protected int nErrorCode = 0;

    /**
     * Error Message
     */
    protected String strErrorMessage = "";

    /**
     * 에러메세지를 입력받는다.
     *
     * @param strErrorMessage 에러메세지
     */
    public DTException(String strErrorMessage) {
        this.nErrorCode = -1;
        this.strErrorMessage = strErrorMessage;
    }

    /**
     * 에러코드, 에러메세지를 입력받는다.
     *
     * @param nErrorCode      에러코드
     * @param strErrorMessage 에러메세지
     */
    public DTException(int nErrorCode, String strErrorMessage) {
        this.nErrorCode = nErrorCode;
        this.strErrorMessage = strErrorMessage;
    }

    /**
     * 에러코드, 에러메세지, 스택 트레이스를 입력받는다.
     *
     * @param nErrorCode      에러코드
     * @param strErrorMessage 에러메시지
     * @param stackTrace      스택 트레이스
     */
    public DTException(int nErrorCode, String strErrorMessage, StackTraceElement[] stackTrace) {
        this.nErrorCode = nErrorCode;
        this.strErrorMessage = strErrorMessage;
        this.setStackTrace(stackTrace);
    }

    /**
     * 에러코드를 리턴한다.
     *
     * @return 에러코드
     */
    public int getLastError() {
        return this.nErrorCode;
    }

    public int getCode() {
        return this.nErrorCode;
    }

    /**
     * 에러메세지를 리턴한다.
     *
     * @return 에러메세지
     */
    public String getMessage() {
        return this.strErrorMessage;
    }


    /**
     * 에러메세지를 리턴한다.
     *
     * @return 에러메세지
     */
    public String toString() {

      StringBuffer strbuf = new StringBuffer();
      strbuf.append(this.strErrorMessage);
      strbuf.append("[");
      strbuf.append(this.nErrorCode);
      strbuf.append("]");

      return strbuf.toString();
    }


}
