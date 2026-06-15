//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.st_ones.nhepro.SCTR.service;

import java.io.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class TabbedXmlFromRoot {

    private static Logger logger = LoggerFactory.getLogger(TabbedXmlFromRoot.class);

    private String scode = "";
    private String newXML = "";
    private String tabStr = " ";
    private int startCount = 0;
    private int endCount = 0;
    private StringBuffer newXMLBuffer = new StringBuffer();
    private String xml_encode = "";

    public TabbedXmlFromRoot() {
    }

    public void setXmlEncoding(String encode) {
        this.xml_encode = encode;
    }

    public void MakeXmlFiles(String xmlStr, String outfilename) throws Exception {

        this.startCount = 0;
        this.endCount = 0;
        InputStream InputDataString = null;

        try {
            XMLReader parser = null;
            TabbedXmlFromRoot.SAXHandler createhandler = new TabbedXmlFromRoot.SAXHandler();
            parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
            parser.setFeature("http://xml.org/sax/features/namespaces", false);
            parser.setContentHandler(createhandler);
            parser.setErrorHandler(createhandler);
            parser.setProperty("http://xml.org/sax/properties/lexical-handler", createhandler);
            InputDataString = new FileInputStream(new File(xmlStr));
            InputSource IpuntDataSource = new InputSource(InputDataString);
            parser.parse(IpuntDataSource);
        } catch (Exception e) {
            logger.error(e.getMessage());
        } finally {
            InputDataString.close();
        }

        String resultxml = "";
        if (this.xml_encode.equals("")) {
            resultxml = "<?xml version=\"1.0\" encoding=\"EUC-KR\"?>\n" + this.newXMLBuffer.toString();

            try {
                this.MakeFiles(resultxml, outfilename);
            } catch (Exception var8) {
                logger.error(var8.getMessage());
            }
        } else {
            resultxml = "<?xml version=\"1.0\" encoding=\"" + this.xml_encode + "\"?>\n" + this.newXMLBuffer.toString();

            try {
                this.MakeFiles(resultxml, outfilename, this.xml_encode);
            } catch (Exception var7) {
                logger.error(var7.getMessage());
            }
        }

    }

    public String MakeXmlData(String xmlStr) {
        this.startCount = 0;
        this.endCount = 0;

        try {
            XMLReader parser = null;
            TabbedXmlFromRoot.SAXHandler createhandler = new TabbedXmlFromRoot.SAXHandler();
            parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
            parser.setFeature("http://xml.org/sax/features/namespaces", false);
            parser.setContentHandler(createhandler);
            parser.setProperty("http://xml.org/sax/properties/lexical-handler", createhandler);
            ByteArrayInputStream DataString = new ByteArrayInputStream(xmlStr.getBytes());
            InputSource IpuntDataSource = new InputSource(DataString);
            parser.parse(IpuntDataSource);
            return "<?xml version=\"1.0\" encoding=\"EUC-KR\"?>\n" + this.newXMLBuffer.toString();
        } catch (Exception var7) {
            logger.error(var7.getMessage());
            return "";
        }
    }

    public String MakeXmlData(String xmlStr, String encode) {
    	//System.err.println("=========================================1=TabbedXmlFromRoot==MakeXmlData="+newXMLBuffer);
        this.startCount = 0;
        this.endCount = 0;

        try {
            XMLReader parser = null;
            TabbedXmlFromRoot.SAXHandler createhandler = new TabbedXmlFromRoot.SAXHandler();
            parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
            parser.setFeature("http://xml.org/sax/features/namespaces", false);
            parser.setContentHandler(createhandler);
            parser.setProperty("http://xml.org/sax/properties/lexical-handler", createhandler);
            ByteArrayInputStream DataString = new ByteArrayInputStream(xmlStr.getBytes(encode));
            InputSource IpuntDataSource = new InputSource(DataString);
            parser.parse(IpuntDataSource);
        	//System.err.println("=========================================2=TabbedXmlFromRoot==MakeXmlData="+newXMLBuffer);
            return "<?xml version=\"1.0\" encoding=\"" + encode + "\"?>\n" + this.newXMLBuffer.toString();
        } catch (Exception var8) {
            logger.error(var8.getMessage());
            return "";
        }
    }

    public void MakeXmlFiles(String xmlStr, String outfilename, String docCode) throws Exception {

        this.startCount = 0;
        this.endCount = 0;
        InputStream InputDataString = null;

        try {
            TabbedXmlFromRoot.SAXHandler createhandler = new TabbedXmlFromRoot.SAXHandler();
            XMLReader parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
            parser.setFeature("http://xml.org/sax/features/namespaces", false);
            parser.setContentHandler(createhandler);
            parser.setProperty("http://xml.org/sax/properties/lexical-handler", createhandler);
            InputDataString = new FileInputStream(new File(xmlStr));
            InputSource IpuntDataSource = new InputSource(InputDataString);
            parser.parse(IpuntDataSource);
        } catch (Exception e) {
            logger.error(e.getMessage());
        } finally {
            InputDataString.close();
        }

        String resultxml = "";
        if (this.xml_encode.equals("")) {
            resultxml = "<?xml version=\"1.0\" encoding=\"EUC-KR\"?>\n" + this.newXMLBuffer.toString();

            try {
                this.MakeFiles(resultxml, outfilename);
            } catch (Exception var9) {
                logger.error(var9.getMessage());
            }
        } else {
            resultxml = "<?xml version=\"1.0\" encoding=\"" + this.xml_encode + "\"?>\n" + this.newXMLBuffer.toString();

            try {
                this.MakeFiles(resultxml, outfilename, this.xml_encode);
            } catch (Exception var8) {
                logger.error(var8.getMessage());
            }
        }

    }

    public static boolean genFileCreate(String fileName, String fileData, String encode) {
        FileOutputStream ResultFile = null;

        try {
            ResultFile = new FileOutputStream(fileName, false);
            ResultFile.write(fileData.getBytes(encode));
            ResultFile.flush();
            ResultFile.close();
            return true;
        } catch (Exception var13) {
            logger.error(var13.getMessage());
        } finally {
            try {
                ResultFile.close();
            } catch (Exception var12) {
                logger.error(var12.getMessage());
                ResultFile = null;
            }
        }
        return false;
    }

    public void MakeFiles(String resultxml, String outfilename) throws Exception {
        String outString = "";
        OutputStreamWriter osw = null;
        FileOutputStream myOutputStream = null;

        try {
            outString = new String(resultxml.getBytes("KSC5601"), "8859_1");
            myOutputStream = new FileOutputStream(outfilename);
            osw = new OutputStreamWriter(myOutputStream, "8859_1");
            osw.write(outString);
            this.newXMLBuffer = new StringBuffer();
        } catch (UnsupportedEncodingException var10) {
            logger.error(var10.getMessage());
        } finally {
            if(osw != null) { osw.close(); }
            if(myOutputStream != null) { myOutputStream.close(); }
        }

    }

    public void MakeFiles(String resultxml, String outfilename, String encode) throws Exception {
        String outString = "";
        OutputStreamWriter osw = null;
        FileOutputStream myOutputStream = null;

        try {
            myOutputStream = new FileOutputStream(outfilename);
            osw = new OutputStreamWriter(myOutputStream, encode);
            osw.write(resultxml);
            this.newXMLBuffer = new StringBuffer();
        } catch (UnsupportedEncodingException var11) {
            logger.error(var11.getMessage());
        } finally {
            osw.close();
            myOutputStream.close();
        }

    }

    protected class SAXHandler extends DefaultHandler implements LexicalHandler {
        private Locator locator;
        protected static final String DEFAULT_PARSER_NAME = "org.apache.xerces.parsers.SAXParser";
        protected static final String NAMESPACES_FEATURE_ID = "http://xml.org/sax/features/namespaces";
        protected static final boolean DEFAULT_NAMESPACES = false;
        protected static final String LEXICAL_HANDLER_PROPERTY_ID = "http://xml.org/sax/properties/lexical-handler";
        protected boolean fXML11;
        protected boolean fInCDATA;

        protected SAXHandler() {
        }

        public void processingInstruction(String target, String data) throws SAXException {
            TabbedXmlFromRoot.this.newXMLBuffer.append("<?");
            TabbedXmlFromRoot.this.newXMLBuffer.append(target);
            TabbedXmlFromRoot.this.newXMLBuffer.append(' ');
            TabbedXmlFromRoot.this.newXMLBuffer.append(data);
            TabbedXmlFromRoot.this.newXMLBuffer.append("?>\n");
        }

        public void startDTD(String name, String publicId, String systemId) throws SAXException {
        }

        public void endDTD() throws SAXException {
        }

        public void startEntity(String name) throws SAXException {
        }

        public void endEntity(String name) throws SAXException {
        }

        public void startCDATA() throws SAXException {
            TabbedXmlFromRoot.this.newXMLBuffer.append("<![CDATA[");
        }

        public void endCDATA() throws SAXException {
            TabbedXmlFromRoot.this.newXMLBuffer.append("]]>");
        }

        public void comment(char[] ch, int start, int length) throws SAXException {
            TabbedXmlFromRoot.this.newXMLBuffer.append("<!--");

            for(int i = 0; i < length; ++i) {
                TabbedXmlFromRoot.this.newXMLBuffer.append(ch[start + i]);
            }

            TabbedXmlFromRoot.this.newXMLBuffer.append("-->\n");
        }

        public void startElement(String namespaceURI, String localName, String name, Attributes attrs) throws SAXException {
            TabbedXmlFromRoot var10000 = TabbedXmlFromRoot.this;
            var10000.startCount = var10000.startCount + 1;
            TabbedXmlFromRoot.this.endCount = 0;
            TabbedXmlFromRoot.this.scode = name;
            TabbedXmlFromRoot.this.tabStr = this.getTabStr(TabbedXmlFromRoot.this.startCount);
            TabbedXmlFromRoot.this.newXML = TabbedXmlFromRoot.this.tabStr + "<" + TabbedXmlFromRoot.this.scode;
            TabbedXmlFromRoot.this.newXMLBuffer.append(TabbedXmlFromRoot.this.newXML);
            String strAttr_ = "";
            int p = attrs.getLength();
            if (p > 0) {
                for(int i = 0; i < p; ++i) {
                    strAttr_ = strAttr_ + " " + attrs.getQName(i);
                    strAttr_ = strAttr_ + "=\"" + attrs.getValue(i) + "\"";
                }
            }

            TabbedXmlFromRoot.this.newXML = strAttr_ + ">" + "\n";
            TabbedXmlFromRoot.this.newXMLBuffer.append(TabbedXmlFromRoot.this.newXML);
        }

        public void characters(char[] ch, int start, int length) throws SAXException {
            String s = new String(ch, start, length);
            if (!TabbedXmlFromRoot.this.scode.equals("-1") && s.trim().length() != 0) {
                TabbedXmlFromRoot.this.newXMLBuffer.append(s);
            }

        }

        public void endElement(String namespaceURI, String localName, String name) throws SAXException {
            String tempVal = "";
            if (TabbedXmlFromRoot.this.endCount == 0) {
                tempVal = this.getTrimedStr(TabbedXmlFromRoot.this.newXMLBuffer.toString());
            }

            TabbedXmlFromRoot.this.tabStr = this.getTabStr(TabbedXmlFromRoot.this.startCount);
            if (TabbedXmlFromRoot.this.endCount == 0) {
                TabbedXmlFromRoot.this.newXML = tempVal + "</" + name + ">" + "\n";
            } else {
                TabbedXmlFromRoot.this.newXML = TabbedXmlFromRoot.this.tabStr + "</" + name + ">" + "\n";
            }

            TabbedXmlFromRoot.this.newXMLBuffer.append(TabbedXmlFromRoot.this.newXML);
            TabbedXmlFromRoot.this.scode = "-1";
            TabbedXmlFromRoot var10000 = TabbedXmlFromRoot.this;
            var10000.endCount = var10000.endCount + 1;
            var10000 = TabbedXmlFromRoot.this;
            var10000.startCount = var10000.startCount - 1;
        }

        public String getTrimedStr(String xmlStr) {
            int index = xmlStr.lastIndexOf(">");
            TabbedXmlFromRoot.this.newXMLBuffer.delete(index + 1, xmlStr.length());
            xmlStr.substring(0, index);
            String tempVal = xmlStr.substring(index + 1, xmlStr.length()).trim();
            return tempVal;
        }

        public String getTabStr(int count) {
            TabbedXmlFromRoot.this.tabStr = "      ";
            String returnTab = "";

            for(int i = 0; i < count - 1; ++i) {
                returnTab = returnTab + TabbedXmlFromRoot.this.tabStr;
            }

            return returnTab;
        }
    }
}
