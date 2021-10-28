Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01345C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB346610F8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhJ1MLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhJ1MLp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:45 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891FEC061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j21so801055edt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6U++GRovHrbLxMfd6g9LLspUryAfjCsvlEZW6MTxFw=;
        b=S651mPWlufY822f8dWS5zo80+QssjrRvOk746EeeqRP1A731napjM6y2s0gCisz1+a
         IhZxDXDXbJeb9Mgl9C41LjW+HhlPdAk0/OKMTUHsZGldrIhI7UgQiEnFCEWq4+LUfJZO
         Irk4IHErpa8ao2UYflDjYL7utVyH3Kadh0nU1UjtyN0ixvXVtbLrmaOLc3zkuARf5XtB
         amsqU0Uig3JC83R4DwzFTYhL5cn76ijSMAWhg5KE+WTht5X84HVwa+DhVSMvipmDE8/Z
         gvImHj9IqYa2qaChFHAVX17yEPMQUS0byGXmI8T7Zoi8yptMwaN3+g492nNvk+G2dCmx
         sAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6U++GRovHrbLxMfd6g9LLspUryAfjCsvlEZW6MTxFw=;
        b=vW0ljERjRWdEzEGs0J3qr8lC/ww7+MkU0ZVw/Y1sjrJYPvNWhP+Cf6oUERETtufwTL
         8bP6cSP4w66S5tGqWgZ9BOPJXoxpAvwzNpqndepjw8MpvgNyQtdni+XnmtprmKvN3oF1
         d6xN//KlzlRpSQhtEu3uzY55U7AS6LFD/yvB6sniwuX/gHIIkruIi+xuhe/CpFqni4kb
         jQ2xE6lT+ZDoE1cEnt/Gyh2Hq8VlB2plAEVgdzr9Mj4S34vzJk/FIyNRvWFx+PWsEMxF
         gHAApd/6wrcruxekFhYIUDEOiEpJDwao5+OPt2FGs1lGbXA/Wpq8KItn4/M++NCn3pJg
         RBJQ==
X-Gm-Message-State: AOAM531jeSsZRFQyWFMWV0ReF2e5iBi0beVhDD/EGr/ht/K9RUkqwQjN
        uQwHF3uGVL5tGq4nSV65M4WqEyALVrnAyQ==
X-Google-Smtp-Source: ABdhPJx7HSN7m94sip52AanKwYyzfonIYeSNWJpBwVerM7no2dDBhl7pWLaVVoabL9MZtbK1jDPWdQ==
X-Received: by 2002:aa7:c555:: with SMTP id s21mr1549493edr.81.1635422957162;
        Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/12] libtracefs: Reimplement kprobe raw APIs
Date:   Thu, 28 Oct 2021 15:09:02 +0300
Message-Id: <20211028120907.101847-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 44 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 083a3a9..84a9903 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -148,38 +148,28 @@ void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
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
+	kp = kprobe_alloc(type, system, event, addr, format);
+	if (!kp)
 		return -1;
 
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
-		return -1;
+	if (type == TRACE_DYNEVENT_KRETPROBE) {
+		free(kp->prefix);
+		kp->prefix = NULL;
+		ret = asprintf(&kp->prefix, "r:");
+		if (ret < 0)
+			return ret;
+	}
 
-	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, str);
-	free(str);
+	ret = dynevent_create(kp);
+	dynevent_free(kp);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 /**
@@ -205,7 +195,7 @@ static int insert_kprobe(const char *type, const char *system,
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format)
 {
-	return insert_kprobe("p", system, event, addr, format);
+	return kprobe_raw(TRACE_DYNEVENT_KPROBE, system, event, addr, format);
 }
 
 /**
@@ -231,7 +221,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format)
 {
-	return insert_kprobe("r", system, event, addr, format);
+	return kprobe_raw(TRACE_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
 
 /**
-- 
2.31.1

