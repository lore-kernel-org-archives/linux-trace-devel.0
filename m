Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B9FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1BA610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhJ1MLu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJ1MLu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690ABC061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r12so23967475edt.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akQzZgBjI6nbqVpWTSjXjrsovzXSpLnqRfVY2Y/4Fho=;
        b=OoKdVpWhHDzGW6R7tmoBGoxZje+jM4bUzQ67/UqwARj5Nhz+AlAaWF4P+OW14Es5qs
         8JW0zaPcfc/GGlwqSTUV/Y5550ONx1OwQKCjoFDvVY1js22ex9J0+0yjszk4IQbjd5QA
         UWZPDhMxpD5x2nN+1hPiVumeQv9Gymd3zc8rwZxRWshGV1aIRsi+PnHe6bPHrNP9FH/Y
         A475IFVKa5tqfB8gndeCmeCb1x3Y75djrSU+Quj91eY8StdmAS6i6uEysVg1xuUXMyNR
         F/viEnPUlmqCFdxewnMj5xqcUi9GZ5/oVYTmp0BV776Optq0Y0v7rVJk18fEIDWOKB3a
         Hyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akQzZgBjI6nbqVpWTSjXjrsovzXSpLnqRfVY2Y/4Fho=;
        b=dMwCbwvf3UgGC0yPxxTBgdHEVwuCWod+NnAiLN5TkOYgRRzgcW+dt3Wy8rrA3yyDqX
         u7MwBRnCdBoA1tmXIuzbz/GGWSMlW8wzQzT4Ba3EwHpCSSQ7ZHeinYWgt8l07AgpAAnC
         XeXjf+pVHJdLVNlWpTCceuPGkNEmLe9BAU6kIUkO0Zuci0LtBOLuu+OvWIoH59HADtCq
         gGOZSss0E8Cg7JfmrAfaLmsWjee1bHgVQH6i9bZLpvEYFUBzza08atTicQgw02wBaU82
         x8CRxrnNajoRbEeBbJDHG+JVVGtrBpLHI/HpjbuySK9p4JYB6Jx/8sX4HJnhUhBqBHDv
         kfQQ==
X-Gm-Message-State: AOAM530UiS4iOK0/t4elCxcNYjl8C90CghBAZt1eTEoPoXlJA/g7kT8H
        s6Usah9UH+o+BBFr7duRZEc9vAXsUjP1HA==
X-Google-Smtp-Source: ABdhPJzVkajY4R3QdcjGSGetf+tCgeCA3alTgAVfPOmfVrDZNxMgimsi1yBUPDzuTxkNJvTKIG1Exw==
X-Received: by 2002:a05:6402:14cc:: with SMTP id f12mr5632023edx.242.1635422962031;
        Thu, 28 Oct 2021 05:09:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/12] libtracefs: Document tracefs_dynevent_list_free() API
Date:   Thu, 28 Oct 2021 15:09:07 +0300
Message-Id: <20211028120907.101847-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly added tracefs_dynevent_list_free() should be documented in the
library man pages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-utils.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 41544ab..2908d41 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracers, tracefs_get_clock, tracefs_list_free -
+tracefs_tracers, tracefs_get_clock, tracefs_list_free, tracefs_dynevent_list_free -
 Helper functions for working with trace file system.
 
 SYNOPSIS
@@ -15,6 +15,7 @@ SYNOPSIS
 char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]pass:[*]events);
 --
 
 DESCRIPTION
@@ -36,6 +37,9 @@ The _tracefs_list_free()_ function frees an array of strings, returned by
 _tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
 APIs.
 
+The _tracefs_dynevent_list_free()_ functions frees an array of pointers to dynamic event contexts,
+returned by_tracefs_kprobes_get()_ API.
+
 RETURN VALUE
 ------------
 The _tracefs_tracers()_ returns array of strings. The last element in that
-- 
2.31.1

