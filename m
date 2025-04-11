Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB5278E4D
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744412221; cv=none; b=iIZ6o+yB1mgsktRwNlTR2xxxiq3DTgs9aph32qTiGAELG/SE5+4xWZsQEi8InGxucMko+Nwww7kyE6uFKb+SbjKes7GnRzpGw+6clh3yyNXCptSDtvhJqE69+WvdQzDWO9zmi1x0NtT9xkUYHa2tVrCHaPeS+Rep+DGgakkfHIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744412221; c=relaxed/simple;
	bh=RPWFSrFyeqmJJMPzaOEFhTip5+Kcy8Az1Bf8ZA2vtho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qmbn8wRmmL9mRbWpOCPJ+ERrkCjamC5a2fo1oR2dy9CdE3yYZLc72GTUL5Frsszgy4FKCq3rKqXrCt135aazPQWTHcZKUWUaM2toZK0MiG4wPCS+Uog9GbwEth+tzHR7Abn++TKhxStIq6aWes6NErXNLTSBQzQson9tgrmA0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bLt50aMN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bLt50aMN"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BII3fB022213;
	Fri, 11 Apr 2025 22:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=YmYiUmOi+KegmcZTV8z08FoHC6Ao9mHw7y2s0MdxE
	S4=; b=bLt50aMNi+qi5bXeF9SJv+lZc7Id9FlsGlwERhFcjHrXm7Trvfu3rGwya
	69cVUCTaTOI/pK7OKKM7H3xn7vIJVQh4qBMpdam0+fK2kslyFUFnKBAj66txGGzP
	JRpJpsAFGSddAGbpqjL90JpqVh7XoecpGqi6SrDp2UDX0W0D24azzvNVoa77LB1J
	hH3ukpQAzqP5nq/HJ9XshNHf+WR85V6PPDTNY0+nGu5ihnb8gIQ17ZAtyauttLco
	bhj+kJyjVNVjbuVPN0n+PIMLicphIyasmWEtCYjibGGzT1uGSaT4u8Q67EF0qDfF
	qmy6F3VlKuH9YvRIhORLev5ABKPCw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45y343tus8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53BIvdID018567;
	Fri, 11 Apr 2025 22:56:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45uh2m50u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 22:56:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BMuqRL50987290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 22:56:52 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0D5020043;
	Fri, 11 Apr 2025 22:56:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 699E420040;
	Fri, 11 Apr 2025 22:56:52 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.171.63.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 22:56:52 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 0/2] trace-cmd record: Fix compression on big-endian systems
Date: Sat, 12 Apr 2025 00:49:24 +0200
Message-ID: <20250411225648.6498-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kKXw9xPWBgjTBeTXSljzDTFLSwxP-ntT
X-Proofpoint-ORIG-GUID: kKXw9xPWBgjTBeTXSljzDTFLSwxP-ntT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_09,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=967
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504110146

v1: https://lore.kernel.org/linux-trace-devel/20250411172815.61477-1-iii@linux.ibm.com/
v1 -> v2: Factor out read_size_val(), split out the error handling
          change (Steven).

Hi,

While running trace-cmd on s390x, I ran into a few issues.
This is the fix for the first one: trace-cmd report prints nothing.

The second one is a kernel issue [1], which causes trace-cmd to print
a lot of bogus space characters.

The final one is "error in size of file '/proc/kallsyms'" caused by
delayed removal of a BPF program from /proc/kallsyms. I plan to fix it
by reading the contents of /proc/kallsyms into a temporary file before
writing it into the trace file.

[1] https://lore.kernel.org/lkml/20250411172207.61332-1-iii@linux.ibm.com/

Best regards,
Ilya

Ilya Leoshkevich (2):
  trace-cmd record: Fix compression on big-endian systems
  libtracecmd: Add missing error handling to trace-compress.c

 lib/trace-cmd/trace-compress.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

-- 
2.49.0

