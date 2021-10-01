Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D7CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6108161A50
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbhJAG3B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 02:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhJAG3B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 02:29:01 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F50C06176A
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Sep 2021 23:27:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dj4so31826105edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Sep 2021 23:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8SOynpQtEXrbaiD2T+DZwBu+aILM8cDbHJ+8A4v1Sg=;
        b=XET2lNMHDJkzOmU3dJsEbJkqe/76M6GNYcseRSqkcD7Ux/mR/IQj+9D/szrdfRdGhR
         07HTmvqEwJjf3ubpoM+Dr/9cZ5qNeaDCXdkPh2/pkGqOOhX42Fd1f7DBnZ88S6wPIcZF
         gVinjOvpjzM8eT1gn/IDQjXP+9XLnUZtXWiNs8CRGIQX21oEIT4b0Sxc0ax3Kj441sfX
         +9A7TgnZ0Z6z2kQ0Cm4gIXb2hAV5NeUXQE1wcgLxHIh7EiQM1Q3Y29l8GlpCr4hq6ZwR
         bqyqYARJYrsAGjWPQ1UMlhwHqNGabO0blrBOm4cyRN8tDLaHPDIXyEsqF50K66dZRjDZ
         2m2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8SOynpQtEXrbaiD2T+DZwBu+aILM8cDbHJ+8A4v1Sg=;
        b=o4GRlol8X7FzcqXYBIPDW62Xzf+vDfY3mEnATf2l5jLtfLMyY6SioIJIHXcISO10Qf
         te0DiDAJziCaTjO0DqVa4YifCm8hPgem+m/2UE+u0mMqYZ3N+ZIJDosC1N6xgjGrq5X6
         Cdj7EKVrrCg822YnfkaEvGeqivOBxZQ2eqf6sfBmSetsZ7IQyp+TVM6DcJv4YMfPRrBb
         vjsk0HirKHUrpSY0UTkYW0dp4EzteqsJrJGOeSTMiqNcFpCz0FR+2uz5aFJdpbpoG9TC
         gxebRqdlMCxYgKmuGtsYeJLXCthUCPIuhy86wD4EsKYVFgL8cZ9vm04qsVLbX29qqpW8
         s3Sw==
X-Gm-Message-State: AOAM530mJLNBbRIV5rFto3AT8SWtjgprI/ArwDnQRGD/8Tio1ZCTa6RU
        /fnL+afXSz3thg81Bwx95qaWjP/uMXs4dg==
X-Google-Smtp-Source: ABdhPJxbW6ngayVAAgC68HbGWwBkKefnwgE+I5dnni4meZj0D1GfQzQ2Rk6K0CWp0d5F3j50La2ssA==
X-Received: by 2002:a17:907:9604:: with SMTP id gb4mr4364662ejc.142.1633069635828;
        Thu, 30 Sep 2021 23:27:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n6sm2666479eds.10.2021.09.30.23.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 23:27:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Use the real trace buffer page size
Date:   Fri,  1 Oct 2021 09:27:14 +0300
Message-Id: <20211001062714.2390383-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When new output handler is created, it assumes that the trace buffer page
size is equal to the system memory page size. This assumption is valid
for the current ftrace implementation, but it may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This commit depends on:
 [PATCH] libtraceevent: A new API for trace page size
 https://lore.kernel.org/linux-trace-devel/20211001062338.2389024-1-tz.stoyanov@gmail.com/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 52 +++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a8de107c..f4177f54 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -921,6 +921,56 @@ static int select_file_version(struct tracecmd_output *handle,
 	return 0;
 }
 
+static int get_trace_page_size(struct tracecmd_output *handle)
+{
+	struct tep_handle *tep = NULL;
+	tsize_t psize, size;
+	char *path = NULL;
+	char *buff = NULL;
+	int fd = -1;
+	int r, s;
+
+	/* In case of an error, return user space page size */
+	psize = getpagesize();
+
+	path = get_tracing_file(handle, "events/header_page");
+	if (!path)
+		goto out;
+	fd = open(path, O_RDONLY);
+	if (fd < 0) /* old style did not show this info */
+		goto out;
+
+	tep = tep_alloc();
+	if (!tep)
+		goto out;
+	size = get_size_fd(fd);
+	if (!size)
+		goto out;
+	buff = malloc(size);
+	if (!buff)
+		goto out;
+
+	s = size;
+	do {
+		r = read(fd, buff, s);
+		if (r > 0)
+			s -= r;
+	} while (r > 0 && s);
+	if (s)
+		goto out;
+	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
+		goto out;
+	psize = tep_get_trace_page_size(tep);
+out:
+	tep_free(tep);
+	free(buff);
+	if (path)
+		put_tracing_file(path);
+	if (fd >= 0)
+		close(fd);
+	return psize;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -980,7 +1030,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 			buf[0] = 1;
 		else
 			buf[0] = 0;
-		handle->page_size = getpagesize();
+		handle->page_size = get_trace_page_size(handle);
 	}
 
 	if (do_write_check(handle, buf, 1))
-- 
2.31.1

