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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F173C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02934610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhINNOU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhINNOT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:19 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE99C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:02 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so2085163wmc.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AA+PGUMl91DR7kV9NuJ9YoaOinBRBGDhoRdn94IqH5o=;
        b=k58cAhKP2nqnDsecJIPVS4dwIS2xIwJNhFlwfOnI4miszHP0kkXjUqqBZYHrYvwtvB
         Sy29Et6MZM8cr7q+jvJmlxjYMNQcotYCfYqfX75wUOMT8Q34VefPcgjrA4JwqOOfZ5Pr
         hS74wM0bd8W5vhHWoys/rrN0MbIZUWF5MY4Y7eN6tnkO6bkh1ij1rOdLq/lvZhKDyvSr
         ke3+BXpQg3u3xX+1t5ChwFOXnCtRD1e8M4TAIRFv2Gv8a/0pqVioGQmbM1MylpGn+WOZ
         ADFiIMd5MxY0GTLQtHPgqbsZvLQq01SpvUeL0s5AFuHYL/Y+Qvz/t0b4WP1oBcFRhbQ7
         Qpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AA+PGUMl91DR7kV9NuJ9YoaOinBRBGDhoRdn94IqH5o=;
        b=Qctl4kzw0yaNhHqmGuDXxuOOSTqfMKpfUvClnwwJ8bONYh3DOzserONSbA7yr7Ch4n
         EYK4XPGS+jKPLaj8FLDzmcPBNzmuG0+6ftGvQs5COn4pplF+7MXPFE8IgLZ9CwrVjp/V
         hwsqre2/lzxDR6ldBqh6TsXc9QmpTQhCuIz8wVIG8gqDdiak8y9I5V8o1b4x7nIL2vJ6
         nGU8B9Om8FkUf2Y/CD3J5tPRxPrNV3Ds8ZP3JQ2qaq4TVxu4juQODUkuLHeCd690s7rF
         BcA2NqwuxeILvFu7HHbPDI5QgAfz3nYyNx8wmjwZqWWS19yFnGu1kEkVwkHDkI+hbco5
         ImOw==
X-Gm-Message-State: AOAM533KMqqUsXSmzf3gT/eyk8MQuTNbAaaW4HYB9kn6mf6MKC+zBMPx
        M6ha3O9IJTQPUIXFIkmt3CJPOehoxac=
X-Google-Smtp-Source: ABdhPJwMoy74c+wsOX6VsAPGUJtsnxdxvn8bvZiKP2S/AsI3fOZT1qqrZ1DaLNpeeT1rUKNcXMdOkw==
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr2155657wmq.39.1631625180910;
        Tue, 14 Sep 2021 06:13:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:13:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 18/21] trace-cmd library: Set correct CPU to the record, retrieved with tracecmd_peek_data
Date:   Tue, 14 Sep 2021 16:12:29 +0300
Message-Id: <20210914131232.3964615-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where only CPUs with trace data are stored in the file - empty CPUs
are omitted. Changed tracecmd_peek_data() to use the CPU id, instead of
the CPU index.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index dc82d3ea..de8e0d72 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2019,7 +2019,7 @@ read_again:
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
-	record->cpu = cpu;
+	record->cpu = handle->cpu_data[cpu].cpu;
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-- 
2.31.1

