Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF729DB86
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 22:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744412222; cv=none; b=I/LoB9o3U/x7r9/P17Yh06r5zZYurfUA61oCuk6JLf8lUA6ozt0Wk5HGtEHjPNmaYOQYl4upM4Z+eAfSpDPnFYSuFqjvnMrIPER2OKIOVX0pSGGubfrIEJdueMVBPGZ0WZBHPBmAqTxlIkSk3up/MnU1LMqP/nXwG9xU7+A0gQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744412222; c=relaxed/simple;
	bh=mK82acV1yUV2EjDEpfOuCnm5EyaipI+Kw5iUneAU+mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4z2Chg6PBJA0GcqbEhlNl5KL4h9BZ21+32jwICLb9xew4AoWwJBfyki3HrkBkM3FOvKVc8HFhY4w/qNvAJUT1J6ICNJycRX2+s6Qkyg8trugfu/utNkO4kRNmuTlgEhCJZBTXDHcyYROJ6gsqef97JS8RNPyMilEvJ36LQ4fYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZX91fM9b; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZX91fM9b"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BII3ws022886;
	Fri, 11 Apr 2025 22:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KuFUL2eyw3deRiWix
	Is0N5lWfLlslEKd4DMjJ9jt2gA=; b=ZX91fM9bPbC0TlmPpyZnr8FRp2oQmUe+V
	+fybX3gOZqthXR+tN3zb3WzcIZ61ViIIqkvHmtsvNrevJEXqZhtcJ19vj3oGnGeD
	5milqI4O7J8wz73vQXfJ3mQ1FLmXKIgJzK5Dhhw6EnYg7mAZqtcUS/8CUPBz7uw6
	2ONH0fToNARWTX1+9heY7wRxhK7PqM7wdsJ3Nlhj8TApn0SOqTgcwKfq7uiL27PQ
	bqA2d8Vfs9p4/Y9JBIg6voWkeTy1Rj47Ey5k9p8qWdkI5HctPnYUn/ufNzjl7Pak
	aGZTa4PcaqHDes3dOXtI1j2DjcQrEMAopU4AlV4Ron1kA6YwsiXtQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45y78x1bvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53BLXf3s024610;
	Fri, 11 Apr 2025 22:56:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45ueutwdee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:57 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BMusnj26280492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 22:56:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27E5820040;
	Fri, 11 Apr 2025 22:56:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCA4420043;
	Fri, 11 Apr 2025 22:56:53 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.171.63.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 22:56:53 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 1/2] trace-cmd record: Fix compression on big-endian systems
Date: Sat, 12 Apr 2025 00:49:25 +0200
Message-ID: <20250411225648.6498-2-iii@linux.ibm.com>
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
X-Proofpoint-GUID: bB01VMusC0VP5NM3jUvgeSAGh2_iEs-p
X-Proofpoint-ORIG-GUID: bB01VMusC0VP5NM3jUvgeSAGh2_iEs-p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_09,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504110146

trace-cmd report prints nothing on s390x when compression is used.

The reason is that the code treats size_t pointers as int pointers when
serializing size_t values into 32-bit on-disk fields, which works only
on little-endian systems.

Fix serialization by copying size_t values into int values first.
While at it, add overflow checks.

Fixes: 176bc1f14419 ("trace-cmd record: Fix compression when files are greater than 2GB")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-compress.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 03215ad1..e18af3dd 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -7,6 +7,7 @@
 #include <sys/time.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <limits.h>
 #include <unistd.h>
 
 #include "trace-cmd-private.h"
@@ -77,6 +78,16 @@ static ssize_t  write_fd(int fd, const void *data, size_t size)
 	return tot;
 }
 
+static int read_size_val(struct tep_handle *tep, size_t size, int *endian4)
+{
+	if (size > UINT_MAX)
+		return -1;
+
+	*endian4 = size;
+	*endian4 = tep_read_number(tep, endian4, 4);
+	return 0;
+}
+
 static ssize_t  do_write(struct tracecmd_compression *handle,
 			  const void *data, size_t size)
 {
@@ -331,7 +342,8 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 		goto out;
 
 	/* Write uncompressed data size */
-	endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
+	if (read_size_val(handle->tep, handle->pointer, &endian4) < 0)
+		goto out;
 	ret = do_write(handle, &endian4, 4);
 	if (ret != 4) {
 		ret = -1;
@@ -735,13 +747,15 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 			}
 			size = ret;
 			/* Write compressed data size */
-			endian4 = tep_read_number(handle->tep, &size, 4);
+			if (read_size_val(handle->tep, size, &endian4) < 0)
+				break;
 			ret = write_fd(handle->fd, &endian4, 4);
 			if (ret != 4)
 				break;
 
 			/* Write uncompressed data size */
-			endian4 = tep_read_number(handle->tep, &all, 4);
+			if (read_size_val(handle->tep, all, &endian4) < 0)
+				break;
 			ret = write_fd(handle->fd, &endian4, 4);
 			if (ret != 4)
 				break;
@@ -763,9 +777,10 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 	if (lseek(handle->fd, offset, SEEK_SET) == (off_t)-1)
 		return -1;
 
-	endian4 = tep_read_number(handle->tep, &chunks, 4);
+	if (read_size_val(handle->tep, chunks, &endian4) < 0)
+		return -1;
 	/* write chunks count*/
-	write_fd(handle->fd, &chunks, 4);
+	write_fd(handle->fd, &endian4, 4);
 	end_offset = lseek(handle->fd, 0, SEEK_END);
 	if (end_offset == (off_t)-1)
 		return -1;
-- 
2.49.0

