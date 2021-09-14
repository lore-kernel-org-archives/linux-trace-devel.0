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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA75C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768FE610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhINNN6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNN5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC1C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:39 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t8so15106849wrq.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=cAhm5s/M3pGZ54Twi4Ir1E6KkHXe/h9hx0JSYNpyHO4S+z5gRtRS3Ajctibj8Mntz+
         x0GLfqvm9U1VYh1NOb7g5MY1ihDEQZg1Ua5SGqDsUkGkuoKHUSArPT1tx5NoVPqCZ2eC
         GgCiEfW2YBElVdNr+tM/iPk3o5gxYNRWX/e3/4koepQ42gZbZEb5mzn8b2h+LODmhjd7
         pdKsKeK+vKW+CoAlL7kJZtuCq6lHfYEKpZRRtDj7mIRr2YXn1DOd1/8FxQ6ZwU5JOL5c
         /8KoNfEd6Oxw2DKW+zvambRMHx7SKfWXJnLtaW6ylM8ht+UKQ8EeaEVULsnRn/Ti/fwY
         edSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=WILwj5L1ns1hWFJmMGXhhbj555xJlJrSOFmtBCHtfWduahLkOdPT5vP5Lqk/c0JGyt
         c6TSMKjngytOohGCLuK+l/vzr4vkH6op32Bxy2oMB77rC4tiZJkkQkM5uttCNexxj1L4
         EvbNMaTdaLdTsTNMga8wfzDV9Vuu4Pph2eJDQJ7jynoRQe2XiC3RylRyosrQi1jWfVk0
         CRl0FhbKQTvSKQNoY8I/XVHfazJGbisLhUuOTlLuZdXnfhqHoiDx1Lc+8OS5RQRlUIG+
         3S0fUf+32f9+s4ZKPnrUUViVtozmk5aG57cWRaxk0fDJ2NdKdHw20upfreaYBjJqjfja
         3z8g==
X-Gm-Message-State: AOAM5309h3u76q7rxX6dFLMyIhjTb8mMGwYz9xyuNLc5RyuG9/wesLi1
        dLnV3Tl63ubcrNNXDBxgVX98C1DxOH4=
X-Google-Smtp-Source: ABdhPJzivPNAs6AEAPKPnvT1oEntDCpvZYZ45DlRqv12LYDhnt/tMtsKnpCnsXKTzU/vrmKrFIpWvA==
X-Received: by 2002:a5d:560e:: with SMTP id l14mr18299291wrv.205.1631625158515;
        Tue, 14 Sep 2021 06:12:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/21] trace-cmd library: Fix version string memory leak
Date:   Tue, 14 Sep 2021 16:12:14 +0300
Message-Id: <20210914131232.3964615-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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

