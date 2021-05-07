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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2704DC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE876145D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhEGJym (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbhEGJyl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5DEC061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b17so9546149ede.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIYSV+Nn83OaVWLnEwvJcj4u82LxV3VibYgN2+ygPgY=;
        b=jYO+FIKHQvcxrY8zFMQjql5EYFEQvoSAvc9NtunbYsJxLUZxDc0qMZNxT0DvCqHFWc
         RSdfS6NuUyIWGQPXTbNbUryaFgNM20nCS6QBGqO8MfoKhUQHGwkVUzOvTbQZBi9s58n/
         kkY26bS665BOvl/N/JH/G61FYm/VPq/47XlL7sVD7uPqrK16D16TtFDOXrYY2iUZ1yja
         k2TjnAH0smN5paTiWiw6hKcTxJKuO2UhFQMQR1OqtL9ydWmB9aEzxoIvEFMG9p88e23q
         MyAXEkJV3v7K5BDzP5AYE+zaWhZW9wm8MWTqECbti/Rf3hbuk+saqULcCTW2Yayb6JPY
         Dh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIYSV+Nn83OaVWLnEwvJcj4u82LxV3VibYgN2+ygPgY=;
        b=ovUDJ29I9v1ycrbDv6byvNMinCJQTdDtYDPoY5WcoFbIoEch0qOCYHQrO6UJNXLhvp
         42cC55x6s5ig5JoV5F8p3cqLjqWB/OVxwL6gnHkkCgfhvqlHVNiztafFjN44bEBWmIwn
         A/jmjWUO6xv5us/BMLxe2FLFtGOlAm+620uGA/Aqo2dhmWnMIJNLTV8iwPP339P7JALS
         QUjKIDWZf/OoxshOjS9yQt6D1+6UGMuc2cPYvqtH6Wn2k8hz251YrnikgFeZi0OhoJuP
         ouZslIt4DRQdUELFHyMIrnLioV3V1e9t6Get4VD7xMN588a3A6wnVIPSQQqJYyNDa2bu
         /NQg==
X-Gm-Message-State: AOAM531KyFUlcy1dhgoDm2qZP3p80nZZTmWmzCPlcIFhz0wZQ+eCKHfW
        vhjfzVM2QQ8dcUcBO+zaSa6jcMRxsX2Fxg==
X-Google-Smtp-Source: ABdhPJzgkg3Y4058+R6kgc/apmfyayP04+jqgoF9d3Nq51URY3Pb4gdLaC7esiJwp2xswP0mTwMI/g==
X-Received: by 2002:a05:6402:d05:: with SMTP id eb5mr10231237edb.6.1620381220366;
        Fri, 07 May 2021 02:53:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/8] trace-cmd library: Set debug log level in debug mode
Date:   Fri,  7 May 2021 12:53:31 +0300
Message-Id: <20210507095333.1080910-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
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
index 3b2a9183..995f5786 100644
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

