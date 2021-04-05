Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939A8C43461
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD06613B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhDEOVb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241296AbhDEOVa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E4AC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b7so17085534ejv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2bpfUmF+YwnlreGA7yi828PWj2M/BNGHaLXVcBvWW4=;
        b=baxmwyx3S8N7veoaUuMl2rk6i+WTpAfCX+jbLbpGgGGG4jqWynWQErvQjFlkhy6gF5
         3b278h4oOTLbQ3x2ty4xVnA2Sjk4W3uEm5sjCGK+ydv4tmO75hNtNa9o+E7mcCKfP2ep
         8bx8nPcxa7vORZvqUZ42nxdNAIohTxHWryNql0RmRVjmY56wbQLC+JsQf/YNJprUWYo+
         /2zkTwsk9H4KmW7utalN0JD7A1JTnBBW59GjZMvtbAuemRCEFENe1e5SFHBkw2I5hqSr
         Ji/NIFzbHb3WM8WLZElq4vlWTZCBSWj3NWfQr0Cx/UUMmiwnekX5xMtpRxxBgbruT8fs
         85vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2bpfUmF+YwnlreGA7yi828PWj2M/BNGHaLXVcBvWW4=;
        b=PiZ6AMKh5RCacodlY0QfZV1j7+fmeMPmIV4XteFanLJE3l8tLuqQ7CAMvfFBXxk2Y2
         bStygwoK6nu/TEfrH1pocSR+Ih1fqoP13ZodK4oHbQfx411i3TYui0ysByAHGUx+wBSR
         MQe+pKcZh26/ki0utXYuzDXLiFUHEtv3BV8U2pSjTkLuXzs4/cv8BJlQwfYuKeeeQx3U
         njurt2zbDwyFxggV76CeaaKOAQHu5Q6hj83u51h0UOtXClA2X9LMxbE4M5Kdziij0/Ru
         5h8/lcT6Rr6zmqfXmV9A1gFncy1JaX3NujMZYHmh52UW2DFS33ouhj+Bxl3mt8YIB9dJ
         HM3g==
X-Gm-Message-State: AOAM5313T3G2rg3oTUI3XSPlbGA3aozsBaVQ+a7XbX3Uns2X/lGxDqmm
        0c39PQLliOZ33/AUpFF65jA=
X-Google-Smtp-Source: ABdhPJw7nRVnK+efkG0kzL2c/bdviZobkJBDMe+mLgzWJhf0MDYLcReNU0bHdEehwSTluaWl4/s6MA==
X-Received: by 2002:a17:906:86c1:: with SMTP id j1mr29514863ejy.373.1617632483415;
        Mon, 05 Apr 2021 07:21:23 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/5] libtracefs: Modify the arguments of tracefs_option_is_set()
Date:   Mon,  5 Apr 2021 17:21:04 +0300
Message-Id: <20210405142107.507711-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210405142107.507711-1-y.karadz@gmail.com>
References: <20210405142107.507711-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This function is supposed to take as argument a mask returned by
"tracefs_options_get_supported()" or "tracefs_options_get_enabled()",
hence this argument must be a pointer.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 4 ++--
 src/tracefs-tools.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index fbd7db5..5c4e50d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -136,8 +136,8 @@ struct tracefs_options_mask {
 };
 void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
 void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id);
-
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 51a7971..3b5f773 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -359,10 +359,11 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id)
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
-		return options.mask & (1ULL << (id - 1));
+		return options->mask & (1ULL << (id - 1));
 	return false;
 }
 
-- 
2.27.0

