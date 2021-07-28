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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019D0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E03F460D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhG1NeJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhG1NeJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EEEC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:07 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f13so3187776edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ic8xJhlyJSCo1MuvLaj0vyNt7EBk5JnRJRvOFZn8+F8=;
        b=sJkG9NFIccuJWvfK07L7TUKJqeeTyTInBhcxWKN4I2qxW6JAnv0Fmj+KIcM12/WH7g
         3Zeki/Z+13b+4sfUguXgKjewrwT8FFpUCrOClz5hhybJ3WTrDFcGRoDMe9UU1rO7XnUG
         e3vw/HYoNJ3MKInV5q3zfk4+674hfUFeb1nXtRvq5nBD8+pQCakJyDxC/SteMfcdlPbg
         iPSsnnozKXY36CGBWRoR49LYnzM5onc60UzgGqtYKuj+SAEukFqNli/Ya+wsqQ6kQIfY
         H5bHnQIzBDwHTgrQoxnqHzAmBbOZWbbayq/D5o1XRdag9CBLOW5Eq/FbySxQGU4Lz8Bg
         g4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ic8xJhlyJSCo1MuvLaj0vyNt7EBk5JnRJRvOFZn8+F8=;
        b=EU41FR406iG68GGFybR8xfnlzQc7LxOgKyJM4T9SEKeTC9qE/omgFAFxd1l6AATIcB
         olJEpiPf0TTDIYK15krZvBbgc01+lttNQZ+I7ArE0OSWYcf7RptFuAgrRAKyDSYRshiu
         afWkqmGutDJJ4r6N3cokr6QL86GePLPWv23d0nOVCEoAk7+lu5ZmGOffR7V6cmV4cp+X
         W9x69ngpL57T+Ar4PVWPqk2TRd4DGq6+DJYmMoIpE6WwJkRZnJ8cdTOpjQj2+cPhTnJb
         Cd9jDzpcLExEV6pzx8ELxcmwF9qvDfsiSj1Eeu1stLyQuV2dG/YNpv3e5CGVClPMgsYj
         N5vg==
X-Gm-Message-State: AOAM533eZdjroQitOLf5i2Rs37wNxMapn7toLVApG5X9Fh9ap5HuGEGE
        M6toxqrkl9IEvLWFyNDpRRE=
X-Google-Smtp-Source: ABdhPJzDds/dAQ2XMrSDhmGj53gQr64ST50zdhbNZXet9ouosQEpU7a0iQzY/ODh6x13YGiRYs41oA==
X-Received: by 2002:a05:6402:b19:: with SMTP id bm25mr17016169edb.213.1627479246467;
        Wed, 28 Jul 2021 06:34:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 68/87] trace-cmd dump: Dump trace file version 7
Date:   Wed, 28 Jul 2021 16:32:31 +0300
Message-Id: <20210728133250.234140-69-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 8e95e884..99dc0ea4 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -883,6 +883,31 @@ static void dump_therest(int fd)
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
@@ -910,15 +935,10 @@ static void dump_file(const char *file)
 
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

