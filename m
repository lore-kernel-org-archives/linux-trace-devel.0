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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9038C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2420611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhIJNtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhIJNtP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23021C061762
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:04 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id h9so4411105ejs.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=If1AwQprV5ZGgvFj4HkgTHldkuYoTQU65DI9E3JbASmpA/1M6NXBAJKNRFGO39slfw
         kxBRu+qTrqmLzVBkMINzznIubbzRrHhmU/DVbtOpF0KCzx8SAlpSTvs+6rCoiKdka5Jc
         AQA2ioMFeGrrbIuFclZ+7r8EY8xffc2+b2n15UNyC7S4yevgfLoP+tPEmmHCMG1KGORL
         JBL4yUHOGHdzlR74lKbs7bAhgGscaN0bBcy++1U63WPX51j/HwnTmoED6POWtz3wT4bC
         EkJqG8cw6Srewcz816VqnZD/zyhlboHF7eddYJYTDrnBBSV+gDqa7rHlTuA9YS+RFg8F
         i8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=VBcVtbqlh7dYbExiy7PDsajk4KDWPmkBdlQsufBdcTgd14KqPSKQRd0P5TUSw9duM6
         IUf7IaeLywOY7XJiPv74aqpoTsBfsCe3/k/3hN88wZeRdtMRpMzQCmfpIiw8NlumePFk
         dAmyGEpn4RmTSeUdDrrkFO7Le1VsyB0pdHI1cciG2qOY6m7TCELkWR0BkkLZy0xM5rwS
         PGAMJVZprikJrkthYVlY1GRDiNzd+CMhfF8BLnnriR5MS2nM6nhHJNLC5G+BDnCbb2OD
         tdblfyd+JxB+hpLJwNYywNGuDY2w4tys7KhHaPLm/givoIBPk9G2m7mD3y3Z3it9fm4h
         iA2A==
X-Gm-Message-State: AOAM532Tg2Riru5nGJ1YW+PGN5Wwonbtz0HcMlXiSN7lThWM9NDiyb+g
        G6Z8Zp4Kw5yV6SzgEeY6zIJ6ggPGBtI=
X-Google-Smtp-Source: ABdhPJztOgNWlQW5T8HKJz0ypmVqDWRkkWSLhJ0S5HFVK1MXstF9XPX6jc2h9tojG6Il314xqaqoBA==
X-Received: by 2002:a17:906:48d0:: with SMTP id d16mr9225279ejt.562.1631281682759;
        Fri, 10 Sep 2021 06:48:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/21] trace-cmd library: Fix version string memory leak
Date:   Fri, 10 Sep 2021 16:47:39 +0300
Message-Id: <20210910134757.2863982-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The version string is allocated when a VERSION option is processed, but
is never freed. Free it on input handler close.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0dbcdbdc..9253bc37 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3518,6 +3518,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->cpu_data);
 	free(handle->uname);
 	free(handle->trace_clock);
+	free(handle->version);
 	close(handle->fd);
 
 	tracecmd_free_hooks(handle->hooks);
@@ -3959,6 +3960,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->cpu_data = NULL;
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
+	new_handle->version = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
-- 
2.31.1

