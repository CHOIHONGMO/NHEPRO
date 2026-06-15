package com.st_ones.common.util.clazz;

import java.math.BigDecimal;
import java.text.DecimalFormat;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverMath.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public final class EverMath {

	public static double getRound(double paramDouble1, double paramDouble2) {
		if (paramDouble2 == 0.0D)
			return paramDouble1;
		if (paramDouble2 == 1.0D) {
			return Math.round(paramDouble1);
		}

		double d2 = Math.pow(10.0D, paramDouble2 - 1.0D);
		BigDecimal localBigDecimal = new BigDecimal(String.valueOf(paramDouble1)).multiply(new BigDecimal(String.valueOf(d2)));
		return (Math.round(localBigDecimal.doubleValue()) / d2);
	}

	public static double getCeil(double paramDouble1, double paramDouble2) {
		if (paramDouble2 == 0.0D)
			return paramDouble1;
		if (paramDouble2 == 1.0D) {
			return Math.ceil(paramDouble1);
		}

		double d2 = Math.pow(10.0D, paramDouble2 - 1.0D);
		BigDecimal localBigDecimal = new BigDecimal(String.valueOf(paramDouble1)).multiply(new BigDecimal(String.valueOf(d2)));
		return (Math.ceil(localBigDecimal.doubleValue()) / d2);
	}

	public static double getFloor(double paramDouble1, double paramDouble2) {
		if (paramDouble2 == 0.0D)
			return paramDouble1;
		if (paramDouble2 == 1.0D) {
			return Math.floor(paramDouble1);
		}

		double d2 = Math.pow(10.0D, paramDouble2 - 1.0D);
		BigDecimal localBigDecimal = new BigDecimal(String.valueOf(paramDouble1)).multiply(new BigDecimal(String.valueOf(d2)));
		return (Math.floor(localBigDecimal.doubleValue()) / d2);
	}

	public static String EverNumberType(double paramDouble, String paramString) {
		String str = "";
		DecimalFormat localDecimalFormat = new DecimalFormat(paramString);
		str = localDecimalFormat.format(paramDouble);
		return str;
	}

	public static String EverNumberType(String paramString1, String paramString2) {
		String str = "";
		try {
			double d2 = Double.parseDouble(paramString1);
			str = EverNumberType(d2, paramString2);
		} catch (NumberFormatException localNumberFormatException) {
			str = paramString1;
		}
		return str;
	}
}
