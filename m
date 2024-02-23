Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9133D6C
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Feb 2024 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708728456; cv=none; b=S2dF/jX7USgt+HcA2u2Rc4NCAoZH8nmSfch+hQFVJaCjZ4TOWDvby3XenB0+rtNlFaE5nYnfjg2VR16/KORfQK14hrw1sMthMRUPlgFs4+2xHlNGeodljvImQ7FO5AuZpyRT/MyeipP39fnS/BM8+0QpHVGkGTCR82w6tX4qAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708728456; c=relaxed/simple;
	bh=HB7NX9KLgfFMWgneyP8B4M2E9t6aHEle10uCwuKmF9U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MV8eWYB4PGoqibzKqIsB9YyR5b8/HmOePxPnD7ef+Q/2mYJ/w41q1L48BdkdsQauGZdCYmNoAt9Dl7lzIRw5/6K5b3HMgJpZx4CD7BE+zmkAzWgkvq0h1Uf0qTH0x14QaPHSf9rlzvBBk6guvQkE62mG6r6t1DUBM/4LoNZuTBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c1hvwlNo; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c1hvwlNo"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4129653080aso3854355e9.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Feb 2024 14:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708728453; x=1709333253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OWi1/as6Mzj+F66nZdvAMG0D8xaNQ1BmVWyRB1TAj/k=;
        b=c1hvwlNoBgEDWSaTPs7I0xzDhLtYV9ugoxFsUo2iI99lE9WGEwuHtkgRfQVkWU5Hrf
         oFWfTmpVx3NmfiYZQfupUkQyCNgdvJ2XIf2BAU/VaWe+7YNiukQJsLf/rWvKOlVEZDbc
         je82Dq7KpcohgLWtsDl6Ka307ppDC0JwXfv3HGZgw1P0dnr4OO1NGx3J5v9apw+950AZ
         DwFRlimrggCgzoKHEoK6bYNbOq4UEsjHAc6sHLaEK0l1I0VATRYGfiz5m01LOp3OvJ0I
         zU73C54yuSfSXpfrsZHBKChsLsKfyCufZeNtbF4PnWeLdk4UGmoit9WEyJsYmYhcG+kK
         cxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708728453; x=1709333253;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OWi1/as6Mzj+F66nZdvAMG0D8xaNQ1BmVWyRB1TAj/k=;
        b=fa5QAO9DIw9Zbsmjr0SucWqVO7Z2rSpGpw2+swI6jdRZC2YBPEzkPCcnSHCa4uTpLc
         jLo5NZASEBZr9k22Dic3w0+lQvTFdHhHq2rTLqMxWd+zeyoYW0Ho8Tye8yygdga7LzZL
         ITqVvNGiEN2scchH5YMGNHM9jQ4hOOCVCS4hAC4Hip3+gXHbrB47NmffWGCQTVvJt6Ph
         9hbeP/6dDbwqUKDWNsj1eCMtu+Rb5zzF0GJcJVO2Ugs4QHJN7fM+tH52DQCCF3byXEE3
         sw2R/6XmPPxx0Afx+osivNg8ps0Dnd+fdBLTxM5eJssNauGQncdOPsVIQiDW9am3PHxe
         jXxQ==
X-Gm-Message-State: AOJu0Ywmm5Aw2e+Acgzbl4cNMIDm3cbt1m7fr2XgFFJsKhGORoOdS+PP
	Z6H/QBm1klDa/8fI9Ze863hfyN7aQyWv/l8/lwa9yj3i7tfffZbC9KE+BXbu0DZqk5wYPB9knil
	gvFXeC1DvToMpHOLyUiYHugHQ6ET8N/E/VbWp8fFm2ePQrAHd4Vr0WRSML/9oi/UQcwNK8Ik+6m
	msbXZiZf+E4bXdn8p7UqBRdjOZIEntxqSaiSMhaJNWJfH/gTyPSGuiDS45OSN5ZiipHucK
X-Google-Smtp-Source: AGHT+IHvfMa60Pa6svweK8AyqrPmV+GbgryMQfyyTB4ZHWmAyD7L9pTedyj4AIw88deXWCJwhL6YNocgbScjAtqU
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:1e12:b0:412:989d:6514 with
 SMTP id ay18-20020a05600c1e1200b00412989d6514mr2383wmb.2.1708728453114; Fri,
 23 Feb 2024 14:47:33 -0800 (PST)
Date: Fri, 23 Feb 2024 22:47:23 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223224723.132673-1-vdonnefort@google.com>
Subject: [PATCH v3] libtracefs: Update trace_buffer_meta
From: Vincent Donnefort <vdonnefort@google.com>
To: linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The current version for struct trace_buffer_meta is taken from a work in
progress Linux patch series. Update it.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index fac13df..a0130bb 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -9,26 +9,43 @@
 #include <asm/types.h>
 #include "tracefs-local.h"
 
+/**
+ * struct trace_buffer_meta - Ring-buffer Meta-page description
+ * @meta_page_size:	Size of this meta-page.
+ * @meta_struct_len:	Size of this structure.
+ * @subbuf_size:	Size of each sub-buffer.
+ * @nr_subbufs:		Number of subbfs in the ring-buffer, including the reader.
+ * @reader.lost_events:	Number of events lost at the time of the reader swap.
+ * @reader.id:		subbuf ID of the current reader. ID range [0 : @nr_subbufs - 1]
+ * @reader.read:	Number of bytes read on the reader subbuf.
+ * @flags:		Placeholder for now, 0 until new features are supported.
+ * @entries:		Number of entries in the ring-buffer.
+ * @overrun:		Number of entries lost in the ring-buffer.
+ * @read:		Number of entries that have been read.
+ * @Reserved1:		Reserved for future use.
+ * @Reserved2:		Reserved for future use.
+ */
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
+
+	__u64	entries;
+	__u64	overrun;
+	__u64	read;
 
-	__u32		meta_page_size;		/* Size of the meta-page */
-	__u32		meta_struct_len;	/* Len of this struct */
+	__u64	Reserved1;
+	__u64	Reserved2;
 };
 
 #define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)

base-commit: 04505a07824592f039eac66fe565994635eb5d5d
-- 
2.44.0.rc0.258.g7320e95886-goog

