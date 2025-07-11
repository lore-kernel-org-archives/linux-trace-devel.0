Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC852C17A8
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240493; cv=none; b=mp0XPeMMdwZf9wyi3mAeDCykA1GH/XZVYs3YomhTA4InKNcAp4do8mpENy6djXhTcJsntomPBYYRak4C4Uzgp/i7Q6ujdRsDL8QMRPHWs53etuDHvA1mYZjvJiGOdZUTYGx9XjOMCdmpoHm0g19zMkoXJ1bp11lHsXNaos5yQo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240493; c=relaxed/simple;
	bh=BCWnOFgT/Nz4dpsCBA8E+T2YSHGtJB/jlPuiM+h6ti8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXQjP8sGNg+2muWfgGg6v0TtxES/QB50YlrREVZrg053aWuK36vMdg4BxQ+VUpA3T4WosimsfQpmP4Xi+iPOWORK6EgTfix0mAB+fh/1zgXtWLrhn9C4XGrKCyG+Lzj734VYjMXaaBZsDhT1g8y8bP/d62YTXgWLdL/HyFTlGmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IxErw/tz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IxErw/tz"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BCKJa5000348;
	Fri, 11 Jul 2025 13:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Sfce3ZCBgNbrfac6g
	4h0BHkbJChZ4K5hQMrNhbFkSao=; b=IxErw/tzP9dR4KVsMTLGU6yVw1xABvnLS
	zA5KpR+nyg7qy1MbyCD88q4PZi2x09UUJQRLbIUNf7uCJu7shCPlltrYLQ9yTBd9
	v0LUKshUo97H4DqXUYe7cIhujKLv6Uz9ANDYR2CYH52zQUIyr5fRhL3cCgbmAhaX
	iSRZTBgMqwc0xOPB0epNI5fuznb0vIjz4zdtlKVUvq30ud/8QrP7Nks7lEv+Aj5P
	3/Ee2YYNH8Ja1tjrJ1F3GZyKo4Rv67PE9qaFO0uhET3w/Px6Xj1/C4sHnMQUmIEO
	imeFXWhMSi12Bbn/8nok3Nlu0qvVY20e37faTme+vhhqQ157v2sDg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47puk4k2ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56BC2nqC024684;
	Fri, 11 Jul 2025 13:28:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qh32tmax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 13:28:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56BDS55e52953520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 13:28:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 345BA20043;
	Fri, 11 Jul 2025 13:28:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF3AE20040;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
Received: from heavy.ibm.com (unknown [9.111.24.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Jul 2025 13:28:04 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 2/2] libtracecmd: Support changing /proc/kallsyms
Date: Fri, 11 Jul 2025 15:25:36 +0200
Message-ID: <20250711132802.1781-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250711132802.1781-1-iii@linux.ibm.com>
References: <20250711132802.1781-1-iii@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA5NCBTYWx0ZWRfX6R+5vG4luLM1 QVUsvEEePaRSMfikzsuhYImMfqr4tj8Q9MeCWCLkDcokM5kigjv0WGpsvYpSQrnn0+dI1BBy9dn 9MmuZLYaqISIBcvyOm61MlV46+OoqsO9wTG6Pf9VuWw03otaGuNCfUUoxx2s9Hkit7W3TR5A5sQ
 rNEEuGYLp9IkiUNZ5EMYwy0GM7LDU+nZW0zxk/vsk7ZLfyp+FR+oxlCd+vWp3k3N+hp/eJzNH1r +kre4H7ASyIhC2m5p0G5RTpjuDaJmYzaFpYsGb4tPsVz8pBa2sn6Buqmi4cQbFqyb3kvk3HiT+k ewgmqHCC/6mg50HKidtv7k/luQJnyOKrwfDrG5KYuUNoaL8sdbxcY2rrxdRn7T6fZTyIOHobiGx
 wAk2lKsBdJotYDY/uZ2fUOvzY5Ppi+T7jZh/tug9s3155K7bK8x9C7Sc7FzMgZ0AxhQJtWRm
X-Authority-Analysis: v=2.4 cv=XYeJzJ55 c=1 sm=1 tr=0 ts=6871116a cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=HioQ91JM4KdVr2j8WGQA:9
X-Proofpoint-ORIG-GUID: AoVUoKTYtIdvCILP8rAzdnx1LWvoGBAK
X-Proofpoint-GUID: AoVUoKTYtIdvCILP8rAzdnx1LWvoGBAK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110094

Running BPF selftests under trace-cmd intermittently fails with:

    error in size of file '/proc/kallsyms'

This is because these selftests load and unload BPF programs.
bpf_prog_put() uses workqueues and RCU, so these programs disappear
from /proc/kallsyms after a delay.

trace-cmd reads /proc/kallsyms twice: the first time to compute its
size, and the second time to copy it into the trace file. If the
resulting sizes don't match, which is what happens in this case,
recording fails.

Fix by updating the size. This will work even for sending trace data
over the network thanks to trace_msg_cache.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-output.c | 38 +++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c333553e..b981baf3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -577,6 +577,39 @@ __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsiz
 	return 0;
 }
 
+/*
+ * For files that can change while reading them (like /proc/kallsyms) the
+ * normal "size != check_size" can fail. That's because from the time the file
+ * size is determined and written into the output to the time the actual data
+ * is copied into the output, the size can change. In this case, the size that
+ * was stored in the output needs to be updated.
+ */
+static int update_endian_4(struct tracecmd_output *handle,
+			   off_t offset, int val)
+{
+	tsize_t current;
+	int endian4;
+
+	if (offset == (off_t)-1)
+		return -1;
+
+	current = do_lseek(handle, 0, SEEK_CUR);
+	if (current == (off_t)-1)
+		return -1;
+
+	if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	endian4 = convert_endian_4(handle, val);
+	if (tcmd_do_write_check(handle, &endian4, 4))
+		return -1;
+
+	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return 0;
+}
+
 static int save_string_section(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
@@ -1135,6 +1168,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	off_t size_offset;
 	tsize_t offset;
 	struct stat st;
 	int ret;
@@ -1166,13 +1200,15 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	}
 	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
+	size_offset = do_lseek(handle, 0, SEEK_CUR);
 	ret = tcmd_do_write_check(handle, &endian4, 4);
 	if (ret)
 		goto out;
 
 	set_proc_kptr_restrict(0);
 	check_size = copy_file(handle, path);
-	if (size != check_size) {
+	if (size != check_size &&
+	    update_endian_4(handle, size_offset, check_size)) {
 		errno = EINVAL;
 		tracecmd_warning("error in size of file '%s'", path);
 		set_proc_kptr_restrict(1);
-- 
2.50.1

