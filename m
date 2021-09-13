Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF79CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9165A60FBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhIMMwA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF99C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:44 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b21-20020a1c8015000000b003049690d882so4049061wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=EZNh+/wAEhroEmroiDPq+t/VAkvZJyc9BiVdXjMcOKROXe4U3TZwTKOSwLjqDez9HS
         9gtTkOoQaETH1nZ4mkCfSFHAQRHmYZ8oJrN2kf9NpDmG6NzEzGFRg7F0erHkn254e4cT
         Rhj5XJjrYBGEP7sUlDmr9T6srWUXMJBGvsDl0Nahno/Fq2XHPWIhjjMQhfKnH4f+DMIF
         NPbUFb+VV3sUSoxx5kWsYaZCjvXB4PWg8w1zoApNWeuWd6ORvNUp9aIJ0z1WkStObIe0
         3wD3o7yC56MDveITHyM76ATJy0eOubCpgF1LVewIHX97P52fqfFEQfbl5QpYX6LNu9EE
         SVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=jlGFy6WSesqfWNpLJfAWUDu7b7pPWJwcr/zKV4SEWSBHl6DOlhuQ4Bt+d8kGWrxp/B
         9tShCS/GmRoVRl2XwyDwpYZB2a1rvGZpbE9MGkII8KUTWKq8H2b/WAdp6I5LbH1zZQ5m
         mlgP0Ym62mP0FfG6+/b2LL1UAY106mRTFRWS6wJuU+85FZMBt+U3/o+kZ/ExWWGfxqUr
         +Bd81EXbxH5iHD5avCcaHTyQmCWoQxJKIDhzZPoCIDw1CXjb0B+RGmcaWedsP90nXQRp
         QE/yVbab/nzH0IHMoVIln2Pl57GXIbiuYtW/nEvGbUf8UtQyhYefZaKp0i2vi8W5jTJO
         LoEw==
X-Gm-Message-State: AOAM533+eC2CksQEK6bKiMxRM8XKBvcTgoVb2Q8bItbFqKKf5JLGRitk
        QWJjddVTC5itAHw8HQo6crln7h6sreY=
X-Google-Smtp-Source: ABdhPJxLvGt+I9R9Lonu7YMAqLMUj8BfPAHsngdPINJEfJbA7XqcF9HJZlWJbUdNUaeg9e1xDHmM/A==
X-Received: by 2002:a1c:2141:: with SMTP id h62mr10154410wmh.117.1631537443224;
        Mon, 13 Sep 2021 05:50:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/10] trace-cmd dump: Print compression header
Date:   Mon, 13 Sep 2021 15:50:31 +0300
Message-Id: <20210913125039.3680986-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
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
index d0278f7e..3cce231f 100644
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
+	if (file_version < FILE_VERSION_COMPRESSION)
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

