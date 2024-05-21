Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC49148821
	for <linux-trace-devel@vger.kernel.org>; Tue, 21 May 2024 21:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716327458; cv=none; b=kjkPp1gx3wBqkbgjeL3IU9M32MMRJuQdnjCDdmJ3VQ/c++1+9rtA26rdHy2lbEOxM/P8WKdNn6sF+krzHt0ufNN9YjtDbyrMzjbNwjjVC0VATrOsyff3e6hcqgoktc0Ewx2GGBGGcODi43LswCVWrsxjuwbcukDv/5wYLMwRURI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716327458; c=relaxed/simple;
	bh=+3rp3Q2+gEr+jFFbZ3SQPf+vhKkp30a9YngYpY0Vn9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kctHxDDj7rGWZZaU+uSNL54jghq4rXS8ErX1dgIS8tu0SLbb+zXgeZsZVAYLgzrdzQQHNubNwM+ONed7mO6e6RzH7m5RLD7BMZNoG6nofynNE2gIuk10uRSlEheWKB1JMDzYHisWsb8gekQ9JpE7el3tKvSAS/fRwIdqiBMxcHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oia63TZO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oia63TZO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LJi11U003867;
	Tue, 21 May 2024 21:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=R+ZmuZinOiWRre7vZ+5rp4KEH+ByJwGu913I7q/wncQ=;
 b=oia63TZOiqoFRyyccVONRQ7RQUwgf98tCkNhONX069gz8AN6e8wyEq5Vp+0Y5P+KvLT9
 1GGc702OvylypC2DVEv98LwqJzNkthc04t+kSwpvJneWgul850f6etjeoy2DV8JMrRpT
 2VD0bGcJ7rHuZ/0cpPnifvUInpN5iiEguqmK3JzVX4VlzVuCEyzi/8wFlx8hFNqwxvBm
 hneR7DsPcC6U3IlFkht6lpamD8oyderh5fa6jClFwrrydluupxFTgW6CDMStSipEphBg
 NXficLh/ws0TpHyEGlOVckFZRYibJXUjdD2SQhbb93Jf9bi1gvyJrOIkHEzEbZmyPfoY JQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jrepc3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44LK1DSk036053;
	Tue, 21 May 2024 21:37:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js8bk76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LLbVQl013284;
	Tue, 21 May 2024 21:37:32 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-159-157-201.vpn.oracle.com [10.159.157.201])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js8bk65-3;
	Tue, 21 May 2024 21:37:32 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH v2 2/2] trace-cmd: Add ftrace options for the fgraph retval feature
Date: Tue, 21 May 2024 14:37:30 -0700
Message-ID: <20240521213730.67993-3-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
References: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_12,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405210163
X-Proofpoint-GUID: EcHkRT9ssworg0pfwTnwptbXv9yAd81f
X-Proofpoint-ORIG-GUID: EcHkRT9ssworg0pfwTnwptbXv9yAd81f

Add two internal options for fgraph: fgraph:retval-skip and
fgraph:retval-hex. By default, trace-cmd will print each function's
return value at the function_graph exit point, if the kernel supports
the fgraph-retval feature. If users want to skip the output of
functions' return values, then set fgraph:retval-skip. Alternatively,
users can set fgraph:retval-hex to force the return values to be
printed in hex format.

Here are example commands:
> trace-cmd report -O fgraph:retval-skip
> trace-cmd report -O fgraph:retval-hex

Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
---
 lib/trace-cmd/trace-ftrace.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 2b4e49a5..d2378833 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -26,6 +26,18 @@ struct tep_plugin_option trace_ftrace_options[] = {
 		.description =
 		"Show the depth of each entry",
 	},
+	{
+		.name = "retval-skip",
+		.plugin_alias = "fgraph",
+		.description =
+		"Skip printing function retval in function graph",
+	},
+	{
+		.name = "retval-hex",
+		.plugin_alias = "fgraph",
+		.description =
+		"Print function retval in hex at function exit in function graph",
+	},
 	{
 		.name = NULL,
 	}
@@ -33,6 +45,8 @@ struct tep_plugin_option trace_ftrace_options[] = {
 
 static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
 static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
+static struct tep_plugin_option *fgraph_retval_skip = &trace_ftrace_options[2];
+static struct tep_plugin_option *fgraph_retval_hex = &trace_ftrace_options[3];
 
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
 {
@@ -235,8 +249,8 @@ print_graph_entry_leaf(struct trace_seq *s,
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (ret && fgraph_retval_supported) {
-		if (!IS_LINUX_ERR_VALUE(retval))
+	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
+		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
 			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
 		else
 			ret = trace_seq_printf(s, " (ret=%lld)", retval);
@@ -385,8 +399,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 		trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (fgraph_retval_supported) {
-		if (!IS_LINUX_ERR_VALUE(retval))
+	if (fgraph_retval_supported && !fgraph_retval_skip->set) {
+		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
 			trace_seq_printf(s, " (ret=0x%llx)", retval);
 		else
 			trace_seq_printf(s, " (ret=%lld)", retval);
-- 
2.42.1

