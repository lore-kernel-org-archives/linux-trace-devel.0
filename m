Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7112D373F
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240492; cv=none; b=DJOhT8ahOX6xksDdNahLtcaOS1QsnXK4RIDc5PRseaELJg2owFcdZzzzVGjoU5jO3Nx0h0TVDTIBmzNDa4YAcknDi8IH7+s0P/oO+gqVpFi/e5fzuu5v5R12jwssBY6mQgi1rs+R+LzhxmMWOn/RlPUdK1TQd4O2cNM0lUGKG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240492; c=relaxed/simple;
	bh=FkTLYy5VT7XUyzoRXHe8nVPZZDKMEKubdV930dJEkJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GVb9SLJYocC4dz+X+jz7VKR42LogKprx33JODnbJwS0iqBJvxcJolpz/bUbTUQCb7hDCDo6J9srNQUDLx6IEFr4d4E6ACPUojHmQi20fYRYJykKT3N3gMxR5auM6vFYl7EtaOyCq5bHY18UJX6UQcYDZIECeu9cbR2AZwMORTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eYekh6Ll; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eYekh6Ll"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7Go42029137;
	Fri, 11 Jul 2025 13:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=qB+jOVBTjKCoJeDR7NH7qIUdfnVScnFxv4NTL8m7o
	LI=; b=eYekh6LlQctODBQN9eJCj02t5omgL/+ne+ItNG/waakPaqWaoq3773B33
	dSPuGENyuiDj7Rzny0/dKKdzoYIS3xKDoE2FiSjz7hILyQJyx13FwJEXF/5lwhd5
	v2Y1coUWHv6ean3ijX7RrgJP6lY+SSxZL5vbIauJNgfJdBTxuptnTr8hdERQrSLu
	+uXta1k5l/wrGac+OkINv52LE9nZKar09KVgDd0ORD3AHGbfncXaZGR2Lrhh8aW1
	aw2rwiX35dRpA6UFMkvNRmL9wsepYNWk0XlrtKq1k3SqHQfzOrw7LOVXyMw7gegf
	XvphcEkzV2q/ciMsbyBpCVbFb/BJg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47puk4k2uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56BC0rmZ002860;
	Fri, 11 Jul 2025 13:28:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47qfvmtsmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56BDS4qd50594154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 13:28:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4650020043;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8FF520040;
	Fri, 11 Jul 2025 13:28:03 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.111.24.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Jul 2025 13:28:03 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 0/2] libtracecmd: Support changing /proc/kallsyms
Date: Fri, 11 Jul 2025 15:25:34 +0200
Message-ID: <20250711132802.1781-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA5NCBTYWx0ZWRfX1khtxSzyhOh2 GMacN3iY27E6eXiuaHz/XKjw5dxXXfovMHz0X09VAn8y9mYPWAmZzts8u7yGzf8ak5ZSFU8avJ2 FWGnKuU3PREQBY0qy+z97c86uAm9To8JhGcsUx7GwwDcpvkCeI3p9J5ZCr6g7Uv7SyfZZ8KVe5B
 v7ZjIoFZKAYxyNcpUYu8Qg8LGa+5ivQs1uC2IK302WNIuy1hAD6Ydd8ibxm0eeG9WZIJtXi3fIy +9Y23lnrnLomM44Lr9cuZQEGDArzC8KxkT9Rvw+Oujoi9XWPANsrh8IGRc6PxRZAbkMVziFeLS3 ox+sIB/AXLC0+Q25CharTvbLsahTnC38WmP31Zd0oq5OlR1d7nXzdmxB1MOCaDL0MsIsHtdY3z4
 OnGinNROlFsu11Z3Rq/UswVPl4aCLX5cEAwZwOCVI0SHcfjwD9zFHFkkf6MhSKteZ9vYN91K
X-Authority-Analysis: v=2.4 cv=XYeJzJ55 c=1 sm=1 tr=0 ts=68711169 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=9bfxzjHHuqZCDq64mLQA:9
X-Proofpoint-ORIG-GUID: ZQIL2ZQA-k1grL_LFmkNLxAXCOnYoggr
X-Proofpoint-GUID: ZQIL2ZQA-k1grL_LFmkNLxAXCOnYoggr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 mlxlogscore=829 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110094

v2: https://lore.kernel.org/linux-trace-devel/20250602214154.446881-1-iii@linux.ibm.com/
v2 -> v3: Add a comment and some newlines (Steven).

v1: https://lore.kernel.org/linux-trace-devel/20250416231325.14113-1-iii@linux.ibm.com/
v1 -> v2: Rewrite the size instead of reading the file twice (Steven).
          Turns out exposing do_lseek() is not necessary, since
          everything is in the same C file.

Hi,

this series fixes tracing in presence of frequent BPF or kernel module
loads/unloads. Patch 1 is a small required improvement; patch 2 is the
actual implementation.

The problem can be reproduced like this:

    # while true; do rmmod loop; modprobe loop; done &

    # while trace-cmd record -p function_graph /bin/true; do :; done
      plugin 'function_graph'
    libtracecmd: Invalid argument
      error in size of file '/proc/kallsyms'
    trace-cmd: Invalid argument
      Error creating output file

Best regards,
Ilya

Ilya Leoshkevich (2):
  libtracecmd: Support querying position within a new compressed block
  libtracecmd: Support changing /proc/kallsyms

 lib/trace-cmd/trace-compress.c |  5 ++++-
 lib/trace-cmd/trace-output.c   | 38 +++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

-- 
2.50.1

