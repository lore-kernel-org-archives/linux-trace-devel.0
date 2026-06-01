Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F538D41F
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780310296; cv=none; b=QoE9ar6lIqbh0bvnLQD7g3HxA9qhN6FSmBtkDLynOqAkaPJnlDCBZK94E2y+gJm70PtXBoxYUtkhWIF9Y7elrfr3e0B9txX/bmIiAVSxmgA/e/JaeFpKOoWgmQWKAJhbCq6NlYR7DXDDpi2dD9sKc1r1Rfon5SR5ybg/0E1nazg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780310296; c=relaxed/simple;
	bh=ORn6BMeC/4eiSa/kHU7b+CKtpIEzoy6L2On3VNf+hQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rcy0uIy7hBKaaqLXtUzEZpVG+MAxTjkDw1fHG17GdDNafIRiI+6mktYTVPRa5dBgdAgkUupUVQhaWJilCCOXnL35rWK0jalAw8c/jQpCWk/oHoGh7iloVTF/SnnSzNpjzru0dJ9bWamFMri5hhuC+ti+WT3FXWJKu0dRwU3z7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ajK4mwC5; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ajK4mwC5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Bf
	uhy+zaWDLt1jHpO1nNa3H8jn/mnAYwmFSlhk22wHs=; b=ajK4mwC5XMUfVPq7AG
	vrcD3+F9ExGppKPIYYW4vpTF11OX7GuNYk9nQJ4n/D2nGjratlqENVYnlTztToIR
	IQCEcj62F3AaSkF2d6ol3MAcLXv4u1WGZRUi5xYx6OSStoqqmCEjYbh75kZkw8h/
	Eh2sgXHmmwzB/yYBibdsXAEj0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDnb0EAYR1qVFYYHQ--.59767S3;
	Mon, 01 Jun 2026 18:37:54 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	Emil Thorsoe <ethorsoe@tuxera.com>,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH 1/2] libtraceevent utest: Handle short reads when reading BTF
Date: Mon,  1 Jun 2026 18:37:49 +0800
Message-Id: <20260601103750.68805-2-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260601103750.68805-1-create0818@163.com>
References: <20260601103750.68805-1-create0818@163.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDnb0EAYR1qVFYYHQ--.59767S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7trWDAw1kXw4rKFy5Xr4kCrg_yoW8tF4kpF
	47uFyYkrs5JF17XFyfZFnxKwnxAws7Xay7XrWxJayYvF15JFn8CrWktFyUWrWSy3ykXa4U
	ZayqvFW3Cr43XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zCjgUcUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCvwM6c2odYQOSKQAA3b

test_btf_read() falls back to malloc() and read() when mmap() of
/sys/kernel/btf/vmlinux fails. The fallback currently assumes that one
read(fd, buf, st.st_size) call returns the whole file.

That is not guaranteed. On a Rocky Linux 9.7 system with a readable
/sys/kernel/btf/vmlinux, mmap() fails with ENODEV and a single read()
returns only 4096 bytes from a 5150407-byte file. Reading in a loop
returns the complete file.

Read the BTF file in a loop so the fallback path handles short reads
correctly and avoids passing partial BTF data to tep_load_btf().

Fixes: 5b44859765fc ("libtraceevent utest: Read btf file in utest if mmap fails")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
 utest/traceevent-utest.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 1c3a4c2..b93d686 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -506,6 +507,28 @@ static void test_parse_dma_addr(void)
 			    data, sizeof(data), "dma=0x1234abcd");
 }
 
+static int read_full(int fd, void *buf, size_t size)
+{
+	char *data = buf;
+	size_t total = 0;
+
+	while (total < size) {
+		ssize_t ret;
+
+		ret = read(fd, data + total, size - total);
+		if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		}
+		if (!ret)
+			return -1;
+		total += ret;
+	}
+
+	return 0;
+}
+
 static void test_btf_read(void)
 {
 	uint64_t args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
@@ -525,6 +548,8 @@ static void test_btf_read(void)
 
 	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (buf == MAP_FAILED) {
+		int ret;
+
 		malloced = true;
 		buf = malloc(st.st_size);
 		if (buf == NULL) {
@@ -532,7 +557,13 @@ static void test_btf_read(void)
 			close(fd);
 			return;
 		}
-		CU_TEST(read(fd, buf, st.st_size) == st.st_size);
+		ret = read_full(fd, buf, st.st_size);
+		CU_TEST(ret == 0);
+		if (ret < 0) {
+			free(buf);
+			close(fd);
+			return;
+		}
 	}
 	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
 
-- 
2.39.5 (Apple Git-154)

