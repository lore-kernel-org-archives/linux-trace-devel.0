Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD0FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 246DD6112F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbhKHIfc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbhKHIfa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:35:30 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F40C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:32:45 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v11so56654797edc.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJinter6hvaTZ7hkhe49ZloOXDQE1dkoYVML+Ac3us0=;
        b=jUnu4DH6l0bf+6q1Nt0JXq6POQni6sO7wPdi9HfxdT1nj2JXJwsCzBeWUlJbhV/WUE
         2Z3QziS+qrFJJ8jEVbZuOP7x7262Pizdma7twTADZGHZHaJyClkxuK7fVFqP601H715I
         2UNDn49HKe9VHkGrFQDZF+ugF8cLHCDDMD8awSaiZhl/rSKGNZnmF8YjGc4dvPw6szjd
         elRXVrMWVFHjKx3uVda7F0Zng5g3rCA3HsTeBwYkRUhE2eB1hjTrzSnWiCoV9/JBEsn/
         d3mW5KEQ/gPW+IJ0OWULWnirnxZM2d0xWbNGyQm7zCKeMvDdBZUdzqPb+/Niu7yg2QkW
         K86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJinter6hvaTZ7hkhe49ZloOXDQE1dkoYVML+Ac3us0=;
        b=eJQ8bjJi14UpgT5t4D46QbP00zI5UUVuUd89cqGAGrfMg2ZgjbNjttlMowKXYVgdVF
         Dl8nRa46cFdcnA0z9A56mL7yrk49MOOCr3gU4L54JRLuwjo1aNL8d8PrT5cUy/vg45dv
         fHRH4avWTuypCNq5kJWJZrTBuk5aJktkAhAjvj3mknNj36KMUlSnluGZ/uIiLMAA3/FQ
         f9EbW+lkj6aCoV7OSELDc9iGdhn8c3ASfXA8/dtxKk+t2c5Fa6Qa991zpKaQhKbM8XJZ
         IzkHL5aZshGAvlLXNfNg/pJRJFXKJQtp5huinsX1m+jvGy3h2JBJ98yjlDbUEcuXW+fY
         Un1g==
X-Gm-Message-State: AOAM530uKwapvX/D/kfPYBCtaUqpZLwa+IQZrBaZ2K31WZdyIGBDOAQH
        d5UUpC6x3RAVXBCN1ax2yV5mlsCau7BNfg==
X-Google-Smtp-Source: ABdhPJxieC07cNJ3HKx/2kiqxx7VUYeG7uHygP226wZZd++YVLcWmboNuMs7doj1ox0lyr/FLYRtqg==
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr30752606edb.158.1636360364432;
        Mon, 08 Nov 2021 00:32:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id hv13sm1550525ejc.75.2021.11.08.00.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:32:41 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Update the libaudit warning
Date:   Mon,  8 Nov 2021 10:32:39 +0200
Message-Id: <20211108083239.65459-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the latest Fedora (34), the package for libaudit library is
audit-libs-devel.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index f4e7a98e..6a2cc3d0 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -21,7 +21,7 @@
 
 #ifdef WARN_NO_AUDIT
 # warning "lib audit not found, using raw syscalls "	\
-	"(install libaudit-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"
+	"(install audit-libs-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"
 #endif
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
-- 
2.31.1

