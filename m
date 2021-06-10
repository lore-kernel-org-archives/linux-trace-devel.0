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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1560C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D5A261406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFJLhq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:46 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:41787 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhFJLhi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:38 -0400
Received: by mail-wr1-f42.google.com with SMTP id o3so1903044wri.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SL302fTyFfaFnXlErdYp1JrAPy3ZPN35AL5S03E1of4=;
        b=Puz9pVBcmVgloVl3X0jDBoqce+pByemJkeQvKnfJi+6I09vxXWeYS8hkhIg5ILXwNo
         PVVJsy3sIx1oD5TCcoagb8lELKBqBbzP0JZEU/5UX1m69of2WiqhX5R5mGMBb/02iJM0
         CW48Mg9mcIJf9jarz1mFhPRjsQ94ZWfLKP5zzMUwUi+N8hEEXl9740+3TNuG5kwxAU2V
         bcyr/Pp+3Xg3nR31NXbEJzvb6K1F2OJLp+KkJYVFsZl9WbRk4rBAD/oy67WtiN/XW1Nq
         //YEW3fQ65w034fvQ4rL5fE/Kn+ADvX0+5lvGsNcWgPZXT80fg1aFLodJJ5A/zKhpcN/
         GJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SL302fTyFfaFnXlErdYp1JrAPy3ZPN35AL5S03E1of4=;
        b=degBIJerounnvH7XqQdlKYn5Rkey3fvqm+eXtN8z2qMixi7F8IgPK8PHUhIP6rReI8
         6+Dz+pmPhCcUYn5j/gO/zvKc/enbcfypoOLPPqRa7e91k2Si7Xmz7sptfFeM9BYi5Sby
         Bcv74bAkmES2DFsFQEgVXu0iezbC1yQJJFupm4Zm7yaPZGBaNZWNo2yB2KaNfxwh0tg2
         j49HY4OnY0eewOcKqt88SO92Z3J5vm9fqYhNwotj2IHr78vzexuMyh1+oLj81x4cG8If
         P+sS/HHZzCOQinhQpDfUmi5jSFGrpoNyFfLOC0M6FVgSe3tczM/tJV3H+1InHI5WEY7A
         IPcg==
X-Gm-Message-State: AOAM531pyJfAQIXA+xFZGwxQ1oKeWFpXod4FXm+FplUlLo/wIjAdvbQt
        zV9/QnrI9rBIFjEIDwr5G6x65tWU5dEsMQ==
X-Google-Smtp-Source: ABdhPJwjAdbNAaXr5aNU8SpqQ7JG/yP+BvBlmbJDVS9deJdMclPItoaZlMUo0f+AR3lymCEkwuDXmA==
X-Received: by 2002:a05:6000:18f:: with SMTP id p15mr4990565wrx.102.1623324869770;
        Thu, 10 Jun 2021 04:34:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 01/40] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Thu, 10 Jun 2021 14:33:47 +0300
Message-Id: <20210610113426.257931-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove these unused private trace-cmd library APIs:
  tracecmd_create_file()
  tracecmd_create_file_glob()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  6 ----
 lib/trace-cmd/trace-output.c                  | 29 -------------------
 2 files changed, 35 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 5c2ab4ca..4bd36baa 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -263,12 +263,6 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files);
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *event_globs);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
 			       struct tracecmd_event_list *list);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a4a1eecc..9231c319 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1614,35 +1614,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	return NULL;
 }
 
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *list)
-{
-	struct tracecmd_output *handle;
-
-	handle = create_file(output_file, NULL, NULL, NULL, list);
-	if (!handle)
-		return NULL;
-
-	if (tracecmd_write_cmdlines(handle))
-		return NULL;
-
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) < 0) {
-		tracecmd_output_close(handle);
-		return NULL;
-	}
-
-	return handle;
-}
-
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files)
-{
-	return tracecmd_create_file_glob(output_file, cpus,
-					 cpu_data_files, &all_event_list);
-}
-
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
 	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
-- 
2.31.1

