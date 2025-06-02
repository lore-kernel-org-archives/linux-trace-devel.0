Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491412253E9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jun 2025 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748900525; cv=none; b=RGXighCEsr9QYbl/t2q89ca6AgY7/hfv4FmUAbj3jN9IRC9BxyiS5b4slkRRHcwSHGwocLeTH+Lc+oWm6miqCjFGM7Z+Yp76yYj92iRPDULBGdNbRyydiuReq+9sID0AynBvF6fgwKW9P1rFZ4R0Z1RpjpfEbZZ8H9ka5uMaCbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748900525; c=relaxed/simple;
	bh=RqfJvjm9SZxZaYWDwE4WEnJtKibv8wf+3V26cRMoDOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9uEm2lMuA6Wm6BjEYnxBkyw12x6HroOSzzPl0cNcaYZIirsT3w36ZxN/KP19yHU3i0NyeTi5FJ+q2Xn7G4X7PBS/jMu7CWK46XFl8XDA/exgD0WRTAT3xtBlFsC0VDIqc98z/5yQzgSeMNRwog1m4/b5sHihJilGU8oql5FGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bpEO0BQi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bpEO0BQi"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HWt91013866;
	Mon, 2 Jun 2025 21:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Yi6rkfPma/l0y1XOA
	gxtLH965RW6/90jP7dwl8fTcUU=; b=bpEO0BQiLYskc51tQGlXRg/zV2Ge2envP
	Xt+jlX6gqwcjsB+BLVj9jiFDAcXL8cQktOYw6DjYsIaUPHeQKrqhUtoCG2eEmjE8
	PVZTqf2AF0I3Oe2/GfeC+AFttqyD7C8AcBhhV17Qzba3SPHIKPaGK4LnmMu8Ooon
	VzC+qSOdL3+1yeuW68HGEZFSoo0rON0rQuh9xU092TeXdFg2ze40mjpTV0pLR4dO
	7eY+YCXvwuF0zup9DbykXWZRUh/a415YQHQjG1AS2QNOxPs7qY/XBiQuiSKJkxqI
	hsmMm9CpAq+vJed3ppEWmQ0Wk0+KYKrfUXz6lYXDJtLkmVtW+pkUw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geygvmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 552JeH8k028437;
	Mon, 2 Jun 2025 21:42:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 470eak7r0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 21:42:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552LfvNH57540958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 21:41:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9BC720043;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E5FA20040;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
Received: from heavy.ibmuc.com (unknown [9.87.156.82])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 21:41:57 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 2/2] libtracecmd: Support changing /proc/kallsyms
Date: Mon,  2 Jun 2025 22:38:33 +0100
Message-ID: <20250602214154.446881-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602214154.446881-1-iii@linux.ibm.com>
References: <20250602214154.446881-1-iii@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CXlfglprZpso3VWOsURQpLiGz01kTuDT
X-Proofpoint-ORIG-GUID: CXlfglprZpso3VWOsURQpLiGz01kTuDT
X-Authority-Analysis: v=2.4 cv=X4dSKHTe c=1 sm=1 tr=0 ts=683e1aaa cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=Hzq5PU1NObztuRoyUSoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE3OCBTYWx0ZWRfX0vOxp+hsR2ug k6bBeffRIh18j7uYhPFP57ypN4QEZPHeODScIkM4pbwZX1rqRudoTwlMC6EYf3P647wgs8c5bEn zCFqr0s7ctXhXppiv4fpYw7+l91SVxRK5CSEAEJrtK8kFdSp4rmgni7dWDRZmHbq0xMS4ohEJcu
 cVxek7SSZHOiTY2F9IRSA0qMxXTFbl0vRIxwoOqBSqa0VW0mh3mXHzVv7+H1P0aqH32MnnKfgrz nJRAcNTBzps4e9QkGVnGD7gSWamsvIoXFWpR5lux8Pr3o4WtTZfWOA5LSxp8PtwRoZGnp7Dat0L qtfch7qWjahKsknJXgGte6DvYIEAu7+KNl6WtMgXG9HK2Exov05BSt4sUN2SO8F+mzPHvPE9Yl2
 x1HVfWvOlemarzB6V+X6AN5P6KftCWALhbhSdysLaDmJSjBp+wkbmNb5K9/W7A4z6/8xBbOT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_08,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506020178

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
 lib/trace-cmd/trace-output.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 00b87a19..e9ec8f51 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -577,6 +577,27 @@ __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsiz
 	return 0;
 }
 
+static int tcmd_out_update_endian_4(struct tracecmd_output *handle,
+				    off_t offset, int val)
+{
+	tsize_t current;
+	int endian4;
+
+	if (offset == (off_t)-1)
+		return -1;
+	current = do_lseek(handle, 0, SEEK_CUR);
+	if (current == (off_t)-1)
+		return -1;
+	if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+	endian4 = convert_endian_4(handle, val);
+	if (tcmd_do_write_check(handle, &endian4, 4))
+		return -1;
+	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
+		return -1;
+	return 0;
+}
+
 static int save_string_section(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
@@ -1134,6 +1155,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	enum tracecmd_section_flags flags = 0;
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
+	off_t size_offset;
 	tsize_t offset;
 	struct stat st;
 	int ret;
@@ -1165,13 +1187,15 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
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
+	    tcmd_out_update_endian_4(handle, size_offset, check_size)) {
 		errno = EINVAL;
 		tracecmd_warning("error in size of file '%s'", path);
 		set_proc_kptr_restrict(1);
-- 
2.49.0

