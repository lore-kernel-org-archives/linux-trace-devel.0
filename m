Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA65C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F0E64E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhBKKfl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhBKKdI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:08 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BC3C06178B
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id w1so9219684ejf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tge4VpWhNZLplgeS0avc+7KTpwHzqvBlhwQ81Ehq4Uk=;
        b=Hb2HIhmgCjcpzPr+AczL+hDTWorKD0IwDuh3/L7vHcgbKH/K632QxhbYQgQ5GjNDwf
         cVvTrfIK/N0zas/6UdczsmmpvDmMOk5DTmGAT3jDTqo6uwB0q4DWHdpzLNEIk1b+nO0x
         hVqoXKJwnyTCsK7Xf96eHkOJywlsRte28LFYsCFr4PtKTsOU0N0jOwoK28hEOlvtVaA6
         YEV/9DBRFM2RXMa5GImmdHwqfZNpQbASBJVRB3IKdKNDEJi+ryt+rR2QRDOS9rN54wnA
         0nCMhwfJoINf5yI2OgJU7qEaDjfsY8HmF+Zdfybl/B4XnpWUEQyEUL+7BlLk8f4HlBJD
         +Axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tge4VpWhNZLplgeS0avc+7KTpwHzqvBlhwQ81Ehq4Uk=;
        b=XU1OaoHqNQw6VKlRph6T9sOmA8nG4ruxulT5zTaYWDNkM75gbmlRrIr8MRCTqVz4PM
         O/rC2eR3heLOfphZwHP+0kzuBT+vHZuUrOVR73NgjqmTl7H21ccHOa+G5rHy0uJMghuz
         ThyHpXFEQDHA59u7Fstk1LNxTN+Ea7hUnWRomI2Q/d/NRK+wGAb2n63pKr0ps0BLZ2wE
         A/dt8gsUd4JyXm22D8FABB4d2a5rmquOlgukwsNlzUdCu0PRvnjY6r4v/cLCFJyL8GHw
         +dGtFaEwe1nT+nwl9IKWfQplF/XhOUhbJ+lO8iWe9ofdLft1qLS8CsTlOOK+Qb3+rl8e
         lUIg==
X-Gm-Message-State: AOAM531j/2BtYBluMiyBmL4qghjSqUWH9BHfQqa3exhU0PUtlP+nQfXN
        2QcbjLuNtfBHKKnTrLJJe6E=
X-Google-Smtp-Source: ABdhPJy/WfWrLZ4ZdhE+qaSgN6bExGGhO9oAMD2z+ke57meKHOF7sRx8d2SnBAKgat2P5Fpqw8S1BA==
X-Received: by 2002:a17:906:17c3:: with SMTP id u3mr7714587eje.304.1613039545585;
        Thu, 11 Feb 2021 02:32:25 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:25 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 05/27] kernel-shark: Count the number of readout interfaces
Date:   Thu, 11 Feb 2021 12:31:43 +0200
Message-Id: <20210211103205.418588-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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

