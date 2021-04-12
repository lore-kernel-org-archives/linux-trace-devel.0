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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF48CC43461
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 967036120A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDLEYm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 00:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhDLEYm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 00:24:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB97FC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:24 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e14so17954557ejz.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eRN40LuzUuqyOiJ/hfYY0BTbF/WCKqocdnHeHMnTWy4=;
        b=rmpZ+AvKm69ZWQv72ZFybKVRUH7L1l5Gi0XDDu3ErqzsUmH+a0KplOGJeeXxC1hoWr
         4qZv5zrVzc6kar6pqcb3WudadFuLqChAu/l5PoTeFOrOf7bP0YzbUiekFB4CMacS2+Et
         Z9Rc+qOlFAKxDGmJhMzaKO+yJhUF4rEjORGLsGha0M1py77PgSDcuBLkYDUG+dCOhAF5
         CR5Lv+hwgDDgMWic5KoGeNKG4ejLKI6unTOBcnthzR0+qlM96j5JIqh4+XzCSBNwcuxF
         rISzm6Ld4gokUaa2J3xFTyo862BvX7APsCZstGgk1LrMc7LsZxSh3CRq06Kdndy8atCG
         biUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eRN40LuzUuqyOiJ/hfYY0BTbF/WCKqocdnHeHMnTWy4=;
        b=iULTqfi2B+iJxhonYM/TuE0ZRTRViM/uPIxFhOfk9pCWHgKGc79kb5roOLuxegjxmA
         5sIzoOjMwtU3ztVgQRyPwCLOVfewPncVlbeGKjuU/YTw4bOwvCy6GcKD1FuFGrKjQqon
         Wqq17YB+MKQnVP8PSEDywdiat9/zRX1o/uoUku+wMpjD6a7vecNFkgwfYuleuzL61nOh
         uU3MpmBKPbIJBtOtorMVR66lz1q5NZubAcr5gBZdGYnAWT+nYOb7aT19JteZDj3M33S/
         c/UYJ85aM1K6h76HsGWiHggfo6OEldVUXgc3DZLptie86jWiVgKkol0HZC+4dHVgaoC8
         AmiQ==
X-Gm-Message-State: AOAM5320m+l72euiPAiTcbMEiIa8T3+SuFYLdS/ge9BvEpZNGIv9I1t4
        oKADWmRY1nTr7XPdHzVa5CY=
X-Google-Smtp-Source: ABdhPJwbm5IFNlVwfHHAohGUfBk1D1ugSLFKY4ZExm+7UXVLSBwRdrApfxfm4d5mD8c14MpElhZfBg==
X-Received: by 2002:a17:906:f42:: with SMTP id h2mr24936591ejj.317.1618201463575;
        Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bh14sm4926786ejb.104.2021.04.11.21.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:24:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtracefs: Fix loading of saved maps
Date:   Mon, 12 Apr 2021 07:24:18 +0300
Message-Id: <20210412042419.3295237-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
References: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The internal helper function, used for loading saved printk formats,
kallsyms and command lines retuns 0 in case the given file exist,
but is empty. In that case a buffer is not allocated and size 0 is
returned. Logic for loading those mappings does not handle that case,
which leads to memory corrupion freeing invalid memory.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-events.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 94573b3..3a6196b 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -603,7 +603,7 @@ static void load_kallsyms(struct tep_handle *tep)
 {
 	char *buf;
 
-	if (str_read_file("/proc/kallsyms", &buf, false) < 0)
+	if (str_read_file("/proc/kallsyms", &buf, false) <= 0)
 		return;
 
 	tep_parse_kallsyms(tep, buf);
@@ -623,7 +623,7 @@ static int load_saved_cmdlines(const char *tracing_dir,
 
 	ret = str_read_file(path, &buf, false);
 	free(path);
-	if (ret < 0)
+	if (ret <= 0)
 		return -1;
 
 	ret = tep_parse_saved_cmdlines(tep, buf);
@@ -645,7 +645,7 @@ static void load_printk_formats(const char *tracing_dir,
 
 	ret = str_read_file(path, &buf, false);
 	free(path);
-	if (ret < 0)
+	if (ret <= 0)
 		return;
 
 	tep_parse_printk_formats(tep, buf);
-- 
2.30.2

