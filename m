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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F30C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C57060F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhIMM3W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255CDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b6so14387237wrh.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=HQdR91nKg/cQGO+kCRG9gOXIpsM3UrdutBuPBrY4/HxfhwwwFoj9PJE6PboLt1lVML
         fZyjxv4MGGGCJ1wxMUbkzb3Im7+mBvc+DZ2zs48t5QmDLw5HdO7G4idSfTuaR4K3vKRz
         YZ3J07hMHcdyxnhy4LExv/HHYCYC/SdiRoHzDzJQxxi9M4tBDY2G1XTDOBSC47WnndLa
         Yqe8QCmyJFu3JbElmKdeBeP5Ua1frqjDzK5P/nGKjl7rE02VWIdv+52z6OV7mbB69NAL
         Ra1JiAaxyzutQeQUdi/LF+zE45xG0hcDK4O/wOAm5FutvD4kDqzMu3OMTssMyjD9scup
         nTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t6f35bOqeR513Bi7TdiB4HXAWp6UmqxXje43WtBoeKo=;
        b=Bt5eLGNnn9msRpeBD0jYOJNKEA17kn+50eUdz1bcWpuYjYQDy8oB9L8IPbO2/aKgG9
         d4cQP2+KXv95Wt3KL8BxNg491Lg7Ywiuwzv/qWTYYOcHh6cmXJdd/nL70lgjmmtzkiOg
         ze52Gm9Ud7ngzvaOo3FJmdYwtuXLNVj7YuUw3X5hAQjY9HtZx1Ac1v6TEjYqCeU9bxoD
         pZIw0JOBUm92u72WhjOZxhX9YDooZ+QJKhIA8d12xakP5O+DKGr6sl9NuvTKsF8pWrea
         2ilbk1F2X8WCvnfbTjekqlttSNII9J2S28HBO00sZFQqZd3EYBtV3kgMqbTO4wC5ScoC
         41qA==
X-Gm-Message-State: AOAM530aKoBOcu8tCNa7KKSuoWa4sPpaoKz5B2S3cGK9kp5FqDgAVyz5
        BPXQA0SWVzv5H2VwHbCljITLJkXn2e8=
X-Google-Smtp-Source: ABdhPJxaRoHMprEexklbs1A9qMMGtORt3dk/x17HUXwI3Sna4v5xw5rJwdt6MGVfV3OCGuPV0O8a2A==
X-Received: by 2002:a05:6000:124b:: with SMTP id j11mr12483136wrx.147.1631536084820;
        Mon, 13 Sep 2021 05:28:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/21] trace-cmd library: Fix version string memory leak
Date:   Mon, 13 Sep 2021 15:27:41 +0300
Message-Id: <20210913122759.3672494-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

