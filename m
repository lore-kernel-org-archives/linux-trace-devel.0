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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E8AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6EF60FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhIMMbS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239987AbhIMMbS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:18 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B21C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:02 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g128so2086488wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ct8SU3vXBeHq1mgavDX/5sPlI71Foyy4FsHNm3PvdDg=;
        b=LiQye0+gc5j9Gq4lqJGLadgbQGLItU1WoGGU78SwN3W4NgnkRHS0mtPp6nLoNkGYqZ
         cRfDnmrjflBxQ4HbBp6fmZx8xUW7xjU1FmrBcolQ7630sjq6USQiOeYiosHphX5HjULP
         R9hxD2Ad2gmA7IQ3PWMoXRb5eEBrlJ4T26x/+X52JklOxgcZEEZUzQPK+GLO6a421Q0t
         Ay9pIlQ60xbZVakd/PubgxVeWd2eZTua7mhQ+yYOGetHBqPpeYgM4Z6vdAuG4+V/WVMX
         8ceSy+KIJec08w5m4NXC38EfOyHmdVbzlKF6U5pHynKqOoP3foyNhOzqhuGdfkls+kGU
         WH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ct8SU3vXBeHq1mgavDX/5sPlI71Foyy4FsHNm3PvdDg=;
        b=4YieW8/VvVz2pjql00nUVw8UU9YUS+Am0bfwsHbiC8cCzkjOLw5DM39QTwilqB3toR
         WBRAYjT9z9Eucd0zJjGAE9gSuSkWye827TJUrdeR3yAzXPwN7lhufG2M6KAPzCyQQYPf
         xxvobDT2nUINHcnNbfIsmJdBnPt1a5T7dhq/aON8RhHeK2j0iBlXRVTCN4SQajAumPqk
         Bebps+4yx2V3R4Aqbbn6j+ZqYvTvWJA6U8lOuuH1qIKGZgGhETz7FhfNNc7J8jPPP1+t
         q3TQGvxKj8JtizZdhhG2qM9F62AjS/i+ZXjI8s7dY7Z2v7lomqnCUcyxza7KaULHxpnM
         zaoA==
X-Gm-Message-State: AOAM532WWKdVhWWsmKPPa2YOE4J58GpIevvzDCEOpZu2/aA/an2yZFSB
        aPN2tRbeDfrQrpHc3ThwCzPxcGFvz1U=
X-Google-Smtp-Source: ABdhPJzOk65uOjbMbeBEPiJ5ArChLK3rT748kWJApnwWJc79gjLelsqb0MBqSCRhFm2aG5ID7mGr9Q==
X-Received: by 2002:a1c:9888:: with SMTP id a130mr11031024wme.102.1631536200754;
        Mon, 13 Sep 2021 05:30:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Mon, 13 Sep 2021 15:29:33 +0300
Message-Id: <20210913122947.3673239-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 format is based on sections. To fit the latency
trace data in this structure, a new section and option for it is
defined:
  BUFFER_TEXT
It is similar to the BUFFER section which holds the flyrecord binary
data, but has a latency specific design for text data. The BUFFER_TEXT
section has:
 - section header, as all other sections
 - compression of the trace data, optional
 - corresponding trace option, pointing to the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 26 ++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d85a4b3b..d8a981af 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -144,6 +144,7 @@ enum {
 	TRACECMD_OPTION_KALLSYMS,
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
+	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 2515a5de..329ef5d3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1788,7 +1788,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -1811,7 +1813,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1821,23 +1824,40 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	}
 
-	if (do_write_check(handle, "latency  ", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
 	if (!path)
 		goto out_free;
 
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (HAS_SECTIONS(handle) &&
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+		goto out_free;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
+					  "buffer latency", flags, false);
+
 	copy_file(handle, path);
+	if (out_update_section_header(handle, offset))
+		goto out_free;
 
 	put_tracing_file(path);
 
 	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
+
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	else
+		close(fd);
+	unlink(output_file);
 	return NULL;
 }
 
-- 
2.31.1

