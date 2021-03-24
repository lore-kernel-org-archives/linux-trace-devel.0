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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730C1C433E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8CC61A0A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhCXNEe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbhCXNE1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B63C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:27 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1148331wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XWEGLIRdj+57c4CPY7xbrjfzkALdluV2F+0dWMm/4Z8=;
        b=Xx5DLFViugfqpBRQGlScs5Q3eblS0B/NOMpobWYbjF8xldqI5JyGSmKAZ7KcmWLr7a
         Pq8765z/9W7qvhnEbv+2LMDF8rkIwB7wzyFwXt+xDJ/uZi94nDrGdYWdkzZhfC5+z77S
         iULdVjz+zmfascAEh6rdcUsy3OqEMwvjo+J7J9PITYBXqlC+YzqTzgrJcDMptAiKXSG2
         kzd7Ozu7MLf8PjXA7TD6Vz+IQp3kfBC5Ddc8XoGCFDr2LAqiMuB6R5eXXPDEWpyM0j1X
         YdH8WMznirmegODtrWpHxFp/04Da2r3NDRf0GzFAKFYKuOD7AoqvVfnu80Q2v+1ZjiTP
         Y4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XWEGLIRdj+57c4CPY7xbrjfzkALdluV2F+0dWMm/4Z8=;
        b=RthpZ1moxoBe/iHT54kNlhGyEwnkGXGtwOrfMaKDRvhI8bJ3P6hf3p5jn+fGAiToC0
         7/643jUgot3JAwdoRC4Qp1S9rnu5HTeaZKuSwfIYxT37rmu5yVBPad3D6CC6zwoxhGk5
         oxb7BNU5SbLqhKVNqhpbyYxZ/QcL9HHcBnT86HRLqi76HCZZrAk9Vg+ECKGeJ1ElHFQu
         VKA/VQv1yjNLAzXjQPpdKA3xm32qYcTVJcBEgTXpsykumz/qicVIEBQMSoXLKppWTbj9
         J8bnFaKIqvVL7dsBlNLWNmuEtA/P0R8smKa3diphfTrEesx5gzWufBj8QV4eqSqzYnRg
         z6sQ==
X-Gm-Message-State: AOAM532vIRH7TcJCp6V4Z+6rc9C+BXyh8Aw8lM9HEpzqgWZrSWduEiX5
        6ZZWzw2YXd4Pe1AyXQsGGGE=
X-Google-Smtp-Source: ABdhPJx8GI7VRPbXcCgwcgv0x+n6Qj1q6cgwWoP6gYQcCVxm9gZv/8emkfTkUgFo/QYMfzCRrFWgeg==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr2947573wmk.30.1616591066021;
        Wed, 24 Mar 2021 06:04:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/23] trace-cmd: Add new local function to check if a trace clock is supported
Date:   Wed, 24 Mar 2021 15:04:00 +0200
Message-Id: <20210324130418.436206-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new local function is added to check if a given trace clock is
supported by the ftrace:
 clock_is_supported()
This function is used by the other patches from the set.
The logic should be part of the tracefs library, when a tracefs API is
implemeneted, this local funciton will be removed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 635897e1..5f7f5b3d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5683,6 +5683,33 @@ check_instance_die(struct buffer_instance *instance, char *param)
 		    tracefs_instance_get_name(instance->tracefs), param);
 }
 
+static bool clock_is_supported(struct tracefs_instance *instance, char *clock)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
+	if (!all_clocks)
+		return false;
+
+	ret = strstr(all_clocks, clock);
+	if (ret && (ret == all_clocks || ret[-1] == ' ' || ret[-1] == '[')) {
+		switch (ret[strlen(clock)]) {
+		case ' ':
+		case '\0':
+		case ']':
+			break;
+		default:
+			ret = NULL;
+		}
+	} else {
+		ret = NULL;
+	}
+	free(all_clocks);
+
+	return ret != NULL;
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
-- 
2.30.2

