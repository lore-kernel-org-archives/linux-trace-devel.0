Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195D8C35240
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0DD220708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FOvQwiky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgA2Jy0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:26 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46775 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgA2Jy0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:26 -0500
Received: by mail-lj1-f196.google.com with SMTP id x14so15361008ljd.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fc0j0BiA9SjJB9GgeDcl8wyZ3wbFf9Y07xK8FXQu8DY=;
        b=FOvQwikywkATgZje/FzGJBsoZ1w3Eq+FdKhksTR7Zo/HuNZQZWGfVgs8LgKydT7jOb
         pzU/Y5nwa8RzwokFosy/oFS+sgItABbRl5JQbHoimNUGXl9cHUjiEnGcwF+xwCXD2IR2
         PKzPEYvWfIoUuTFvGgkp9pfiqEjRdile2hnMWBAMMgqE1u9GJNA70LMPXZmewyf6leAP
         aAbYgd8Rh+cYn3eTa1GwdhTaFfY4Ss39ViLzqguifrG4WQjAWpZnNAvvWEVNQoNnWnl0
         PIlU1fvU+WMZbvFcky9c9kZsBOTKFWD2BGBPz6iRIpfmJJXubaU34e9suVs53LvlNbYI
         962w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fc0j0BiA9SjJB9GgeDcl8wyZ3wbFf9Y07xK8FXQu8DY=;
        b=ZoPGrWAHYfIBKUQrkQ93g/qwS/M59B1VItHgQzj915+LZZGFszfkBDgVH4TlONqyf7
         f1bTiiQeIKEyhq67LCmkP7wGmbPsLoOfuFAt3B1CCCGaWin4i+j6LwoP5/tgqIPFqeMT
         WCq6Z7sXXOFutmtFCZQ4KXgxHW3t1r/Dm6yGMh+Cm7rnNP9YS0V8qpycSIOeJqFdiYbY
         PV14EsCprr2/mDaDgt2IDi1R93/2VGb/h+XL+Avf60wy9Dn1lW1qhangB2KbrYmPHHvn
         QF/n3SOo1wY+nJ25Hd63FTqJDIRifuFcOaGzC+TTTJ8D+scxLMPiS3Xf5Ksc6wDI2Vja
         kO8g==
X-Gm-Message-State: APjAAAXGSSOaSlwroz6o+NWb9hCKT/CZbKG103+Y9ao0A6kResq9CWWt
        hTMxp4AezCuUAO8CQnIxTPJBHM12
X-Google-Smtp-Source: APXvYqz9Vz0VYTIhe3EroIrdGGobrL0/i0/opIA9yV4y/K/HJP/oyy+SynUd39bfKbXZ4NaHdXhN0A==
X-Received: by 2002:a2e:7e11:: with SMTP id z17mr12013789ljc.279.1580291664465;
        Wed, 29 Jan 2020 01:54:24 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/9] trace-cmd: fix description of tracefs_get_tracing_dir() API
Date:   Wed, 29 Jan 2020 11:54:13 +0200
Message-Id: <20200129095421.881786-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The string, returned from this API must not be freed, as it is
a pointer to a local static variable. This was not explicitly
stated in the description of the API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/tracefs/tracefs-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index 658c852..de46aab 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -133,7 +133,7 @@ char *tracefs_find_tracing_dir(void)
  * tracefs_get_tracing_dir - Get tracing directory
  *
  * Returns string containing the full path to the system's tracing directory.
- * Must use tracefs_put_tracing_file() to free the returned string.
+ * The returned string must *not* be freed.
  */
 const char *tracefs_get_tracing_dir(void)
 {
-- 
2.24.1

