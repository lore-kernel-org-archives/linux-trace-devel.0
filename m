Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B42B2874F1
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984157; cv=none; b=V+2Us5WYxn6JxBvyILDoHkEUVSbQmpFmfR484prto78V8bJnLl22U5pfHRhPJ99/+geM1zRXAbFUJRalntZSNz2aHH7h2epzCVJ/1mU+mPbZvEzK4qHQOCTDkhjUVCcbmmiLIcQUWHE5H4oyABSPtQoQ4VwxEyRIb7qY0zhw6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984157; c=relaxed/simple;
	bh=XmkvL/6gxKm+9O8vlZpTfGD3RDyvns/XSsnEh6hrmPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2lLvOEmwl3kdRKIHswDgPFUJJ/zcdmQi7ebsngPqcN2jtCR0H1oDaQLqTJVqxktoJ2nW/EwCIun5lEquSGLx/hPeOo+Vu9/FFgkQ6U78iC5QIudzeGbEtlRff+iVozy5Ub6NmipCZEu98Xsty/Ht/AsUeG08qCx0azI3cCvvLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0125C4AF0C;
	Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJIiY-00000001Dhj-3N8J;
	Wed, 12 Nov 2025 16:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 4/4] libtraceevent utest: Add simple test to test BTF parsing
Date: Wed, 12 Nov 2025 16:42:38 -0500
Message-ID: <20251112214929.290686-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112214929.290686-1-rostedt@goodmis.org>
References: <20251112214929.290686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a test that reads the kernel BTF and does a simple test.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/traceevent-utest.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b95e47869437..b62411c16a11 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -15,6 +15,8 @@
 #include <dirent.h>
 #include <ftw.h>
 
+#include <sys/mman.h>
+
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
@@ -378,6 +380,41 @@ static void test_parse_sizeof_undef(void)
 	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
 }
 
+static void test_btf_read(void)
+{
+	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
+	const char *func = "getname_flags";
+	struct trace_seq *s = test_seq;
+	struct stat st;
+	void *buf;
+	int fd, nr = 6;
+
+	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
+	if (fd < 0) {
+		printf("[KERNEL DOES NOT HAVE BTF] ...");
+		return;
+	}
+	CU_TEST(fstat(fd, &st) == 0);
+
+	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	CU_TEST(buf != MAP_FAILED);
+
+	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
+
+	munmap(buf, st.st_size);
+	close(fd);
+
+	trace_seq_init(s);
+	trace_seq_printf(s, "%s(", func);
+
+	CU_TEST(tep_btf_print_args(test_tep, s, args, nr, sizeof(long), func) == 0);
+
+	trace_seq_puts(s, ")\n");
+	trace_seq_terminate(s);
+
+	CU_TEST(strcmp(s->buffer, "getname_flags(filename=0x7ffe7d33f3d0, flags=0)\n") == 0);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -429,4 +466,6 @@ void test_traceevent_lib(void)
 		    test_parse_sizeof4);
 	CU_add_test(suite, "parse sizeof() no long size defined",
 		    test_parse_sizeof_undef);
+	CU_add_test(suite, "read BTF",
+		    test_btf_read);
 }
-- 
2.51.0

