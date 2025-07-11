Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777562D373B
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240493; cv=none; b=MKbA8eZ6dA610nmqz87Qwgz+/cuN0NJvhN0e0nePdQecKcEhAd0uxsIaKSLQY2qo1LF0j8ffVtXz5d9WWl42sXmCncgcxi/kQaimfT6j/jVvDlNBLA22oh2CDBNCrUPNKmDRPNeteSYTdtY8rR2906bgYYXK9duQAjvs4C9HRgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240493; c=relaxed/simple;
	bh=NApgzwGTcBFsm/ntqNWGIFR0OPqyv0JHfY33FVMPGLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq4SiPx4MGdEeTxjf9mT8a7eDJB0t9ncU6tQlJrOEmhu7L3zUxVmUwWoZ+ei4FmvG8bhGJpgsrzQ0baf2okafnLRNoGtVWI0m/GLvwJpomzZq/fSvBn8skglspc92TldvRVbcGOh3ksuRV8IREZmNKN29IJdv5eQHdtpV71Pgdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OsSPwG0z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OsSPwG0z"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B8HtKt003481;
	Fri, 11 Jul 2025 13:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=p/CiNBxm13wWuEwj/
	4wB6sfTbD6yQBDRrFc3VUFYH7k=; b=OsSPwG0zJtr3M8E2dlRCwmlmGieMIHEIM
	8KLOQxGuY03oZnh+x1B7mVfWOoD8zolFIfEbd6Ud/g0HIgOG5GVnSzdIQ5SDygpH
	RIB55l+Cpc4qYYvbhI+9LF1mjIRFjhAwyonAm7pu1vwt3DosCMV5rMINL4I6wkeJ
	8htT5ynAUCNPShCJRcUlB9rg+YAt82b4/Gj70hWVh2hIr+07ThrTGqth1U0idaUb
	LfgdcEhKaqBpXPjqkXj0oVALwe6m1W8o5bM/DdGwTxLLxG+B7xjmLyaZj8Bze9D7
	ksBGLEblwruW2pFuPbjjcw7+kH9O2pazcw/65azYb6ry5tFLyd/hg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ptjrhyv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56BCrRqH013555;
	Fri, 11 Jul 2025 13:28:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qgkmapmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56BDS4hG50594156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 13:28:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB54E20043;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59F0D20040;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.111.24.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 1/2] libtracecmd: Support querying position within a new compressed block
Date: Fri, 11 Jul 2025 15:25:35 +0200
Message-ID: <20250711132802.1781-2-iii@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250711132802.1781-1-iii@linux.ibm.com>
References: <20250711132802.1781-1-iii@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=GL8IEvNK c=1 sm=1 tr=0 ts=68711169 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=ttnRCE21zARDvYvolyIA:9
X-Proofpoint-ORIG-GUID: kBQfcA-wf0zu1LgFWYatpkSC4X-78oFc
X-Proofpoint-GUID: kBQfcA-wf0zu1LgFWYatpkSC4X-78oFc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA5NCBTYWx0ZWRfX0GMHF8RCko02 AJG5CvaOctfNxzqe0jx/EO81kkDDOBTatH4AUBfxOs/W2GKuOVxTKLfoTvTFadL+e0p6S5NSy9m UZklzSjNnKU8bxuLKcFK3eo/CNdlz/2bWvjJVVp6hgypVpvkzBbvQC+m+/YL622plSPyKdfMlme
 b+fssR0ULwv53GY5KpqKWi6UdbxIDfoRquVXjXrA1GTiTXVonUrfetNY7m7iAjE8dfgPG1Swdmr Y4CGYDe7s4dlmOM0wcCQNbP3RYb5vM/U8/T3xzJw9oDuEis5e5pKKcyXZdf5kSr7ZcW4a/ai1th zUzmDC+oyGmTuYcTMjzkVjgnjtUh89B/ZK7uMdhjvyXOlxqLGhm9phc3sh/dvUGVnj/QM5Szajs
 53qK+bPLY+MZJRrdWo1poSq5hxZNortSPWB40c2ilOLjnIyybt3tpKQn4gWZE+vN4x03+LKj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=963
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110094

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
2.50.1

