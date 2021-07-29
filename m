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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4D5C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F7D60FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhG2FLH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhG2FLG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937FBC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:03 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qk33so8388454ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVgcQ054TzlseuUkjG0ta+zXAdH5bdxjdFF14khoTQI=;
        b=fs7KeWEXBvsl+5/x6EcQXLVF2u/pPesDTNOEqPCgLFUig6gazsvLoQpUktcQ/Xyimb
         5N2J8QxJDaxZh2JaeeCzwlaKV9WW4ooPvoB0tafjyVsoGYdYv1bJb9XjODa3wfwBxGbf
         9wcN63HTEzWiQLPUPzq2ICQXiZHGuu7VWzAJUU9Oj5HWgGoWfgH/jBHhwgS4OJ2k6Jge
         OPKVYJjXn3XwxuJD0QqhWgusSLEAKbMEG9L1fLkL7VI2sbZUcz477K0hrChXnbMK0sOW
         HgTUmaiqWo9rF/hmR8KI6W8IakxVc+jeAihe5Kni4YGTxY4T4/fAaANN8xDrCeHXAN4l
         Z5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVgcQ054TzlseuUkjG0ta+zXAdH5bdxjdFF14khoTQI=;
        b=gRXZzjCgRqwf8LvlAruNtVvW6mDQvDZeMiUnV3TCfRBrCcHZXYOsfq2F1J50FNi0mn
         SJYwfT8krDpe6fkoZwPK4+LGfJJkjPZp+R877lMSbEGJv8uxhSUITiI5LKilbBEsZMJG
         UVxTXYFYuM/aLWhh2cKV87pgI0YBPLneBu0LGgPBtsgGXL3vy1SC0bHIVV808fWJoHio
         seMG6sBF3iRbijA6ugh4iBDuvAqHICw+gQePjWxe6HZavCIKqC+hEI14GpTxZHZja14d
         7NPtJ8T2QkiMWk0nxwA5hej8L5pQVkdGBucFx51YyfaZB3BbiM2xxe0rkp6mm/la7BXY
         jV+w==
X-Gm-Message-State: AOAM531/yIlZqwv1xMGuiC5DUBnGEoYXve4v2UJHAq3ETv/KcQFwwtiB
        whoSOqE23wn3V7FHgVKHw/k=
X-Google-Smtp-Source: ABdhPJxaQmmLEHM7ANdGNftErjLIX5rvBjfDobBdrSIlAYMHLa7Cl2ln1mB1JU4/nV02/NmfUHZvSQ==
X-Received: by 2002:a17:906:a24c:: with SMTP id bi12mr2887633ejb.530.1627535462284;
        Wed, 28 Jul 2021 22:11:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 63/87] trace-cmd dump: Print compression header
Date:   Thu, 29 Jul 2021 08:09:35 +0300
Message-Id: <20210729050959.12263-64-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Dump the compression header of trace file version 7

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e150a17d..e6f774bd 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -217,6 +217,29 @@ static void dump_initial_format(int fd)
 	do_print(SUMMARY, "\t\t%d\t[Page size, bytes]\n", val4);
 }
 
+static void dump_compress(int fd)
+{
+	char zname[DUMP_SIZE];
+	char zver[DUMP_SIZE];
+
+	if (file_version < 7)
+		return;
+
+	/* get compression header */
+	if (read_file_string(fd, zname, DUMP_SIZE))
+		die("no compression header");
+	if (read_file_string(fd, zver, DUMP_SIZE))
+		die("no compression version");
+	do_print((SUMMARY), "\t\t%s\t[Compression algorithm]\n", zname);
+	do_print((SUMMARY), "\t\t%s\t[Compression version]\n", zver);
+
+	if (strcmp(zname, "none")) {
+		compress = tracecmd_compress_alloc(zname, zver, fd, tep, NULL);
+		if (!compress)
+			die("cannot uncompress the file");
+	}
+}
+
 static void dump_header_page(int fd)
 {
 	unsigned long long size;
@@ -715,6 +738,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.31.1

