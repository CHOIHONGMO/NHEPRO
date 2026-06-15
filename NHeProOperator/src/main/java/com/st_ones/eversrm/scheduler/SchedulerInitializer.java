package com.st_ones.eversrm.scheduler;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import javax.servlet.http.HttpServlet;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.st_ones.batch.nhebatch.web.BNH0001;
import com.st_ones.batch.nhebatch.web.BNH0010;
import com.st_ones.batch.nhebatch.web.BNH0011;
import com.st_ones.batch.nhebatch.web.BNH0012;
import com.st_ones.batch.nhebatch.web.BNH0013;
import com.st_ones.batch.nhebatch.web.BNH0014;
import com.st_ones.batch.nhebatch.web.BNH0015;
import com.st_ones.batch.nhebatch.web.BNH0016;
import com.st_ones.batch.nhebatch.web.BNH0017;
import com.st_ones.batch.nhebatch.web.BNH0018;
import com.st_ones.batch.nhebatch.web.BNH0019;
import com.st_ones.batch.nhebatch.web.BNH0020;
import com.st_ones.everf.serverside.config.PropertiesManager;

public class SchedulerInitializer extends HttpServlet {

	private static Logger logger = LoggerFactory.getLogger(SchedulerInitializer.class);

	private static final long serialVersionUID = 1L;

	public SchedulerInitializer() throws Exception {

		String serverIp=java.net.InetAddress.getLocalHost().getHostAddress();

		System.err.println("SchedulerInitializer's serverIp ====================== " + serverIp);
		System.err.println("SchedulerInitializer's running.ips =================== " + PropertiesManager.getString("quartz.batch.running.ips"));
		System.err.println("SchedulerInitializer's quartz.use.yn ================= " + PropertiesManager.getString("quartz.use.yn"));

		if("Y".equals(PropertiesManager.getString("quartz.use.yn"))) { // 나중에 주석풀것.

			Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
			String scheduleName01 = "eversrm.scheduling01"; // 아리오피스(조직인사)
			String scheduleName02 = "eversrm.scheduling02"; // IT Portal(계약서 받는거)
			String scheduleName03 = "eversrm.scheduling03"; // IT Portal(계약서 보내는거)
			String scheduleName04 = "eversrm.scheduling04"; // 사용자,부서SYNC
			String scheduleName05 = "eversrm.scheduling05"; // 첨부파일 과금
			String scheduleName06 = "eversrm.scheduling06"; // 예가마감 사전안내
			String scheduleName07 = "eversrm.scheduling07"; // 임찰마감 및 입찰서 제출 기한 사전안내
			String scheduleName08 = "eversrm.scheduling08"; // 휴면계정 전환
			String scheduleName09 = "eversrm.scheduling09"; // 12개월 미접속 사용자 정보 이관
			//String scheduleName10 = "eversrm.scheduling10"; // 12개월 미접속 사용자 정보 이관
			//String scheduleName11 = "eversrm.scheduling11"; // 파트너스 12개월 미접속 사용자 정보 이관
			String scheduleName12 = "eversrm.scheduling12"; // 검수 및 대금지급 지연 안내

			/** ******************************************************************************************
			 * [기본정보] 아리오피스(조직인사)]
			 * 매일 새벽 04시 10분 [아리오피스에서 조직정보를 3시 40분에 넘겨줌] : 15 ~ 20분 소요
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail01 = newJob(BNH0001.class).withIdentity(scheduleName01, "DEFAULT01").withDescription("아리오피스(조직인사)").build();
			CronTrigger trigger01 = newTrigger().withIdentity(scheduleName01, "DEFAULT01").withSchedule(cronSchedule("0 10 4 * * ?")).build();
			scheduler.deleteJob(jobDetail01.getKey());
			
			/** ******************************************************************************************
			 * [기본정보] IT Portal(계약서) 의뢰
			 * 매시 55분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail02 = newJob(BNH0010.class).withIdentity(scheduleName02, "DEFAULT02").withDescription("IT Portal(계약서의뢰접수)").build();
			CronTrigger trigger02 = newTrigger().withIdentity(scheduleName02, "DEFAULT02").withSchedule(cronSchedule("0 55 * * * ?")).build();
			scheduler.deleteJob(jobDetail02.getKey());
			
			/** ******************************************************************************************
			 * [기본정보] IT Portal(계약서) 전송
			 * 매시 20분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail03 = newJob(BNH0011.class).withIdentity(scheduleName03, "DEFAULT03").withDescription("IT Portal(계약서전송)").build();
			CronTrigger trigger03 = newTrigger().withIdentity(scheduleName03, "DEFAULT03").withSchedule(cronSchedule("0 20 * * * ?")).build();
			scheduler.deleteJob(jobDetail03.getKey());
			
			/** ******************************************************************************************
			 * [기본정보] 사용자,부서SYNC
			 * 매일 새벽 7시 45분 => 아리오피스(조직인사) 완료 후 7시 45분 수행
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail04 = newJob(BNH0012.class).withIdentity(scheduleName04, "DEFAULT04").withDescription("사용자,부서SYNC").build();
			CronTrigger trigger04 = newTrigger().withIdentity(scheduleName04, "DEFAULT04").withSchedule(cronSchedule("0 45 7 * * ?")).build();
			scheduler.deleteJob(jobDetail04.getKey());
			
			/** ******************************************************************************************
			 * [기본정보] 첨부파일 과금
			 * 매일 새벽 01시 00분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			// 2021.07.08 첨부파일 과금 제외 : 현재상태 과금 불가
			//JobDetail jobDetail05 = newJob(BNH0013.class).withIdentity(scheduleName05, "DEFAULT05").withDescription("첨부파일 과금").build();
			//CronTrigger trigger05 = newTrigger().withIdentity(scheduleName05, "DEFAULT05").withSchedule(cronSchedule("0 0 1 * * ?")).build();
			//scheduler.deleteJob(jobDetail05.getKey());

			/** ******************************************************************************************
			 * [기본정보] 예가마감 사전안내
			 * 매시 50분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail06 = newJob(BNH0014.class).withIdentity(scheduleName06, "DEFAULT06").withDescription("예가마감 사전안내").build();
			CronTrigger trigger06 = newTrigger().withIdentity(scheduleName06, "DEFAULT06").withSchedule(cronSchedule("0 50 * * * ?")).build();
			scheduler.deleteJob(jobDetail06.getKey());

			/** ******************************************************************************************
			 * [기본정보] 임찰마감 및 입찰서 제출 기한 사전안내
			 * 매시 50분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail07 = newJob(BNH0015.class).withIdentity(scheduleName07, "DEFAULT07").withDescription("임찰마감 및 입찰서 제출 기한 사전안내").build();
			CronTrigger trigger07 = newTrigger().withIdentity(scheduleName07, "DEFAULT07").withSchedule(cronSchedule("0 50 * * * ?")).build();
			scheduler.deleteJob(jobDetail07.getKey());


			/** ******************************************************************************************
			 * [기본정보] 휴면계정 전환
			 * 매일 오전 2시
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail08 = newJob(BNH0016.class).withIdentity(scheduleName08, "DEFAULT08").withDescription("11개월 미접속자 휴면계정 전환").build();
			CronTrigger trigger08 = newTrigger().withIdentity(scheduleName08, "DEFAULT08").withSchedule(cronSchedule("0 0 2 * * ?")).build();
			scheduler.deleteJob(jobDetail08.getKey());


			/** ******************************************************************************************
			 * [기본정보] 12개월 미접속 사용자 정보 이관
			 * 매일 오전 2시 30분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail09 = newJob(BNH0017.class).withIdentity(scheduleName09, "DEFAULT09").withDescription("12개월 미접속 사용자 정보 이관").build();
			CronTrigger trigger09 = newTrigger().withIdentity(scheduleName07, "DEFAULT09").withSchedule(cronSchedule("0 30 2 * * ?")).build();
			scheduler.deleteJob(jobDetail09.getKey());
			
			/** ******************************************************************************************
			 * [기본정보] 개인근로자_휴면계정 전환
			 * 매일 오전 3시
			 * @param req
			 * @return
			 * @throws Exception
			 */
			// 2024.01.08 개인근로자 휴먼계정 전환 알림 문자 제외
			//JobDetail jobDetail10 = newJob(BNH0018.class).withIdentity(scheduleName10, "DEFAULT10").withDescription("11개월 미접속 개인근로자 휴면계정 전환").build();
			//CronTrigger trigger10 = newTrigger().withIdentity(scheduleName10, "DEFAULT10").withSchedule(cronSchedule("0 0 3 * * ?")).build();
			//scheduler.deleteJob(jobDetail10.getKey());


			/** ******************************************************************************************
			 * [기본정보] 72개월 미접속 사용자 정보 삭제
			 * 매일 오전 3시 30분
			 * @param req
			 * @return
			 * @throws Exception
			 */
			// 2024.01.08 개인근로자 휴먼계정 전환 제외
			//JobDetail jobDetail11 = newJob(BNH0019.class).withIdentity(scheduleName11, "DEFAULT11").withDescription("72개월 미접속 사용자 정보 삭제").build();
			//CronTrigger trigger11 = newTrigger().withIdentity(scheduleName11, "DEFAULT11").withSchedule(cronSchedule("0 30 3 * * ?")).build();
			//scheduler.deleteJob(jobDetail11.getKey());
			
			
			/** ******************************************************************************************
			 * [기본정보] 검수 및 대금지급 요청 지연 안내
			 * 매일 오전 10시
			 * @param req
			 * @return
			 * @throws Exception
			 */
			JobDetail jobDetail12 = newJob(BNH0020.class).withIdentity(scheduleName12, "DEFAULT12").withDescription("검수 및 대금지급 요청 지연 안내").build();
			CronTrigger trigger12 = newTrigger().withIdentity(scheduleName12, "DEFAULT12").withSchedule(cronSchedule("0 0 10 * * ?")).build();
			scheduler.deleteJob(jobDetail12.getKey());
			

			// 특정 IP에서만 실행한다.
			if(PropertiesManager.getString("quartz.batch.running.ips").indexOf(serverIp) >= 0) {
				System.err.println("a=====================================start========================================");
				scheduler.scheduleJob(jobDetail01, trigger01);
				scheduler.scheduleJob(jobDetail02, trigger02);
				scheduler.scheduleJob(jobDetail03, trigger03);
				scheduler.scheduleJob(jobDetail04, trigger04);
				// 2021.07.08 : 현재상태 수행 불가
				// 첨부파일 과금 Batch 제외
				//scheduler.scheduleJob(jobDetail05, trigger05);
				scheduler.scheduleJob(jobDetail06, trigger06);
				scheduler.scheduleJob(jobDetail07, trigger07);
				scheduler.scheduleJob(jobDetail08, trigger08);
				scheduler.scheduleJob(jobDetail09, trigger09);
				// 2024.01.08 개인근로자 휴먼계정 전환 배치 제외
				//scheduler.scheduleJob(jobDetail10, trigger10);
				//scheduler.scheduleJob(jobDetail11, trigger11);
				scheduler.scheduleJob(jobDetail12, trigger12);
			} else {
				System.err.println("Batch 가 실행되지 않았습니다. 특정 IP 에서만 실행됩니다.");
			}
		}
	}

}
