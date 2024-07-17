Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9555C45013
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 23:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721258231; cv=none; b=KK2A0MbycB/8iAv9W29tDhY4I/IVpDUVpVHZ4xfLBbct1BKSmNK4eUzCL4C8qMhJXpyTsKN2XwvdWLQdxg0gau3Q8XOYoXM2CBslmEkSxctvro+ZHOkTooAFcvjj7vjYppxiSnocJNNsh3w7IK0MgTgWq9rVN/0gKJUzaHSBvVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721258231; c=relaxed/simple;
	bh=mHPdD5kSzKl59xGiRNxzvwOOw/plFbGx7YpHbENbFlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z2v5FrcP1eZMDsULB+VWk+GTXcu3lbwuy8e4JJK9bge5Qlxzhsl7YN/X9BuShVWUa7FVMp9hkxh6qyeK7Z1UUWlKbho++mrFMso/N3OjZrxQl1wH3HgWJ00SOxoWo/qq9yWoWl+kg8fEthROApjhOD/UcMmuZlI0iPHo8b/gWbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dyVp7fHt; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dyVp7fHt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46HN66Hk014680;
	Wed, 17 Jul 2024 23:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=corp-2023-11-20; bh=boeaVyIBwmj//o
	CHhJi6txp0b0RmUcye5sHpo5FWdf4=; b=dyVp7fHtwK4R3B9mYQXQw9by4zE6xC
	mFQwxcR6pyQNTm2a/kLxf49fufvjov1pz9gBSXfD01rlVA4Qirb/FHQxbDXp/37m
	ifiGdqeF7hSOSGOJVpRwQ3Hu4zS11QwaQvT+SRthPk0ZmkqwkGkhiOiYt1QB0rjm
	iB9J3uhomIOBbmrfbgs2QJS77GvbtqcjW19EnCKfq6ABjjN2Be4zGsmLzALH5DwO
	L/qsBKr1L/xFxNhXj9hMl6ZKvHPOmObPDGXxlE8SeifsVUUy63w+ISbMnkSUH+Uq
	tpSLLs8tqhgzN4GseVyeWNY44WaAAyDkJQv5Bo/UzTEIbajAD41bl4fQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40eqapg0gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46HMp4ok006695;
	Wed, 17 Jul 2024 23:17:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40dwey710v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jul 2024 23:17:05 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46HNH4Lk013450;
	Wed, 17 Jul 2024 23:17:04 GMT
Received: from jfwang-mac.us.oracle.com (dhcp-10-65-155-38.vpn.oracle.com [10.65.155.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40dwey7105-1;
	Wed, 17 Jul 2024 23:17:04 +0000
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, jianfeng.w.wang@oracle.com
Subject: [PATCH v3 0/2] trace-cmd report: support function retval in function_graph
Date: Wed, 17 Jul 2024 16:17:01 -0700
Message-ID: <20240717231703.46744-1-jianfeng.w.wang@oracle.com>
X-Mailer: git-send-email 2.42.1
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
X-Proofpoint-ORIG-GUID: a-ct_m4dc5b49PoP5dSIWtegp1Bz3qa7
X-Proofpoint-GUID: a-ct_m4dc5b49PoP5dSIWtegp1Bz3qa7

The upstream Linux kernel has introduced a funcgraph retval feature
for the function_graph tracer. (Commit ID:
a1be9ccc57f07d54278be34eed6bd679bc941c97). This patchset is to utilize
this feature to support printing each function's return value in
'trace-cmd report'. Add three fgraph options so that users can skip
the printing, and force the return values to be printed in decimal
or in hex format.

Change history:
===============
v3:
- Fix code format.
- Add fgraph:retval-dec option.

v2:
- Check if a retval is an error code: if not, print it in hex.
- Make this retval feature on by default.
- Add fgraph:retval-skip and fgraph:retval-hex options.

v1: https://lore.kernel.org/linux-trace-devel/20240415154921.4998-1-jianfeng.w.wang@oracle.com

Jianfeng Wang (2):
  trace-cmd report: Print function retval in function_graph
  trace-cmd report: Add options for the fgraph retval feature

 lib/trace-cmd/trace-ftrace.c | 72 ++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

-- 
2.42.1

