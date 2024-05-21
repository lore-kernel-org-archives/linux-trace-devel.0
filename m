Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CE61494D0
	for <linux-trace-devel@vger.kernel.org>; Tue, 21 May 2024 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716327457; cv=none; b=OtPCaCMgJ1+eC+/PIXlkmjdLs2K4YvH5ZRXP8KQ6vDlBF3w+pY/x7H7f90+3997xDuHk5OuzN7rl/9hdkiStCkvS19xo9EtdGN7zU94OtQKus0oIRcwm32cOq6YiLL8mo9AwA+bLakzyw0aTyBXikvryKCZPmAuDrU5Y2rXqbcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716327457; c=relaxed/simple;
	bh=qzLA6LeoR3mRrRVr3IAGvhM6xx3eU+I0939x/nC5pqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qHBpQGc1LARuiZryI67fSoifdqSw0x7qAnmou0T2BsJ4F8tE02m7hpgWHaJFvKIawrNGPqKmIuTZwD48kcU21visMxIKvHsxPm1nDRkZxyBqLU/cl7lB42S6XWky1M7EGzjkFA/ivJH1fINT7TGlLVRBdzMYZdFfljPNXyV7MXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UrEmYOlW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UrEmYOlW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LJi33D011519;
	Tue, 21 May 2024 21:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=0oyivbd8NMRSJ67VU9i8PEjMe5PeclFdFaDVx2MKokU=;
 b=UrEmYOlW82f0t+JXdZ6QjMfkJbRbBawyjXhZREjJApo39Ze4Rvk4F43Zsrx6gXObySeN
 vgNkdqgFUIjhe/JvASvChYdpMuOoC1IQPJqjhz8JpnG4aU2eooCf2pTTYiU6jjcOXhi2
 vwRtbyyfh80+pA0mpsEQHfjb7Wzn2X/39LakKP97krM6tVi3V9/6rIMpBcu3UUcyUfOV
 29hn00pXtYNO7QldevsdbTMLxFxJZZP7ilZfRcL6v0YphO8uR7CbQzrKwfpdvodkA9im
 6G4YbpfaI6U4E5Yc0uhdBzSXgEAZ/96bX2+BX+GO+7ZQTiO9QPshXfO1bleskmOSc1Oq WQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mcdxfgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44LLP3pr036049;
	Tue, 21 May 2024 21:37:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js8bk6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 21:37:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LLbVQh013284;
	Tue, 21 May 2024 21:37:31 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-159-157-201.vpn.oracle.com [10.159.157.201])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js8bk65-1;
	Tue, 21 May 2024 21:37:31 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH v2 0/2] trace-cmd ftrace: support function retval feature in function_graph
Date: Tue, 21 May 2024 14:37:28 -0700
Message-ID: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
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
X-Proofpoint-ORIG-GUID: V0zL9hcekYzWWzBDPGpsCuohG6M6uUUy
X-Proofpoint-GUID: V0zL9hcekYzWWzBDPGpsCuohG6M6uUUy

The upstream Linux kernel has introduced a funcgraph retval feature
for the function_graph tracer. (Commit ID:
a1be9ccc57f07d54278be34eed6bd679bc941c97). This patchset is to utilize
this feature to support printing each function's return value in
'trace-cmd report'. Add two fgraph options so that users can skip
the printing or force the return values to be printed in hex.

Change history:
===============
v2:
- Check if a retval is an error code: if not, print it in hex.
- Make this retval feature on by default.
- Add fgraph:retval-skip and fgraph:retval-hex options.

v1: https://lore.kernel.org/linux-trace-devel/20240415154921.4998-1-jianfeng.w.wang@oracle.com


Jianfeng Wang (2):
  trace-cmd ftrace: print function retval in function_graph
  trace-cmd: Add ftrace options for the fgraph retval feature

 lib/trace-cmd/trace-ftrace.c | 51 ++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

-- 
2.42.1

