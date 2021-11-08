Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0ADC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650AA61265
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhKHIG4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbhKHIG4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:06:56 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4280CC061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z21so13524407edb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pU+NtIrc4CdGL98+rjHnfDjwBrEOwB3aWXlLt46NXCs=;
        b=gHytIe5ybf+bLpTXR24oli9hTB1SId62Rnn3Bm9f9U2FelrzZ6+AUfoA2DZxW0JR4s
         IhzqiLBjloenyN0MAV73eYCOtJYwr9RBB6KEqUTfci4HyBMfAYfE77GwrtWtKKLoSlsl
         tIyMTbOKiw9AI7rpGqXMm8hPZ/5EI6YY/DxsKLc7ev7XpY9Kb5eu+RE3o4JT9J9sGejP
         EU53AJpaW9OxjMLsZeobIMRlXol7XWLl7eogDBFt/zfQNjQxs9z5aXYwzuUz0+nSsEma
         CepFfaxczUO03G/+B+DnlCcHs9SSL36wmn5MGIj7zypJDbi6NJv+SsKE/XrFDVRRiB+n
         yLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU+NtIrc4CdGL98+rjHnfDjwBrEOwB3aWXlLt46NXCs=;
        b=usgpQmkoGAX5OO//Kfk1GrY97Rc/NvzLhtg1Jwunk7/SoFoCua4HrwNDd9Q58HjPj9
         mGbT5pkYDqYmKDZRPRIpZfCX8LqyO8nFyWNI5F2LwIARPwQAUATaJs8DH6hwPLWtbQia
         Sz4fyXX6vc4JGv/Dv0K3wSg1cvrLk9yoIwyUSnQ11ymKepg/jUSjrGvLiuVXhbS8uGy+
         bJnalN22nrocWUpiM0iUfkHV7065IQel5dnYP6qumLbTKODWwM1dCU/zB35BsgGhfdVQ
         3d2QeAnTSjJpjbndmzw86/NDq2tO0dv6dk3MffQ/9iRt4i59Pk80mvIBVf6X3kzjyXaS
         feDw==
X-Gm-Message-State: AOAM530jCLJrchl16YJcb5M1mUoJ18cBLDO3lfpGZit9NAcJtyUR6Z8w
        yguLgHQjziYWF+SzfU2uF+CcXF5APQ9vWQ==
X-Google-Smtp-Source: ABdhPJxRsyA8i6Zw9pacmBHky52wtYPQ5hF3AFX1HslaVXYV4rRWwRThbNK+v3Z9zMOOuLeXZNCLdA==
X-Received: by 2002:a17:907:8a1b:: with SMTP id sc27mr60830266ejc.572.1636358650926;
        Mon, 08 Nov 2021 00:04:10 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 04/12] libtracefs: Reimplement kprobe raw APIs
Date:   Mon,  8 Nov 2021 10:03:56 +0200
Message-Id: <20211108080404.55814-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
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

