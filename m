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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B02C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E2A6121F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhEQNl3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNl2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAB7C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n2so9262840ejy.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DE7IG0BcWFqttkSphNV6FPXme57AvRKb/PS7r+vk3bk=;
        b=k1hiyA6EuXnP2IHdHntTzY4XCVFZRgfXYCS/uYUku8n/LFtTsFIrgkNOqv91J97OuZ
         Nh7Fu+2exYXhbYcJ+kuXXmhU6ABNn6ZxauYb+yIo9d44tNz1ESEeU1raQNw1j3sKAo3G
         VmrAadv5DwZkQqnrjHiKk+Rz9RKst8xg7Dhk5UQH2RqxM0zv02tKDGqLT/HLoj6fVUJg
         DqGIGySF4KK7GkiblZ8CUApjitqQq+2kxm7GCZkkSikr6yFGZrcrj0efhkNn/Zcb+W/v
         V9vyxaOzmKb5d1ikfAiKTdZduYssBj+d0XaX70YGlUq16bAetLrC8fE7879IanG6TC3p
         w4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DE7IG0BcWFqttkSphNV6FPXme57AvRKb/PS7r+vk3bk=;
        b=Ed5gEHSBU8UqLpAYSE0GvwauNXa3w8If/bofFGFEBRlOQwiRG7yWl9ta7m3mZ5bBLS
         S7aZxCVM4NxiXR+innXDinr/nru8HZN3aRJaw1t7fywl8p1Xc0a6rjllhLWej5mbAGHO
         ojVi1euTCI4V3ditv8b6OvZEyTvS44U4rKLSj61JaBILn6yQc8LhC7OoeAWTIotR6zG4
         BS6Gq05nZkwUMgHsiNuCH/nnMAEoy37jX1FcfdjdxDBLN1Oo4lnG8rCBqLvz/4BTQi2K
         TxQiQA5sqV5+MQvCXIIwcVbBqkACa145gxeuq9MI/kV4FREi6p4dJ7hyCRYD8T75TKr0
         rNsA==
X-Gm-Message-State: AOAM532lCZKruDUq6AqsGm/AekqN8PQdnzWs+12gTvzqUVTmxq3NE3op
        3qt+KwmhJsClchjFPZAEWws=
X-Google-Smtp-Source: ABdhPJzq2FOEIvZPpyj+Fbug0QqmY0l+sATywr0KNJczunI61at1PgkH1D8WIbjKqx5qmmFL+Gda6w==
X-Received: by 2002:a17:906:44c:: with SMTP id e12mr18421056eja.57.1621258811228;
        Mon, 17 May 2021 06:40:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/6] trace-cmd library: Set debug log level in debug mode
Date:   Mon, 17 May 2021 16:40:03 +0300
Message-Id: <20210517134005.611251-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the library works in debug mode, set the log level to debug.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index be9fcf0e..b65f9dec 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -93,6 +93,11 @@ const char *tracecmd_clock_id2str(enum tracecmd_clocks clock)
 void tracecmd_set_debug(bool set_debug)
 {
 	debug = set_debug;
+
+	if (set_debug)
+		tracecmd_set_loglevel(TEP_LOG_DEBUG);
+	else
+		tracecmd_set_loglevel(TEP_LOG_CRITICAL);
 }
 
 /**
-- 
2.31.1

