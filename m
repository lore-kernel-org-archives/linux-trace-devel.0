Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F87C085
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2024 15:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713196169; cv=none; b=uslhKVh7Clk3cZb9X8WCIBKwJaPNxr/xePcBrnfU7/epE/dpFzR/AyP2G/bXnOv0tkiyz9Uup+nufRye0ecN70dlF/Dw8rPSrQ4LBRdR4DWBDZqJZGeh9xr97EJCD81b7p5wODDC++/99zkT7O+EjUcs8MKdZP86BL18SChu5U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713196169; c=relaxed/simple;
	bh=hSM5xxAgj6TTJJCPzGO+6ImOEX5pMRKTDSZ0jDvUzg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbcGpstouYY7uAh2WHgIREQ6geNu79lcvdOjq8TAg0aA0Apd9cRj3Jdndynu8nKa0+II26i8sV3DJVpTRCOZs+rGTJcXj3v3Ad1l4vmZBhYnWxA4ZrbOpg7pb/PHj9wr+rfJlEbs2/FujthcE4xRA2kxZLzklIGeCunTf8BQ/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nQd9lFsB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nQd9lFsB"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43FDY4aH017766;
	Mon, 15 Apr 2024 15:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=8bTRRrq2eojbkx6CYA+oJEsfhL3eA+Q2DcOPO2NxFCY=;
 b=nQd9lFsB1e8DgnVW3o/4nWeLdNx5gnVf3BYPCw9wFsn+Vjn48lVUJoXmhLeOPsqoFgT1
 T2AdArnzi/b1yV/QSBd9OLzPjUuqUFPjXMj11um5m80WEG2IV0APOLXddlP17XDDPmBo
 f4eq5ow0vCQvRg3Z3UWtS0oxs6pcJpaVRaCieKiMfuWO0EFj9zdWXznyI80lBeRI5nPz
 Ipp78muq2btBvV7D6Hg7U1AHrBKx3ijrFrVTAb8tWOFja1rbnR7tk3BDR5k+olQVZlPD
 /1JQav5akUcxZ2xu+BVVlWUapVcHLX7Vn8qE1bNtUQsJ14WmGTiIYyeWwVTZtJWbltl/ Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfhnub5hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43FFcvf3012604;
	Mon, 15 Apr 2024 15:49:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xgkwdu24q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:24 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FFnMuV028510;
	Mon, 15 Apr 2024 15:49:24 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-136-194.vpn.oracle.com [10.65.136.194])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xgkwdu238-3;
	Mon, 15 Apr 2024 15:49:23 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval option
Date: Mon, 15 Apr 2024 08:49:21 -0700
Message-ID: <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
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
X-Proofpoint-GUID: cB67kbU6h9xqE298zPbwEpw8kaofLGg5
X-Proofpoint-ORIG-GUID: cB67kbU6h9xqE298zPbwEpw8kaofLGg5

Added internal options for ftrace, and included a fgraph:retval
option that will print the function names at the function exit.
When the option is set and the function_graph retval feature is
supported by the kernel, each function's return value will be
printed as '(ret=retval)'.

Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
---
 lib/trace-cmd/trace-ftrace.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index cb05d88c..fecc3d69 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -23,6 +23,12 @@ struct tep_plugin_option trace_ftrace_options[] = {
 		.description =
 		"Show the depth of each entry",
 	},
+	{
+		.name = "retval",
+		.plugin_alias = "fgraph",
+		.description =
+		"Print function retval at function exit in function graph",
+	},
 	{
 		.name = NULL,
 	}
@@ -30,6 +36,7 @@ struct tep_plugin_option trace_ftrace_options[] = {
 
 static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
 static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
+static struct tep_plugin_option *fgraph_retval = &trace_ftrace_options[2];
 
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
 {
@@ -232,7 +239,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 		ret = trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (ret && fgraph_retval_supported)
+	if (ret && fgraph_retval->set && fgraph_retval_supported)
 		ret = trace_seq_printf(s, " (ret=%lld)", retval);
 
 	return ret;
@@ -378,7 +385,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 		trace_seq_printf(s, " (%lld)", depth);
 
 	/* Return Value */
-	if (fgraph_retval_supported)
+	if (fgraph_retval->set && fgraph_retval_supported)
 		trace_seq_printf(s, " (ret=%lld)", retval);
 
 	return 0;
-- 
2.42.1

