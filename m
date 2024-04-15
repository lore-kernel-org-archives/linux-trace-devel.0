Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE87BAF9
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2024 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713196168; cv=none; b=aUwCj3TQhrc1hD01ZXIf49LJvOUEqloonRMFPryF4Mn4rCgPFV4Gv54C1CmG+MbchAjmJTR4nR+wtEfyTo1hJSRVgwAs6l2DpgdsgQ95cJTQ5FT+bPjyD8fa1GGRSElXxsR31C+wmsGCeOJlinUhBFlmhKlPYcVJhEUyN9ClLH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713196168; c=relaxed/simple;
	bh=aYMeADaHqtF7cQlTnjNayz3qOu5UZ9VcmTHE/5bJul8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlrzom+oPP54ybWAOBbaLZawCvK0WiOASsS9s2dp/3sRQyf51eCeq+LezBEwQdjiz6JFZBjQ1z+z2DgdE7+4i4foPLiRBGzr4kRuSrOdtrdV5H5S2fnLfUtHDIPFEVpkMkp4hfiva+ePLUbtHN8PSjjKYoinuzYS2BYmYlOqkBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AYS9WJNI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AYS9WJNI"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43FDY0er021416;
	Mon, 15 Apr 2024 15:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=EMIlTyagNVLqIwhhkjWf+g8EV4D2FabvY/XA3t0d0gw=;
 b=AYS9WJNI3k8Z3KC4kUPX8n25MZ7PWFjt5/JP+A9K8pSa/38wi/S/wsa0RSoYFkECZ3yn
 q4h1p7ZBqVN/shAT+scjkBoAjTTnJ8xBYE2ZahvkxlGO5fLbfgBtg4CJQ42gMVWH3WQ5
 EYXkypa1VGCxC5FO9uLJ9mb8hUqUpKHZhrZ8JEFB78W0amq95CYDZFJ+WMxA7lTAp5tJ
 mjaAXkwQ9iDo3rsMQREuZM/1M2x+DtZJ7Wbq6SG79QFBhabljpRvfQUQYkznQdstppcF
 4QawUlWQnyeB+IGi/Vy6qaiWJvsG99BOInyJ4AujQjwziNcbiZCBoVFjP6NPL9tts3Hu cA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfj3e35tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43FF0npV012555;
	Mon, 15 Apr 2024 15:49:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xgkwdu249-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FFnMuT028510;
	Mon, 15 Apr 2024 15:49:23 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-136-194.vpn.oracle.com [10.65.136.194])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xgkwdu238-2;
	Mon, 15 Apr 2024 15:49:23 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH 1/2] trace-cmd ftrace: print function retval in function_graph
Date: Mon, 15 Apr 2024 08:49:20 -0700
Message-ID: <20240415154921.4998-2-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_12,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404150103
X-Proofpoint-GUID: fNVWJAdlalrZd1u3p7-DNkikaCswzu1t
X-Proofpoint-ORIG-GUID: fNVWJAdlalrZd1u3p7-DNkikaCswzu1t

The upstream Linux kernel has introduced a new feature, i.e.
funcgraph-retval for the function_graph tracer. (Commit ID:
a1be9ccc57f07d54278be34eed6bd679bc941c97). With this feature, the
function_graph tracer can record each function's return value along
with its execution time at the function_graph exit handler. This is
useful for debugging kernel issues, such as syscall errors.

This commit enhances 'trace-cmd report' by supporting the
function_graph retval feature if the underlying kernel supports it.
Once the feature is supported, 'trace-cmd report' will print each
function's return value in this format: '(ret=retval)" at the end
of every funcgraph leaf entry and exit event.

Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
---
 lib/trace-cmd/trace-ftrace.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 89e46c3d..cb05d88c 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -185,6 +185,8 @@ print_graph_entry_leaf(struct trace_seq *s,
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	unsigned long long val;
+	unsigned long long retval;
+	bool fgraph_retval_supported = true;
 	const char *func;
 	int ret;
 	int i;
@@ -195,6 +197,13 @@ print_graph_entry_leaf(struct trace_seq *s,
 	if (tep_get_field_val(s, finfo->fgraph_ret_event, "calltime", ret_rec, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
+	if (!tep_find_field(finfo->fgraph_ret_event, "retval"))
+		fgraph_retval_supported = false;
+	else {
+		if (tep_get_field_val(s, finfo->fgraph_ret_event, "retval", ret_rec, &retval, 1))
+			return trace_seq_putc(s, '!');
+	}
+
 	duration = rettime - calltime;
 
 	/* Overhead */
@@ -222,6 +231,10 @@ print_graph_entry_leaf(struct trace_seq *s,
 	if (ret && fgraph_depth->set)
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
+	/* Return Value */
+	if (ret && fgraph_retval_supported)
+		ret = trace_seq_printf(s, " (ret=%lld)", retval);
+
 	return ret;
 }
 
@@ -316,6 +329,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	unsigned long long duration, depth;
 	unsigned long long val;
 	const char *func;
+	unsigned long long retval;
+	bool fgraph_retval_supported = true;
 	int i;
 
 	ret_event_check(finfo, event->tep);
@@ -326,6 +341,13 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "calltime", record, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
+	if (!tep_find_field(event, "retval"))
+		fgraph_retval_supported = false;
+	else {
+		if (tep_get_field_val(s, event, "retval", record, &retval, 1))
+			return trace_seq_putc(s, '!');
+	}
+
 	duration = rettime - calltime;
 
 	/* Overhead */
@@ -355,6 +377,10 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (fgraph_depth->set)
 		trace_seq_printf(s, " (%lld)", depth);
 
+	/* Return Value */
+	if (fgraph_retval_supported)
+		trace_seq_printf(s, " (ret=%lld)", retval);
+
 	return 0;
 }
 
-- 
2.42.1

