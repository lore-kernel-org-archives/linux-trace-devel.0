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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9099C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8ED8613FF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhFJLha (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:30 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39501 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhFJLh1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:27 -0400
Received: by mail-wr1-f52.google.com with SMTP id l2so1907980wrw.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ul0cYskXBCYyoanWYB1IZdsjLcqgyRalazjxs5buo98=;
        b=mB52Zaj4kFscXcxls6227hHw7ebbq9Adfpb2LylvlR2G1viNhuGGtiF+5pYQexDPrZ
         fjEWbAkJkIi+1PhAah/D0VvAd212UWWqfzjoTjSo9hoTm0wLYDLUEs86t9mfPDQSyNWm
         LLPWV1fQzH38drnLthUTqTlqUiNChuBWShZTZ1HUNlg5UwPIfRpoBbDtpzdglP6yhkW/
         5yTvTVhjLMoNPFsj8rItvmidIAOey8CVcvJOYRnYK3IoRxXfOY9boJwLIPFF6e/Ym5vJ
         vksgZ29Tsqj76uO6hTIe/SJsI2p9o9oJeF80+bWgYqQHDGtTOo/ZYMZrVbdXbcmbMKM2
         cVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ul0cYskXBCYyoanWYB1IZdsjLcqgyRalazjxs5buo98=;
        b=iKjAQexfZ1W10qTUqdpKywCtsujnghKDNtkFbG6pSSv/wRz5YqTMSle9qzfGyDqnK1
         qWwO9Xs0jVvoU8A8YAZFFFfhQcyn2tNNktqkKf5B/WEas0kiuJZDSlsJyjZRUMrWc3GO
         29tAUcG1uBkyfHPOyk0t4qy/JI/gRJHXvhX09KddwUoHuOSv03VzTnsMYi8oybEV2twQ
         o9JGVqNzLXQYo5WVGSTp/Ka7LnY6+TEoevyYTbI2x/V+BbCMtw1rkJbXkSd4wZdASCe5
         IBC8CUf6hf7OCflHAFuyETdqn5U7EBexVeUqoL3Gfkmtm/hqcrCUgGfqOoX7VStpYg9z
         zJkA==
X-Gm-Message-State: AOAM533K9tQCbGdxrKihXpJzhGGMKPQxX62TleeO8WiYkGAH+kzV6Ym1
        H9NS30GsVSxbYWSyvP26epo=
X-Google-Smtp-Source: ABdhPJxw91iJ+vyt817tPv/UyfLTPUHCtBDCrjd+TFTWyXuFccSa8gHmMji+3mq4jPPtIse224k6Zg==
X-Received: by 2002:adf:ee85:: with SMTP id b5mr4890793wro.95.1623324870780;
        Thu, 10 Jun 2021 04:34:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 02/40] trace-cmd library: Remove unused API tracecmd_update_option
Date:   Thu, 10 Jun 2021 14:33:48 +0300
Message-Id: <20210610113426.257931-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index 4bd36baa..49539432 100644
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

