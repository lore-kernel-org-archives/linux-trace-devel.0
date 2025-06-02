Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE10D19F48D
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jun 2025 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748900525; cv=none; b=LdqNSipyl37g8PZWV2BTfFxVXUURhTFwSJ0WUtZJ+DjwfGnoa1ArrIqN3izsXulxuaaJaBp5UL1+crQFPFHpGVgo08T94Xo8HN8UulHfw39n7Yua61zo/TLQlLB+T69e+EdJB+b8b1CBo2Jc2KFXPrcOWVSBEiHmPMXmGgZ6j+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748900525; c=relaxed/simple;
	bh=U4DyZiEv6HAwkJJACkIjYpqedZWMt1pehB6tSl2tCx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GqiO4cjgOMITEahv+jxo7yEOAHUd9hFaOPEdOp4esGQngNPzQvrkVPAmxV9pLe/e3HUMNl6ZEyplOqLi0R/E3t7J2jaVpEWkRxro7wWdp8w5mrwHRKzUXreWFhga01WNPP0UfBT+uHgegA1PISB4TFiamsDDeKjyedMDhSZ3Cik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JA4uBH90; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JA4uBH90"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552I3FwC027571;
	Mon, 2 Jun 2025 21:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=sTfcWlRT34cr+NHdirbeM6xqESmbM9bvjZfeu0moN
	Ds=; b=JA4uBH90aEVFChWxIVvTSCsLBERJlcXBW6zfSrGPFfBPZvTGL/nQlB/vQ
	EvhGRGMcpLzxDqABtgBaJqqQQqMvVVNwH9P/D7ClcATyFsj274C7SqZzTg+RC5Bm
	ljQcArgIcHzzU+KuLekkPP7cbVyIIjf0PUa850qrYDtb7ofm27bG0/wc4cat4aVb
	9LkMBCKcFyUOevQ8ErpDfrGhzIGvkHTIzf88DLfwV7qy28ZBGohvnhzlOGrbiQyt
	B8wuxe7jQqOtk91PMujEwj29/qXGYkNQYnF9tkYFpFASbjrAl8CDsjFeHlaz3E1D
	kubcED+Iyg/mVXP6e5DuS2IGXJaHw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gw1rsny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 552JMSsN028442;
	Mon, 2 Jun 2025 21:42:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 470eak7r0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552Lfv3o57540954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 21:41:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05B6820043;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A309520040;
	Mon,  2 Jun 2025 21:41:56 +0000 (GMT)
Received: from heavy.ibmuc.com (unknown [9.87.156.82])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 21:41:56 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 0/2] libtracecmd: Support changing /proc/kallsyms
Date: Mon,  2 Jun 2025 22:38:31 +0100
Message-ID: <20250602214154.446881-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE3OCBTYWx0ZWRfX2E0JfqqOa6rU +YuvUg6U31CHr3VR2GehTm3UOL/BaWAIXmwxgqctNH/XRH20U0pdAK2mQmhv/OwV6UD2/IiyiFx AQo1U1Llw76aYFxLswVs1fZgA3zU+X3ZcNQr5r0WIX9QKO1XIEahLa3xvY4HNBspeDROOW7clk0
 dOThmOdyEYIYxr1HH3znIMLa4P/y36sYOxFMY7nwBDQ8PA0cmNppXuXoD7eKcKZmhNh6ySzCkb+ TOfw3wv+YeHHf/+K0NlkZ7atTvNCzX/r8TLJyIgHT10RNw9heY5LbXtRAaSZBHtflNm+++VVZww MNGwOpY8/NMtISs69syX7pt/Ofxb8QZlKmIvFzp4w8T+LCV39/PSzC1pluXgxGVVBCmU5I5YRDL
 W+t4ClPv/R80I1FTXn4sECAFAtDIYuRBJzHKlnrYievO8lJ/zpOncI5pMbI2N4eOk4KZ19hh
X-Proofpoint-ORIG-GUID: BB_17PZOuJGqHh3DBRdJaiKIPiISI0b0
X-Authority-Analysis: v=2.4 cv=HcIUTjE8 c=1 sm=1 tr=0 ts=683e1aa9 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=gYqNpyX8Y4BRQe2u7a0A:9
X-Proofpoint-GUID: BB_17PZOuJGqHh3DBRdJaiKIPiISI0b0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_08,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=821 suspectscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506020178

v1: https://lore.kernel.org/linux-trace-devel/20250416231325.14113-1-iii@linux.ibm.com/
v1 -> v2: Rewrite the size instead of reading the file twice (Steven).
          Turns out exposing do_lseek() is not necessary, since
          everything is in the same C file.

Hi,

this series fixes tracing in presence of frequent BPF or kernel module
loads/unloads. Patch 1 is a small required improvement; patch 2 is the
actual implementation.

Best regards,
Ilya

Ilya Leoshkevich (2):
  libtracecmd: Support querying position within a new compressed block
  libtracecmd: Support changing /proc/kallsyms

 lib/trace-cmd/trace-compress.c |  5 ++++-
 lib/trace-cmd/trace-output.c   | 26 +++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.49.0

