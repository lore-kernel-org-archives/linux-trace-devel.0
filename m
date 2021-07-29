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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA40C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03396023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhG2FLM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbhG2FLL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6949FC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id e19so8426787ejs.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZv6utpTkIgjWEWaVEGim6LglWLWmt2byg65wBCXWFc=;
        b=tsBub1ewL+ZXbZyPHeXyvGSJHG2omqYOgU91cXQuKzDCwAaA1tN8w4jL8bKb/PcSEb
         YKqiSyzCFYlq2aXMQLHc+PXU0otvCY9Z5xGGdf82jLZLDKSeDcud4fmA2eKeD5n/eAP5
         jVoriSpluSY7fhvRu6pyRqomMjyiz/U2ivaDTxYBRYcXjU1BaXbayb/h2wjBJtC6/GeP
         /XVeQoNhelB/7oFy7CXK7szXYaHy3FqHbX2bACzSLcUK+eA0Q0BqbATRnHE145y/ta5q
         1pbrRF+7tW8W1InOCrRrS/NjwBCnHEW2s/RS434ilLSdXpkV8p2hYZEEgwtuNR42vGk5
         bPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZv6utpTkIgjWEWaVEGim6LglWLWmt2byg65wBCXWFc=;
        b=J6sTA8/oKVhKT2LCxU1lM6m8IR/VRy5PS2Rk5mEjYmYKIvgl1rrYFrQ9f314GCK9MA
         1XarJeL3bYToZ8J3j2C+K9UcRCXAnGoD975Xn/lXmCek5QN865A1gamSV8NxGTLxHxB2
         cJ0yxLwKpAidp+99l9y+OZPeG7C/tunvx+bKmIeWzD/cxnHnhYwRmkX4qUFXSM6+kxVr
         p8NUZRw2WWLAM0BZVQGUFfLEBH4yeSTvwtuoBNvpq4ETF/D8p8ym0NFxrkqsf0oXBjDS
         OuZ9fnaGo2/cndlbqvN9gjr8FmjhYA0bxDFzGbuR3aKA+vNbT5C+CZ20/RbOsfzJqTG6
         XYmQ==
X-Gm-Message-State: AOAM530gxJraQUUEvSNAcJi8dwuXZESzIbtEQcJ27wJl20NPqtdntFRv
        Ho0BCCjDImRjsocizE9cl2loaTKfWqU/Lg==
X-Google-Smtp-Source: ABdhPJw8YFvOEAmxFA2miRoucu4Aeg/OYGC+xMR7SOFSNCz2oXt9/8pBufyLxsYNRs5ni49ACAFMCw==
X-Received: by 2002:a17:906:e241:: with SMTP id gq1mr3039139ejb.87.1627535467098;
        Wed, 28 Jul 2021 22:11:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 68/87] trace-cmd dump: Dump trace file version 7
Date:   Thu, 29 Jul 2021 08:09:40 +0300
Message-Id: <20210729050959.12263-69-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has different structure than version 6. Separates
parsing both versions in different flows.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 571b6ac2..9088d2f5 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -884,6 +884,31 @@ static void dump_therest(int fd)
 	}
 }
 
+static void dump_v6_file(int fd)
+{
+	dump_header_page(fd);
+	dump_header_event(fd);
+	dump_ftrace_events_format(fd);
+	dump_events_format(fd);
+	dump_kallsyms(fd);
+	dump_printk(fd);
+	dump_cmdlines(fd);
+	dump_cpus_count(fd);
+	dump_therest(fd);
+}
+
+static void dump_v7_file(int fd)
+{
+	long long offset;
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read offset of the first option section");
+
+	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+		die("cannot goto options offset %lld", offset);
+	dump_options(fd);
+}
+
 static void free_sections(void)
 {
 	struct file_section *del;
@@ -911,15 +936,10 @@ static void dump_file(const char *file)
 
 	dump_initial_format(fd);
 	dump_compress(fd);
-	dump_header_page(fd);
-	dump_header_event(fd);
-	dump_ftrace_events_format(fd);
-	dump_events_format(fd);
-	dump_kallsyms(fd);
-	dump_printk(fd);
-	dump_cmdlines(fd);
-	dump_cpus_count(fd);
-	dump_therest(fd);
+	if (file_version < 7)
+		dump_v6_file(fd);
+	else
+		dump_v7_file(fd);
 	free_sections();
 	tep_free(tep);
 	tep = NULL;
-- 
2.31.1

