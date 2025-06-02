Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A3B1DEFDD
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jun 2025 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748900525; cv=none; b=SJMhIgir2a0EPra4BGicgGqOqEPhLfkIZwvYFtF/RLZnBd3LqWlbZJqLL+RfzEuH1SrBphq6Gegutv4dqlBCUyN052lndxRt2psX9D0GrQ+Py99OIikyyRUvh+NtcV5MXx9jqMASc27sYqyCIPmtayjQVfhVQDA6pIZ9Wv91UGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748900525; c=relaxed/simple;
	bh=bqSRbFJPDwtCm5QhVKdVK1eEMtfaml68orSlRwVGPnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyx9VnWWXdB7rXSJ86p9qh7VCsjoPuywM4Yg5NnbNUAVJTu05LjrJwC1TG3rvgoqDry1Cw5fRT2OurfuGSSshwXQ2e+krC1M2XO4Qjzg/FQs64JWSCK9qVStd+evxv8tVYWUo/QYKLWTwPG3G3lufKBNncc8TjRyWcrJL4ZJTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MOTs1WiW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MOTs1WiW"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HXb4d001339;
	Mon, 2 Jun 2025 21:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jBN7DMvxR/eGRTc6W
	uwZJYqJ6RaGWYGPdF/nA5bh6KQ=; b=MOTs1WiWa8KhHFRqRCapiXBjvXsuJSUMY
	udV1vqNuk8iq0E85bVq4T8WfNo3Nv2jjY9CJ5vDW1J1HI9ZswpdbPV2Hq8H8mlBl
	Oqnx9Em/mqXQvqJGYquEyTd3lK5rPRua94LgsPk6CosAzwquEx5ncGB9EaTzuOel
	g79vgLxyHOaLHcsaiybH2hAtyF8uKDQA7qrLgxvJH5ZF1SMa4cKN7ynn71hZvhSe
	j8qC+p3oSqrvY/XMvTbQVkjeWU8Yhpfi5cv4rGjPE1JkZnlP8tEp7EBFhvRz0yhL
	F6myHiRGnDfWUWaZxuR1lQDd88bf3lXUV5jfXwqU4eVZiPZQdhOYg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf00vsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 552JKIo0024754;
	Mon, 2 Jun 2025 21:42:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkm7w1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552LfvmV57540956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 21:41:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CF5F20043;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 174CB20040;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
Received: from heavy.ibmuc.com (unknown [9.87.156.82])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 1/2] libtracecmd: Support querying position within a new compressed block
Date: Mon,  2 Jun 2025 22:38:32 +0100
Message-ID: <20250602214154.446881-2-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602214154.446881-1-iii@linux.ibm.com>
References: <20250602214154.446881-1-iii@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cGO2ezf97h06ecrHT1MGVamUg315xLDe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE3OCBTYWx0ZWRfX7iWMFf1k4dZF nXMm1ah5X5SLpe0HlkUNx03D5RPrOsRC0h8BsnU1Iipu+sV4LloOxkZbAKnAePCWJROXUerlZQV dIFEx9tlXOO9tBQLW93qSSSqEmkhmqzSkU0xswvlmRVz+Gm5rYkXTyszCoIIu2oB6Q9myKGA+1Q
 pKCH7AYdSjmLjCpTh1AT1S8u0dDoZVtugUZcIXes8Ax2ncTk13XiTrsQ9RyQWJKZKbf5CpGEf4f Qcvd094sacaEbQki73Hrmz8M1jEwdV2mdCknGsRWNvtkrYo9FOKql3MJrwqCCY08YYQKVn5BJd6 NnNyXVKd9t7MUk+I76cSkuuJcelOumthH85QCgxaO4qfRC/4Is7FiHKDnDpvKkrJwjLJCl2E94l
 rNd7foPiKKelrgq6W7XPiZvxotxB/wrVeiO1ocsCNyjh980Yy6X8RF6K8NeTfPNflriup9Ma
X-Proofpoint-ORIG-GUID: cGO2ezf97h06ecrHT1MGVamUg315xLDe
X-Authority-Analysis: v=2.4 cv=c+WrQQ9l c=1 sm=1 tr=0 ts=683e1aaa cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=ttnRCE21zARDvYvolyIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_08,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=970 phishscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506020178

tracecmd_compress_lseek() refuses to return position within a new
block, because handle->buffer is NULL. Add support for this; do not
implement actually seeking within a new block, because this is not
required at the moment.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-compress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 2a7a3e24..3e10cf5b 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -132,9 +132,12 @@ off_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off_t offset,
 {
 	unsigned long p;
 
-	if (!handle || !handle->buffer)
+	if (!handle)
 		return (off_t)-1;
 
+	if (!handle->buffer)
+		return (whence == SEEK_CUR && offset == 0) ? 0 : (off_t)-1;
+
 	switch (whence) {
 	case SEEK_CUR:
 		p = handle->pointer + offset;
-- 
2.49.0

