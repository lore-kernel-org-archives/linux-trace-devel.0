Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008665;
	b=lnLPhWdlKPWDrMXeZFqnGKE0Y6rgh5gKnbuVMPv5o24KVFdWaagPVZ9dzEOGhmrwByf0
	 tz4YCwwAz0zQ2JlA0fKbMnSHTBu/T6PKn3vPCwJK+qnl8Fw/gYTBSZ7yr/FRnWPM/LF6d
	 BEX38gTZGwV1ZaFPiFWVxnMJXRSy7vQwHk8prRgPMItLVfGEEah3Vy1mxmW5Q0SU2axWP
	 gRrXnFzKmhxzAy5kW4H666L2ef36FSjWwQQUZnwakUTCEqWkwI3qkOSkauyjHEoH1Eu9Q
	 h9jw8S6McWXTrJJ8QG06/ceb0B2k0lPot+qnvs80saK/QAgy2dtK1Y9U6da9JXE7hag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008665;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6RwcTgwkv90PO6u6mE0zsGFrk9vXRGh7GUpdPk4sGlk=;
	b=bQfUBOKDUVrwVmr3viVRVDBG1JYmZ4XcK1YlOez+JRii0XlcefjiBxEG3J7gJRrJ74NJ
	 LyP7VblaiTa3PwDrMPhgLJpSl0AqLET53zTDOanJG+oWXEFf7uIixeNXVcphoRHJhmSU9
	 RNXWcsH82WZpfmpOXOD7YkUJ4ddhBXxTEbJNq3xaf9SA8/kww8MFnWjY2igX0+aC46h3B
	 QQlpnSRCNGGVsuz/uZj6tuDeRdsZZ7B1TShonuJmjdWvgBrQBvGJqxrsAF9yb1gJFMuyN
	 Aa4D8613DkKbuH5q1dDZivqe6dw0KAfiguVICuyNYAKBa0Q+3TVZdf4uw694oo5Rcng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GOhDO9Oy;
	arc=none smtp.remote-ip=185.125.188.121
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EA1606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10EA1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GOhDO9Oy
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B81793FC2D;
	Wed, 18 Nov 2026 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795008657;
	bh=6RwcTgwkv90PO6u6mE0zsGFrk9vXRGh7GUpdPk4sGlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=GOhDO9OyunOw17zKM6lg6ui+g8C+S7OH2i+n87d1IQ/V+YHN6af7KbLumGYQW9oBo
	 kuKjSsJJtFV3diy8bUbbEpeyLfOTynVgLlPtY4brg7OSGJ8ZsxM3OIGY8Lvo28q3jS
	 z78sJq3TYSpZdgDvKMtLmVorulCR74hP53OwhgmvAIo7TiMLnNFcDuo6aIeH7/vrdB
	 QiPXxiN7QJH7hNnkHj66E8Wjg+BZZ60ghCs9D0yvxP0QYQborq+LVDdgsmO8qSG0hJ
	 bgv4QikKglB4nMpFn+kCm+AmcOjTt9H5hPt8B9LggOWb/RFg/wvnqRiNamHANtlLcU
	 sod5zSeSRFxlPNBd+GhcC9Ynjq0RleMsH78o4kR/MtKurW9Upbq7/A9kVQV8xGBwYN
	 lJyBaeDgy41E3czpg1aosAC0tZFN5x4OxtQnKw2DRp0mweE2Wa+V4E7jrzPeY39BnV
	 w/U0UCiPcwEPO2Jjr8qUthwrJLQ8UDq4Wm+/S6+sVv032+PZq1xyePG/KQabxb+i8H
	 af5DgYz7YuWZF4ge4rKAhZdLoAmdrtrbARgu85fHVcJ/JGs96XeSWBXVUNly1X1Hrv
	 OAdOvZTgQRA50xITBBhwA2QZfEzlKSBXUgs79uqyddDopZfrgpSh01qifEyy4N7Css
	 fE6ois0FAw8jnm8FzbXXTNsc=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 1/3] libtracefs utest: Scale trace cpu pipe test to the sub-buffer size
Date: Wed, 18 Nov 2026 13:30:51 +0000
Message-ID: <cc284a8f0a3d10df83b053214da53d7d9915255a.1795008447.git.frank.heimes@canonical.com>
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

The last step of the "trace cpu pipe" test writes events_per_buf * 1000
events, i.e. the equivalent of 1000 sub-buffers, while a reader thread
copies the ring buffer with tracefs_cpu_write() into a temporary file
in /tmp.

When the ring buffer is memory mapped, tracefs_cpu_write() writes a full
sub-buffer, padded with zeros, for every read that returns data. As the
reader thread polls continuously, most reads only return a few events,
so the amount of data written is roughly the number of reads times the
sub-buffer size.

On architectures with a 64K PAGE_SIZE like ppc64el the sub-buffers are
16 times larger than on x86 and events_per_buf is about 3276 instead of
about 200, so the test generates 3.3 million events and writes more
than 13 GB into the temporary file. With /tmp being a tmpfs (as on several
distributions) this fails with ENOSPC:

  Test: trace cpu pipe ...FAILED
    1. tracefs-utest.c:1966  - ret >= 0
    2. tracefs-utest.c:1970  - cnt == expect
    3. tracefs-utest.c:1966  - ret >= 0
    4. tracefs-utest.c:1970  - cnt == expect

Scale the number of sub-buffers to the sub-buffer size, using 1000
sub-buffers of 4K as reference. This keeps the test unchanged for 4K
sub-buffers (1000) and uses 62 sub-buffers for 64K sub-buffers, which
still is a multiple of the ring buffer size.

Link: https://bugs.launchpad.net/bugs/2062119
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---
 utest/tracefs-utest.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e48232c..44e8fb4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1973,15 +1973,27 @@ static void test_cpu_pipe(struct test_cpu_data *data, int expect)
 static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance, bool map)
 {
 	struct test_cpu_data data;
+	int big_num;
 
 	if (setup_trace_cpu(instance, &data, true, map))
 		return;
 
+	/*
+	 * Scale the number of sub-buffers to write to the sub-buffer size,
+	 * using 1000 sub-buffers of 4K as reference. With the memory mapped
+	 * buffer every read writes a full (zero padded) sub-buffer, which on
+	 * architectures with large sub-buffers (64K PAGE_SIZE) can easily
+	 * fill the file system holding the temporary file.
+	 */
+	big_num = 1000 * 4096 / data.bufsize;
+	if (big_num < 1)
+		big_num = 1;
+
 	test_cpu_pipe(&data, 1);
 	test_cpu_pipe(&data, data.events_per_buf / 2);
 	test_cpu_pipe(&data, data.events_per_buf);
 	test_cpu_pipe(&data, data.events_per_buf + 1);
-	test_cpu_pipe(&data, data.events_per_buf * 1000);
+	test_cpu_pipe(&data, data.events_per_buf * big_num);
 
 	shutdown_trace_cpu(&data);
 }
-- 
2.53.0

