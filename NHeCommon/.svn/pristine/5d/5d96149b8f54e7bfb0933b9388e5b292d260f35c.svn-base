package com.st_ones.common.util.clazz;

import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.apache.fop.apps.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.xml.stream.XMLStreamWriter;
import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : PdfPrintUtil.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value = "pdfPrintUtil")
public class PdfPrintUtil {

	private static final char ZERO_WIDTH_SPACE = '\u200B';
	private static Logger logger = LoggerFactory.getLogger(PdfPrintUtil.class);

	public void writeSingleXMLElement(XMLStreamWriter xtw, String tag, String content) throws Exception {
		xtw.writeStartElement(tag);
		xtw.writeCharacters(appendZeroSpace(content.toString()));
		xtw.writeEndElement();
	}

	public void writeMultiXMLElement(XMLStreamWriter xtw, String boundToTag, String itemTag, List<Map<String, Object>> list, int maxRows) throws Exception {
		xtw.writeStartElement(boundToTag);
		for (Map<String, Object> item : list) {
			xtw.writeStartElement(itemTag);
			writeMapByIterator(xtw, item);
			xtw.writeEndElement();
		}

		if (maxRows != 0 && maxRows > list.size()) {
			Map<String, Object> item = list.get(0);
			item.clear();
			for (int i = 0; i < maxRows - list.size(); i++) {
				xtw.writeStartElement(itemTag);
				writeMapByIterator(xtw, item);
				xtw.writeEndElement();
			}
		}
		xtw.writeEndElement();
	}

	public void writeMultiXMLElement(XMLStreamWriter xtw, String boundToTag, String itemTag, String[] list, int maxRows) throws Exception {
		xtw.writeStartElement(boundToTag);
		for (String item : list) {
			writeSingleXMLElement(xtw, itemTag, item);
		}

		if (maxRows != 0 && maxRows > list.length) {
			for (int i = 0; i < maxRows - list.length; i++) {
				writeSingleXMLElement(xtw, itemTag, "");
			}
		}
		xtw.writeEndElement();
	}

	public void writeMapByIterator(XMLStreamWriter xtw, Map<String, Object> param) throws Exception {
		for (Map.Entry<String, Object> obj : param.entrySet()) {
			writeSingleXMLElement(xtw, obj.getKey(), obj.getValue().toString());
		}
	}

	private String appendZeroSpace(String input) {
		String result = "";
		char[] temp = input.toCharArray();
		for (int i = 0; i < temp.length; i++) {
			result += String.valueOf(temp[i]) + (i < temp.length - 1 ? String.valueOf(ZERO_WIDTH_SPACE) : "");
		}
		return result;
	}

	//@SuppressWarnings("static-access")
	public void returnPdf(ByteArrayOutputStream xmlStream, String transformFileName, String configFileName, EverHttpRequest req, EverHttpResponse resp) throws Exception {
		StreamSource source = new StreamSource(new ByteArrayInputStream(xmlStream.toByteArray()));

		String basePath = req.getSession().getServletContext().getRealPath("/");

		FopFactory fopFactory = FopFactory.newInstance();
		FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		Transformer xslfoTransformer;

		try {
			StreamSource transformSource = new StreamSource(new java.io.File(basePath + transformFileName));
			xslfoTransformer = getTransformer(transformSource);

			Fop fop;
			try {
				
				/*	체크 
				fopFactory.setUserConfig(new java.io.File(basePath + configFileName));
				*/
				fopFactory.setBaseURL(basePath);

				// By project - set PDT document information - sample
				foUserAgent.setBaseURL(fopFactory.getBaseURL());
				foUserAgent.setAuthor("ST-ONES");
				foUserAgent.setKeywords("#po");
				foUserAgent.setCreationDate(new Date());
				foUserAgent.setProducer("ST-ONES");
				foUserAgent.setTitle("PO");
				foUserAgent.setSubject("Purchase Order");

				fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, outStream);
				Result res = new SAXResult(fop.getDefaultHandler());

				try {
					xslfoTransformer.transform(source, res);

					byte[] pdfBytes = outStream.toByteArray();
					resp.setContentLength(pdfBytes.length);
					resp.setContentType("application/pdf");
					resp.getOutputStream().write(pdfBytes);
					resp.getOutputStream().flush();
					resp.getOutputStream().close();
				} catch (TransformerException te) {
					throw te;
				}
			} catch (FOPException fope) {
				throw fope;
			}
		} catch (TransformerConfigurationException e) {
			throw e;
		} catch (TransformerFactoryConfigurationError e) {
			throw e;
		}
	}

	private Transformer getTransformer(StreamSource streamSource) {
		TransformerFactory impl = TransformerFactory.newInstance();
		try {
			return impl.newTransformer(streamSource);

		} catch (TransformerConfigurationException e) {
			logger.error(e.getMessage(), e);
		}
		return null;
	}
}
