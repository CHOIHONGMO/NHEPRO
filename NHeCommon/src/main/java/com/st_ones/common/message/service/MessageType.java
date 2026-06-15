package com.st_ones.common.message.service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MessageType.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public enum MessageType {

    /**
     * 성공적으로 처리되었습니다.
     */
    PROCESSED_SUCCESSFULLY("0001"),
    /**
     * 저장하시겠습니까?
     */
    WILL_YOU_SAVE("0031"),
    /**
     * 성공적으로 저장되었습니다.
     */
    SAVE_SUCCEED("0031"),
    /**
     * 삭제하시겠습니까?
     */
    WILL_YOU_DELETE("0013"),
    /**
     * 성공적으로 삭제되었습니다.
     */
    DELETE_SUCCEED("0017"),
    /**
     * 결재가 상신되었습니다.
     */
    APPROVAL_COMPLETED("0023"),
    /**
     * 권한이 없습니다.
     */
    AUTH_REQUIRED("0037"),
    /*
     * 선택한 데이터가 이미 처리되었습니다.
     */
    PROCESSED_ALREADY("0045");

    private final String code;
    MessageType(String _code) {
        this.code = _code;
    }

    public String getCode() {
        return this.code;
    }
}
