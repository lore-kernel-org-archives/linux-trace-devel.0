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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B0CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54801613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhELGjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhELGji (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1594AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c22so5194360ejd.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dR9cwZyRjBzKaGdEXi13MgximQSnOMDkCL1jWfZl6fY=;
        b=iUA1Uot74D7MZK8VSpnRZVoYrV8gBoxTJNvTnYpi3lfw2J2Pu6bvEPLz7cz5JcLNs4
         P/R9/ipJgk21XLWz8nax0NEOJXubkRSALDxk3RNXdglBIXb+b6Z0zr7QptE9PttYkJXi
         7VrQSDDWtJYNU9K6C+hA72c65vOa01RFxf0fwAu7i9yd0fUuwdpGg3nPgGx/bToM0qRt
         S9uqCPsmip+LB6LJBDXGfAbCY8WdS8kvzKpeiSbXZZG1zsIXgO1s0/zgaIR0fBjNJCpa
         Na2IGt2M/DSYyiVf2wlCJ9zmfVQVOObFrCpZrS20FqDZq7qZ7xO+X7aUCb7NOPl9yg2a
         t4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dR9cwZyRjBzKaGdEXi13MgximQSnOMDkCL1jWfZl6fY=;
        b=OhvPfJJ9cQm40LEHo4mLu0QPQd5qFBYc30Qmdh+BHTev0o15wq4QQfVHaQvfSfUkkS
         naJhYZjza3pCvev//2r8bnfnd2/aqp//+D/eGm3VD3DZ9g5tMDmQWVvLJC5LlhruMVau
         NK9oioE8h3su0jthWobjxU2MbjpEAkbUYvZYnYLzzsy44by82W/vc5d7dkyv6yW/+Mm6
         jVK5VeRE93VLGK2yXVSOn9UI1uDTGMvbuKVXi2n4c7x2JGycR9FzjJkcacDWjYorZn5O
         qBaGQkFMtueMjXBTaGHwdbMTWwrooJx1Jnr/BTp5oiAFwXcf8LiTMsaX6/gvSWmFWIjs
         GqYw==
X-Gm-Message-State: AOAM530N1LnxryoNyr5ziUx8vmwFueYUNygEtwnBR15M5bPoMgEveZDi
        Hxz/hf/l1vCyay8pwWTKMFmLXQ7eXuBILg==
X-Google-Smtp-Source: ABdhPJysXv4Fz9pFZh2lnfRT7LqU99HOpm2G4Pm3Q08v562U2QM12LH5YX5T4FUOLkBMAOPWOHSSGA==
X-Received: by 2002:a17:906:7ac9:: with SMTP id k9mr36607812ejo.229.1620801507889;
        Tue, 11 May 2021 23:38:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 02/25] trace-cmd library: Remove unused API tracecmd_update_option
Date:   Wed, 12 May 2021 09:38:00 +0300
Message-Id: <20210512063823.324610-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removed not used trace-cmd library API for updating the options section
of already written trace file:
 tracecmd_update_option()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 --
 lib/trace-cmd/trace-output.c                  | 40 -------------------
 2 files changed, 43 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 8ec33ea2..ecd172ca 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -290,9 +290,6 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
-int tracecmd_update_option(struct tracecmd_output *handle,
-			   struct tracecmd_option *option, int size,
-			   const void *data);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9231c319..c0aa58cf 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1229,46 +1229,6 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
-int tracecmd_update_option(struct tracecmd_output *handle,
-			   struct tracecmd_option *option, int size,
-			   const void *data)
-{
-	tsize_t offset;
-	stsize_t ret;
-
-	if (size > option->size) {
-		tracecmd_warning("Can't update option with more data than allocated");
-		return -1;
-	}
-
-	if (handle->file_state < TRACECMD_FILE_OPTIONS) {
-		/* Hasn't been written yet. Just update current pointer */
-		option->size = size;
-		memcpy(option->data, data, size);
-		return 0;
-	}
-
-	/* Save current offset */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, option->offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", option->offset);
-		return -1;
-	}
-
-	if (do_write_check(handle, data, size))
-		return -1;
-
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", offset);
-		return -1;
-	}
-
-	return 0;
-}
-
 struct tracecmd_option *
 tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 			   int cpus)
-- 
2.31.1

