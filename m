Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873433;
	b=RU8DJqOBYKHkzpMHBpG/3W8JDrrD9KfL2cZ5JI59ixMOpMzBd4unT5eTsSqMxDGIxKll
	 g2BqcCoqZsQO8Fpv7p28eNUGLMWlDZBNdaTpyxaoO+4QgiKlWTViJ+u6lA+YKP1edmGl+
	 MyubiKH8e2CiDS08BpvcdDM62kTaUipmvasIQBXDdsvs4LVTONSVAOlZbToXwGISskkAy
	 x9oqvyWLtKZu/FdubHEvfQ5s3zioH5hXgcW1y2/j03vpHXzdjqzzL12SqBCGt2B4sntR7
	 Ct3TNaVYnqm89x2D/yw4vXxwcus2py80gyR12I6X59eVMatkicrl8yKocSEqvWyVctw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873433;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=yWwL6CRocQOXkP/YF1HJOwUZtgxlc1fXafseNapHPqo=;
	b=r8KaNmAfi/7wbngb5EdW25Ybs3lBsrm9TCmyRS7YhhnmSmsBTPtwhUlRCguD164TcKHo
	 4njQu75CaWhfsYDKLwA22jvthPxUyQkFwAGUs8jg9NAT5bZA82EeWh2WLFdcG6M3a+n5/
	 hVZQJopaKePJxxVBPqGr0XzJIA8POdQ/qPgjR7HJD9byQrOV/rzgELNVNdh5qd0NV8HaW
	 LPA90oP8pjzrmJCgLCitzLEcPfmN1yIQ9CCUa3/jZVxHsu2vPgNfmDkyfI54NtxjdKCSf
	 x2pFvLLO2pk/6nONGDYRE86e4OrZtPsvp9AFLeZ/TtJ4P5qgWJsm09XZ6oC0pLbHhfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=us.ibm.com;
	spf=pass smtp.mailfrom=us.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GkIgI43y;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B3D606A31C
	for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0B3D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=us.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=us.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GkIgI43y
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGNQ5mA581991
	for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yWwL6CRocQOXkP/YF
	1HJOwUZtgxlc1fXafseNapHPqo=; b=GkIgI43yEb2ag4cWrypAXB5/lZejny/jI
	nyDEy62BPDPaGfL7380+rzYH53VGUw6sETc5aAX4iCGSHaSaWfCpR3JVWtINvhM0
	8tGYwrRIUM3tDtKxIQTo8ufcYP/dETLg61XPImofFUN90QT/glb+vE7QEe6VE99y
	ubxNrfxKzqgoHAqKofiVvOyc3qZP/TiXoClDXNTBFFD5q4UFj/byiJ09QuTW3owZ
	/UL5/Y6FDyMh6V/X/+IyeCV9Z3kw9fLHC9hO3iToXsCa2jk0Yl9rMZut4uXK6yrw
	CYkeRY9X7c0zgSrxe98BT56wn+QnE8YRGZWbecuAyz3OXjD/EeRjg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxfc50cuf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:57:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGNYrF72684511
	for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:57:11 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j067n99fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2026 23:57:10 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGNv8W228246764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 23:57:08 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6957D58061;
	Mon, 16 Nov 2026 23:57:08 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FF4558060;
	Mon, 16 Nov 2026 23:57:08 +0000 (GMT)
Received: from ubuntu-server.ibm.com (unknown [9.61.151.57])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Nov 2026 23:57:08 +0000 (GMT)
From: Jamie Dolan <jldolan@us.ibm.com>
To: linux-trace-devel@vger.kernel.org
Cc: Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH] libtracefs utest: Fix buffer size in follow events clear test
Date: Mon, 16 Nov 2026 17:53:49 -0600
Message-ID: <20261116235650.21314-1-jldolan@us.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com>
References: <39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5NSBTYWx0ZWRfXyvW7eKPE/gMz
 LYcpzYlP9sKGjM1B4atIuH/FhX0V5u3BZ9dZXe+vimghbkJqpc5Cj2EepWKaA3NsRVl5c4kKuvu
 RUcj3KqKD+2ioH3ewL/iKa/B2enuiqo=
X-Authority-Analysis: v=2.4 cv=Fu6QbGrq c=1 sm=1 tr=0 ts=6afb9857 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=danhDmx_AAAA:8 a=VnNF1IyMAAAA:8
 a=sSvmSXybxLCSEcB7nqQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5NSBTYWx0ZWRfX3ClhW2fhpWpK
 xYHu7ri+tuidVckTMzmTmz6tv9JLJyEZrW+oLgr8JiS+Vm1FZsbtu24WVZNTFyjSMCBNYKCj8Up
 TrS+Z/VYycwHJQv1DzwQ1qTDwMk5b1L4YV7ZdGFI4z1ya0gjH1/tCKmiIzB7e9M2cEj+bJ434+f
 +XqEVEmIt9RHkowimpCuJQgjS5/CyD8l1OKxcAVV7h4pSDkS1tFql3P9ZCkdThDVst4k/gIetiF
 DjuzfPkkawz3SlyhQaTYZEGT8QNYI5GLwZTaac64ioj5pRYsxBVTZH0dWgHczlUmLzNk2bJWuMr
 yeisvIc/dUIMuMz7UXBoD+5baaZRkt4NqrCAS6Hptnl16ODJj8mHEz4BQUZnDiSizjh+uwiiWmq
 7dH64EgBn2vuR3ojf37imYDbOIwSRUne/QOjc3+TuhQnDWOTyjCUcJK4nrrfse2IAPLQ6J6/QDS
 JEcOa3TzfOGPbHcqdfQ==
X-Proofpoint-GUID: CFbf6icHwqyIoXDbDzBgjcxhIfwdKYiJ
X-Proofpoint-ORIG-GUID: CFbf6icHwqyIoXDbDzBgjcxhIfwdKYiJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_07,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160095

Commit 310b796 (libtracefs utest: Add better logic to cause
missed events) reduced the buffer size to make missed
events more likely during the follow events clear test.

However, getpagesize() returns the page size in bytes, while
tracefs_instance_set_buffer_size() expects the buffer size in
kilobytes. This causes the buffer to be set 1024 times larger
than intended, making it less likely to overflow and trigger
missed events.

Convert the buffer size from bytes to kilobytes to ensure
the intended buffer size of 4 pages is used.

Fixes: 310b7964c41f ("libtracefs utest: Add better logic to cause missed events")
Bug: https://bugs.launchpad.net/ubuntu/+source/libtracefs/+bug/2172071

Signed-off-by: Jamie Dolan <jldolan@us.ibm.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e48232c..bbbcc84 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1721,7 +1721,7 @@ static void test_instance_follow_events_clear(struct tracefs_instance *instance)
 	/* Shrink the buffer to make sure we have missed events */
 	page_size = getpagesize();
 	save_size = tracefs_instance_get_buffer_size(instance, 0);
-	ret = tracefs_instance_set_buffer_size(instance, page_size * 4, 0);
+	ret = tracefs_instance_set_buffer_size(instance, (page_size * 4) / 1024, 0);
 	CU_TEST(ret == 0);
 
 	tracefs_trace_on(instance);
-- 
2.53.0

