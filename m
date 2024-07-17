Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551A79D2
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 23:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721258235; cv=none; b=fjkWWf9cs3oNEkiqW9zhuynb+opm6GMBWRO8CurwAr/6O83VOW9PmvfZ65D8x5AH4CGmOs7CdpOPMHQCI7V/KPiSunyEied41NV0d0dQBc8G1+aRIqJT2o9XoI19xMPElPbCdhkxQ/hlLr/A3eDO2KlnceOd1KGwgyb6boHH4Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721258235; c=relaxed/simple;
	bh=JnuXOgcAkyWzItthMXPHVh3tEgyp2ZZ7lSSNOuOUggA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/5+cEwCIF8ARYCPWO/gevkS603aYGhyMerCaQbNMyI0wcvrmBQsa45m7NMJkBEWUneOcgu7116S8EGKZ0zNvkHXb6xCErlm+d2B33O5TMnv1cFC+jtzV1c5I1ngSfn08glef1xSoG46b1frsRy/zBVHaFyoC3gBNjybnt7PJCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RIh4e11K; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIh4e11K"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HNBic2015786;
	Wed, 17 Jul 2024 23:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=corp-2023-11-20; bh=T
	+jpQEHKxAFAXG5RIqUKP1iyMcMS0x6CMgZCL6zZaCw=; b=RIh4e11KNE+sqXNhT
	rtGLu/owx7Rp/4x+F3WnwIHeQPSZQ4udxu4QzCJ91Kyt5jwiMEghJi0IJxGVVrF9
	6Ie8dyhC6rwlbLaUiTVLvSuYmTNY8ll8cF5a/v0tavEZM80Iahet0pSfO/nPM7/S
	5kPC4Kq+3HgJwfS9DysHrkXN/bwkIxOl1xun4aNodKGwYKvgu3PE3XtPB6cawt8K
	uXwqDGxi3hkoGSB4lzN18YIBQ2hWxVbgsiyxAAap7VesYbGO/cRZyJBiBF3KRH7O
	DxIZ7WGasDHu6vrD6m0HqWUaHuhFwhlTGKFV5rWfWDM+dC0pxefimR6kp3Nl6TtX
	UYSKA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40eqd1g06d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46HLA43Q006877;
	Wed, 17 Jul 2024 23:17:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40dwey7117-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:05 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46HNH4Lm013450;
	Wed, 17 Jul 2024 23:17:05 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-155-38.vpn.oracle.com [10.65.155.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40dwey7105-2;
	Wed, 17 Jul 2024 23:17:05 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH v3 1/2] trace-cmd report: Print function retval in function_graph
Date: Wed, 17 Jul 2024 16:17:02 -0700
Message-ID: <20240717231703.46744-2-jianfeng.w.wang@oracle.com>
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
X-Proofpoint-GUID: FdDcVGsBUPS9mxXrQ9TZ9iv5uheQpIux
X-Proofpoint-ORIG-GUID: FdDcVGsBUPS9mxXrQ9TZ9iv5uheQpIux

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
of every funcgraph leaf entry and exit event. Error codes are
printed in decimal, while others are printed in hex.

Example usage:
*  Record
> trace-cmd record -p function_graph -P <pid>

The recording process is not changed: trace-cmd can communicate
with the kernel to get the actual funcgraph_exit event format.
If the kernel supports ftrace-retval, trace-cmd will use the
updated event format that has "retval" field.

* Report
> trace-cmd report -O fgraph:depth -O fgraph:tailprint

If the kernel supports this feature, the output looks like this:

 <...>-1136215 [006] ..... 1724848.377495: funcgraph_entry:                   |        __cond_resched() { (3)
 <...>-1136215 [006] ..... 1724848.377495: funcgraph_entry:        0.200 us   |          rcu_all_qs(); (4) (ret=0x0)
 <...>-1136215 [006] ..... 1724848.377496: funcgraph_exit:         0.601 us   |        } /* __cond_resched */ (3) (ret=0x0)
 <...>-1136215 [006] ..... 1724848.377496: funcgraph_entry:        0.581 us   |        proc_reg_write(); (3) (ret=-5)
 <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:         5.059 us   |      } /* vfs_write */ (2) (ret=-5)
 <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:         6.332 us   |    } /* ksys_write */ (1) (ret=-5)
 <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:       + 18.414 us  |  } /* __x64_sys_write */ (0) (ret=-5)

Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
---
 lib/trace-cmd/trace-ftrace.c | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 89e46c3d..d2d1321a 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -10,6 +10,9 @@
 
 #include "trace-cmd-private.h"
 
+#define MAX_LINUX_ERRNO   4095
+#define IS_LINUX_ERR_VALUE(x) ((unsigned long long)(void *)(x) >= (unsigned long long)-MAX_LINUX_ERRNO)
+
 struct tep_plugin_option trace_ftrace_options[] = {
 	{
 		.name = "tailprint",
@@ -185,6 +188,8 @@ print_graph_entry_leaf(struct trace_seq *s,
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	unsigned long long val;
+	unsigned long long retval;
+	bool fgraph_retval_supported = true;
 	const char *func;
 	int ret;
 	int i;
@@ -195,6 +200,13 @@ print_graph_entry_leaf(struct trace_seq *s,
 	if (tep_get_field_val(s, finfo->fgraph_ret_event, "calltime", ret_rec, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
+	if (!tep_find_field(finfo->fgraph_ret_event, "retval")) {
+		fgraph_retval_supported = false;
+	} else {
+		if (tep_get_field_val(s, finfo->fgraph_ret_event, "retval", ret_rec, &retval, 1))
+			return trace_seq_putc(s, '!');
+	}
+
 	duration = rettime - calltime;
 
 	/* Overhead */
@@ -222,6 +234,14 @@ print_graph_entry_leaf(struct trace_seq *s,
 	if (ret && fgraph_depth->set)
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
+	/* Return Value */
+	if (ret && fgraph_retval_supported) {
+		if (!IS_LINUX_ERR_VALUE(retval))
+			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
+		else
+			ret = trace_seq_printf(s, " (ret=%lld)", retval);
+	}
+
 	return ret;
 }
 
@@ -316,6 +336,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	unsigned long long duration, depth;
 	unsigned long long val;
 	const char *func;
+	unsigned long long retval;
+	bool fgraph_retval_supported = true;
 	int i;
 
 	ret_event_check(finfo, event->tep);
@@ -326,6 +348,13 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "calltime", record, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
+	if (!tep_find_field(event, "retval")) {
+		fgraph_retval_supported = false;
+	} else {
+		if (tep_get_field_val(s, event, "retval", record, &retval, 1))
+			return trace_seq_putc(s, '!');
+	}
+
 	duration = rettime - calltime;
 
 	/* Overhead */
@@ -355,6 +384,14 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (fgraph_depth->set)
 		trace_seq_printf(s, " (%lld)", depth);
 
+	/* Return Value */
+	if (fgraph_retval_supported) {
+		if (!IS_LINUX_ERR_VALUE(retval))
+			trace_seq_printf(s, " (ret=0x%llx)", retval);
+		else
+			trace_seq_printf(s, " (ret=%lld)", retval);
+	}
+
 	return 0;
 }
 
-- 
2.42.1

