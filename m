Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C679D1494D6
	for <linux-trace-devel@vger.kernel.org>; Tue, 21 May 2024 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716327457; cv=none; b=btJxsxval34IK8iulVvecxyLRoFJIMhA0zDfpgNe8DFV+XCipbgFVUslukmSzJakTbofRFrPa3ov7VwtF2zlcpYhWawLP1fZrdNT9UvxUu/U5UpJAlWVCO0R6/bBKj64a01SqbXNwgaEb7+bAQD2vjX4A30JXMGqJaY7IMy0hA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716327457; c=relaxed/simple;
	bh=hckkZIIzc5rkxLSG4IQe/dK+J7YeXB59wS6HpV8ecz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKA7/Kkl5X9bKI0XclE5pAym2V6qvzf6NDWKquPeSmJNB9OSJYD946YuKlqJvM2Y6Z8fyZIoY86IdeVG3rd6Ygobt8nxCn0nT9I0bK5sDZB+zqoWLW3FrZzYHbVRG+U/4kWZ3p2s6TQHdEe/uvHovghi+Xm749yZWU9/fEURtL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PddXzE0v; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PddXzE0v"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LJi8WR025711;
	Tue, 21 May 2024 21:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=sCk92XT4O3nGF18oiA4Vr3z08Ea9MsQx0uZyzHl4nwE=;
 b=PddXzE0vWv0L5DR/1grGI/G5FaI95ZNm0i9PeLYTQgeNJ/exjeMTsIIlSGU+kgq2d0mt
 wJ85/JOnfdw+fFT7XHX5nYDXqsnPYNTT/1y3DNayXgGYaVd18huR6Ilgzub5tsK3wncM
 qzX5SIM8BthI9h3T0re8B1xTq8lxW6MzxQPVAcs7tSeKK35JCZjPtu4ndZ8JqYDQbMtw
 CJkiJMRRwQnCcOfFYG5ZKsUsmmJVw4mMf53sKJ5tjMKScBZUB3k/fYypM3o7AJLimwtB
 H7Ak4zX0HUevQtkHCTvesxRV9UvVNLePE0HGuh6UlVDInNMX0pb9BH5pK2U2AAWg7AtU Dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k466g0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44LKb9Q8035996;
	Tue, 21 May 2024 21:37:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js8bk6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LLbVQj013284;
	Tue, 21 May 2024 21:37:32 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-159-157-201.vpn.oracle.com [10.159.157.201])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js8bk65-2;
	Tue, 21 May 2024 21:37:31 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH v2 1/2] trace-cmd ftrace: print function retval in function_graph
Date: Tue, 21 May 2024 14:37:29 -0700
Message-ID: <20240521213730.67993-2-jianfeng.w.wang@oracle.com>
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
X-Proofpoint-ORIG-GUID: et0RqIBhvwJ4TADbZEx4G0mk7rGviMzD
X-Proofpoint-GUID: et0RqIBhvwJ4TADbZEx4G0mk7rGviMzD

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
index 89e46c3d..2b4e49a5 100644
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
 
+	if (!tep_find_field(finfo->fgraph_ret_event, "retval"))
+		fgraph_retval_supported = false;
+	else {
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
 
+	if (!tep_find_field(event, "retval"))
+		fgraph_retval_supported = false;
+	else {
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

