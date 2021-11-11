Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9803C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4250603E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhKKPPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhKKPPq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:46 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5CEC06127A
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:57 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id f4so25358491edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/LcOcTAQq/E0EFpf44euFOpIpRgzGloaNazoVxOO5cs=;
        b=TxV6oe6XhsI7vfMIo3quV6Z81t2r+2WLUb8JOD2oRuVl801/2BjhD5s3lAA9Cupyqf
         AmMhsst3Wk5nfsofRJr+bybcqlgQkwzXRXa7Ams2tv0oDEDsBGr8+AE6QZH9brXZM8bm
         uHegJn4Og/lY0byKYEDIlfafCox5WC8g7QoH/wkJhKWDa6hV1PCCI17JaJw+G4xydOqU
         tOzpzlhllHLtOcPPL87AU49x4pbDCPmfenzWnvCSDx0T0Ue7KubylbJHS7Kw5wH2Ruv3
         ICmHmPDgDbcEl6ckTnjQTdwV44QIcOEArjJ5m2936uq3L/GYna6l2QFEMQvmoB78FXfV
         4yXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/LcOcTAQq/E0EFpf44euFOpIpRgzGloaNazoVxOO5cs=;
        b=As3APYnqB8EDsNZVXHke8aDHZgPyEtApPU1OrrlhfxeFGttW0F072pWm4yPQOAXh4q
         346z1uWC0O9ivNBqugzMdyPsZ+SVm6ZjPvMh1FRTtyA/24WVXEiQppJ8v82H8DPo4WTK
         /KgzvZ3aL/VPamis1BdCbGq+tGZgNeD426xGL4wFfYh/rj3T1TPdgAeUUSkVE5zVY3dQ
         3z9Sm+pe7bdV8OQkLCeg8Lsf32ujw8BQiZUoV+qG0FbhTyofBZ+WuimXLWg7nVNuwHf9
         xTchxuCz/u69W4kyGYn1OQyEd2k8T+yEXV4eOKKLng4rxXxGU5lpsCJ+bytvIc49jhvN
         eE3g==
X-Gm-Message-State: AOAM531BCGWrVd/KqRAFJHepyd+IV/6PR4tByBxuEDD4meZiBBK4cJnU
        yEUVKgvuC6Wp+r3ML7+w9L4MytrnJKHfbw==
X-Google-Smtp-Source: ABdhPJyO7uyD5i0zXu4RtKeQBJ5Z4XOb2nQtWnC578YkjFSTFpYi7CV6wBfB4HhyBDXRVqnAVWExBw==
X-Received: by 2002:a17:906:3056:: with SMTP id d22mr3983981ejd.548.1636643575692;
        Thu, 11 Nov 2021 07:12:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/10] trace-cmd dump: Add helpers for processing trace file sections
Date:   Thu, 11 Nov 2021 17:12:43 +0200
Message-Id: <20211111151250.87023-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local database for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index a1fc6d7b..e3c40a0d 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -43,8 +43,18 @@ enum dump_items {
 	OPTIONS		= (1 << 9),
 	FLYRECORD	= (1 << 10),
 	CLOCK		= (1 << 11),
+	SECTIONS	= (1 << 12),
 };
 
+struct file_section {
+	int id;
+	unsigned long long offset;
+	struct file_section *next;
+	enum dump_items verbosity;
+};
+
+static struct file_section *sections;
+
 enum dump_items verbosity;
 
 #define DUMP_CHECK(X) ((X) & verbosity)
@@ -768,6 +778,17 @@ static void dump_therest(int fd)
 	}
 }
 
+static void free_sections(void)
+{
+	struct file_section *del;
+
+	while (sections) {
+		del = sections;
+		sections = sections->next;
+		free(del);
+	}
+}
+
 static void dump_file(const char *file)
 {
 	int fd;
@@ -793,7 +814,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.33.1

