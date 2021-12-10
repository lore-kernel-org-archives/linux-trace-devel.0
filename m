Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48F3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbhLJLJA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbhLJLI5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CFCC0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so28021552edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WX47OPQEx83sN8j6buaugyeSyf6qywAdlZjc3Eu/hMY=;
        b=Hu8lwkLyzly1+Gq7AjnJGR5e3jICMTwou4Xf5s3H5U7X3RCmsbFxaa6eE12Kr3EAMV
         ElOYBWVLJJoCTi6cWTBOUjLlbThZltnl7FuN7zwUPffVA1+QpdRDB0uxPYHPGc4F+DmI
         onZuB77E3orOTKlzLBTQGlsHnI3SzWxzu9ONxgvIzhwRyiKUTFLgYFUveoolYgZHCWsd
         kE2ngy0fDCazrJFGgFNRg7HjYoetcQSfv3wcyzWt0IqkBdqH1/jjeWKemuJesHXRoLs0
         7Bmk7f+xjO3HAsk7gXTIlEPKi2Rs1q6UfLZNmhla9kxnFaddpSDqa5ZLUrZgQ0BtUbKR
         41iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WX47OPQEx83sN8j6buaugyeSyf6qywAdlZjc3Eu/hMY=;
        b=ao4LgdyjoxUDhdMgSefKKr6XvxTlyh/+pGgMxvx13TONwDeUWgBH00K0dnXorVy8gk
         9cG6Kj4CHXUd1DJAWlsUo6mOYI3o6hBSHGNfxpp9eePScEse3PR4Ts+jzP3w7hnTH5Zv
         XPOeUXmJhgr0HNaZlJCc8NzCzSHLCGOxdA7x5liBTY7hhI2JjsNIYvRaUilqeLblB0bx
         lAMsJK8Ymdm2i3pz1Nu9CAErJMAlsgALJifMH+YWjX1xIrVBiDc/wn/2ABlBmDEt40hv
         XFZZCNLEDyb/lsOd3xqUHpEWOWwtdBb5eNgDfOxZfvm73V02d7BuDilRrF98Kl3AEuEr
         cwqw==
X-Gm-Message-State: AOAM531XY3NgXanL9rEG5IfMuqdh4zaDzhO4XsNuPGpwaHCz71AcmvaX
        pVIkXNjcHokTZjmTKG9wM6nxDnTz0to=
X-Google-Smtp-Source: ABdhPJww7GkBYJoCeaSGL7JnhRelKJN+K5JnJzkMg3AwJOTaamEXd6gfEqKFOm/6hK1kl8Y4y/itGA==
X-Received: by 2002:a05:6402:544:: with SMTP id i4mr37804763edx.9.1639134320369;
        Fri, 10 Dec 2021 03:05:20 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 07/11] trace-cmd dump: Dump trace file version 7
Date:   Fri, 10 Dec 2021 13:05:07 +0200
Message-Id: <20211210110511.98856-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index f6d84e3b..1ccdec22 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -930,6 +930,31 @@ static void dump_therest(int fd)
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
@@ -957,15 +982,10 @@ static void dump_file(const char *file)
 
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
+	if (file_version < FILE_VERSION_SECTIONS)
+		dump_v6_file(fd);
+	else
+		dump_v7_file(fd);
 	free_sections();
 	tep_free(tep);
 	tep = NULL;
-- 
2.33.1

