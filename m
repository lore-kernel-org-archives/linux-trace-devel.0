Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008668;
	b=gBsWpb9ABWYWMnQYkhSamxnwRZIHDSCrcCWOmhG/jKhxF1X0/iStpH5/xsR01VG3SNDH
	 3gSNtOvbr8nGln4evMshfN1D6Pp7Het59BzKcuj+Bv778RmM35A9/TNB7Yqh/+mDoxiHk
	 ZD9hNZX1OB62dk9CAGh8VVguwR/FZJ8iJtkbJSXbxbR7tJBWeBuo36gCos4BI775A3ale
	 3DSmP4dN8eb9aejrEIGjmbJjrRmGXJLNdrsPgXsMZmf4RTvFKgBZ2o4KZ0agde7rxrHT7
	 edWl9xm8fczzBJNDsCoVowxR5mLTtM26+FknaVWM+lp9L9xsV43S5fC8QoybJd9ueEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008668;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6ZasPSQgc7zvOgCavxnYm7UIZQuTIZ7plR4Q3obOgzQ=;
	b=wJ4okiJRKxuVvJbqweeXm+A6ljH20seyqedTABjUj3z2YxCGaGLzAHdIzOv8M74f3qCs
	 zMN+Xb+SAPFvt3K/MaNqygWUfO1DwaPD9dv34FS9BFqaZi3QNQ7akXZuoF5O21aSzWScn
	 mefAmtvo7XSvZd1jslGPIfsNFZaKoN3PW8JfhjfeZiHsCF/e30tiGgnc1N9zwBQZlNvWU
	 cjXFRHH6vLAEyui43/jNFWDT4MBLC5sx7n8Bp+Cw7+Wn6etybCgKfiQlA2v8oIuy4iMUA
	 ZQgttnsAPmOX2TfTebQicKlHZPTjjRfa4HNomY0mNRXmqYZlRrKEP5GhDFBjLGMAnSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=bHgSk0sl;
	arc=none smtp.remote-ip=185.125.188.121
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD90606A32F
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD90606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=bHgSk0sl
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D98D14161C;
	Wed, 18 Nov 2026 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795008661;
	bh=6ZasPSQgc7zvOgCavxnYm7UIZQuTIZ7plR4Q3obOgzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=bHgSk0slTsDUIE/1BzWVrPXA0jrUivILLHUX3nSL3CKOk3Ah59EuDCssNcJOa8ZhB
	 JM82Dve6onjLZro/vHmx8Jz3vGuk3iPAR9l90tGmDftgrSi/isOgdJxmxWMtw7c8/L
	 gDmstkEnm5ojCHg6/8qmPdc8/Rv0Nh5IZCXZZqfBQ2167fNX5MUHCLN+noIxt+dz5x
	 UFsIE7GtVt1LnnekO25fybu1S8pZG2uG+gIXL1r31ou6QtouG6zNXHpIdXvQlDF29P
	 5UgFCSbaWTVwx1bbHIPCOay7BeWKtuo/1Ms67v7qwN4TDK7xpb9Kt6Rd6L/XHdxQc8
	 tFUyUS9Oi5C7JJ8nJExMrNFPS5TtvY1pd0q/DKWWQ6gd1BpPUlsjfKqjiCooYe6jq7
	 lowcmHSoHH1SfFK7GOnFm2MCwngn/gOPNYqHTiq2ugCccInmVVsX8WFrOLJNaHx13d
	 3qyznZguZzLdywBEglJ3XMWzpmJzW+IN9F27o/2t4OrQgLg5DV9Tg8G3GXX//XaJMM
	 HCxoeYmWL7MFmlHV/y79ag/DRelYDK3woKvZotzv88UgGBHT4o+DBQ2yxWnDC6g4vn
	 404Bze2Um3rZieKddWSYKtzUgIPYhQk/K8WQ1qh0lr/3rsBAtgesV7WdDsTNKgvLmv
	 5WWCO3gzbw8fIpl33vLkFLPk=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 3/3] libtracefs utest: Account for overruns in the trace cpu pipe test
Date: Wed, 18 Nov 2026 13:30:53 +0000
Message-ID: <e1c2f63117cb06c58e3c9f85248b4cd545fc4453.1795008447.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795008446.git.frank.heimes@canonical.com>
References: <cover.1795008446.git.frank.heimes@canonical.com>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "trace cpu pipe" test generates events on CPU 0 while a reader
thread copies the ring buffer with tracefs_cpu_write() into a file, and
then expects all events in the file. For the large step of the test the
number of events is about three times what the ring buffer can hold, so
the test only passes if the reader thread keeps up with the writer.

That is not the case when running under valgrind with the memory mapped
ring buffer, where the reader walks every event in user space. The ring
buffer then overwrites the oldest events, and the test fails in
"make test_mem" on all architectures (amd64, ppc64el, ...):

  Test: trace cpu pipe ...missed events -1
  FAILED
    1. tracefs-utest.c:1970  - cnt == expect
    2. tracefs-utest.c:1970  - cnt == expect

The kernel accounts for every overwritten event in the overrun counter
of the per CPU stats. For example on ppc64el:

  map=1 expect=203112 cnt=85176 overrun=117936

Check that every event was either read or accounted for as overrun by
the kernel. If no events are overwritten, which is the normal case
without valgrind, the test is as strict as before.

Link: https://bugs.launchpad.net/bugs/2172071
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---
 utest/tracefs-utest.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 44e8fb4..877f09f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1942,9 +1942,24 @@ static void *trace_cpu_thread(void *arg)
 	return (void *)ret;
 }
 
+static ssize_t get_cpu_overrun(struct tracefs_instance *instance, int cpu)
+{
+	struct tracefs_buffer_stat *tstat;
+	ssize_t overrun;
+
+	tstat = tracefs_instance_get_stat(instance, cpu);
+	if (!tstat)
+		return -1;
+	overrun = tracefs_buffer_stat_overrun(tstat);
+	tracefs_instance_put_stat(tstat);
+
+	return overrun;
+}
+
 static void test_cpu_pipe(struct test_cpu_data *data, int expect)
 {
 	pthread_t thread;
+	ssize_t overrun;
 	void *retval;
 	long ret;
 	int cnt;
@@ -1952,6 +1967,10 @@ static void test_cpu_pipe(struct test_cpu_data *data, int expect)
 	tracefs_instance_file_clear(data->instance, "trace");
 	ftruncate(data->fd, 0);
 
+	/* The events are generated on CPU 0, see setup_trace_cpu() */
+	overrun = get_cpu_overrun(data->instance, 0);
+	CU_TEST(overrun >= 0);
+
 	data->done = false;
 
 	pthread_create(&thread, NULL, trace_cpu_thread, data);
@@ -1967,7 +1986,14 @@ static void test_cpu_pipe(struct test_cpu_data *data, int expect)
 
 	cnt = read_trace_cpu_file(data);
 
-	CU_TEST(cnt == expect);
+	/*
+	 * If the reader can not keep up with the writer (for example
+	 * when running under valgrind), the ring buffer overwrites the
+	 * oldest events. Those events are lost, but accounted for by
+	 * the kernel in the overrun counter.
+	 */
+	overrun = get_cpu_overrun(data->instance, 0) - overrun;
+	CU_TEST(cnt + overrun == expect);
 }
 
 static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance, bool map)
-- 
2.53.0

