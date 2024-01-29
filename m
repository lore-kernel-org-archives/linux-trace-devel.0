Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42A51482F9
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538689; cv=none; b=G2088ZI7cQDRVgmka+lUVpstbFVuda2TNL0mhOybeotZF/Liy+c3sL1x79Mqrb7FQk/mnMFJ9VMjhtvRwgJeDrdFSGTxJLDB0JgTd8ScyPCmykhN9iNGy7+rhmw83a4pHSzvKBMayClVa2/yCFhkhmRlGfp/daTSPXM59wwLcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538689; c=relaxed/simple;
	bh=52t4wPYvMwpH/T/qp0ozGBQnsLqYao+8fNnpNS2VyFs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t2T62uSQfYWP+6agACHDilV1vt+F3maadKBptJyhYTLj5pBeJ/UPcB/YIaCuTuU1DhsF7o1mOJd+fOYyMMpOtNli++qFMEqOt28Vflu6VTrckjW0yrlMh5+sUCMAEq6wYlY4g9sOkXS+lWqRnw3U5wX5xDTVj0gp+61nsue/cjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=blO2ByFB; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="blO2ByFB"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5fffb2798bfso44708807b3.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 06:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706538686; x=1707143486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w9KeidiqR8MAtIfEdVgPdtMycQfPKrdz/yD8Mg07T4s=;
        b=blO2ByFBAC8Le8/VP0Jl25wNYq1NnIKkAn6FnXblcpKzlTGWJaEMFKpzqMSWnlIGWj
         nmOZHLxc3qigiEuuxpXVuyr3Z542IRZRvsGnhsLRGcphEJosLAKEQvMzuTMKanqKiVGz
         8hnWCJ+6Z6TWUq7QK2VBC7qplku7WE/Q/GBUYMxkrBIYTrNOBoj2LJ6jZzyKqf21K7Cu
         fn/0fsUpDCQaWwJBMYtkX/sbCdncqsgW5lXFFJ1pdCCrVIOS/o+iR3kKzzZME5mBOMNn
         JQr3MLpuqq/w3LtHYMban0BzXbPM/ywQqbwj71UXvcjGLLE+ZOvcroXFMo8g7ZGDTWWE
         uPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706538686; x=1707143486;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w9KeidiqR8MAtIfEdVgPdtMycQfPKrdz/yD8Mg07T4s=;
        b=mOPXcA7O1NNgIDSM1Q98KGPhU8sRWkPysiRNPwPeP2qzpa6Um6r+tXQ5H/jnKPJmjO
         iHA8rlzOZsLuLPPkA1Io431du7C6BgFwrklHncg8yexFrMKfhaDxiI9xuunBKtbU1KuL
         fvX8dnN7rM4SC5OmuQ9+eAsoP39sHm/58+UV2C21Er+/EqyirUTTDX/rlnJ7yFlJZ5sI
         WjOTYsgo+SC71vr8/ztDz3WjXYy/0RIUPpdKEBkr2Grdp6Ke1VZBUH+76YGtHEnLRVSA
         +ME6unL1QrFi9UTdeOqVyxqKqjqDM/sl6TIeOR3lNXlrCTXbvZzn6tVDBLA/4ZyUmodv
         4LjA==
X-Gm-Message-State: AOJu0YyGuzCGvN853NK1KamjqIOANVG+0TdOEFOh+p6/Wu2EurU0Xn+r
	XRd0y25bPRHe3BIFGP25xm8bnGLOpN7RUchcyOXGzIOFjitVj8DQb+v5zNqSsymS1sPjdz3EpRY
	ElELaLfXMEidR/8uSY/VswK//MM6npA0JN42dfyfrSqK0ITQUqQfjtP936IZu+t2wMLppi+C7HT
	d2RfKKdMV/YsLoGeJQng7XI76mzhTB+C+VJMwnqOPpgem5+NdD0MyXmLRKIWkWgHOM/qmK
X-Google-Smtp-Source: AGHT+IFmNRpMm7T4SIif4y7DnOTK/iyPGRFisyac7gZjgg3Iyy89pjUokfmQzO9MI5sR1/OHmuhlU+CBOyB/mUCf
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a81:9854:0:b0:602:d17a:7f60 with SMTP
 id p81-20020a819854000000b00602d17a7f60mr1840940ywg.10.1706538686451; Mon, 29
 Jan 2024 06:31:26 -0800 (PST)
Date: Mon, 29 Jan 2024 14:31:22 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240129143122.2149432-1-vdonnefort@google.com>
Subject: [PATCH v2] libtracefs: Update trace_buffer_meta
From: Vincent Donnefort <vdonnefort@google.com>
To: linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The current version for struct trace_buffer_meta is taken from a work in
progress Linux patch series. Update it.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index fac13df..17e6366 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -10,25 +10,26 @@
 #include "tracefs-local.h"
 
 struct trace_buffer_meta {
-	unsigned long	entries;
-	unsigned long	overrun;
-	unsigned long	read;
+	__u32		meta_page_size;
+	__u32		meta_struct_len;
 
-	unsigned long	subbufs_touched;
-	unsigned long	subbufs_lost;
-	unsigned long	subbufs_read;
+	__u32		subbuf_size;
+	__u32		nr_subbufs;
 
 	struct {
-		unsigned long	lost_events;	/* Events lost at the time of the reader swap */
-		__u32		id;		/* Reader subbuf ID from 0 to nr_subbufs - 1 */
-		__u32		read;		/* Number of bytes read on the reader subbuf */
+		__u64	lost_events;
+		__u32	id;
+		__u32	read;
 	} reader;
 
-	__u32		subbuf_size;		/* Size of each subbuf including the header */
-	__u32		nr_subbufs;		/* Number of subbufs in the ring-buffer */
+	__u64	flags;
 
-	__u32		meta_page_size;		/* Size of the meta-page */
-	__u32		meta_struct_len;	/* Len of this struct */
+	__u64	entries;
+	__u64	overrun;
+	__u64	read;
+
+	__u64	Reserved1;
+	__u64	Reserved2;
 };
 
 #define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)

base-commit: 73ac9c192d058712993f9941927c924f2e206168
-- 
2.43.0.429.g432eaa2c6b-goog

