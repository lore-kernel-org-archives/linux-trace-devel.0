Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACAAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCE861284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhKKPJL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhKKPJG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:09:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A09EC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:06:17 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r12so25358567edt.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E9MjIrTo6m2QewfstLR4i2s1tGW2exN3IoUKp+UkBP8=;
        b=YjALq6BbMyVgQzs1OS2gULyPjXIlm25+nR4x8Q+HZ8I/ffpCzCmpGC/GReh0EFxipt
         kR9E94FWSDxmA+l+/mOe/iSoagHoJlNWvwJGjSqO/7GGCUr40pR/v9kkHmjhIwRlK3Fc
         /rtMuD1B0ZGITU2jQbXEWf1bg/DXkmt9h08NkxJrIpfVIrt4TRgO7BiCxVOoFWDs1yTp
         UJvOrXYAXfV+wbwQKo4bCLl0NPdgn13l6UDAcfEr6JM23sNQs8E4wfS+h8aRa/RtgF6K
         5tfttUyJZLHumoscGlKjsGaUeZDhjzmJ8XfwbWzjby//vIsM2QBKyFPWBlNGHw7NVM8Z
         rp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E9MjIrTo6m2QewfstLR4i2s1tGW2exN3IoUKp+UkBP8=;
        b=6QNU+dc13vu+zb+ocpLjWnDyJLrYBFJRqEZRllUI2beUj5meORgfJ703EKH6raklFR
         +TlwE8Pg/GEA5WFF7QWTIGsLad35bvRRoZTKSUYR8e7Sc3YxVkAP14Ue/DTxu/y7+6eS
         oq8XfS1BS+plGw6EBe8s5jRQT9220+StBqBLXpJEFj1hkfj/ntzIp3r+BGg1gQOLbNwh
         T6f8Ya0OA6fdu3aOzaQl8i7PNz4Q/c2d6D0BfFpviTmGmJgdoxuTAD0E6v1R92Ew7D5o
         qfsh17ptg/wgXrSj1LXlcwNZOQbeDTDFl8GC5DV4fY0J9EvRztVKVXW1uSzmJpZp+VxB
         Lakw==
X-Gm-Message-State: AOAM533LdUJdDa0WxQOHvWPrUN3CLLhEI41XqGqhfgc6Y3wXYbs5YPlb
        DBdCsTUbMvWpWzLQQV6qg0lbPYNxgm7ZTQ==
X-Google-Smtp-Source: ABdhPJz7a+dAPtqnO5RQVO5WPsc+lqeYUoQ87dwVcI4vbcnhZYwqsHTvvO9ueLxXwuP54q4ZN5kVUQ==
X-Received: by 2002:a17:906:6547:: with SMTP id u7mr10211825ejn.544.1636643175674;
        Thu, 11 Nov 2021 07:06:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i10sm1595339ejw.48.2021.11.11.07.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:06:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 5/6] trace-cmd library: Set the correct file state when reading file with no kallsyms
Date:   Thu, 11 Nov 2021 17:06:14 +0200
Message-Id: <20211111150614.86172-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The kallsyms section of the trace file can contain no data, this is
valid use case. When such file is read and parsed by read_proc_kallsyms(),
the file state should be set to TRACECMD_FILE_KALLSYMS in that case.

Renamed a local variable from pevent to tep, to be consistent with the
libtraceevent prefix.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index edf84993..f02d7e31 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -741,7 +741,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
 	char *buf;
 
@@ -750,8 +750,10 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 
 	if (read4(handle, &size) < 0)
 		return -1;
-	if (!size)
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
 		return 0; /* OK? */
+	}
 
 	buf = malloc(size+1);
 	if (!buf)
@@ -762,7 +764,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	}
 	buf[size] = 0;
 
-	tep_parse_kallsyms(pevent, buf);
+	tep_parse_kallsyms(tep, buf);
 
 	free(buf);
 
-- 
2.33.1

