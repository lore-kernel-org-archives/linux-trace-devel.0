Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A175029414
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2024 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713196168; cv=none; b=u1zmT0duJm4MeOj2i6NwQINS1XyE7rSpz62EwRG2v/uDON68ISeJqQyjejPxlo7nIeYREoDFldEy92XbThaaHCBfXrxQkv8h9bARdL6vOE2qw6M2TpA3VOWIGTkYiEc4mUt7NIv0GhTsxNewGvkQf2BdRLH6qu7mHcgz/2l0TBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713196168; c=relaxed/simple;
	bh=R6ICAp9NHL7rJCpEuP7u1h5JlmUWMAcRn9Z98CFa74k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gtqyOKS93BL+cMCpJTWXl7WaGCyMPvZkX/9IERwWh9xJc2t1J5Zh04bIxSfQA+/LG+Wb1rEaEp6z/ZC3MDPbKi0MQKzWftZM+5Sk8BeB9ascri0yfy1HMXsudSfGQIPguT/Qp0FuAZeFSiQ5Qz+BvFmyC7vsY4CjwVtTBmKEH8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ik8U3XRw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ik8U3XRw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43FDY8vD006603;
	Mon, 15 Apr 2024 15:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=EBKRX3nWhaTSfnx9IQYYl0ecSQ1/i49tshvXS8Yw5kI=;
 b=ik8U3XRwAbd8YgRHbKHpx5iOOw5qBy/X6mYzZWpk+JfXJwaKcXn39+ZfAfZXa60lCQ18
 5iuC1Ik408tPg2Rj7y9YkV1BEYo6TCuGUcgIPLPkR32zkCihAXXYXffOgms8Cq0TyoVI
 6ojGnNxN2bgjCp2HTEQJGTfOA1O1hR9yYXCUkLKIJZkxVfad1mdVxAK4hGzlUSjX+/0M
 2gwe8+EzV78wzl9OqfduEXiQ+NKjUS9mqjymo4jm5RG/wmKi2zoquVnJstCgsdyY6lqF
 bbogQ8cc0wXLTWNUnWkyOdqYUN2mgyzlosUmeJEefP3R7f+7kCMbOoqw/be7qzeE3iEu MQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgffb5n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43FEpQxj012545;
	Mon, 15 Apr 2024 15:49:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xgkwdu23w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:49:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FFnMuR028510;
	Mon, 15 Apr 2024 15:49:22 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-136-194.vpn.oracle.com [10.65.136.194])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xgkwdu238-1;
	Mon, 15 Apr 2024 15:49:22 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH 0/2] trace-cmd ftrace: support function retval feature in function_graph
Date: Mon, 15 Apr 2024 08:49:19 -0700
Message-ID: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
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
X-Proofpoint-ORIG-GUID: ag8drr1nszgXYa58Cb1-yqMsPQ2hQirh
X-Proofpoint-GUID: ag8drr1nszgXYa58Cb1-yqMsPQ2hQirh

The upstream Linux kernel has introduced a funcgraph retval
feature for the function_graph tracer. (Commit ID:
a1be9ccc57f07d54278be34eed6bd679bc941c97). This feature can be
useful for debugging kernel problems, such as root cause
analysis for syscall errors.

This patch series is to utilize this feature to support
printing each function's return value in 'trace-cmd report'.
The default is off. Add a ftrace internal option so that
users can turn this feature on if they'd like to request for
the retval information in the function_graph tracer.

Jianfeng Wang (2):
  trace-cmd ftrace: print function retval in function_graph
  trace-cmd: Add ftrace options with fgraph retval option

 lib/trace-cmd/trace-ftrace.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

-- 
2.42.1

