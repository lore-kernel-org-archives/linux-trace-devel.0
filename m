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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9028C4320E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A7760D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhG1NdE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhG1NdA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:00 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647B6C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ga41so4591305ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vG87pRqsy0uysrPDDm/LTeBAIg6pQmsLqcTTq1yayqw=;
        b=UP+gRMxMHsxmsErCXoKNfAWNuF3pq9qBEkf0njugCnbYCfjwnKp9roLZxKRLOqzYu9
         yFUftMNi20w/hMuST9y4lfmfp/H9qx3wGFnd0qFYO/njW7smQherEIP2a7Gy1Ucv1bl4
         vQiiBtI/P9wgiwed4SxbJ9pzLyQMFBTdDq5nwVy6bfANPUw5mIA8ISIiA4UBKZOgg1uc
         SPXhsdnNBy3+7DG6/1AKfzrOYdN/PdN3al7aH25T/jYqZf7YCwaeCKV5QJFW5FijPjRB
         vpUcCwbjCogCoRK5AsJIwGNQeMi5Z6AbNGNOTPY33WZJPoIIPZuhYCZdZBVI6awim3ze
         29/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vG87pRqsy0uysrPDDm/LTeBAIg6pQmsLqcTTq1yayqw=;
        b=MF8lZVLo5p/3VV+KNOScxUeDeqTUF7ehXcJHPuniV9lmu3Um9crxoSbRagplJmPZ2t
         e7khMTej635n+gyC1ySCACcQCiuod/AUVd+UoWfnkIul7Q/VpNoSJpPcxWp3wVCfAYh1
         k8eWdyUYrGkT7pXVo+EusTmgeZJC+t+vKtTnhrFtU/y4rm2+DMt5dz+1LNWsONbbWnwl
         ZV+2Ciit70Gp749Xs5W8qY8jpsvutLcHXBQl149GsHfMqbJ1PCapcXTpqILiUUvF/Azf
         gM4BlH+bozksKbf67/0uiozsZTN9F7dx5FJH7QSnju8iA9RmaXA6yk8RVHD/kMDubA2Z
         1MCw==
X-Gm-Message-State: AOAM532+0mOfjjd14T2b68xELG/MXNCOkWKg3M1DpBqDOAKnHMkfphPL
        B/4fPMppDe9WPkEpyDUoYEQ=
X-Google-Smtp-Source: ABdhPJxMOWfQa3c+ifZ8yF9MuQo1OGlh0s4+5p7tPoZgdUKgo6sBrhfIvhLVW3vPkFj0SWZJwy2FFA==
X-Received: by 2002:a17:906:40e:: with SMTP id d14mr18197265eja.338.1627479177021;
        Wed, 28 Jul 2021 06:32:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/87] trace-cmd library: Fix possible memory corruption on processing a trace buffer
Date:   Wed, 28 Jul 2021 16:31:28 +0300
Message-Id: <20210728133250.234140-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace buffer is read from the trace file, a new input handler
is duplicated from the top one. Some of these data are poiters and
should not be duplicated, as it could lead to a memory corruption on
handler close.
Added a safety check to ensure requested buffer index is valid.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f94a0073..38dd0deb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3945,13 +3945,14 @@ struct tracecmd_input *
 tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 {
 	struct tracecmd_input *new_handle;
-	struct input_buffer_instance *buffer = &handle->buffers[indx];
+	struct input_buffer_instance *buffer;
 	size_t offset;
 	ssize_t ret;
 
 	if (indx >= handle->nr_buffers)
 		return NULL;
 
+	buffer = &handle->buffers[indx];
 	/*
 	 * We make a copy of the current handle, but we substitute
 	 * the cpu data with the cpu data for this buffer.
@@ -3965,6 +3966,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
-- 
2.31.1

