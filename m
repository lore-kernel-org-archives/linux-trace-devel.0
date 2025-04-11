Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235C231A42
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744392507; cv=none; b=ml4VebENi1j1d5xwysiOqJy0anHMGNr9mGI0tgvmdri3roupXuJEAvO74gGWjI610MxJ0rB6DAbHu/3165HTEFyqMU+SR84pNRvsl0RekVOw4OIzdol3RxrFWjiMa1qEHKVskCfv7OrvM1zBm1pRvQc5UfT8OKqi5JVNYtTBvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744392507; c=relaxed/simple;
	bh=CZk4e7KDw22m7pwsoStsu41M3RbTzTJ81m0Von8kkgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y80nrQ6hdcEmxj0+VBaMyY4RQLgCNG3klA5oN0rofJj2M2ZN8Qr3xcHU1m0YVnifGTQp4iz57mMFsWeu8oWykbNRM5eMcy75ES3w/GkskTKI9LFaifPtQ8k/m74NHBabqR79jrKyBOOGwpW0qyEFlPPqoXUV5JHvm/tKOEr3TTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rZdZlPx1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rZdZlPx1"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BHBRsh006047;
	Fri, 11 Apr 2025 17:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=NsjtW70XpqjjshSFSHnQdPvaaRBrThRA2vJH8w+D8
	Ag=; b=rZdZlPx1DpiyQCI1uIcJ9rfZ8VF9yAwOVzHeP8WbEr9yTw9cC4tadKSPG
	rbmFM5FdsKyiipF0j6+Q+kyABFN1OMqH2YV4Pm1VuMVe5kO+otwAp9AqtyBmiEwR
	njqaYXm36k7OGeNYGxoISHR5EL0wt36sI96EQ9YTFjKF6gUBHDWWpUR2In4crBuk
	C2y8bpm3xcnCDWwbN0hFTefIQGYkrM3bXnTTWyxJsVF+5Gy8j8y8hdDD6RBaUfD/
	Op4nT0+GEQeHToA2Xez5HDoJwa+/IYeIizKjPeUx5Cczrjs7L+1RLa1s3bdEyGre
	olimjf87YhdX5ZnT9JTvYxMBMZKvg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45y78x02ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 17:28:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53BF758H017825;
	Fri, 11 Apr 2025 17:28:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45uh2m3u49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 17:28:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BHSIZ238338846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 17:28:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F87A20043;
	Fri, 11 Apr 2025 17:28:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3334E20040;
	Fri, 11 Apr 2025 17:28:18 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.171.71.74])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 17:28:18 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH] trace-cmd record: Fix compression on big-endian systems
Date: Fri, 11 Apr 2025 19:27:56 +0200
Message-ID: <20250411172815.61477-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x31V_jMUrL6cSl2hsaAuCkd8RUJzwyP_
X-Proofpoint-ORIG-GUID: x31V_jMUrL6cSl2hsaAuCkd8RUJzwyP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=939 suspectscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504110106

trace-cmd report prints nothing on s390x when compression is used.

The reason is that the code treats size_t pointers as int pointers when
serializing size_t values into 32-bit on-disk fields, which works only
on little-endian systems.

Fix serialization by copying size_t values into int values first.
While at it, add overflow checks.

Fixes: 176bc1f14419 ("trace-cmd record: Fix compression when files are greater than 2GB")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-compress.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 03215ad1..1b599043 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -7,6 +7,7 @@
 #include <sys/time.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <limits.h>
 #include <unistd.h>
 
 #include "trace-cmd-private.h"
@@ -331,7 +332,12 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 		goto out;
 
 	/* Write uncompressed data size */
-	endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
+	if (handle->pointer > UINT_MAX) {
+		ret = -1;
+		goto out;
+	}
+	endian4 = handle->pointer;
+	endian4 = tep_read_number(handle->tep, &endian4, 4);
 	ret = do_write(handle, &endian4, 4);
 	if (ret != 4) {
 		ret = -1;
@@ -735,13 +741,19 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 			}
 			size = ret;
 			/* Write compressed data size */
-			endian4 = tep_read_number(handle->tep, &size, 4);
+			if (size > UINT_MAX)
+				break;
+			endian4 = size;
+			endian4 = tep_read_number(handle->tep, &endian4, 4);
 			ret = write_fd(handle->fd, &endian4, 4);
 			if (ret != 4)
 				break;
 
 			/* Write uncompressed data size */
-			endian4 = tep_read_number(handle->tep, &all, 4);
+			if (all > UINT_MAX)
+				break;
+			endian4 = all;
+			endian4 = tep_read_number(handle->tep, &endian4, 4);
 			ret = write_fd(handle->fd, &endian4, 4);
 			if (ret != 4)
 				break;
@@ -763,9 +775,13 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 	if (lseek(handle->fd, offset, SEEK_SET) == (off_t)-1)
 		return -1;
 
-	endian4 = tep_read_number(handle->tep, &chunks, 4);
+	if (chunks > UINT_MAX)
+		return -1;
+	endian4 = chunks;
+	endian4 = tep_read_number(handle->tep, &endian4, 4);
 	/* write chunks count*/
-	write_fd(handle->fd, &chunks, 4);
+	if (write_fd(handle->fd, &endian4, 4) != 4)
+		return -1;
 	end_offset = lseek(handle->fd, 0, SEEK_END);
 	if (end_offset == (off_t)-1)
 		return -1;
-- 
2.49.0

