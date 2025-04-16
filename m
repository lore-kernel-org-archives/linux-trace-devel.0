Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51328E3F
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Apr 2025 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744845215; cv=none; b=GGZ0zbKHKGWpAFjIHVWvPRfUEeUB1hCeu/7zQo9+OoTyCDUZVlOfIBYcAERfiXFlBXCD8VMZNl61qYbH/DI+NWxZTWVErcNP1HiCpei2lmKeElGv9TuwQO2kkkyHbqco70Sd1/RaJk7x+awh2F50Wkr//xRo6jg05NsyACSBkcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744845215; c=relaxed/simple;
	bh=tHk8o7C9NlomDhEAISTgqalHMyXHqR9rvFBF03yqje0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E66OwCx4UlfNmEe/qCsk962xdVjNQfexpCFE70xNbSMZ/Ohh6xYplUlDznbMN3aWfA/FE/mzrP8Drpy/uaVlP6MA7h1hkbQtIWV4JfeYCI8aM2vkYWma7dZY6ZZg6CoVEvFL8YKAuBaYGsxW5nUxSjhy51iwB3L6lu6b2xjgO3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AVgVoYFI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AVgVoYFI"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLdJLF016688;
	Wed, 16 Apr 2025 23:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=lX6tyeHpj+dHGh0ewtX2cp4JPFl8TN/HLUMUAwHIw
	BA=; b=AVgVoYFIPFCso3zK4m2Xxd2DvHVL7290thszv159+oKUP7LFWCL7K+l1u
	GZaLkwkdQxEMJ2fKGUNBCxFZQYdKrX/bRDAPGuoHA0yH1l6ePcT8RFYmtdbNjp4c
	SLGp4s8BgDdfDSpq9KeBdZmjKBUbyjTF0TYJFDUChhxRF91rxj78vrGS9gL8VSlD
	cHgMRSu0maq7GnGGlH3kRMABL2Wmh8YiecDKVkhdP+Swhb3p51ttkcwdUrRqGWQh
	PUQkU4geCQNDNKOGuHGb38HBKmjK6wEToEBSXbxfoAx45edC5JbTPgBnF8DidWN2
	fCeiWoZC3bjGRIvrAyB31UQXYeG1Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 462mn7r9qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 23:13:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53GLMAPL030906;
	Wed, 16 Apr 2025 23:13:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4603gntu8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 23:13:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53GNDQNt35717634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 23:13:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49BB620043;
	Wed, 16 Apr 2025 23:13:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFB6F20040;
	Wed, 16 Apr 2025 23:13:25 +0000 (GMT)
Received: from heavy.lan (unknown [9.111.0.205])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Apr 2025 23:13:25 +0000 (GMT)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH] libtracecmd: Support changing /proc/kallsyms
Date: Thu, 17 Apr 2025 01:13:00 +0200
Message-ID: <20250416231325.14113-1-iii@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ANnAolku c=1 sm=1 tr=0 ts=6800399b cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=XR8D0OoHHMoA:10 a=VnNF1IyMAAAA:8 a=CnWWG_I2wGpGm9_n_UAA:9
X-Proofpoint-GUID: r-2Zwb2-lwdeco8YzhMLjs1u0q41keJ2
X-Proofpoint-ORIG-GUID: r-2Zwb2-lwdeco8YzhMLjs1u0q41keJ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_09,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504160184

Running BPF selftests under trace-cmd intermittently fails with:

    error in size of file '/proc/kallsyms'

This is because these selftests load and unload BPF programs.
bpf_prog_put() uses workqueues and RCU, so these programs disappear
from /proc/kallsyms after a delay.

trace-cmd reads /proc/kallsyms twice: the first time to compute its
size, and the second time to copy it into the trace file. If the
resulting sizes don't match, which is what happens in this case,
recording fails.

Fix by first copying /proc/kallsyms into a temporary file, and then
into the trace file. An alternative would be to read it into a
malloc()-ed buffer, but this would increase trace-cmd memory usage,
since /proc/kallsyms can be a few dozen megabytes large. In case
/tmp is tmpfs, both solutions are almost equivalent.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 lib/trace-cmd/trace-output.c | 66 ++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 00b87a19..d85021be 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1129,14 +1129,52 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
+static int copy_to_temp_fd(const char *path, tsize_t *size)
+{
+	char temp_path[] = "/tmp/trace_XXXXXX";
+	char buf[BUFSIZ];
+	int fd, temp_fd;
+	stsize_t r;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		goto fail;
+
+	temp_fd = mkstemp(temp_path);
+	if (temp_fd < 0)
+		goto fail_close;
+	unlink(temp_path);
+
+	*size = 0;
+	for (;;) {
+		r = read(fd, buf, sizeof(buf));
+		if (r == 0)
+			break;
+		if (r < 0 || __do_write_check(temp_fd, buf, r))
+			goto fail_close_temp;
+		*size += r;
+	}
+
+	if (lseek(temp_fd, 0, SEEK_SET) == (off_t)-1)
+		goto fail_close_temp;
+
+	close(fd);
+	return temp_fd;
+
+fail_close_temp:
+	close(temp_fd);
+fail_close:
+	close(fd);
+fail:
+	return -1;
+}
+
 static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 {
 	enum tracecmd_section_flags flags = 0;
-	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
-	tsize_t offset;
-	struct stat st;
-	int ret;
+	tsize_t check_size, offset, size;
+	int endian4, fd, ret;
 
 	if (!tcmd_check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
 		tracecmd_warning("Cannot read kallsyms, unexpected state 0x%X",
@@ -1155,36 +1193,36 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 		return -1;
 
 	tcmd_out_compression_start(handle, compress);
-	ret = stat(path, &st);
-	if (ret < 0) {
+	set_proc_kptr_restrict(0);
+	fd = copy_to_temp_fd(path, &size);
+	set_proc_kptr_restrict(1);
+	if (fd < 0) {
 		/* not found */
 		size = 0;
 		endian4 = convert_endian_4(handle, size);
 		ret = tcmd_do_write_check(handle, &endian4, 4);
 		goto out;
 	}
-	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
 	ret = tcmd_do_write_check(handle, &endian4, 4);
 	if (ret)
-		goto out;
+		goto out_close;
 
-	set_proc_kptr_restrict(0);
-	check_size = copy_file(handle, path);
+	check_size = copy_file_fd(handle, fd, 0);
 	if (size != check_size) {
 		errno = EINVAL;
 		tracecmd_warning("error in size of file '%s'", path);
-		set_proc_kptr_restrict(1);
 		ret = -1;
-		goto out;
+		goto out_close;
 	}
-	set_proc_kptr_restrict(1);
 
 	ret = tcmd_out_compression_end(handle, compress);
 	if (ret)
-		goto out;
+		goto out_close;
 
 	ret = tcmd_out_update_section_header(handle, offset);
+out_close:
+	close(fd);
 out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
-- 
2.49.0

