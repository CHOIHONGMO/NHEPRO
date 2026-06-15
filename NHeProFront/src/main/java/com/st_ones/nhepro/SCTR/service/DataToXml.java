//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.st_ones.nhepro.SCTR.service;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.StringTokenizer;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import signgate.sgic.xmlmanager.sax.XMLcreateAdapter;
import signgate.sgic.xmlmanager.util.TokenUtil;
import signgate.sgic.xmlmanager.util.TypeCheckUtil;

public class DataToXml {
    TokenUtil tokutil;
    XMLcreateAdapter xmladapter;
    ArrayList datalist;
    String mappingfile;
    String tempxml;
    String errmessage;
    int errcode;
    String maxelementname;
    String maxelement;
    StringBuffer maxelementdata;
    String maxelementroot;
    String maxsubelementname;
    int subele_check;
    int loop_label;
    String first_name;
    Document doc;
    Element root;
    Element item;
    String docCode;
    private boolean isSecu;
    private String ack_type;
    private String xslURL;
    private String xml_encode;

    public boolean isSecu() {
        return this.isSecu;
    }

    public String getAckType() {
        return this.ack_type;
    }

    public DataToXml(String config, String docCode) {
        this(config, docCode, "");
    }

    public DataToXml(String config, String docCode, String encode) {
        this.tokutil = null;
        this.xmladapter = null;
        this.datalist = null;
        this.mappingfile = null;
        this.tempxml = null;
        this.errmessage = "";
        this.errcode = 0;
        this.maxelementname = null;
        this.maxelement = null;
        this.maxelementdata = null;
        this.maxelementroot = null;
        this.maxsubelementname = null;
        this.subele_check = 0;
        this.loop_label = 0;
        this.first_name = "";
        this.doc = null;
        this.root = null;
        this.item = null;
        this.docCode = "";
        this.isSecu = false;
        this.ack_type = "";
        this.xslURL = "";
        this.xml_encode = "";
        config = config.trim();
        docCode = docCode.trim();
        if (config.endsWith("/")) {
            this.docCode = docCode;
            this.mappingfile = config + docCode + ".map";
            if (this.xml_encode.equals("")) {
                this.tempxml = config + docCode + ".xml";
            } else {
                String tempencodename = "";
                if (encode.equalsIgnoreCase("UTF-8")) {
                    tempencodename = "UTF8";
                } else {
                    tempencodename = encode;
                }

                this.tempxml = config + docCode + tempencodename + ".xml";
            }

            this.tokutil = new TokenUtil(this.mappingfile, this.tempxml);
            this.xmladapter = new XMLcreateAdapter();
            this.isSecu = this.tokutil.isSecu();
            this.ack_type = this.tokutil.getAckType();
        } else {
            this.mappingfile = config;
            this.tokutil = new TokenUtil(config, docCode);
            this.xmladapter = new XMLcreateAdapter();
            this.tempxml = docCode;
            this.isSecu = this.tokutil.isSecu();
            this.ack_type = this.tokutil.getAckType();
        }

        this.xml_encode = encode;
    }

    public String getErrMessage() {
        return this.errmessage;
    }

    public String getErrorMsg() {
        return this.getErrMessage();
    }

    public int getErrorCode() {
        return this.errcode;
    }

    public void setXSL(String xslURL) {
        if (xslURL.indexOf("<?xml-stylesheet") < 0) {
            System.out.println("스타일 시트 표현이 아닙니다. 입력값을 확인하시기 바랍니다. " + xslURL);
        } else {
            this.xslURL = xslURL;
        }

    }

    private String specialCharChange(String data) {
        TypeCheckUtil hw = new TypeCheckUtil(data);
        data = hw.replace("&", "[amp;]");
        hw = new TypeCheckUtil(data);
        data = hw.replace("<", "[lt;]");
        hw = new TypeCheckUtil(data);
        data = hw.replace(">", "[gt;]");
        return data;
    }

    public boolean setData(String name, String value) throws Exception {
        if (value == null) {
            value = "";
        }
//        System.err.println(name+"==========================================================setData1===value="+value);
        boolean check = this.tokutil.isinputcheck(name, value);
        value = this.specialCharChange(value);
//        System.err.println(name+"==========================================================setData2===value="+value);
        if (this.tokutil.isrepeat()) {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 반복항목입니다. setMaxinit()-> setMaxUpdate() -> setMaxFinal() API를 이용해 주세요.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return false;
        } else if (this.xmladapter.list.containsKey(this.tokutil.getXpath())) {
            this.errmessage = name + " 단축 항목은 이미 세팅하시 항목입니다.\n 확인하시기 바랍니다.";
            this.errcode = 9000;
            return false;
        } else if (check) {
            this.xmladapter.list.put(this.tokutil.getXpath(), value);
            return check;
        } else {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return false;
        }
    }

    public boolean initLoopDataWithChild(String name, String node) throws Exception {
        if (this.loop_label == 0) {
            this.first_name = name;
            return this.setMaxelementinit(name, node);
        } else {
            return this.setMaxsubelementinit(name);
        }
    }


    public String closeLoopDataWithChild() throws Exception {
        if (this.loop_label == 2) {
            this.setMaxsubelementFinal();
            return "";
        } else {
            String data = this.setMaxelementFinal();
            boolean check = this.tokutil.istempxathcheck(this.first_name);
            if (check) {
                if (this.xmladapter.list.containsKey(this.tokutil.getXpath())) {
                    this.xmladapter.list.remove(this.tokutil.getXpath());
                    this.xmladapter.list.put(this.tokutil.getXpath(), data);
                } else {
                    this.xmladapter.list.put(this.tokutil.getXpath(), data);
                }

                return data;
            } else {
                if (this.tokutil.getErrMessage().equals("")) {
                    this.errmessage = this.first_name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                    this.errcode = 9000;
                } else {
                    this.errmessage = this.tokutil.getErrMessage();
                    this.errcode = 9000;
                }

                return null;
            }
        }
    }

    public boolean setMaxelementinit(String name, String data) throws Exception {
        this.loop_label = 1;
        boolean check = this.tokutil.istempxathcheck(name);
        if (check) {
            this.maxelement = this.tokutil.getXpath();
            this.maxelementdata = new StringBuffer();
            if (data != null) {
                this.maxelementdata.append(data);
            }

            this.maxelementname = name;
            this.maxelementroot = this.maxelement.substring(this.maxelement.lastIndexOf("/") + 1);
            this.doc = new DocumentImpl();
            this.root = this.doc.createElement(this.maxelementroot);
            return check;
        } else {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return check;
        }
    }

    public boolean setMaxelementinit(String name) throws Exception {
        return this.setMaxelementinit(name, (String)null);
    }

    public boolean setMaxsubelementinit(String name) throws Exception {
        this.loop_label = 2;
        ++this.subele_check;
        boolean check = this.tokutil.istempxathcheck(name);
        if (check) {
            String xpathdata = this.tokutil.getXpath();
            this.maxsubelementname = xpathdata;
            if (xpathdata.indexOf(this.maxelement) == -1) {
                this.errmessage = name + " 단축 항목은 " + this.maxelement + " 엘리먼트 그룹에 속한 매핑정보가 아닙니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
                return false;
            } else {
                xpathdata = xpathdata.substring(xpathdata.lastIndexOf("/") + 1);
                this.item = this.doc.createElement(xpathdata);
                if (this.subele_check == 2) {
                    this.root.getLastChild().appendChild(this.item);
                } else {
                    this.root.appendChild(this.item);
                }

                return check;
            }
        } else {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return check;
        }
    }


    public void setMaxsubelementFinal() throws Exception {
        this.maxsubelementname = null;
        --this.subele_check;
    }

    public String setMaxelementFinal() throws Exception {
        this.loop_label = 0;
        this.doc.appendChild(this.root);
        OutputFormat format = new OutputFormat(this.doc);
        if (this.xml_encode.equals("")) {
            format.setEncoding("EUC-KR");
        } else {
            format.setEncoding(this.xml_encode);
        }

        StringWriter stringOut = new StringWriter();
        XMLSerializer serial = new XMLSerializer(stringOut, format);
        serial.asDOMSerializer();
        serial.serialize(this.doc.getDocumentElement());
        String data = stringOut.toString();
        data = data.substring(data.indexOf("?>") + 2);
        this.maxelementdata.append(data);
        this.maxelementname = null;
        this.maxelement = null;
        this.maxelementroot = null;
        this.doc = null;
        this.root = null;
        this.item = null;
        return this.maxelementdata.toString();
    }

    public boolean setMaxaddData(String name, String data) throws Exception {
        boolean check = this.tokutil.istempxathcheck(name);
        if (check) {
            this.xmladapter.list.put(this.tokutil.getXpath(), data);
            return check;
        } else {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return check;
        }
    }

    public void initLoopDataWithoutChild() {
        this.setMaxinit();
    }

    public boolean setLoopDataWithoutChild(String name, String value) throws Exception {
        return this.setMaxUpdate(name, value);
    }

    public boolean closeLoopDataWithoutChild() {
        if (this.tokutil.isrepeat()) {
            this.xmladapter.list.put(this.tokutil.getXpath(), this.datalist);
            return true;
        } else {
            System.out.println(this.tokutil.getXpath() + " 경로는 반복항목으로 지정되어 있지 않습니다.");
            return false;
        }
    }

    public void setMaxinit() {
        this.datalist = new ArrayList();
    }

    public boolean setMaxUpdate(String name, String data) throws Exception {
        if (data == null) {
            data = "";
        }

        boolean check = this.tokutil.isinputcheck(name, data);
        data = this.specialCharChange(data);
        if (check) {
            this.datalist.add(data);
            return check;
        } else {
            if (this.tokutil.getErrMessage().equals("")) {
                this.errmessage = name + " 단축 항목은 " + this.mappingfile + " 템플릿  매핑정보에 없는 정보입니다.\n다시 확인하시기 바랍니다.";
                this.errcode = 9000;
            } else {
                this.errmessage = this.tokutil.getErrMessage();
                this.errcode = 9000;
            }

            return check;
        }
    }

    public void setMaxFinal() {
        if (this.tokutil.isrepeat()) {
            this.xmladapter.list.put(this.tokutil.getXpath(), this.datalist);
        } else {
            System.out.println(this.tokutil.getXpath() + " 경로는 반복항목으로 지정되어 있지 않습니다.");
        }

    }

    public String getxmlData() {
        ArrayList necessarylist = this.tokutil.getnecessarylist();
        if (necessarylist.size() == 0) {
            this.xmladapter.xmlParsing(this.tempxml, this.xmladapter.list);
            TabbedXmlFromRoot x = new TabbedXmlFromRoot();
            String xmldata = "";

            if (this.xml_encode.equals("")) {
            	xmldata = x.MakeXmlData(this.xmladapter.getXMLData(),"UTF-8");
                //xmldata = x.MakeXmlData(this.xmladapter.getXMLData(),"euc-kr");
                //System.err.println("===================================================================");
                //System.err.println(xmldata);
                //System.err.println("===================================================================");
            } else {
                xmldata = x.MakeXmlData(this.xmladapter.getXMLData(), this.xml_encode);
            }

            if (!this.xslURL.equals("")) {
                xmldata = xmldata.substring(0, xmldata.indexOf("\n") + 1).concat(this.xslURL + "\n") + xmldata.substring(xmldata.indexOf("\n") + 1);
                this.xslURL = "";
            }

            return xmldata;
        } else {
            for(int i = 0; i < necessarylist.size(); ++i) {
                System.out.println(necessarylist.get(i) + " 필수 단축 항목 데이터를 입력하세요.");
            }

            return "";
        }
    }

    public String getDocCode() {
        return this.docCode;
    }

    public boolean writexmlFile(String s) {
        return this.xml_encode.equals("") ? TabbedXmlFromRoot.genFileCreate(s, this.getxmlData(), "utf-8") : TabbedXmlFromRoot.genFileCreate(s, this.getxmlData(), this.xml_encode);
    }
}
