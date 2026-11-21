Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795259798;
	b=atsGnTc67x6ZAwXb/JaPFxsc+WaW7VmkXbQF7PzUIHSmSqcbNEUpk6waMZ5AfE/FrQNB
	 YbUAjOUvPxkCXRB4Ca2/O3Ny3uLksn/BTZAGAMVRTryWxGEd7kO4nY/dJGnrhFwZjs1hp
	 vCw8qlAm4G9uSSgcEBcpO2HPyTAAh72P9kQNDGJgPiWxeUt6eU7tg+Sy25DWk/c1w0l1M
	 CsNJw+6N/dOIbNNXxWq0I4oDVrvw59+bDaDjeCJDYpjfj1iX4lcRkMcQvFEU64D1BDYzQ
	 omUjr1vg+sVZ2QHQ2jSbPFiypJeWR2LwJ8jn98jpC/irx53sA2HrSgH/8ugUAT3MAvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795259798;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=gw9vdjCB7x0Z1yWu5Tp4h2oo/vv9Z/FpPD0NN1RJ498=;
	b=kwFxAUKPKcBClIv9uzeQQ7L1tzYNnu4xW83M5EjEh5YNBQt13x+mxksLy6vEssjSyyL/
	 UF+J8ifipxeKPVybXD04nRiYSkqg5YQxxnqiJzB0R1EdE/fwYTCmpOCGVau0mCQx7UlrK
	 wT3t/IODQZzBnSfWBOweGYWpVHRgqnhWOt6uFMVi2n3X+wVXm4P8bCzYdSWkLNLxZWFQm
	 V+l25+kwZciCIsgPyWcF5DAf5sLPvYWAe86diW27Uibxn5VLrrNXr7W658vWTwFbYTYsC
	 R/lHraE0Tz2mkPfBEv37og69vbkKi+fesQipdDZnRDrgR26uMhF882ofFYxu8QWUM9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dUeqYiW7;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182DD606A325
	for <linux-trace-devel@vger.kernel.org>; Sat, 21 Nov 2026 11:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 182DD606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dUeqYiW7
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cddc597d062so1067015a12.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 Nov 2026 03:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795259797; x=1795864597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gw9vdjCB7x0Z1yWu5Tp4h2oo/vv9Z/FpPD0NN1RJ498=;
        b=dUeqYiW7TUlTh+MbX1seTk5SxBKXQmtzZ369x8kQfwrnHS+sNc13F3rOKCtuIDOtIH
         5IBltBKeWttfwQSy+/4dqyaTdoTxNfWLuSC9y8GP/zZ0IQwg5IPvWt+kDhFe1aSeAgJE
         MgshD4lMvizYOuOT90aH8HJFN8q1fftjkPVrU449z7M3wdIH2vvGZC/vGtqhw0vaXoWg
         BHYwRaI9EYMPUGdgIx7unwhnNBaRgNKm5Jhg4R+upkdjqqliBailVOjJdcGXG8xNmz/s
         D+drUoclWiSHvT+I+/iJLwwKbDDxnZGH4l1OkuIBJrjoH3f3Fj+xnrxaWqlKIsiHNz2o
         DwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795259797; x=1795864597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gw9vdjCB7x0Z1yWu5Tp4h2oo/vv9Z/FpPD0NN1RJ498=;
        b=L4/102bAiDwh/a32yL0MFLX4bqj9JwEFZvJCZpF2BhXOYLnGWAQ9pndZ0/5fNVkvg6
         W6FfEjtZI2YPXSxWuIYoJWl+yKS1Wd0wuo3W/J9A7wj8GMEatSrzMj0+rjyHryvtxmeS
         Dho2hpabQnM9qlr+j+I1EHrUbw/upkcihInJ27WgvzYA92rTXm5S4WzmxhQcsgk/jlJQ
         9ZI57TWWJZtYKDhyl073rxf1Iyb+HxdbossobUUExj2MQu5hDqjcsTjXypfR+C88brLg
         VgSoZhnqUV5CaRzA/vDFBeID1TTcenrkWqz51QMsBH3tUY5VxvWaQFORA+VzghsGd0RW
         o4aA==
X-Gm-Message-State: APuU4Z+OyYEGjB+a8hYnWMN+8niX9S5HkXpCvhwypxVyfMdlqImaIeTl
	mz6jaB+0f7ZbcnIJdQOQbgyNst3IqdRgz7rtj/c1kcU4ccSv2XmiMgr4kQdl7g==
X-Gm-Gg: AZFdTZftRoCC5J6cC4YtBNUQoMcPBsk9s6vfauJvLqv8AoqkpuQdy38+EkMQeVhQ62m
	W9k5AHIpYYO+7SvtJymACuREfhDccjRTXMk/aNwoKl1yc4i2a+FY9TsEyYOdU9m/et/GfWu2q6I
	2LXcERRXh6SNyzeedbulOQ1NYZ6YUwQxDrKdAgpCwAczsDKQUENNxAgml9z1QwpCcW6AgtEqRYJ
	JBK0ET9wu2QTxr3wniKH3H7iClO4FJqEshSKDQ47v7RijtKp9soQGnbw0Gh5Q7hx06DthNzQgIt
	w9N4N5F3UqvkYqCbPuqTHgZyjnEsZ86wpbaDm9DBnyQ1UfM6SqBoe6oeb/c7kCyeFBC7zrGTzgm
	hfFxFZXw38yh7DHwk3+KcN5beqcEhRT2Vl7/aKsUK/ER/gZJULQv35yZMCUpC7Dl8NVCKJCPWFL
	zzoHwS/ZGtKMVtFKXLxDR9RGuN5otzgs8OKDzB0d6O9IChptOXH4jq6cn8//Zvby8298n85a4p1
	C2A1elJ6ei+tLj4D9XobBlmZAYCVNM6htayju4BZi7fq1c0eBsMrHjA0fcgGwUnriGzDmRvJg5/
	4ujwtIBFSJUOBmxQUhPoyt2dI0GW2SM7EZAuKzHrop1IlKWlJr3CWH0oizeo8C4vp7qC
X-Received: by 2002:a17:90b:3e81:b0:3ad:6090:a190 with SMTP id 98e67ed59e1d1-3b41c9559f5mr4819632a91.41.1795259797260;
        Sat, 21 Nov 2026 03:16:37 -0800 (PST)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:7939:12f3:f41c:b2d5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40a878d50sm10475605a91.11.2026.11.21.03.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 03:16:35 -0800 (PST)
From: Li Pengfei <ljdlns1987@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Read the sub buffer size of the instance being opened
Date: Sat, 21 Nov 2026 19:16:05 +0800
Message-Id: <20261121111605.1145760-1-ljdlns1987@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Li Pengfei <lipengfei28@xiaomi.com>

cpu_open() loads the top level headers, but the file it opens belongs to
@instance, which can have a buffer_subbuf_size_kb of its own.  Load the
headers of the instance being opened.

A mapped read copies whole sub buffers, so bound it by the size the caller
was told to allocate, for the case where the two still disagree.

Fixes: 4ede86e9a48d ("libtracefs: Enable mmapped ring buffer")
Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
The size tracefs_cpu_read_size() reports is what callers allocate with, so
with a 4K top level instance and an instance at 128K a mapped read copies
128K into a 4K allocation.  A test that writes 5000 trace_marker records
with "-B foo --subbuf-size=128 --nosplice" read back none of them on
arm64 6.12, and all 5000 with this applied.
---
 include/tracefs-local.h |  2 +-
 src/tracefs-mmap.c      | 11 +++++++++--
 src/tracefs-record.c    | 17 ++++++++++++++---
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 056e7ca..ea9145a 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -120,7 +120,7 @@ int tfs_append_filter(char **filter, unsigned int *state,
 void *tfs_mmap(int fd, struct kbuffer *kbuf);
 void tfs_unmap(void *mapping);
 int tfs_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf);
-int tfs_mmap_read(void *mapping, void *buffer);
+int tfs_mmap_read(void *mapping, void *buffer, int len);

 struct tracefs_synth *
 tfs_synth_init_from(struct tep_handle *tep,
diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 7530805..2129c4e 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -222,7 +222,7 @@ __hidden int tfs_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
 	return 1;
 }

-__hidden int tfs_mmap_read(void *mapping, void *buffer)
+__hidden int tfs_mmap_read(void *mapping, void *buffer, int len)
 {
 	struct trace_mmap *tmap = mapping;
 	struct kbuffer *kbuf;
@@ -231,6 +231,13 @@ __hidden int tfs_mmap_read(void *mapping, void *buffer)
 	if (!tmap)
 		return -1;

+	/*
+	 * @len is the sub buffer size the caller was told to allocate, which
+	 * can be smaller than the mapping's if the two disagree.
+	 */
+	if (len > tmap->map->subbuf_size)
+		len = tmap->map->subbuf_size;
+
 	kbuf = tmap->kbuf;

 	ret = tfs_mmap_load_subbuf(mapping, kbuf);
@@ -239,7 +246,7 @@ __hidden int tfs_mmap_read(void *mapping, void *buffer)
 		return ret;

 	/* Update the buffer */
-	ret = kbuffer_read_buffer(kbuf, buffer, tmap->map->subbuf_size);
+	ret = kbuffer_read_buffer(kbuf, buffer, len);
 	if (ret <= 0)
 		return ret;

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index f5197c4..13cef71 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -99,6 +99,7 @@ static struct tracefs_cpu *cpu_open(struct tracefs_instance *instance,
 	struct tracefs_cpu *tcpu;
 	struct tep_handle *tep;
 	struct kbuffer *kbuf;
+	char *instance_dir = NULL;
 	char path[128];
 	int mode = O_RDONLY;
 	int subbuf_size;
@@ -118,8 +119,18 @@ static struct tracefs_cpu *cpu_open(struct tracefs_instance *instance,
 	if (!tep)
 		goto fail;

-	/* Get the size of the page */
-	ret = tracefs_load_headers(NULL, tep);
+	/*
+	 * Get the size of the sub buffer from the instance being opened, as it
+	 * can have a buffer_subbuf_size_kb of its own.
+	 */
+	if (instance) {
+		instance_dir = tracefs_instance_get_dir(instance);
+		if (!instance_dir)
+			goto fail;
+	}
+
+	ret = tracefs_load_headers(instance_dir, tep);
+	tracefs_put_tracing_file(instance_dir);
 	if (ret < 0)
 		goto fail;

@@ -429,7 +440,7 @@ static int mmap_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 	void *mapping = tcpu->mapping;
 	int ret;

-	ret = tfs_mmap_read(mapping, buffer);
+	ret = tfs_mmap_read(mapping, buffer, tcpu->subbuf_size);
 	if (ret <= 0) {
 		if (!ret && nonblock)
 			errno = EAGAIN;
--
2.34.1

