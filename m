Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025243;
	b=MQ5ux6DOXkKi6sMzRvoPrywOvflJFXj4wa/gKiQYbmmjIz77LDmJPuSK2IhtwWZ0hAwN
	 luG8i6EMLot9wVoqSZBvuiV45ivUojKdQJjvGYZmnZNeFzJJaUER7QoxDlN++BaE1ERxO
	 KrAOtKubQsfrhWstvNMtruHE2EvSASzazg1eYBcbratQ6JdVcsR33+Qf3D8CMJ7aIkeuO
	 6epVYyTbiQq/hazEbaeB3DpfbKNrkL79oMpIpKhl2xlL4gxBmTMjcwccYqE0c0QKHdyCx
	 Eajp5DX63xEya5Bz+7bVDlMTjqUKSE+xHkRX87s/tqFWjM7cmKIye5Ve2qM42OuSP0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025243;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/4P4QcAsnce/r643knYLjl2g4Sf4Yi3G3kQrcqupxkA=;
	b=IjicfjxcADdzmMYejRFPIg7QHttvc5WdEaCp2kleBbFcJvz19Bvt2RQ+6KekfLL1TmzK
	 eWDTtl7pbYRuv0gXJHjhk3eZGYDXiGnyuEeDkDQUHu1t/jNvjvVTNcU8rO/FHxKLJmqHY
	 eNhiDXWIhEeOq8p+nivTeY+qnLXFuRuiPlPKUudMX1N3QuvWoygvF2geaaGMJVhJhSB4d
	 arovKYOpEog4jgO6i4EQWvgGC3afQvwZEwqRj+VIIWup9W2zQQefL7ROcDqm6xS7yHTg7
	 XAuIjafxOuAP39KbXDYDO1gzY/vX45m3fgG2bGqje5CwJy84jZ3EZGfjRtZXFBm/E1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pUfaallY;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BF606A32C
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 18:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 160BF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pUfaallY
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHQEE11707973;
	Wed, 18 Nov 2026 18:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=/4P4QcAsnce/r643knYLjl2g4Sf4Yi3G3kQrcqupx
	kA=; b=pUfaallYiLhdtqMYS6s/QLtpt+pxp+imem2n2UY4Ph96hjg+27iFZzh1h
	ug1xQys4Vs+oOiDcre/aRmFcoLg5rc+Plo6DJAF8JjDmT/SvPGW61+WCAksfNG+X
	gtiwPt6YoZgGbp5T0FFDMiUJ1W+gz8v27k7jxbgJHEk2U85x4kZZTU0BbV6bzp/j
	z9TTBMgPEyHTIznuCPM1Xl6i6lI8DeDTo4YWsG5QLQqPpGLfQ6M7S7+6RLZ1dkn4
	vceoysku1BYYxfxbLnGqTXwje5w9012oy46vb2xAt45WkgG395vHkwdajEJ90VcO
	mwm2ZIXLuBCY+oGWw5J71qYZ01N/Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105t3wkp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 18:07:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHJwqK3429450;
	Wed, 18 Nov 2026 18:07:19 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j02juh8ky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 18:07:19 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AII7IFq52953504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 18:07:18 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BEB75805F;
	Wed, 18 Nov 2026 18:07:18 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD20C58050;
	Wed, 18 Nov 2026 18:07:17 +0000 (GMT)
Received: from wspoon5.. (unknown [9.5.7.39])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Nov 2026 18:07:17 +0000 (GMT)
From: Jamie Dolan <jldolan@linux.ibm.com>
To: linux-trace-devel@vger.kernel.org
Cc: frank.heimes@canonical.com, Jamie Dolan <jldolan@linux.ibm.com>
Subject: [PATCH] libtracefs utest: Apply min percent before setting buffer percent
Date: Wed, 18 Nov 2026 18:06:41 +0000
Message-ID: <20261118180641.40630-1-jldolan@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=IouL47/g c=1 sm=1 tr=0 ts=6afde958 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=danhDmx_AAAA:8 a=VnNF1IyMAAAA:8
 a=BGmylJew8my_ZTgJfLMA:9
X-Proofpoint-ORIG-GUID: RPtUa73sBPl9AMRrzfd1u798L6qVy6L0
X-Proofpoint-GUID: RPtUa73sBPl9AMRrzfd1u798L6qVy6L0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3MSBTYWx0ZWRfX5mtvKOl19spl
 SziVF3UbV+F7wGJKn+U1GHYvdOwk8YuYFxv8tbccLX4xmFXNR0O57/zXZNkYQmBEorvhlXvgyrH
 p6qZ+LQEqtHd5vcYJk3wsjhvlM91dsYA98fKWrqjJV8sp7W0+lHxGo4ph6dtfDLh719y70yhVHl
 94PHdDL7aYNdEIPI4D6kpB/ckjDUA0AGIp22xMZTiree8ElzawlSOc6bgLQI8pYhyr8n/ltVxY7
 B/PS7oXmSSLuw72vKKSITGi6JMc0hp+ZhnMo5Vs0nOHevYu8voGjFulwNAQIGS5c81UN1LlQaky
 +JumUFgSwENtU/wgQBk0/WyK5qe+JkGqkkTU2da6nZbcOhxCfRd/AolBTrTWr+1EdgtwwvYksrQ
 XTr/tpmtLxcWJvjTVL7FSqbIHxmAGMIOE+67h7ilssBTOXQN3CkxunOO9GOCo02U+yJLTp45bqD
 SAlD08G5VoUgroiKQcQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3MSBTYWx0ZWRfXx0qFVm/8Sprr
 L1GWsDvGpPoBISISK1IbikyuaVldBaUCgg0ABBGxsIvV75kCsaaVssWsiElheowQsnn0gXmMrbr
 xOVlat0qzSCjcZC0N0hfkg2peeR5Jy4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180071

The "trace cpu read_buf_percent" test raises the buffer percentage
to a higher minimum value to account for architectures with larger
sub-buffers, such as PowerPC with a 64K PAGE_SIZE.

However, the adjustment happens after the buffer percentage
has already been set in the kernel.

As a result, the kernel uses a lower threshold while the test
calculates its expected event count using the adjusted percentage.
This causes tracefs_cpu_read_buf() to return earlier than
expected, causing the test to fail with "data->done == false".

Move the min percent calculation before the buffer percentage is set.

Fixes: 05a5dc42733b ("libtracefs utest: Fix min percent test")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=219358
Bug-Ubuntu: https://launchpad.net/bugs/2062119
Signed-off-by: Jamie Dolan <jldolan@linux.ibm.com>
---
 utest/tracefs-utest.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e48232c..ec56327 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1333,6 +1333,19 @@ static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 	save_percent = tracefs_instance_get_buffer_percent(data->instance);
 	CU_TEST(save_percent >= 0);
 
+	if (percent) {
+		int min_percent;
+
+		/*
+		 * For architectures like PowerPC with 64K PAGE_SIZE and thus
+		 * large sub buffers, where we will not have over 100 sub buffers
+		 * percent must at least cover more than 1 sub buffer.
+		 */
+		min_percent = (100 + (data->nr_subbufs - 1)) / data->nr_subbufs;
+		if (percent < min_percent)
+			percent = min_percent;
+	}
+
 	ret = tracefs_instance_set_buffer_percent(data->instance, percent);
 	CU_TEST(ret == 0);
 
@@ -1350,16 +1363,6 @@ static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 
 	/* For percent == 0, just test for any data */
 	if (percent) {
-		int min_percent;
-
-		/*
-		 * For architectures like PowerPC with 64K PAGE_SIZE and thus
-		 * large sub buffers, where we will not have over 100 sub buffers
-		 * percent must at least cover more than 1 sub buffer.
-		 */
-		min_percent = (100 + (data->nr_subbufs - 1)) / data->nr_subbufs;
-		if (percent < min_percent)
-			percent = min_percent;
 
 		expect = data->nr_subbufs * data->events_per_buf * percent / 100;
 
-- 
2.43.0

