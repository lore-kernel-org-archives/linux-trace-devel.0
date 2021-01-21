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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC48C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE653233EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 10:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbhAUKhx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbhAUKgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 05:36:50 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF01C061757
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:09 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o10so4709488wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Jan 2021 02:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vD04eZK71m4XkC+i07/YIm11gw/ywYpNzrjDT8awvvQ=;
        b=EIXCMcsXBklDHisyiDwahYV5bz7EHF57iVSAGP3AUFD9s82V72OEdqk1pAr256pPiU
         uclEfWQ3WSsQ7n9r13k2ikd58VMXkZDA5900+MSo9uZemysoBlrlM6K2fxH5Gbn1bMI9
         Myc/rAyNyzQaSrKi3N9cX9kCRxXdSQizClteb11VM8Lu2cIaNqY8MFo3z/pxOukMXKE4
         PAdzp2XtRm2/LEFjgegDOUm4drzrLYD59XRe/va9v+JnsD+KT0RQ1giJzAsJMdiyOyJ7
         YaU8Jl8lfHoZRniExHPQhmAhmAgPp53p2oTExuep6y5zj+jQradxMqMf4nb405/2mqgu
         OD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vD04eZK71m4XkC+i07/YIm11gw/ywYpNzrjDT8awvvQ=;
        b=bWQvRcBS/XnOrHwghq/gzrlT0oP/LfK4mgGkPLpZ/FyULBIbPkIiciF764FO+Imueg
         aJ+etGfmTtOY8AVL10GoFCt8RuuDVONzO8uBOFDzsoiDxnnXOrbyQ9bNI8+J/7K7aYE8
         XL4dwHRTUr97745yaEpc+U9KSUZP2Xswz6QGO1KZ+3xY/juDhp2H9i/AMHqmKcRQcFg+
         EGzLyOuSm4lPwTBTz08ROZmFtlSeV5KeUDTkuoC831n26H9xMmo9r8dFKlOd3VbnFpDU
         G7O1J+efKS/Qmqj7lqC9U0ELAxfeIdY40clk1g5oSKbFlz5i+D7bSS3EidUSgNnINmwE
         0s7w==
X-Gm-Message-State: AOAM530IX9mJ1ebRq2SbLCgN7SkDi1phW4XIFMm+cFMLMWtwFrrzXsvs
        zaomq4HlhHfXKNLXe3+0hR3rdUUbvYQ3suaI
X-Google-Smtp-Source: ABdhPJxHc06Qb25I70gWTOEvvZIjcimYmod3fsC4+tq8tGG4GiW7s9xcSjo9mOF0NnJ8/I0KjsvXtw==
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr8083981wmk.70.1611225368558;
        Thu, 21 Jan 2021 02:36:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm7294123wme.37.2021.01.21.02.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 02:36:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd library: Export 2 APIs for opening trace file
Date:   Thu, 21 Jan 2021 12:36:02 +0200
Message-Id: <20210121103605.224108-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121103605.224108-1-tz.stoyanov@gmail.com>
References: <20210121103605.224108-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two additional internal functions are exported as trace-cmd library APIs
for opening a trace file:
  tracecmd_open();
  tracecmd_open_fd();
These new APIs complement the existing tracecmd_open_head() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h                     | 2 ++
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7dc88cb0..5a1ba6ba 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -12,6 +12,8 @@
 struct tracecmd_input;
 
 struct tracecmd_input *tracecmd_open_head(const char *file);
+struct tracecmd_input *tracecmd_open(const char *file);
+struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_pair_peer(struct tracecmd_input *handle,
 		       struct tracecmd_input *peer);
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 64945815..22e20b66 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -143,8 +143,6 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 
 struct tracecmd_input *tracecmd_alloc(const char *file);
 struct tracecmd_input *tracecmd_alloc_fd(int fd);
-struct tracecmd_input *tracecmd_open(const char *file);
-struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_unpair_peer(struct tracecmd_input *handle);
 void tracecmd_ref(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
-- 
2.29.2

