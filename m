Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D95C90C
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 11:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706008369; cv=none; b=VoSPYaCjNX/9Y60Zjvm6zvennkbIyDkao5YULZOqutbnGgEh9xIrn3ndKFWS//3gjtoyP/HDiGtOi3r6hcAeuZ27E+GTbtV2m5ClFVx1meKxBtWjs/5vA4n9/J+2M8gtkXRjuZTAQSQ6nKICX5GCY3NaG5xpSRcvMFQBbllnukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706008369; c=relaxed/simple;
	bh=9kasoA0AUkyRYPirUdlaylYrFiADtAl+f+IPfDlcmoA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M1Vd3IONt78jRN4C/eAWB4cQkzsf+rhpgnVD1ea/1TWsB+Y/Eu4obPWO7lMDePstEI9Uer5HnG6IwGebKOHqwDGaXtGESymlppq1ebWHetY/N/MYXYN/V/ICDXWwhvtFgBnZQctaNhKiXk9d9qh5GmUw5CgXDzcdNDV6tV+twRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWEW07Sg; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWEW07Sg"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a2f6476d246so277550866b.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 03:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706008366; x=1706613166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gJRR/IzSUViV0BC63QZ46ioauR86Jy6tNE7A0oYtCqc=;
        b=PWEW07Sg/iGK0zdQdYwqBPN93H7KrcB2Zhp8TwNSaG1DiGriWta1Ew5yZWPREpkuHx
         wEazBxftY7iy8k+HfvMz1lwFC1tHsr5akFz0WN6xUrdANsBpazVTzk+OAYoh0vhred2J
         FcQvnSdy0tCuvWM0jhrJbsKo2oY16kcNT0JH+QqPFV3FQVL6mGfL7r/8FbGBRl/cMb09
         NdILMy65e5xnNPqX6t6oeYFmGyIR4FVlEoTLHRON6uywFQNLLls62hbuOXZPNLZ3jqAP
         v4wPPKDmyXX7Hr1vGuaStkSVdiuhKwZwT3UcEh6GFEV2jeO1Gwzn0hpmRbul94OR+YhV
         pIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706008366; x=1706613166;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJRR/IzSUViV0BC63QZ46ioauR86Jy6tNE7A0oYtCqc=;
        b=jNLeVsKQmeThk8eOZPeq52dlfucB0gxi0SPiI3uHfYz+mjq7rb/UyDUeQ8RDc+aW1y
         GIoOLvQDJl83liwblu9xp/6i/NDBTL01LKy4HrJ/ognMgeXzHwtUiasV5EO1haBguTWz
         6rssK70WHh/tf3HX9ncBgvN9idMvCTaAC0ENZ6MyPKpS2PtOX+4bOxSsamtbPqY1FqMZ
         MeDXgNUBHDVYd4SG1qiG07nBH9RKqz20fe40Bob7dMM2pM3cKYRZ9DupKH87z/p65QW6
         SWnt/Ed/hSuxxt4rhg5a7JTjAK4c2DWmHFifyB/7qYwtpVGG5t+Q289T2w2+4VP92xwZ
         hOmg==
X-Gm-Message-State: AOJu0YwvHfut2lX15J3f6uSTq5hgzFghKl7C3CcatahO9LiumabLoEem
	NinEh9WCChyrYf2zr6z1/oL8uNO8ql++9cr2dHgGlBSkKMUAdDueZEyvHLcc2s42o0cudQ6rMdi
	HFlljKoy2rVomsEpSxxroexztjCF9HjUddVBiqFHeEVxXx9rI4I7zYKN2o19jEKaTWwA8qW61sa
	fOr+p0Nf82rxhb8rgFqKQZkudtz4NvA3MzkRZ/Y2+DezKLzIlt9MJZ6lKpoMV363rUKdK6
X-Google-Smtp-Source: AGHT+IE9mYljjxLSiWt+gsR9Rj19+SRIo6qPoQXU0ealrmqaf1v2HTG8Ms+9k9W+rHNWs4mDE/Ylcr8dijYFPm8Q
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a17:907:8b95:b0:a2d:7f63:dd4f with SMTP
 id tb21-20020a1709078b9500b00a2d7f63dd4fmr21455ejc.4.1706008366153; Tue, 23
 Jan 2024 03:12:46 -0800 (PST)
Date: Tue, 23 Jan 2024 11:12:42 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240123111242.3665230-1-vdonnefort@google.com>
Subject: [PATCH] libtracefs: Update trace_buffer_meta
From: Vincent Donnefort <vdonnefort@google.com>
To: linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The current version for struct trace_buffer_meta is taken from a work in
progress Linux patch series. Update it.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 499233a..d3af453 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -10,25 +10,24 @@
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
+	__u64	entries;
+	__u64	overrun;
+	__u64	read;
 
-	__u32		meta_page_size;		/* Size of the meta-page */
-	__u32		meta_struct_len;	/* Len of this struct */
+	__u64	subbufs_touched;
+	__u64	subbufs_lost;
 };
 
 #define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)

base-commit: 73ac9c192d058712993f9941927c924f2e206168
-- 
2.43.0.429.g432eaa2c6b-goog

