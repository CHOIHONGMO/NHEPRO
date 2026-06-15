package com.st_ones.common;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.CharacterEncodingFilter;

public class EverSrmFilter extends CharacterEncodingFilter{

	@Override
	protected void doFilterInternal(HttpServletRequest request,HttpServletResponse response, FilterChain filterChain) throws ServletException,IOException {
		if (	request.getRequestURI().startsWith("/nheproif/pms")
			||  request.getRequestURI().startsWith("/sgic/recv")
			||  request.getRequestURI().startsWith("/swic/recvSW")
			) {
//			System.err.println("=request.getRequestURI()====1111=="+request.getRequestURI());
			request.setCharacterEncoding("euc-kr");
			response.setCharacterEncoding("euc-kr");
			filterChain.doFilter(request, response);
		} else if (
				  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guar_approval")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guar_approval2")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guar_cancel")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guar_cancel2")
				){
//			System.err.println("=request.getRequestURI()====222=="+request.getRequestURI());
			request.setCharacterEncoding("euc-kr");
			response.setCharacterEncoding("utf-8");
			filterChain.doFilter(request, response);
		}else if (
				  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarSg_approval")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarSg_approval2")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarSg_cancel")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarSg_cancel2")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarNumSg_cancel")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarBdhd_approval")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarBdhd_cancel")
				||  request.getRequestURI().startsWith("/nhepro/SCTR/SCTR0011/sctr0011_guarNumBdhd_cancel")
				){
//			System.err.println("=request.getRequestURI()====222=="+request.getRequestURI());
			request.setCharacterEncoding("utf-8");
			response.setCharacterEncoding("utf-8");
			filterChain.doFilter(request, response);
		}else {
			super.doFilterInternal(request,response,filterChain);
		}
	}
}