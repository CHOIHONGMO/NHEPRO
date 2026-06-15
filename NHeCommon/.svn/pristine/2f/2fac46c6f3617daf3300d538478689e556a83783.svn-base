package com.st_ones.common.page;

import java.io.Serializable;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : PageNaviBean.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class PageNaviBean implements Serializable {

	private static final long serialVersionUID = 1L;

	private int startNo = 0;

	private int endNo = 0;

	//	private String sortStr = "RegDate DESC";
	private String sortStr = "1";

	/** 한페이지당 표시되는 아이템의 수 */
	private int listScale = 10;

	/** 현재페이지 */
	private Integer pageNo = 1;

	/** 총아이템수 */
	private int totalCount = 0;
	/** 리턴 URL*/
	private String pageUrl;

	private String langCd;
	private String basicFl;
	private String isPaging = "N";

	public void setPagingValue(int pageNo, int listScale) {
		if(pageNo == 0) {
			pageNo = 1;
		}

		startNo = (pageNo * listScale) - (listScale - 1);
		endNo = startNo + (listScale - 1);
	}

	public int getStartNo() {
		return startNo;
	}

	public void setStartNo(int startNo) {
		this.startNo = startNo;
	}

	public int getEndNo() {
		return endNo;
	}

	public void setEndNo(int endNo) {
		this.endNo = endNo;
	}

	public String getSortStr() {
		return sortStr;
	}

	public void setSortStr(String sortStr) {
		this.sortStr = sortStr;
	}

	/**
	 * @return pageNo
	 */
	public Integer getPageNo() {
		return pageNo;
	}

	/**
	 * @param pageNo 설정하려는 pageNo
	 */
	public void setPageNo(Integer pageNo) {
		if(pageNo == null) pageNo = 1;
		this.pageNo = pageNo;
	}

	/**
	 * @return listScale
	 */
	public int getListScale() {
		return listScale;
	}

	/**
	 * @param listScale 설정하려는 listScale
	 */
	public void setListScale(int listScale) {
		this.listScale = listScale;
	}

	/**
	 * @return totalCount
	 */
	public int getTotalCount() {
		return totalCount;
	}

	/**
	 * @param totalCount 설정하려는 totalCount
	 */
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getPageUrl() {
		return pageUrl;
	}

	public void setPageUrl(String pageUrl) {
		this.pageUrl = pageUrl;
	}

	public String getLangCd() {
		return langCd;
	}

	public void setLangCd(String langCd) {
		this.langCd = langCd;
	}

	public String getBasicFl() {
		return basicFl;
	}

	public void setBasicFl(String basicFl) {
		this.basicFl = basicFl;
	}

	public int getTotalPage(int totCnt, int listScale) {
		int totPageNavi = 0 ;
		if( totCnt % listScale == 0 ) {
			totPageNavi = totCnt / listScale ;
		} else {
			totPageNavi = (totCnt / listScale) + 1 ;
		}
		if(totPageNavi == 0 ){
			totPageNavi = 1 ;
		}
		return totPageNavi ;
	}

	public String getIsPaging() {
		return isPaging;
	}

	public void setIsPaging(String isPaging) {
		this.isPaging = isPaging;
	}
}
