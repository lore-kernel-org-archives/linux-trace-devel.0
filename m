Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237D14AEE9
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 23:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721258233; cv=none; b=qaXdBF9IREloGZGtfDd3GbOZCMNUibNT3R1YkiJ7O4EI66tiq5sEci9tI4MFXaD7mUnjZoLC0OItJJKdQnlUUaZ63g082gRdNLZ5Br6EM0T2Ocv97s4+0JpxLIwjRQkeWpsV0CvBHwXJ6bgPtq7E3FnK87Av0bfjHPHtzLr4OqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721258233; c=relaxed/simple;
	bh=0rEapHx9FBuvUqVv4AGp11m0+vS1UoOwDIbrU/SkZvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urZneexT3rSGKAW7y2ieVjeJcfIFIMvj/HEbYSyTqt5joLZnSTeTuhGmfUuI2Ad3pLeY6+HeTCMTpDtzyRwNc7ix3vxH54RXvUvDjZAyTwRFPg2sO0BTd8qhmwV7FtAIlCqiEOkt6mFv+DLX6YVCywYigBXlMtd/JFPMXRXCgZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=btREc6fL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="btREc6fL"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HNBWX1015025;
	Wed, 17 Jul 2024 23:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=+
	5HUEX6KhfN4nGr2bRTzL+0Qr8J/npclOG7FosrAoso=; b=btREc6fLAVtc3QY5W
	+uEJ1+U03HcStnyiNhCaybkDkfejr1XyLyaQW5D2c862fN2HLJO606CYPofwplVU
	t1kutqSwAglCf7J2FYocO6duAnuQaFfAEaDi+P77ecCSHqnLeRWe9dFlvLIKar6E
	N/oKykCo8+SVaeiV1q+EHynKtIFs7T/jwCd1w4Riklv0VroiuyrS9R8zJpRLxDDF
	Kz0UatYOFNY3GTa/8IuqItnAxgoKvze2XU9JhGxcI11b7Y0XMBwdKK/FgYKBFMeF
	YJMZC48Myf/OSuAVlNXLa+Vua7ERsUf/zrW9BzezG0kG5KvWU4HnxWEwHPb6N1p7
	sYi4A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40eqd1g06e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46HL6uoJ006706;
	Wed, 17 Jul 2024 23:17:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40dwey7120-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:06 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46HNH4Lo013450;
	Wed, 17 Jul 2024 23:17:06 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-155-38.vpn.oracle.com [10.65.155.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40dwey7105-3;
	Wed, 17 Jul 2024 23:17:06 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH v3 2/2] trace-cmd report: Add options for the fgraph retval feature
Date: Wed, 17 Jul 2024 16:17:03 -0700
Message-ID: <20240717231703.46744-3-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240717231703.46744-1-jianfeng.w.wang@oracle.com>
References: <20240717231703.46744-1-jianfeng.w.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-17_17,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407170176
X-Proofpoint-GUID: QGNdI_WAFTQCcAwZjzujFVVSWrbNdQs9
X-Proofpoint-ORIG-GUID: QGNdI_WAFTQCcAwZjzujFVVSWrbNdQs9

Add three internal options for fgraph: fgraph:retval-skip,
fgraph:retval-dec, and fgraph:retval-hex.

trace-cmd will print each function's return value at the
function_graph exit point if the kernel supports the fgraph-retval
feature. If users want to skip the output of return values, then
set fgraph:retval-skip. By default, return values are printed in
hex, while they are printed in decimal if they are error codes.
Users can set fgraph:retval-dec to force return values to be
printed in decimal, or set fgraph:retval-hex to force them to be
printed in hex. fgraph:retval-dec overwrites fgraph:retval-hex.

Here are example commands:
> trace-cmd report -O fgraph:retval-skip
> trace-cmd report -O fgraph:retval-dec
> trace-cmd report -O fgraph:retval-hex

Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
---
 lib/trace-cmd/trace-ftrace.c | 51 ++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index d2d1321a..d0e6a8e7 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -26,6 +26,24 @@ struct tep_plugin_option trace_ftrace_options[] = {
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
+		.name = "retval-dec",
+		.plugin_alias = "fgraph",
+		.description =
+		"Print function retval in decimal at function exit in function graph",
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
@@ -33,6 +51,9 @@ struct tep_plugin_option trace_ftrace_options[] = {
 
 static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
 static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
+static struct tep_plugin_option *fgraph_retval_skip = &trace_ftrace_options[2];
+static struct tep_plugin_option *fgraph_retval_dec = &trace_ftrace_options[3];
+static struct tep_plugin_option *fgraph_retval_hex = &trace_ftrace_options[4];
 
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
 {
@@ -235,11 +256,18 @@ print_graph_entry_leaf(struct trace_seq *s,
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (ret && fgraph_retval_supported) {
-		if (!IS_LINUX_ERR_VALUE(retval))
-			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
-		else
+	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
+		if (fgraph_retval_dec->set) {
 			ret = trace_seq_printf(s, " (ret=%lld)", retval);
+		} else if (fgraph_retval_hex->set) {
+			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
+		} else {
+			/* Error codes are in decimal; others are in hex */
+			if (!IS_LINUX_ERR_VALUE(retval))
+				ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
+			else
+				ret = trace_seq_printf(s, " (ret=%lld)", retval);
+		}
 	}
 
 	return ret;
@@ -385,11 +413,18 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 		trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (fgraph_retval_supported) {
-		if (!IS_LINUX_ERR_VALUE(retval))
-			trace_seq_printf(s, " (ret=0x%llx)", retval);
-		else
+	if (fgraph_retval_supported && !fgraph_retval_skip->set) {
+		if (fgraph_retval_dec->set) {
 			trace_seq_printf(s, " (ret=%lld)", retval);
+		} else if (fgraph_retval_hex->set) {
+			trace_seq_printf(s, " (ret=0x%llx)", retval);
+		} else {
+			/* Error codes are in decimal; others are in hex */
+			if (!IS_LINUX_ERR_VALUE(retval))
+				trace_seq_printf(s, " (ret=0x%llx)", retval);
+			else
+				trace_seq_printf(s, " (ret=%lld)", retval);
+		}
 	}
 
 	return 0;
-- 
2.42.1

