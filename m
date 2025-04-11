Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E93278E4D
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744412223; cv=none; b=SWL6MUcx8y5S/CmAyBFvz5i4/RxdBxbwAKGExYIcdlRf+rKXfTSuC2rqqiNqeIxd0DXlI0VnS9CUPS4IFD3iDCLpjzTpm8Z2Z9wMTH0DfZSi1kqDiwFD5QlyJDYusLdAv5MIXoBmFUeQTCHtjd5MMEbf2OgwxCVyDAbwcbWFHAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744412223; c=relaxed/simple;
	bh=DVM/p0p5Y6psyMPXx2/MnNxXHG/ojjSn9/7iFZCtvK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsPpRvioee+gqNa4w2t92U764crkSeDxjf7riiiKcSjYiNZBuEZ4lgH2JWHoUOv4NTRm56ijD4r+bVbVHPxBT5JeGBLhIFNuP/jmubBaImwY8BGOy/HSB/R0tp13S3Djd0xFU0G3GNIM3oca6w19+e+PfdAUiFqdc8x4gszpdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=re6+cweu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="re6+cweu"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BII3fC022213;
	Fri, 11 Apr 2025 22:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2XuGa16XUl1vnvih7
	JjlzWeX4vVBivNtcGjfh8D4/Jk=; b=re6+cweumdFnGjtiXRHQ+Kmks6EzwzD94
	8HE5ttS4QdKFgakPsZDr7HmIRb1x9ZkCZHiIhmbeXp/KELTwDVOYfjfF93lDNEqr
	oMeKD7PecnagkAFFR3awdeo91h/G17lZu+EFPWAGJwm5zKjrTb5D2ix6Wzroijne
	1RCTJrtSk5U1dTJ3s93CXjRhvkkvWhgCNxXWRrbBEo+77GkDMAzAUK13me7Js2Z1
	7ZpFcKdumxPDiA2aJvIFR7IsIeIKmNzQ+OZSRA7vXBbBrhSYBMLv5vC5AqUbFfmf
	zNSfbP/fWvyvQ8PKLzaijbkqGBvyxzxJCzmX1y3QI7QpOSpUkIM6Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45y343tusb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53BL0JK6024600;
	Fri, 11 Apr 2025 22:56:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45ueutwdeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BMutGL54198606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 22:56:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48D2620040;
	Fri, 11 Apr 2025 22:56:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFCC920043;
	Fri, 11 Apr 2025 22:56:54 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.171.63.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 22:56:54 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 2/2] libtracecmd: Add missing error handling to trace-compress.c
Date: Sat, 12 Apr 2025 00:49:26 +0200
Message-ID: <20250411225648.6498-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250411225648.6498-1-iii@linux.ibm.com>
References: <20250411225648.6498-1-iii@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 69N75dMjSRHaupQqBxwqYlt7OUm2hCtw
X-Proofpoint-ORIG-GUID: 69N75dMjSRHaupQqBxwqYlt7OUm2hCtw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_09,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504110146

Add missing error handling to a few writes.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-compress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index e18af3dd..2a7a3e24 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -715,7 +715,8 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 
 	/* save the initial offset and write 0 as initial chunk count */
 	offset = lseek(handle->fd, 0, SEEK_CUR);
-	write_fd(handle->fd, &chunks, 4);
+	if (write_fd(handle->fd, &chunks, 4) != 4)
+		return -1;
 
 	do {
 		all = 0;
@@ -780,7 +781,8 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 	if (read_size_val(handle->tep, chunks, &endian4) < 0)
 		return -1;
 	/* write chunks count*/
-	write_fd(handle->fd, &endian4, 4);
+	if (write_fd(handle->fd, &endian4, 4) != 4)
+		return -1;
 	end_offset = lseek(handle->fd, 0, SEEK_END);
 	if (end_offset == (off_t)-1)
 		return -1;
@@ -989,7 +991,8 @@ int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
 		if (ret < 0)
 			break;
 
-		write_fd(fd, bytes_out, ret);
+		if (write_fd(fd, bytes_out, ret) != ret)
+			break;
 		wsize += ret;
 		chunks--;
 	}
-- 
2.49.0

