package com.st_ones.common.schedule;

import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : ScheduleListener.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class ScheduleListener implements ServletContextListener {

    Scheduler scheduler = null;
    Logger logger = LoggerFactory.getLogger(getClass());

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {

        logger.info("Starting Quartz");

        try {
            scheduler = StdSchedulerFactory.getDefaultScheduler();
            String scheduleName01 = "eversrm.scheduling01"; //Blossom 결제

            /** ******************************************************************************************
             * Blossom Approval Result >> SRM
             * 1분마다 수행
             * @param req
             * @return
             * @throws Exception
             */
            //        JobDetail jobDetail01 = newJob(BLSMAPPROVALJob.class).withIdentity(scheduleName01, "DEFAULT01").withDescription("블라섬 결재정보 I/F").build();
            //        CronTrigger trigger01 = newTrigger().withIdentity(scheduleName01, "DEFAULT01").withSchedule(cronSchedule("0 0/5 * * * ?")).build();
            //        scheduler.deleteJob(jobDetail01.getKey());
            //        scheduler.scheduleJob(jobDetail01, trigger01);

            /*
             * Cron Expression cron expression의 각각의 필드는 다음을 나타낸다.(왼쪽 -> 오른쪽 순) 필드 이름
             * 허용 값 허용된 특수 문자 Seconds 0 ~ 59 , - * / Minutes 0 ~ 59 , - * / Hours 0
             * ~ 23 , - * / Day-of-month 1 ~ 31 , - * ? / L W Month 1 ~12 or JAN ~
             * DEC , - * / Day-Of-Week 1 ~ 7 or SUN-SAT , - * ? / L # Year
             * (optional) empty, 1970 ~ 2099 , - * /
             *
             * Cron Expression 의 특수문자 '*' : 모든 수를 나타냄. 분의 위치에 * 설정하면 "매 분 마다" 라는 뜻.
             * '?' : day-of-month 와 day-of-week 필드에서만 사용가능. 특별한 값이 없음을 나타낸다. '-' :
             * "10-12" 과 같이 기간을 설정한다. 시간 필드에 "10-12" 이라 입력하면 "10, 11, 12시에 동작하도록 설정"
             * 이란 뜻. ',' : "MON,WED,FRI"와 같이 특정 시간을 설정할 때 사용한다. "MON,WED,FRI" 이면
             * " '월,수,금' 에만 동작" 이란 뜻. '/' : 증가를 표현합니다. 예를 들어 초 단위에 "0/15"로 세팅 되어 있다면
             * "0초 부터 시작하여 15초 이후에 동작" 이란 뜻. 'L' : day-of-month 와 day-of-week 필드에만
             * 사용하며 마지막날을 나타냅. 만약 day-of-month 에 "L" 로 되어 있다면 이번 달의 마지막에 실행하겠다는 것을
             * 나타냄. 'W' : day-of-month 필드에만 사용되며, 주어진 기간에 가장 가까운 평일(월~금)을 나타낸다. 만약
             * "15W" 이고 이번 달의 15일이 토요일이라면 가장가까운 14일 금요일날 실행된다. 또 15일이 일요일이라면 가장 가까운
             * 평일인 16일 월요일에 실행되게 된다. 만약 15일이 화요일이라면 화요일인 15일에 수행된다. "LW" : L과 W를
             * 결합하여 사용할 수 있으며 "LW"는 "이번달 마지막 평일"을 나타냄 "#" : day-of-week에 사용된다. "6#3"
             * 이면 3(3)번째 주 금요일(6) 이란 뜻이된다.1은 일요일 ~ 7은 토요일
             *
             * Expression Meaning "0 0 12 * * ?" 매일 12시에 실행 "0 15 10 ? * *" 매일 10시
             * 15분에 실행 "0 15 10 * * ?" 매일 10시 15분에 실행 "0 15 10 * * ? *" 매일 10시 15분에
             * 실행 "0 15 10 * * ?  2010" 2010년 동안 매일 10시 15분에 실행 "0 * 14 * * ?" 매일
             * 14시에서 시작해서 14:59분 에 끝남 "0 0/5 14 * * ?" 매일 14시에 시작하여 5분 간격으로 실행되며
             * 14:55분에 끝남 "0 0/5 14,18 * * ?" 매일 14시에 시작하여 5분 간격으로 실행되며 14:55분에 끝나고,
             * 매일 18시에 시작하여 5분간격으로 실행되며 18:55분에 끝난다. "0 0-5 14 * * ?" 매일 14시에 시작하여
             * 14:05 분에 끝난다.
             *
             * Ex) 매일 7시 20분에 한번 수행 [cronSchedule("0 20 7 * * ?")]
             *     매일 5시에 한번 수행 [cronSchedule("0 0 5 * * ?")]
             *     10분마다 수행 [cronSchedule("0 0/10 * * * ?")]
             */

            //		특정 IP에서만 실행한다.
            //		if(PropertiesManager.getString("quartz.batch.running.ips").indexOf(server_ip) >= 0) {
            //			scheduler.scheduleJob(jobDetail01, trigger01);
            //			scheduler.scheduleJob(jobDetail02, trigger02);
            //			scheduler.scheduleJob(jobDetail03, trigger03);
            //			scheduler.scheduleJob(jobDetail04, trigger04);
            //			scheduler.scheduleJob(jobDetail05, trigger05);
            //			scheduler.scheduleJob(jobDetail06, trigger06);
            //		} else {
            //			System.err.println("Batch 가 실행되지 않았습니다. 특정 IP 에서만 실행됩니다. 허용된 IP 주소는 "  + PropertiesManager.getString("quartz.batch.running.ips") + " 입니다.");
            //		}

        } catch(SchedulerException e) {
            logger.error(e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        try {
            logger.info("Shutting down Quartz");
            scheduler.shutdown();
        } catch(SchedulerException se) {
            logger.error(se.getMessage(), se);
        }
    }
}
