Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB18C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346825AbhLBMck (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhLBMcj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:39 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28113C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y13so115260398edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gCpS+fcA3sOrLSl9R3BhH9qJggh8STZ7fo9+83uT00=;
        b=kWimwHVV825SGYiYe5ABqgo8sEqp71Yd2WhDYox4r8tdiqpZYHzVh4z3TYEcT+deWk
         HzPVAJ3wyyGnZBPzwmW6bHwhtDdXJcvh44+Vu7pqTkmlD3jE67jueb2nM+y7qIUB4+1M
         WYDA+f/e45CciXRdjQQPqv+Chp1sRWV8S3UhotxNhT+pxK+QqPKa+kt4eKTnRtEal51e
         0SVa11XDc0omuU5jN7AkijheFYoDwbtwpwY4f2g0FFcULZmptX2atNNzCm+ZHbskWpMP
         6eg0OzJV9MBcI1TsATpZtZrUb7ojJKJ4nEReEMSPxYGiaW0hyhb0Rk45oBhMD833l0gu
         avqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gCpS+fcA3sOrLSl9R3BhH9qJggh8STZ7fo9+83uT00=;
        b=EYt9O+EjobpBMFJmYpStp7u2LH5R+84fTbFymxexerhqgqmuT9RLN+pGVh5cgRgOGH
         mLK5KRSGQCjO10h8yC+cmFdo+ymR1vdpejHSb90B+nKXHvdo0ywcdHZ60qw4LmiE1B6x
         i0RgcGz7CMn8JyV/TUPqfQWVdddKiw18IHyJjpzdVVB1Lp4I7728SnFNts6W/W5wvlI1
         ThKpZmwUvm6FJ3wVWloSIbw7O+irjwQQTNBB4VA5SKfLkpmQypQ1Ner08eVatKOpeZUS
         k8uOCIZm99K1UBLLlBb08j9Wi9d+gkLU+OLSh4JqTv8dvrvvsq7qWTkBFm7fWwbO3mBe
         m1KQ==
X-Gm-Message-State: AOAM531Hu2X1Nha92WQgBwN1pZ570D30AZeW9K+f9qVAqakxC85Hv1sU
        P4iFPAIS6Ou5r01TeLx5jDJbblB7djU+8g==
X-Google-Smtp-Source: ABdhPJzBIq2bRrHdoTkvddxvXMrfq6MgvUqglufg8xKQy/yeFjZ++yPdnA6XyCUYF50EXHFGI5Joig==
X-Received: by 2002:a17:906:48cd:: with SMTP id d13mr14565228ejt.35.1638448155807;
        Thu, 02 Dec 2021 04:29:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 07/10] trace-cmd dump: Dump trace file version 7
Date:   Thu,  2 Dec 2021 14:29:04 +0200
Message-Id: <20211202122907.44008-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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
index 2f8cd5fb..11a6e1df 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -929,6 +929,31 @@ static void dump_therest(int fd)
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
@@ -956,15 +981,10 @@ static void dump_file(const char *file)
 
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

