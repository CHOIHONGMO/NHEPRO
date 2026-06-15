package com.st_ones.nhpkicmpnp.dto;

public class CertUserDTO {

	private int cert_seq;
	private String user_id;
	private String is_corporation;
	private String cert_cn;
	private String cert_dn;
	private String cert_ou;
	private String before_date;
	private String after_date;
	private String bcid;
	private String cert_status;

	public int getCert_seq() {
		System.out.println(">>GET Cert Seq : " + cert_seq);
		return cert_seq;
	}

	public void setCert_seq(int cert_seq) {
		System.out.println(">>SET Cert Seq : " + cert_seq);
		this.cert_seq = cert_seq;
	}

	public String getUser_id() {
		System.out.println(">>GET UserId : " + user_id);
		return user_id;
	}

	public void setUser_id(String user_id) {
		System.out.println(">>SET UserId : " + user_id);
		this.user_id = user_id;
	}

	public String getIs_corporation() {
		System.out.println(">>GET IS_Corporation : " + is_corporation);
		return is_corporation;
	}

	public void setIs_corporation(String is_corporation) {
		System.out.println(">>SET IS_Corporation : " + is_corporation);
		this.is_corporation = is_corporation;
	}

	public String getCert_cn() {
		System.out.println(">>GET cert_cn : " + cert_cn);
		return cert_cn;
	}

	public void setCert_cn(String cert_cn) {
		System.out.println(">>SET cert_cn : " + cert_cn);
		this.cert_cn = cert_cn;
	}

	public String getCert_dn() {
		System.out.println(">>GET cert_dn : " + cert_dn);
		return cert_dn;
	}

	public void setCert_dn(String cert_dn) {
		System.out.println(">>SET cert_dn : " + cert_dn);
		this.cert_dn = cert_dn;
	}

	public String getCert_ou() {
		System.out.println(">>GET cert_ou : " + cert_ou);
		return cert_ou;
	}

	public void setCert_ou(String cert_ou) {
		System.out.println(">>SET cert_ou : " + cert_ou);
		this.cert_ou = cert_ou;
	}

	public String getBefore_date() {
		System.out.println(">>GET before_date : " + before_date);
		return before_date;
	}

	public void setBefore_date(String before_date) {
		System.out.println(">>SET before_date : " + before_date);
		this.before_date = before_date;
	}

	public String getAfter_date() {
		System.out.println(">>GET after_date : " + after_date);
		return after_date;
	}

	public void setAfter_date(String after_date) {
		System.out.println(">>SET after_date : " + after_date);
		this.after_date = after_date;
	}

	public String getBcid() {
		System.out.println(">>GET bcid : " + bcid);
		return bcid;
	}

	public void setBcid(String bcid) {
		System.out.println(">>SET bcid : " + bcid);
		this.bcid = bcid;
	}

	public String getCert_status() {
		System.out.println(">>GET cert_status : " + cert_status);
		return cert_status;
	}

	public void setCert_status(String cert_status) {
		System.out.println(">>SET cert_status : " + cert_status);
		this.cert_status = cert_status;
	}

	@Override
	public String toString() {
		System.out.println(">>> CertUserDTO String TEST : " + cert_cn + ", "+ cert_dn +", "+cert_ou );
		return "CertUserDTO [cert_seq=" + cert_seq + ", user_id=" + user_id + ", is_corporation=" + is_corporation
				+ ", cert_cn=" + cert_cn + ", cert_dn=" + cert_dn + ", cert_ou=" + cert_ou + ", before_date="
				+ before_date + ", after_date=" + after_date + ", bcid=" + bcid + ", cert_status=" + cert_status + "]";
	}

}
