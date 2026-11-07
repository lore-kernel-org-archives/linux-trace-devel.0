Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060514;
	b=qTFaM8za1uMEisFAiLYPIVZvtSl676zgANNkKxikP8nQGA2r5oxIF0uzNwa30drhc+r9
	 bC7EB5p/vwMbK6IuatV8hK3wH0WiNYZGxUW9KGyb3W4ry5nR6Vb1km8KcwI+mfvYLV7go
	 fXEY4V8g9BiRh8/uPZMFVvnIVHH8pYfJ1tmbf88vm6lCC4gb47bFZGK7IpF1jpyKreuGl
	 wWwwEJ+BHvrHUhs+jRbcF7wpnWrmCKPEvqKGV3J0KeNMxcADMIQzzAnm1XFc/OM23ZZ3v
	 16b0rduFT2sUJbbFRr/Zykh4UPE/WP2LCq0L0FI75KhXzAwWQbXxLfS/cvqq+fLts5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSun1sy8AhvOiZe/A605zX4z/2gxN/ieAahlCrmQ6SQ=;
	b=Tu0Xb7j0n26uh14j55wuVt9r1qtWO8nVVFkpzaYTD0aLZbD7VQNoBkmZ85BxB0DSoIzK
	 J+O7DgcQdnaU6zukwUGwy9pi2M2Lb/eafwJgZboPr7YFZ4h79FtfY1DvTmlmSyDdpZaWN
	 HAUKlRr0thF9rGnvOkwa6wCuD2pgeXJtLek6hFu1WQkGqavwxe05ZFUltaVluBqcsJ4WE
	 wYdNDerpHpJ8el37KAngaSxDs9GBeA3n91qasr+o+ZBDzekZaGmEGBu55tlKvXgvkB8/4
	 +IQbOy5ZLPcYX+e6PnjD1VflbWJg3sc7Ttpgh2IV9V9zIohcwLNSKyNtygMT9bPr/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="K/4ZqjsT";
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF454606A326
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 14:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF454606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K/4ZqjsT
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2459136eec.0
        for <linux-trace-devel@vger.kernel.org>; Sat, 07 Nov 2026 06:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794060513; x=1794665313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WSun1sy8AhvOiZe/A605zX4z/2gxN/ieAahlCrmQ6SQ=;
        b=K/4ZqjsTUkldMkaDv8P7MQ8SpK6wXmwZMK8/zy8IfgBOP1XukyACIdaOSaP4MZ0hIW
         NgW0tHU66sWrpbdjLKCVw2vCeRVN4/WhvVTKxARylO3DjcY0V51nz0wzOfxUknaxXlaR
         wmT8MLlSi13NioeomFc1arFL3c1lLmlfwTmKpzElKSVCMOl3fcioT/vmxBLIG0FjBYKc
         kJ8hhcV2Z82UIaiGtyfXvSB8IF28kDJdR05/Fp7VWBrwVcdAA2virbsuFkHK3cl1lHjD
         Xoz2uqM80P4KJkIEoQG1IA6nSp5usAyQyD9AMC4rYQhlOSsUGHAWf5WrrPmGaewbIQDP
         er6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794060513; x=1794665313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WSun1sy8AhvOiZe/A605zX4z/2gxN/ieAahlCrmQ6SQ=;
        b=bTetlgB1ZDHuFJ7ORprWqgSk+2fn4LTHEkVKuambhVjyT5j00KYIbGaSB40rCGBwox
         1hp66MFb8SwxBNJetSMB6eThUWwtM8LUDa8N/Mf/SW36uk+Bwgg4XTJ3G3GKkUTEJR1f
         gtvRv3Pp56ppt6WTfayiRe4w3FHDbGuz68VT1Uleu3D9ybZbifBRFMcGHvHjPlXMO5i0
         a53KgRiIF0t8wHjnZwJS+eBS0f/92JLgCwRg9WlAz3wF4LX6Fr5g7JPqWlmjtc2Tuupx
         adsmYbl0FcQVjD485sk3JU5p+eXKZ6dwszTjypSg8KeGQld1hQ2zcxFqqsmd3K0esMRs
         iW3g==
X-Gm-Message-State: APuU4Z9XXuaXY4zJuWh846FS4kiEYuty2mNk2ZDVqtYOfsEwH9NLjm03
	dL58WrflOG8Azdp0hpPhtIsRzH01NWYS85GilwoqhcrOkfSqcHt/dJ3nWBVAKg==
X-Gm-Gg: AYBFou02GEqfk94KuaCclWxzAKpNXRrES+W6rmSpg1z4EcoMZ6kCdFSyZX63+CMMc1f
	wwXxVcCHPkEa9+9tqY8Fkz/HCJjvzQmEyhWSY8C6shxGxYlyTnVzNiVLZX7WbiYR+/wmVLrPsH3
	Bj+NjKsx9fWP67JvxXdurwyvtqMZk6b0yJbOs9cncEdGdLPuz7ZO8RUAcrN4FlIyLrZUn5kq/9Z
	3C/5y3HcgkSgZBmj8zWkLYmUC75UVPBbmioJDD5CESpk9bO2clA5+459nuympONY6zrgAR4iUYz
	CYdu/UuHtlkW7ynH+JaGvVsKLt50B2j2OMXZudUUCutvS/MAax5nTSHjEWWxwa6TzppiIi4t7X4
	imr78ICa1eYoE/+BuHWIAzMOsmwXdXQWWTRCxdw7wEqPoE9VzcIV2Efubi+5jjEUd827BOOL2ZX
	LCite1KEjZRIhQyG2JV1DEbHpArBPS68mHSIOvd50qVNdGj1pZckMJKmiYDzi1aL4xl5HCBApN1
	VKHIbKmn7dNZmFRDtmLJDBytIJm7of66e6U96RVriYh34Vwbw9742aZHfbudy2WCuitN/N7lY5A
	ol03d/i2u2Co+twZzxt7rC9CS1sZJWtTRy64p+qv1UbjvF3yRu9CPOTdZsPoVOkO5OMqxBM=
X-Received: by 2002:a05:7301:db88:b0:369:f9b6:f486 with SMTP id 5a478bee46e88-36f773fb044mr7387149eec.41.1794060512807;
        Sat, 07 Nov 2026 06:08:32 -0800 (PST)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:6fb0:6db0:221b:f543])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm16529219eec.29.2026.11.07.06.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 06:08:32 -0800 (PST)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Pass the pipe size by value to F_SETPIPE_SZ
Date: Sat,  7 Nov 2026 22:07:55 +0800
Message-Id: <20261107140755.2983258-1-lipengfei28@xiaomi.com>
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

F_SETPIPE_SZ takes the new size as the argument itself, but init_splice()
passes a pointer to it.  The kernel takes that argument as an unsigned int,
so the pointer is truncated to its low 32 bits and used as the size.  That
usually fails, leaving the pipe at the default 64K, so a sub buffer larger
than that no longer fits in one splice() and the recorders lose data.  It
can also succeed at an unrelated size with no error to notice.

Failing here stays non fatal, as an unprivileged caller cannot raise a pipe
above /proc/sys/fs/pipe-max-size and the default size still records.

While here, drop the third argument from the F_GETPIPE_SZ call next to it.
That command takes no argument and returns the size, so the pointer was
never read and the return value was already being used.  The branch it fed
was unreachable: F_GETPIPE_SZ never returns zero on success.

Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
 src/tracefs-record.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 21a2f6b..9ef13e0 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -554,20 +554,22 @@ static int init_splice(struct tracefs_cpu *tcpu)
 
 	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false) > 0) {
 		int size = atoi(buf);
-		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
+
+		/* F_SETPIPE_SZ takes the size itself, not a pointer to it */
+		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, size);
 		free(buf);
 	}
 
-	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ, &tcpu->pipe_size);
+	/* F_GETPIPE_SZ returns the size, it takes no third argument */
+	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ);
 	/*
 	 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
 	 * in 2.6.31. If we are running on an older kernel, just fall
-	 * back to using subbuf_size for splice(). It could also return
-	 * the size of the pipe and not set pipe_size.
+	 * back to using subbuf_size for splice().
 	 */
-	if (ret > 0 && !tcpu->pipe_size)
+	if (ret > 0)
 		tcpu->pipe_size = ret;
-	else if (ret < 0)
+	else
 		tcpu->pipe_size = tcpu->subbuf_size;
 
 	tcpu->splice_read_flags = SPLICE_F_MOVE;
-- 
2.34.1

