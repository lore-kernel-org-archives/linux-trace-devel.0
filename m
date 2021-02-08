Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EEDC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C45E64E59
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBHGSf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhBHGSe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 01:18:34 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB10C06178B
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Feb 2021 22:17:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id l25so5474271eja.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Feb 2021 22:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZxQKytp1O+WX+MFBeCcujLCAGzL6iIOfe+UPe4Qe8J0=;
        b=oFV9apd16kmMa5utB6bL4cywgDm9ZlcG+WPYgqo4kbq17EwfwQQUJjvu+sTfnbWHdp
         vIwWUkfX3tgYw5Z+nyJOn8p5v1yegKHwWhxWfG1rYNBrqn7IR+UfLq53KzBZqK2Yr85p
         ljvM7g109yJ/u9s4DuBj7hDfbojFrZXU7danxpgh6LE0LoGtOMtIw+XXPqlqfQrGM6rq
         y+UWE9lMzU5E34lI+Lo/8B0ZZ8xihX3+vIWlyiHgIPxGiqX+MRzspYjP4el7YfGFD9sY
         QSo8XAMi0+5I6CRc9zyCk+C8SuTtGsK7f7/wquCZ70x+WsgLpJ2LAcxA6wsJq9gX6lA/
         qGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZxQKytp1O+WX+MFBeCcujLCAGzL6iIOfe+UPe4Qe8J0=;
        b=dE8gKxbnDUcEB0EaH4637wAK2BKbqc9EcX8pA8qxijf8ouYv0YkLinZnKSkWmilk8L
         leaGs/AuEn+fEMBs/YUsPiieDL68XMKZyF8myyvguIGtf+IUISJKoaPeQKVQB441dowH
         MsO+Freip/gbNezNw2nvhxpmP8S+Nx7OYZ3cP6dhv0tKnuSMClh5p7z6deR16kHNoXHJ
         w7SLeyWOHtVzTUylZ/PvqiWRl7sPZZDOyHINs+rePXpa/XORiFZpujVdDWJgaezLo/KW
         NGdFJh+ats+CIUcrFMj9NRvc5bMWbqKOHFjRRCABi1wfG3oeTgdTeLpS7V8YN9vahkYx
         yQ8g==
X-Gm-Message-State: AOAM532xOF/xHh/JBWTF97ubCRvIlPxW6ukjIQpbxvF3ZNSWwWeXKqW1
        0T5YNzKQ8rUjaWOmosyPgLY=
X-Google-Smtp-Source: ABdhPJyZT3O9GzoAiRruE079iKHRAvIcGsoq64yRSvARHPYqJvZhLea9z50Ov9BrQXDuNCmfV60tqg==
X-Received: by 2002:a17:907:2a85:: with SMTP id fl5mr15238763ejc.554.1612765071134;
        Sun, 07 Feb 2021 22:17:51 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 35sm135618edp.85.2021.02.07.22.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 22:17:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v28 3/8] trace-cmd: Removed unused s64 define
Date:   Mon,  8 Feb 2021 08:17:38 +0200
Message-Id: <20210208061743.510964-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208061743.510964-1-tz.stoyanov@gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removed a s64 define, not used currently in trace packets.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-msg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 611af2c1..c4943165 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -30,7 +30,6 @@
 
 typedef __u32 u32;
 typedef __be32 be32;
-typedef __s64 s64;
 
 static inline void dprint(const char *fmt, ...)
 {
-- 
2.29.2

