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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519E9C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0FB60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhG1Ndk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhG1Ndj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA93C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o5so4674813ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PdhhaRZu41xbnymtvLOW79QcMvaLBUSFkyZPoEgZ8Eo=;
        b=GUkM67fnCZ3gvpdUgNE+fSghEMfZRR2w33G+SjaF8ru1FkeKSg9WGXgVgiduGjQqJh
         9CdJA1Cj+vh3M42agAnemaQigHqsWLoQhnZxvfBRtJqbayApvj9PM4V/nFMkxuQ5e+gT
         anhfsBBt2Vh0KqKc9QZFcX53HogrBuTBavCA2Vl0wGY9kTTKu13JkX3WgAFXO7R0F6sE
         4yGFOUHiv/V+Ws2pApxKveW2r7Xq8u1GVRg6HDpIMlTecf/n5UgFpvIQEBed3CdEcn0P
         3Rw51qC2HaNDxx0aLGYLY2t2bzly4WJrTFv1vceLIWBQ/wU8v5wCiwDkfu06srbssMtF
         Kd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PdhhaRZu41xbnymtvLOW79QcMvaLBUSFkyZPoEgZ8Eo=;
        b=qgn4sKci4IB6MhBVvjFroZRrVOx4v/9+mrMmJ5WA/+r523ID9hInnv+yu+/jucl5cW
         Hpq6q4h1TXp/OAenQf8n5+yF/5fXA2o2e4pkYsRJLKBAwDrZWib9g6TdqWaNRL6hhGnx
         DFVhuCjxMglC8g87QYhidARmeVEv7QN68mWddGQSjSDw0ns6GhmMpBlZn96nCssXl7Sj
         h0u/76502P1CZt7rAi/blXwQZb7uxpti6BeD5j2i5yIH1sAb9fGL3+CooUAYmGYGK+5X
         duMuq8AGNlkB4lTxjjeagD2BpEnXxFMTKXc+F0iK3GRGvpGuRgmhoQZ1fxcwrVzD4iGx
         v26Q==
X-Gm-Message-State: AOAM531IPnpYq2pU5XsjuLg3cOQA16B3HvnJ6Q2QkDu+giKq9CHYbO4D
        inRUTwsDjT6IkEfdrMO/Nag=
X-Google-Smtp-Source: ABdhPJyIV7gjrKQYT20c70WoFtzxE3514vC4FeUYXG3NH52PJjPZYC8JMy4fZW4EIfFF+7Ppa1q3XQ==
X-Received: by 2002:a17:907:aa7:: with SMTP id bz7mr26512127ejc.396.1627479215742;
        Wed, 28 Jul 2021 06:33:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 43/87] trace-cmd library: Track maximum CPUs count in input handler
Date:   Wed, 28 Jul 2021 16:32:06 +0300
Message-Id: <20210728133250.234140-44-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, only CPUs with trace data are stored in the
file. Each instance may have its own CPU count, depending on collected
traces. As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1cc72092..b66436ab 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -133,6 +133,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -953,6 +954,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2908,6 +2910,8 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4216,7 +4220,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1

