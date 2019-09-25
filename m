Return-Path: <SRS0=n4q8=XU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6576DC432C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3521C2082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxbVT+no"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404302AbfIYLId (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 07:08:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404293AbfIYLIc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 07:08:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so6311031wrt.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Sep 2019 04:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ivwn9SWap7yue6yaYYURYHF9bZLaU1Q++8aiwI7tmnk=;
        b=DxbVT+noXP3AkPaDwBBBOx0H7ergjuIxIb3dh2hm8I7MD1KolkPTvkYmqqcmity1wG
         Y1Jo4M/FCpQR87BMgFfp06yLLajKMFPSo8udB8NapZEs3E9KQ4C0ouNA+IPhwPDep65/
         suzbm7CU4B0/rOqhWw61z8KaY8I7+yW1QK7/X8Jsb0GBkBAf2zaVnIDJihRKwkb0T307
         vlQmQeIpNHa+duChuGPWRRXpqBdDoOiDShfK8SOcghoAVwIsg35YwHbVVVU7qZ+8/+xs
         PSikeBk/gYxKEnBActQJxHQkKcLCJRvwWcId+jEVKbAZ8tSrIWpY3n91ucm1rrJXfPZ+
         2+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ivwn9SWap7yue6yaYYURYHF9bZLaU1Q++8aiwI7tmnk=;
        b=H9+VKVKEJzuEnEz6iRY0dnrsxDyUecLtDDBQ9HZdDiC8wtetZUlfaCRJtUWgvenvd3
         A0lxsgwfnqdCywC5BRE33MO7lGfJ1ninEEfY/uoMye9FNqPKhXV9JIKuFpHV2b+uf5e7
         47LoQhW+/R7QhcW3YoNoffjvekUGVB42vjD1QH4Yrgpp9D5xsslw1nBH1AYhH0uPw4QV
         acVRQFNMYkq90bDL+HoZ9S+8Xt5RhbRu37RF7IwEiLgBMNyVygQEIKI+Hxc90ZJt+6Ua
         ugG2fZxIoAsD0gz3A7e0ZFev6njlrJxNPIs032utSEXNxoHwPyNZEJT/dhJF36W5F0I7
         m9Xw==
X-Gm-Message-State: APjAAAWTMtV8p6VUcMeT3F7NXOrUjw+s/QPlKUkfh4XPk7GGWGvHe4+L
        hAWEo7W0mTgf5DT/YdvjZ+ySrxtL
X-Google-Smtp-Source: APXvYqxBrFww2KRuWJUUcNLqQNubsAYeHcC7XGQ3lKLLUSgsFNrBfMChvQT9qTEgxg76faOAetKtng==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr4000123wrs.179.1569409709763;
        Wed, 25 Sep 2019 04:08:29 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm12277619wra.70.2019.09.25.04.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 04:08:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Reset CPU mask to its default value with "trace-cmd reset".
Date:   Wed, 25 Sep 2019 14:08:23 +0300
Message-Id: <20190925110823.1242-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190925110823.1242-1-tz.stoyanov@gmail.com>
References: <20190925110823.1242-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"trace-cmd reset" command should put all ftrace config to its default
state, but trace cpumask was not reseted. The patch sets cpumask to
its default value - all CPUs are enabled for tracing.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 69de82a..c41f55f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4096,6 +4096,24 @@ static void reset_clock(void)
 		write_instance_file(instance, "trace_clock", "local", "clock");
 }
 
+static void reset_cpu_mask(void)
+{
+	char str[24];
+	int cpumask = 0;
+	int cpus = count_cpus();
+	struct buffer_instance *instance;
+
+	while (cpus--) {
+		cpumask <<= 1;
+		cpumask |= 1;
+	}
+	if (snprintf(str, 24, "%x", cpumask) <= 0)
+		return;
+
+	for_all_instances(instance)
+		write_instance_file(instance, "tracing_cpumask", str, "cpumask");
+}
+
 static void reset_event_pid(void)
 {
 	add_event_pid("");
@@ -4808,6 +4826,7 @@ void trace_reset(int argc, char **argv)
 	reset_clock();
 	reset_event_pid();
 	reset_max_latency_instance();
+	reset_cpu_mask();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.21.0

