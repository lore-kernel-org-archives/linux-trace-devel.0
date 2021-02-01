Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4B2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E90A64EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBARZj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBARZh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:37 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0266C061786
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r12so25598424ejb.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tge4VpWhNZLplgeS0avc+7KTpwHzqvBlhwQ81Ehq4Uk=;
        b=IiYocfPf2WS7mSieCxyvxChdv6o1liCoij/Z34rqHJGb42PdxDYUjG5qrZ7immXRu7
         k8nwYoVCacN4WOuULuhQORxxxUeHmy9PkS1YvzabobqwFGvXf5bMN/FTVvxidRO1zoT2
         LUEj82wAvAEwzoIMl7nGVCgriXRA64hpxOFdEBL8plI93KzNNxyifFPiLIzR2QM+HvGg
         zAvwIfzOF7HS0sy8sGJCkEZv6PpzBQBJZhNPM6zKJ+LhSB2Q55tbtYwKWJvzP8nLfx8g
         JoPV9p8tCY/M7itS2W2esrWhQWaLcGeqfLEllpagIYNriDCjjDfawgnPW6YWTfdPu1ul
         qC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tge4VpWhNZLplgeS0avc+7KTpwHzqvBlhwQ81Ehq4Uk=;
        b=mGPzaJ9/sZTQAOxyvFEAbiQdM5SBgneDBC8vZi8f59xglPRcMnZ0qIgx5LBE3zh+gQ
         6g+CDi/+qTQyyKkI6hX2/kkuzH9hXFNFRMKZaWQvOK6gBxdbr4bBwE27ZiTpsosxTa32
         A4PB8tIw5dtKL3qdRTveRGLZ2UgKP69YxNmVsq3cZgOXLKzjAeQaFdPnNfzK8quhn3jm
         QpsB27JAzxcvTTJzCgRey6t1fw0M3ep0AEY3kGeo55VEOSbqpFEvtDxZqX7TYHVUizYw
         wHaXbe6cDgun43w9zLxX2LitxdEL1eK4wKPpgs05UT2fIhmUSW9WVkvLGzNdlCPXxr5i
         hwoA==
X-Gm-Message-State: AOAM533ngGecEWd6lRtDtRmMWINwKoxfe6FcTO7Hqbplua/AJZx02giu
        2a6fVWvqmK6PlZw5QCqfkh0=
X-Google-Smtp-Source: ABdhPJx0YCp7QVmmz8vTq9ph90jJz49tnKyQLk8J411lP5qy/uBQ2Eeo2bt6unGhvPdFGS+HXOoYWw==
X-Received: by 2002:a17:906:3146:: with SMTP id e6mr18057202eje.363.1612200256739;
        Mon, 01 Feb 2021 09:24:16 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:16 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 05/24] kernel-shark: Count the number of readout interfaces
Date:   Mon,  1 Feb 2021 19:23:39 +0200
Message-Id: <20210201172358.175407-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The number of readout interfaces, successfully registered by
the plugins is supposed to be counted and stored in the session
context object. Although this is not used by the GUI, we want
the API to support this feature.

Sgned-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index bc68186..ebd2579 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -457,6 +457,7 @@ kshark_register_input(struct kshark_context *kshark_ctx,
 	input->interface = plugin;
 	input->next = kshark_ctx->inputs;
 	kshark_ctx->inputs = input;
+	kshark_ctx->n_inputs++;
 	return input;
 
  conflict:
@@ -489,6 +490,7 @@ void kshark_unregister_input(struct kshark_context *kshark_ctx,
 			*last = this_input->next;
 
 			free(this_input);
+			kshark_ctx->n_inputs--;
 
 			return;
 		}
-- 
2.25.1

