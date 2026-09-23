Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B057C719
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197055; cv=none; b=JzBfpCR76fDhKu7EAFrwdUBjfJabCfHSRGeuugT4LnaCW5UDQ/4PZWRd1BVyCgc3kqTM4JZpp2pD82UVD+XKur9RU21BuuGVzejHr82Gl7lTDxEYvAyVAn3zwbvAFrXf/sKVF0JcVoNqcNrE1JH7lRjQw+SyXt4XshTB/hMn6j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197055; c=relaxed/simple;
	bh=Bn8LFUHmD2a4J3zwi4WbNidlMqKJpJftqcgfm1qEziA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY0yZMxTCXvvhKSjsPXhTkTUgXwAFGRo6p4S0CDSIEP4B8YAUxyrXMhOrpg/wL9KaJwgtro6kgV6v6819o1XOl3u+41c737bCauKdmGNjdqiSliQvAT0efPhMsEgh7AQiRCCGFSGfDtW8MbhQL+EVQ9HIKJVdB5AdF/kCEYEnRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=GBZgBOrA; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="GBZgBOrA"
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E390E3F4BE
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790197051;
	bh=/0NsjyvOIdRXg4hir2QHmnaw5Ls+xli2mMYzp/utBBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=GBZgBOrAMvyypBGKrmbwyHa08rpcXbLQKXH00QRMgciry+Np4f+BT9KmxEM9I/9Pw
	 CgfTVkDkXHJMxBKfsp6C5Lokiv1upJHWOlH5T5eJW3UtJdWTz2JWL2MPaKDBIqGj84
	 F0gaLfQASdenGpOdapDjyN+CVj/ToZy2HYB691eTN4NWI6v/owDm/HgSaRAI9uSfc7
	 USElYyHbADf7WiYXUrlIRirtRKNHTJtoOQL+1y1v1I8yuU2a9b56veA7kBCszYmF85
	 NfCTeB5YRNvi6h6ZYQZLNmwrFPl2jNfybZVDwl1TVBQ6kTXxuA4z3+tRka5WrBUXVo
	 aX9XxbMuhgdFOgVH++UizSzJYkv13Wb5Yri9GnsBp3gHM4vlRjtJolKAPpdS+dzYOp
	 yd6+TVJUjNPXJkR8fQvEPtuXPcdiHYuSu7LsUm2cES4HN2mkMANBExbhCWN3k1FalF
	 j3YUOLccsT/DBLrbWsOKozkEk2qnieJ8qbWkpQUJF8lBiBZHDn8WZby/XY7rUyuVvI
	 KKFyR0CRsqh6S8xEuxn4374DdQe27WpgakpvUYfZxyeRLdopO65w1X2I5rWpPaXlZt
	 PDJnGbfR3rl+Dd3dQmjDoYrkZ3qaogvWLZFIeHIQrdH/uQh0wpG9z4b6pZlDZmDsKu
	 0zAnp1O82briK5nmoOzzzesI=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e73659ac5so19337235e9.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197051; x=1790801851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/0NsjyvOIdRXg4hir2QHmnaw5Ls+xli2mMYzp/utBBk=;
        b=XOEWvSQDfNG8fzfjUPDhZvqU4tFGjJVqQ4qu9oLBWIKvdceLaaPhjjTb4PS9voYUyt
         m0uyU7Y2XwXUR7hAHGsP5p/SpeP+gvu1ppS4Ukz6RbNNrwM5D8+Xp9hzAwyXtTqLXvpX
         2H81eRte9MpBaGfqory9bjeW0IzgZKVxX4t5jMQk7ku4ZkH4oQv8iiCYdajp5yG+9DXM
         lGHPO8B0CqneagSJJYB3BBBQvwq+n1+NEPUG0SgPOdUFZJ7H4g466F5c9a2gqHR6uVDT
         OV72thT/c8eZTCbZl9n3xzvBH7xQtwh4o8hbsv0DhPHDWhmx9iZuDS8zSya0wWspFWqR
         8yBg==
X-Gm-Message-State: AFuF++lYyfomUZN6HVs6yrrOI0KASgYyVRTiu1rZABVyZZMn/V/YwX0f
	wdJ1ImKdA9mFj50t/Tlix5a6IVCoiZgUjPC4XWp/Gktt3foaIFinOsEDCXD38mNN9TNFw2s15Bd
	Rx3TivYb8n71ekGJi19tAsNIVWwW34qV/C4XIy1P6JvRvRv1ihqtNZjlDgEfcUZgQxY54RT/Qwx
	IZZly+VLIpDdfQ40RLy2LAke4=
X-Gm-Gg: AYBFou0yFcb4EoGmgngcC+v79qJt2QC9oCPgYws4QOOZiZ3z2Q7AuO6lMp43kcayb90
	oe5tGziLaeSrcL+QkgcrY1INTXvkO9Qd+eM1uH3l6WfT+WSqGIKSOIjceKyt3yu4moikqy5IynD
	qi/zjcBObj7wt1SpP0KeEtfFVl4sqEsJ6s+iL/4m3PsnFJWsSkAyPiBur5LOtwBgc8bp7FlvHoy
	/S2aL8uldcF4JQZBtlhilOAb4MhYYelj9vVOjYRxlN1f8FT7SoqTCV445Iqb2gGmdgt0HOpV5TP
	Uj7m5WIaTah3X9Xk35gZV0aI864oi/W9WzJ70qs5KCwbjcLZFS/0RVB/kVE3mv7l86+B35u+++2
	7yVfb3ZnG51qmnYrOLAMd3NnbR9u9Df2MXEEGTRAGeTq6Ox8NF/A3yAdSIVO3rXjHtChgqAnNmU
	G/LD9IEVI=
X-Received: by 2002:a05:600c:1991:b0:49f:d6b2:4dfa with SMTP id 5b1f17b1804b1-49fe66c5281mr6848785e9.4.1790197051593;
        Wed, 23 Sep 2026 13:57:31 -0700 (PDT)
X-Received: by 2002:a05:600c:1991:b0:49f:d6b2:4dfa with SMTP id 5b1f17b1804b1-49fe66c5281mr6848625e9.4.1790197051261;
        Wed, 23 Sep 2026 13:57:31 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5b646sm35538545e9.4.2026.09.23.13.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:57:30 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH v2 3/3] libtracefs: Support EXTRA_LIBS for utest
Date: Wed, 23 Sep 2026 22:56:32 +0200
Message-ID: <20260923205650.2638166-4-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923205650.2638166-1-benjamin.drung@canonical.com>
References: <20260826163726.1fe4677a@gandalf.local.home>
 <20260923205650.2638166-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow building the utest against the system installed libtracefs library
by tweaking the make variables:

```
make LIBTRACEFS_STATIC= EXTRA_LIBS=-ltracefs test
```

Note: This still requires making `tfs_find_debug_tracing_dir` available.

Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 utest/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 9bd3dea..bcb87b6 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -14,7 +14,8 @@ LIBTRACEFS_STATIC ?= $(obj)/lib/libtracefs.a
 
 LIBS += -lcunit				\
 	-ldl				\
-	$(LIBTRACEFS_STATIC)
+	$(LIBTRACEFS_STATIC)		\
+	$(EXTRA_LIBS)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
-- 
2.53.0

