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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13309C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE67060FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhG2FKp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D190CC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v21so8498961ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hpRh7t96oyFAJ+wG6Pr44T7RUZE7tjg8wEUsChKBVYY=;
        b=bj24AicaB4a6nzoys9n4xiGvWjQRYCHPRa5BF/mMN/jHlMOYFy/kcQ9TI2ivoRS4gw
         8eEB/GwppA/e2IfMz/pb84daHwb9Y3cOjNPHDCK3wDtK2LtME4tr2MeLFAk5C+6T77Fw
         zN791IM+fswjUuxlA6z3+IQzLT6+x3Sd4HYDB0JhFNCrmVv9FhqTeI7b2A1efcCt37KZ
         ccwuRwdUid+BYyqOu8D4cu53BqnRFO54Z5s2ykAMcOqajjSUQDbEouPQ2rzV/FSOMIio
         ty1eVt2/7ThdC+Gzcp3P+Wfk+ieOVYyQScNxJnza3RUwHXTMESA+51CQdEJRaSX1DbOY
         WM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hpRh7t96oyFAJ+wG6Pr44T7RUZE7tjg8wEUsChKBVYY=;
        b=n50pfuUHud6rMILxTgv+rUwoNIf0iB/o5zn6Jz55kskavSXJtM6bmh0RNi/08EbHFf
         5kyGGncm2fYivqAsMKyLhJgPqy4PN/77yBxzJqBvAQPstHNQ7Foz6642/+nR0niaKG7X
         CEOG6gO1PQV1UnAi7weg9PzXJ9CxC+UYcAnXpi/CNzm1wjzcxHR88W/hLYcLOXxak0cp
         7xiA63s70A02udSkvqSA7qgNLeZnPSMVPhnN0FHqlrSZU09S3oPxdG8Y+Msf3glNHJvr
         eRqutd+QXbdEDCJv7kE8O5dFUALRvUpJ6hhRFNFRcJLvU2tEThSJhChDztcU/XaR+Ent
         x8Yg==
X-Gm-Message-State: AOAM533iNCC6Pot34DeHwo3zYcHlT4LSp3PKw0pVhvmz/rlwbiett5Ag
        1vDgFRB0Ru3FZ3gef5rB0js=
X-Google-Smtp-Source: ABdhPJwYZhx1XG1RRJlsQ1gFywo2leT3oELoFW0TTSE1RLcazl6ZtnhRywb85wwFJq26TR0itaq50Q==
X-Received: by 2002:a17:906:6d4e:: with SMTP id a14mr2850705ejt.328.1627535440529;
        Wed, 28 Jul 2021 22:10:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 40/87] trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
Date:   Thu, 29 Jul 2021 08:09:12 +0300
Message-Id: <20210729050959.12263-41-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_proc_kallsyms() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 40 ++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e2e12014..99aa33ae 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -845,9 +845,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
@@ -856,28 +857,31 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
 			    lseek64(handle->fd, 0, SEEK_CUR));
 
-
-	if (read4(handle, &size) < 0)
-		return -1;
-	if (!size)
-		return 0; /* OK? */
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size+1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)){
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
-	buf[size] = 0;
-
-	tep_parse_kallsyms(pevent, buf);
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
-	free(buf);
+	buf[size] = 0;
+	tep_parse_kallsyms(tep, buf);
 
 	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	ret = 0;
+out:
+	free(buf);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_input *handle)
-- 
2.31.1

