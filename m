Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1A3630EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKOKtK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237636AbhKOKtB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:01 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF735C061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:05 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so6180641edb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7BUnNNvtelfSsEsX0fj2R1XkVZDYthUXP5AbVuNiHE0=;
        b=K6QRzcDSeJ2+aQWlTFXBC8cNSDoZ8AA1M3NsXT1749x07GCKHKH5WGiKtqp+BmLa8/
         usgNg9uQFb/RTkKOiv1CaUCPDaG6ocSCzfWMQOyj4UKp/I5vcy+STYfitdaAyEfSZgoZ
         5ft3sXgd9Sk4pITRv8RT02RfrSAHTdNRY9JKyjinQQHaVLZ348szHOd9Bb9F6dApUwIC
         kDjoUHQes2BMBtDno6Caq8gqztj5IHvma4LOYyFUdVII4IgMffGDaItJRkqxCXWNHKCR
         /ny/hztnQpho4KWVovo7cl/anwfbXAsy8GzxTZXtTX5xW5Jser1Ay3WiuC6+zemMbC+1
         WNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7BUnNNvtelfSsEsX0fj2R1XkVZDYthUXP5AbVuNiHE0=;
        b=2M9Gb2SF2eFrGEig2jjuOl3uCxKRIR/n8qleMzNiG5hp0d2b3ItL20E7ZUjbPjmuRe
         LGmCteXEQiaJlfhxLAMUfPVwrnYFg8mi1Nf3n1t2RbFLKwOkQY8TMfTCZsILyb7gCspe
         lDOh+OOJDUbFZnsiM2oGBoCRxn9iB7TPyXbXAcoDtdB0tad9tskEPWc6LNZj69GQiztc
         YZG4m4UkfB9t09PuCqUVI4bIyGq87Y+c/jIblTJdzKcsl9TWst76hUK2buUUH2izEG7r
         KfU2MvrsFswLQVtBoBckAR0XDt/tujdGf3bBj/QITqjhq1bAlO8KM/uYuimAulQ0AKt+
         UHuQ==
X-Gm-Message-State: AOAM533oqqpM/vYqgOjuxaOjzNtnfDrG4YNA3GOlVL/RWM/z5LWIyAR6
        M3PM7pFK2LOo4/c0/CEK8XWnp31hvLEUhw==
X-Google-Smtp-Source: ABdhPJzu9P9I05GmpgEM6iLtwDAClal4cxv02t2CpC4tKYvJ1o+iKaypAw5qpxXfFPqw8vl7kJYoYQ==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr54187340ede.362.1636973164344;
        Mon, 15 Nov 2021 02:46:04 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 04/15] libtracefs: Reimplement kprobe raw APIs
Date:   Mon, 15 Nov 2021 12:45:45 +0200
Message-Id: <20211115104556.121359-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
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
2.33.1

