Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794116731;
	b=R5C3YIovfjkUsstsuQ+hg0IctivbYnVY9vMahmJhBhghKdezopDaEj/y3kosOif5T6Ie
	 VJWCSNIgqqFK0mNoyVNAUGc08ezXFlXaC6BHJBlUZ5yM98czZZgPoDB8Gv81ywC2GidVe
	 GXDMH1UD343VSOrZe2iIvLyzPqzkjW1o5RaliONj3YCz/oxGYHN5dliyg1n/DsVtxJwJ1
	 A307+KsCIL2Q8RziuokIfpPr1wRC9n0+4zkXohw4mQk8BHrvbPNtMW4u9r0fubtXDY+rv
	 t4vAZJD72RAfpMtq/Nc94sip4VKGOLLpXO3zVczx2sYnkN4E/x3/CyEstqif4C8bjsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794116731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jJH3uNGiTDgilkiFsYO1bUnEGRo9NE9Iz1hfBpFFnpo=;
	b=E8jMrV9U/gB48ukGad+BWPR1bbnVgdzHo3Df0AwOEgOnUErzR7r7DPQpeWX7bUp2Z4Bz
	 lSaxOFgyW5tu+eZtLRwTNSFdVTunESdsgiy7w30kPBgxryOJvgn7Q3wYpk3Da3U+hKTRl
	 gwM+CeviUc62Ka75pGEFisYJDk5sNtTjTobhSK8n1SK/DHz6yTE+Ag8Rfr98x3A7pYOLn
	 5E6BBNy0q6kI4sq9L7eohEmJVScjfKiOJxPnj2vX4XuiBmbbAJspgS4rz6QS4KTiQ51/1
	 Qbxj8Lz/1lOHzCTkOxYw+wlcScx2ohBnrfGtGfJyaK6GBgVIACC68L/auMJYYMwA5QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x9LFJHtX;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE24606A31A
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 05:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEE24606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x9LFJHtX
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36e795af1d4so164693eec.1
        for <linux-trace-devel@vger.kernel.org>; Sat, 07 Nov 2026 21:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794116730; x=1794721530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jJH3uNGiTDgilkiFsYO1bUnEGRo9NE9Iz1hfBpFFnpo=;
        b=x9LFJHtXsxmM5bZP7ElpAHjDRkaN/3Oret28i5xvLzAxBGbdPqJjRIxEq4XGvyFxhv
         6SAXHmm+KMPakALyKunH/d/1pO6LrHsMvyCU2SxgswkKoa7js2RT4mxzD4YZc9ixjHQQ
         ytuy1cFk/Ut5DsosfXKcESKxMPTmRDQhuZedRokkqFOPDdKDoOle0Dg03PONFlahaO7r
         VdZJMcU9iE4dIEhLdGk2btNQPyc1gQaKNC8fjix3nv47QpYPBkWNCrgCrYU2Cs/Gfb9O
         998eKXDPzWpi7gIYqtsd+q7ol0llNWmfDjeceCTot7SieNZ/4dgXV75WXtiFUuallH+3
         4tSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794116730; x=1794721530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jJH3uNGiTDgilkiFsYO1bUnEGRo9NE9Iz1hfBpFFnpo=;
        b=hphKJlAEITVUg5+dK0eQy5vz308aW+nyjXd2C7C4Gbg6avL52itOFUrAAjUANom/lI
         MXAZGBZe0QPvEzkdOK7cT9jJEHJhKrDHLOVp6yXpzpDmuowBnyoypJuT8XLcgXB/Wz6i
         xUC4XdJ4+qmGKE6Yw//7pDtG/ss/1kfOlJNtCitaDkmdZNvf+11B0/EdliRYeDMbewrs
         RMhsRIxSRO+kN64YiyLr8XwnT6cDMf3nCk51e2q4KIypOnqLecgBDaNVbbIbOgc7Z7hN
         H99f1apAPHHyFBZOekECSMOoGHZ26C8tTuyJixnlJV/CWW3HfzdUuIssJC1nvxAEiA24
         U6NQ==
X-Gm-Message-State: APuU4Z8s8FfY8HUxZnQQMvSMqHLlEwdXzaXg7rhhvdd8e49yUOxBeYcQ
	8gRZ5c6hs8mXxHMcw5IGcw5jvUwDaUFR9bODs7oJ0UMMXpbzfRU8BaXdM55N8Q==
X-Gm-Gg: AYBFou18rGnXzD0wHIojprUlkDxfhEUBMrllZVR4kmm+pSwJyZCsX4KHonMrNs+L6ZA
	uFLduk027r0OctmPeqHIUuZ44Ib7FDZq64KE7cREmKsBWqSUvsMT1t8gWf72itcAcaVtxJTxSIu
	UPBBtSBIOHhjo4AXO6rWhitFfvBqOGQYk17VQ06lhTZ1EOExX0U4Wuy88PU55zuLHmJWeaQ9QU8
	SRFHSf4aVqEcVmADullWRF/8eiN3ArBsXZbXejfuf0V25LeMYStYsclW3w0tlWgrwsYfUCnKHrk
	6vcTRB5YaRRAEBcybVqxiqk43k/mUlC9jR9tfPgZ1vlNjov1bUtxYVBqDb3V3XzN6g/o6rPjgw6
	UvomKrF90kyB2eBSZxz1hbE3XaCicy5+rrfWEQk42dg+OcKsmdsT7KbYq/+Uz48tys5dNOmxYF8
	+cXSqKdDkvJ4JqwNQY+FgJ/QJGb2fNOJfRl4bW+wTixInWkzqzn4WQoLV9HQv5p0in3L0K7cCfP
	rLlN+LmQhO4VjgJR0s1mA6gtiSxivhJe2oQyV7WSO9qYdMBG/RrIOeDQn8G3dXUWJnX1mB0r6OP
	8vIIw0YrgvvAyS9UTB9r1Od0sqpQfxYQf7zCVfpHmeyZiTOkfskCqXAm6qsQu/NFY4eGBBpHs5Q
	tbSr22FXoOSNQVTM=
X-Received: by 2002:a05:7300:cc9e:b0:369:f1ca:5b24 with SMTP id 5a478bee46e88-37256134b34mr1597704eec.6.1794116729572;
        Sat, 07 Nov 2026 21:45:29 -0800 (PST)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:5213:762b:b24:1be1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37265a16f9csm2885301eec.12.2026.11.07.21.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 21:45:28 -0800 (PST)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Pass the pipe size by value to F_SETPIPE_SZ
Date: Sun,  8 Nov 2026 13:44:58 +0800
Message-Id: <20261108054458.217842-1-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107174208.6400402e@fedora>
References: <20261107174208.6400402e@fedora>
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

Fixes: e34cbd83f6d3 ("libtracefs: Increase splice to use pipe max size")
Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
Changes since v1:
- Drop both comments.  They described what the fix changed rather than
  anything the code needs explained afterwards.
- Add the Fixes tag, which v1 was missing.

 src/tracefs-record.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 21a2f6b..f5197c4 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -554,20 +554,19 @@ static int init_splice(struct tracefs_cpu *tcpu)
 
 	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false) > 0) {
 		int size = atoi(buf);
-		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
+		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, size);
 		free(buf);
 	}
 
-	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ, &tcpu->pipe_size);
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

