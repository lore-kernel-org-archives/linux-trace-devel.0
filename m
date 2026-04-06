Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7280D2D7BF
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 07:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775459060; cv=none; b=Dqum1TmoUsXAsbY4FBAZqv2om9EBph+z0ea6fARMWXBj1/8qC0l/b1AxzfstHIYWSpskCMb2BUWXc+/2I73a1WTI+HpSs3xzKSkB+O+00hQuSC/4/w37rrMkGfD89nssMCGSerZBaKlT1T4MU6QWw/e5zwAQInlwV1NCJ6YCzSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775459060; c=relaxed/simple;
	bh=Wwpou1YIC97LecPfRAhHflDGcc0Zuy4UmqXASTbe3Uo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ogrqbpxUOMkQ5L7FGAb2r0vG7EV+J8sPLR23mI64fV9rXLYFVitRfZqe/1DPvKvijuqosOCXAKZt3DsXvzXbv1NRaMxNphkm/5TRB2wFcpgm5b78Tt9RdYGz7gZZ3DBIZEbsg57BMlgiqoslFQ6gw4n/sohx0/1ZNSKZwN3/y7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=oThJ48zt; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="oThJ48zt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=w4
	iii02mdoLNsfmfxGZ3+cPGfCu4xxUWB6HXkL9Aauw=; b=oThJ48ztaNWyp/Hl5b
	xoT6MCpSAMd2uoYZDa8Xbm1BjauXYMpcDu/pRgReo2PKjlmZayuWZ+pzt/htGXor
	/WEgcGjO9egwNED5ypBiIYlhuV+KYK42WU1FCeF5RektoCDgm+GrfsnM8CKtE+Ch
	qCEfpU0+4Nk51FILanzP+IoIk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H4XVWtNpJYexDQ--.64445S2;
	Mon, 06 Apr 2026 15:03:51 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd report: keep a separator before long timestamps
Date: Mon,  6 Apr 2026 15:03:44 +0800
Message-Id: <20260406070344.64152-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H4XVWtNpJYexDQ--.64445S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF1kuFWfCry8CF1xXr4DCFg_yoW5WrWrpF
	Wjyr1qkF48tFsayw1S9F4Duw1Yywn7CFW2gryxu34Ykr15Jr1UXryxKa42qr4fX3ykZ3yf
	Aw4qkw1vka1kZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Upa0QUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCwBkcVWnTWtndHwAA3r

trace-cmd report formats normal nanosecond timestamps with "%12d:".
That relies on the field width to provide the separator before the
timestamp.

With --raw-ts and a large --ts-offset, the timestamp can grow beyond
12 digits. Once that happens, the padding disappears and the output
runs into the raw flags field, producing lines such as:

  [003] dNh2.749686305812356:

Make the normal timestamp format include an explicit leading space so
the separator remains present regardless of the timestamp width.

Add a unit test that exercises report --raw-ts with a large timestamp
offset and checks both the fixed and the broken output forms.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221303
Signed-off-by: CaoRuichuang <create0818@163.com>
---
 tracecmd/trace-read.c  |  2 +-
 utest/tracecmd-utest.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 355ee0f4..aef9b4c5 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -170,7 +170,7 @@ static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
 			else
 				return tf == TIME_FMT_NORMAL ? " %6.1000d:" : "%6.1000d";
 		} else
-			return tf == TIME_FMT_NORMAL ? "%12d:" : "%12d";
+			return tf == TIME_FMT_NORMAL ? " %12d:" : "%12d";
 	}
 }
 
diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index c18fb2ea..cc487d13 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -445,6 +445,28 @@ static void test_trace_convert6(void)
 	CU_TEST(ret == 0);
 }
 
+static void test_trace_report_long_timestamp_separator(void)
+{
+	struct stat st;
+	int ret;
+
+	/* If the trace data is already created, just use it, otherwise make it again */
+	if (stat(TRACECMD_FILE, &st) < 0) {
+		ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
+		CU_TEST(ret == 0);
+	}
+
+	ret = grep_match("\\[[0-9][0-9][0-9]\\] [^ ]*\\. [0-9]\\{12,\\}:",
+			 "report", TRACECMD_IN, "--raw-ts",
+			 "--ts-offset", "100000000000000", NULL);
+	CU_TEST(ret == 0);
+
+	ret = grep_match("\\[[0-9][0-9][0-9]\\] [^ ]*\\.[0-9]\\{12,\\}:",
+			 "report", TRACECMD_IN, "--raw-ts",
+			 "--ts-offset", "100000000000000", NULL);
+	CU_TEST(ret == 1);
+}
+
 struct callback_data {
 	long			counter;
 	struct trace_seq	seq;
@@ -798,6 +820,8 @@ void test_tracecmd_lib(void)
 		    test_trace_sqlhist_hist);
 	CU_add_test(suite, "Test convert from v7 to v6",
 		    test_trace_convert6);
+	CU_add_test(suite, "Keep separator before long timestamps",
+		    test_trace_report_long_timestamp_separator);
 	CU_add_test(suite, "Use libraries to read file",
 		    test_trace_library_read);
 	CU_add_test(suite, "Use libraries to read file incremental",
-- 
2.39.5 (Apple Git-154)

