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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C085BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD27160EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhG1NeO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbhG1NeO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FE3C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:12 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so3260385ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeqSXhB1scM/gYsw5n4fAEvLMCdkuPXcrQGTPYDsIC0=;
        b=KAvwFLYOFaBWD+IeIYXWa3gFnUHOLU4du8cO5hTqEwfeERAYk2wYLomQEtlrJ4rzLC
         O5N4KY0W5+r4X06EAlsLwC+RNyqmir42GU9VgOYsbV2JevIIJhfSu33hX/n3FlbQ/wSu
         coPvZ6ZHxYvl8IoMEC0aAzcp5QtbAgA0NDnv5XSKfgqD18u37pvh5b5oXEzN+zj9Ir0n
         yt4iUXufM0ETBTM/Te59/euhrMfWAN1kRYlM9FU2Ea/pg8rku93mrvSCY/rxB/PGQ8j5
         iiPWkkCmTsLGShNZSOm6R+xSMi04qp1INkJZsgImtxF5XMvv2QxclHJziWoOC7vkyC9g
         8CLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeqSXhB1scM/gYsw5n4fAEvLMCdkuPXcrQGTPYDsIC0=;
        b=WVc29FvaGPe0jcmcDhp8PYMxJNu2QtIw3vQTo8+0A5sx1GE554DZsTfln7ryhGm2Gm
         /FXRuYlYO+7VlyP7TdSTSLIbPO4wWJQgFrzBkUmyfvec3WTJJqVWow5DhtB5oGdDjYUi
         W+UxiSSM5YpRkujVF0DFlznffQlEm44XaCb24rRv3UkFQPB+Y4eQF80YAeXM7jjYCIkV
         lzp5ye149A1AWqzMWVN/JKqr6YxH9uyEL1h8Oin0PPz0Cj/PbbIvojVSv+C+HkbvFq7d
         ci/Ag0oGfpekmNfqUIeHkJd78/cHU1j4OuP3WAXsnV6zICUhAIpQVOdyAWPJEytGfEkw
         TtGg==
X-Gm-Message-State: AOAM531fhQkRyIlW/VA7FkCjEJFMGQ+PtJSLf3BqzGk5OY5V5qL9DPYs
        sv1A/8XSRT/i3mn72JpShnY=
X-Google-Smtp-Source: ABdhPJzVPyXQP+A1gbgX/I7/R7fIeBPTL5Rx76q79bMfymeovq9jOQ9vgwjr0WzLt32g9ezmzOiIYg==
X-Received: by 2002:aa7:c545:: with SMTP id s5mr33795280edr.182.1627479251332;
        Wed, 28 Jul 2021 06:34:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 73/87] trace-cmd library: Reuse local function that writes to output handler
Date:   Wed, 28 Jul 2021 16:32:36 +0300
Message-Id: <20210728133250.234140-74-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reuse do_write_check() internal helper function in the trace-cmd
library. It should be used when writing data to an output handler,
instead of writing to a fd, as it handles compression and network
contexts.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index f8a335d4..c73b37a6 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -59,6 +59,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 			 char *description, enum tracecmd_section_flags flags, bool option);
 int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
+long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
+
 struct cpu_data_source {
 	int fd;
 	int size;
-- 
2.31.1

