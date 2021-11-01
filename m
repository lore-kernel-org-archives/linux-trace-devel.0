Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEB5C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D8C610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhKAJLt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhKAJLs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:48 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2D0C061746
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:15 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z20so62429424edc.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eik72Va0Nwr+QFsa9dNphmJNqZfqhDyw8NkrD7KwD8M=;
        b=JcnCY+7rXqZJRYYKMr0eVyA/OOtuc7fvEKjYkw1tdZ0ZQxneiykI1n79H0UnnIuAN/
         7VAy4ASxgkzBmTn1wy4xhOSxys66FLVT4RsPYXPpcq9e3iIMFtWwNx7VTxORgFEesiQz
         GysAVpvpH0U9gfGyXRKpD7K98wlyQ5kNz/MX4JuyHzjdTWQsK0Levj9Omb4HAcQjJPqG
         QxxRjien1Bx/nwtcq1hFcgi2XF8shgyFOc7QwG48xYGL/rSdHkxDNKUXjL5TZWLME/bv
         GHaINpo9+PFOIpC/V2ZUxtvwufO1yW1YSJi7BI624WKzAVsOHHLF2fskBYhEa6DHn/jG
         uO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eik72Va0Nwr+QFsa9dNphmJNqZfqhDyw8NkrD7KwD8M=;
        b=JmELiIMHv8hWHtMZhyB2cqxrUSgA9zVM0XIz+u4XePKdzOSQm3fnxvYJG1X3Hs0dKq
         BwNU+WEPprcTNG1bJNKZ48KWvKa0c86fXt9pAHNmyXnPT8rDBBJ4jeGmb8m8GNur0Io4
         DrSvVsSvwE7WhayLVraIXBWvvq+A/Nspa/flbHSu5SgdtXHqCB0zxs0vh5k8daJqLKty
         vCrW/baTo1NP5CT2BVkVBJeMsF17Oqv/yd4v+qhSpmcwPUDrCDMLg3KkQtEO051EEh63
         Oot7rA3Eq83qVRvW9xkVaQXSyFq7iImLd+EF030tfgNNeGj3JLgJhINfOc/s0bKaMoYa
         72vg==
X-Gm-Message-State: AOAM530ovnUvc2hYGR/SKlpRgvR4fJPuowHnO1lYtYRKsoLqHgv4hibc
        07FdyFSoEyc127nEOZUp2V8kOEa53lOMTg==
X-Google-Smtp-Source: ABdhPJy6bgiQbxb/I8e4c7ikE0g8diRyd7KpnqKQYQAK3IrCE1TXrMyNbKK4Nn0wacc/Z1n07qwwqw==
X-Received: by 2002:a05:6402:4246:: with SMTP id g6mr3049960edb.112.1635757754021;
        Mon, 01 Nov 2021 02:09:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/12] libtracefs: Reimplement kprobe raw APIs
Date:   Mon,  1 Nov 2021 11:08:59 +0200
Message-Id: <20211101090904.81454-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 390e211..672e748 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -147,38 +147,20 @@ void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
 	dynevent_free(kprobe);
 }
 
-
-static int insert_kprobe(const char *type, const char *system,
-			 const char *event, const char *addr,
-			 const char *format)
+static int kprobe_raw(enum trace_dynevent_type type, const char *system,
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
+	ret = dynevent_create(kp);
+	dynevent_free(kp);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 /**
@@ -204,7 +186,7 @@ static int insert_kprobe(const char *type, const char *system,
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	return insert_kprobe("p", system, event, addr, format);
+	return kprobe_raw(TRACE_DYNEVENT_KPROBE, system, event, addr, format);
 }
 
 /**
@@ -230,7 +212,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format)
 {
-	return insert_kprobe("r", system, event, addr, format);
+	return kprobe_raw(TRACE_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
 
 /**
-- 
2.31.1

