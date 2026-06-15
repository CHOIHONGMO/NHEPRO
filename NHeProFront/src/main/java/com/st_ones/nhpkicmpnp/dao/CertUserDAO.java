package com.st_ones.nhpkicmpnp.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import com.st_ones.nhpkicmpnp.dto.CertUserDTO;

@Repository
public interface CertUserDAO {
//	// DB에 유효한 인증서가 있는지 없는지 확인
//	@Select("select count(*) from CERT_USER_TABLE where \"cert_status\"='validity' and \"is_corporation\"=#{isCorporation} and \"user_id\"=#{user_id} order by \"cert_seq\" desc")
//	public int queryCertIssue(@Param("isCorporation") String isCorporation, @Param("user_id") String user_id) ;
//
//	// DB에 인증서 데이터 삽입
//	@Insert("insert into CERT_USER_TABLE (\"cert_seq\", \"user_id\", \"is_corporation\", \"cert_cn\", \"cert_dn\", \"cert_ou\", \"before_date\", \"after_date\", \"bcid\", \"cert_status\") values (CERT_AUTO_SEQ.nextval, #{user_id}, #{is_corporation}, #{cert_cn}, #{cert_dn}, #{cert_ou}, #{before_date}, #{after_date}, #{bcid}, #{cert_status})")
//	public void insertCertIssue(CertUserDTO dto);
//
//	// DB에 유효한 인증서 조회
//	@Select("select * from CERT_USER_TABLE where \"cert_status\"='validity' and \"user_id\"=#{user_id} order by \"cert_seq\" desc")
//	public List<CertUserDTO> queryCertInvoke(@Param("user_id") String user_id) ;
//
//	// DB에 유효한 인증서 폐기
//	@Update("UPDATE CERT_USER_TABLE SET \"cert_status\"='Revocation' WHERE \"cert_status\"='validity' and \"is_corporation\"=#{isCorporation} and \"user_id\"=#{user_id}")
//	public int updateCertInvoke(@Param("isCorporation") String isCorporation, @Param("user_id") String user_id);
	// DB에 유효한 인증서가 있는지 없는지 확인
	@Select("select count(*) from CERT_USER_TABLE where cert_status='validity' and is_corporation=#{isCorporation} and user_id=#{user_id} order by cert_seq desc")
	int queryCertIssue(@Param("isCorporation") String isCorporation, @Param("user_id") String user_id) ;
	// DB에 인증서 데이터 삽입
	@Insert("insert into CERT_USER_TABLE (cert_seq, user_id, is_corporation, cert_cn, cert_dn, cert_ou, before_date, after_date, bcid, cert_status) values (CERT_AUTO_SEQ.nextval, #{user_id}, #{is_corporation}, #{cert_cn}, #{cert_dn}, #{cert_ou}, #{before_date}, #{after_date}, #{bcid}, #{cert_status})")
	void insertCertIssue(CertUserDTO dto);
	// DB에 유효한 인증서 조회
	@Select("select * from CERT_USER_TABLE where cert_status='validity' and user_id=#{user_id} order by cert_seq desc")
	List<CertUserDTO> queryCertInvoke(@Param("user_id") String user_id) ;
	// DB에 유효한 인증서 폐기
	@Update("UPDATE CERT_USER_TABLE SET cert_status='Revocation' WHERE cert_status='validity' and is_corporation=#{isCorporation} and user_id=#{user_id}")
	int updateCertInvoke(@Param("isCorporation") String isCorporation, @Param("user_id") String user_id);

}
