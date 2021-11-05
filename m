Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD79C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 832F961212
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhKEMTN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhKEMTL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:19:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B2CC061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:16:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c4so13388828wrd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pU+NtIrc4CdGL98+rjHnfDjwBrEOwB3aWXlLt46NXCs=;
        b=BKdNEaj8lBTogocX2wLv+Ozj845XjF/GEg7/WwzXPlL5KfpVJ9NF0tQHzJJLsAjRBi
         V8YTrxwl4aPifzIGiCOO/q8HMCOXdh7pITs8Mez0TQNNMI8PPrIwE2SMN/lfp6Q3u2qn
         tcag3jvVB4VRlosGAeASIjofRdgiL2zAwLjz+N2fJ2fZpIRBqnJtU/8UtTHLQQecspeD
         +Jml8f6hj1Dj6sgc+ajFzOkzx5u4HtjkDRYmWAJY49msobDyN5V0LE0R6Hk3kh4Xmw91
         9pwZgO8kJCjT9VF0JDJ7qmmmlMPXWzWSluMgJThIsULuWkgXSjpHmiLZyS4UFCZDRALi
         P43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU+NtIrc4CdGL98+rjHnfDjwBrEOwB3aWXlLt46NXCs=;
        b=0V99dnoYR0/JOeSORkOsOL4Rc0S1BkDqQfi+4y70p+WdV2trP7JMuQyn4pmDsjVez8
         lnyRnoUxz4okPpJ2diqPXaentGDH6N/MEm5SmnHUdaykr1XyWEPO/rYgzuQWWP1+AC5W
         jDwQ4JgAZvvaXToMrk2FE6g+HZ5/3mSKyX68m5EVDGIystVKKQagAsL4YsgClNqhr7KZ
         FR0Zym6cRq6lS85E12ePl3zeIf8tG7cw55DvhDmbsee/xbhEPFt2VgLrtmD/aEXSmvqo
         VP5FJ+aOUEr2Di8q6QeVOd7j9mqpukB2qHdoSDJDZIeOtTGFthX8vBm82FNw4N8Bckxf
         0Evw==
X-Gm-Message-State: AOAM531/pl3nBcn3wzQr1FVhTsdFaPIwgkK98Tk6OsPwGx6IlgXHZisw
        qgmZSYdwAurP3tdmaWtPEM4g4Zwr021jhA==
X-Google-Smtp-Source: ABdhPJxjUmy1ZtwJz18R/6WMI1KavzznltAV5NvqCy4HhiI0VO+2jboRrBuazrJCPwuQ/F+jygLL7A==
X-Received: by 2002:a05:6000:1b8f:: with SMTP id r15mr73564845wru.27.1636114590412;
        Fri, 05 Nov 2021 05:16:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x13sm7936531wrr.47.2021.11.05.05.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:16:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 04/12] libtracefs: Reimplement kprobe raw APIs
Date:   Fri,  5 Nov 2021 14:16:16 +0200
Message-Id: <20211105121624.398717-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105121624.398717-1-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to unify the code and use the new dynamic event helpers, these
kprobe APIs are rewritten:
 kracefs_kprobe_raw()
 kracefs_kretprobe_raw()
The definition and logic of the APIs remain the same.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-kprobes.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 3f46b8d..a8c0163 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -129,37 +129,20 @@ error:
 	return NULL;
 }
 
-static int insert_kprobe(const char *type, const char *system,
-			 const char *event, const char *addr,
-			 const char *format)
+static int kprobe_raw(enum tracefs_dynevent_type type, const char *system,
+		      const char *event, const char *addr, const char *format)
 {
-	char *str;
+	static struct tracefs_dynevent *kp;
 	int ret;
 
-	if (!tracefs_file_exists(NULL, KPROBE_EVENTS))
-		return -1;
-
-	errno = EBADMSG;
-	if (!addr || !format)
-		return -1;
-
-	if (!event)
-		event = addr;
-
-	if (system)
-		ret = asprintf(&str, "%s:%s/%s %s %s\n",
-			       type, system, event, addr, format);
-	else
-		ret = asprintf(&str, "%s:%s %s %s\n",
-			       type, event, addr, format);
-
-	if (ret < 0)
+	kp = kprobe_alloc(type, system, event, addr, format);
+	if (!kp)
 		return -1;
 
-	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
-	free(str);
+	ret = tracefs_dynevent_create(kp);
+	tracefs_dynevent_free(kp);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 /**
@@ -185,7 +168,7 @@ static int insert_kprobe(const char *type, const char *system,
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	return insert_kprobe("p", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KPROBE, system, event, addr, format);
 }
 
 /**
@@ -211,5 +194,5 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format)
 {
-	return insert_kprobe("r", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
-- 
2.31.1

