Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C40C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A196109F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhKCPrF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhKCPrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:04 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A45CC061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:27 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso2211804wmf.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSMAJ01LS/y7mukHCTMxlvD1U2S16GHAhL8uRiol210=;
        b=CCbjLkAG7mlq2RXc+iGZUcKDEb78z5M2mo8pz9enVvWN8hCx20ic6c6pccBiAHMArB
         uQXZvcbFmR77WtwwbLpZtTbdW2H+cK32dW4rkICeelIfkOzLGd+Im6DE/9xi2PkYfzlh
         KJPX2RFYDZMI3QSReTYh4q9xWemr0eXgfXyfGaZJXqQ1md/+uj2IHgIXS7m8thx9nB4P
         Tgr6m5rQOpj0jyyoh7QAyytr2uC5O7g2uS0BxeOf0jSU/JRHjrbRaGG32pUKwh/TDZ8G
         pr4mOeNPqZ6qMsB2TknZGArvqrK4Qx1BsvgCspCtUldu/5d4JMOQIKcIZNs7Y8RQOgWP
         GmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSMAJ01LS/y7mukHCTMxlvD1U2S16GHAhL8uRiol210=;
        b=AqBh9aQC6h/dJ327MbFuZ4+0CJZW5iHgKoCPFXASS+ivlkxi1ZMSJ3ty3bGMT/xUg7
         D716OR+F9i0y8KvH8BD0t6PJA6Vs5He7Et/rnV8qnPQAjz+JrHOXj3RKgz5Cr1HBwAwF
         sDCUMHwPi0ZWF0L4m4lH0qy0gcbQeYyoe30JyIePw18BYxnXluLMZCSqH9evyvfH72GT
         gPCOnd8gRsjhY1z3qe1fn87su187lNunzvuNP8Hu9XSnJ1/hVH/yz0yLBE/s/O7MWmOp
         IISfaQN2A52vkmjJTOQnAdykDjp+1D09i9tvVdR/GDvAPiTMJcTHbtEaly3uzkkF+/3o
         ecIg==
X-Gm-Message-State: AOAM533u/dPVKaAyiUdni4apvXVOTGY2SLmS6MV+m6QZdIZ6vS7k4jtN
        2KbbZDHM3844hSfFrJblj8c=
X-Google-Smtp-Source: ABdhPJxUp4l017Z3LxXIDdNt72zURp/OZYw7qInNtacqxiOdsSKXWNDj8Z5rSn2lbB9f4ILZc+pDzQ==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr15939963wme.116.1635954266187;
        Wed, 03 Nov 2021 08:44:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/11] libtracefs: Reimplement kprobe raw APIs
Date:   Wed,  3 Nov 2021 17:44:12 +0200
Message-Id: <20211103154417.246999-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
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
index eb71df3..767a878 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -125,37 +125,20 @@ error:
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
@@ -181,7 +164,7 @@ static int insert_kprobe(const char *type, const char *system,
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	return insert_kprobe("p", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KPROBE, system, event, addr, format);
 }
 
 /**
@@ -207,7 +190,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format)
 {
-	return insert_kprobe("r", system, event, addr, format);
+	return kprobe_raw(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
 
 /**
-- 
2.31.1

