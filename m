Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2303E30C15F
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332802; cv=none; b=ZvFpxgVb+KUMDuK175Mk9UIoF14jL8q2A7fKRF/uwnLJeFXn7TiojW1twCpYF4bFcPs2CqrCSAiZQKes9WSDY9pFnp7haCvHtHuMGbsscf8V3kvOhhTnG2m+fPflUCtJbDd5tjlr737CzHkQM4xAvoWODLrrUAj5WRJufFxgSyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332802; c=relaxed/simple;
	bh=jrT0Df8uGhm+CV1BoXhJ2Z+GS3QoslA+8bJjZHR4v4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fwHlQ+clw/SZ6aZ6Yzm9j83kgnlZx4VSyn9Ef0hzzcDANx0Ji5iTAhAJ1BX/zXdayA8Gi8+Kx49zuQMVreOJH5gG+hPtH9/cKCNkNfUq5fr9n4QwMBUZMXXR3+X65xx5Y+iDBjRNdT7PtTb0J5MHo8AuQZk15J5pFaDZDcGwScE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=orWNhUT7; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="orWNhUT7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1d
	W6FrIg/pIib4gOF/Mae0H5I2lBIjfst52d9b7K9ZM=; b=orWNhUT7KWQ4tK0KS3
	EHmvcIpIWQeqQOZIMyWb+CtghtaeXhVXrt1mWU9KWWrpnvtmOXbVkj+O3RjUnSY3
	/jESlVymfOhM2tgGP1SvB/oQFgGmh8c+zsFULjiUzMJDX7EKXdWnWbnJ/urUDH2H
	jPX6QWMcvCMByE3i1VXYdzeQA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBXlKLquB1q+rd1Aw--.65291S4;
	Tue, 02 Jun 2026 00:53:01 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	Emil Thorsoe <ethorsoe@tuxera.com>,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH v2 2/2] libtraceevent utest: Avoid host-specific getname_flags output
Date: Tue,  2 Jun 2026 00:52:57 +0800
Message-Id: <20260601165257.57814-3-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260601165257.57814-1-create0818@163.com>
References: <20260601165257.57814-1-create0818@163.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXlKLquB1q+rd1Aw--.65291S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWrXFyDWw13XrW3ZryDAwb_yoW5JFWfpF
	navF13KF4DJF43Xw4akrnIkr4ayw4vyFy2y3s3XayF9FWYgry7trs5uFyYvr4rGFZ5uasx
	Aa4j9rW8CF1xXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zMc_-UUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6A1LhGoduO02ZAAA3a

test_btf_read() loads /sys/kernel/btf/vmlinux and expects
getname_flags() to print exactly two arguments:

  getname_flags(filename=0x7ffe7d33f3d0, flags=0)

That prototype is not stable across kernels. On a Rocky Linux 9.7
system, the kernel BTF for getname_flags() has a third parameter named
empty, and tep_btf_print_args() correctly prints it.

Keep the exact output check for hosts that match the expected prototype.
For hosts that append extra getname_flags() BTF parameters after the
expected arguments, treat that host-specific suffix as an acceptable
variant only if the output still has the expected argument prefix and a
complete closing suffix.

Fixes: 0294b73f17e9 ("libtraceevent utest: Add simple test to test BTF parsing")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
 utest/traceevent-utest.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 275e5ed..151e841 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -16,6 +16,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <ftw.h>
+#include <string.h>
 
 #include <sys/mman.h>
 #include <stdint.h>
@@ -529,10 +530,21 @@ static int read_full(int fd, void *buf, size_t size)
 	return 0;
 }
 
+static bool output_has_extra_args(const char *output, const char *prefix)
+{
+	size_t len = strlen(output);
+	size_t plen = strlen(prefix);
+
+	return len > plen + 3 && strncmp(output, prefix, plen) == 0 &&
+	       output[plen] == ',' && strcmp(output + len - 2, ")\n") == 0;
+}
+
 static void test_btf_read(void)
 {
 	uint64_t args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
 	const char *func = "getname_flags";
+	const char *expected = "getname_flags(filename=0x7ffe7d33f3d0, flags=0)\n";
+	const char *expected_prefix = "getname_flags(filename=0x7ffe7d33f3d0, flags=0";
 	struct trace_seq *s = test_seq;
 	struct stat st;
 	void *buf;
@@ -581,7 +593,13 @@ static void test_btf_read(void)
 	trace_seq_puts(s, ")\n");
 	trace_seq_terminate(s);
 
-	CU_TEST(strcmp(s->buffer, "getname_flags(filename=0x7ffe7d33f3d0, flags=0)\n") == 0);
+	if (strcmp(s->buffer, expected) != 0 &&
+	    output_has_extra_args(s->buffer, expected_prefix)) {
+		printf("[KERNEL BTF HAS EXTRA getname_flags ARGS] ...");
+		return;
+	}
+
+	CU_TEST(strcmp(s->buffer, expected) == 0);
 }
 
 static int test_suite_destroy(void)
-- 
2.39.5 (Apple Git-154)

