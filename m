Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CACDC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 18:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiLOSeC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 13:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiLOSdh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 13:33:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC00B297
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 10:32:01 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o31-20020a17090a0a2200b00219a2904952so11718pjo.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 10:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc7J5VfqbkePBXIcgmZn1rBMkBEEP9PdPFeu+rapwn8=;
        b=Zgkg6g15fuCmGOaGbUwX+DVt0MM2gXcYqfhH6lKPCd9o1XnPnzMZ+aAAFOxLgrYxJo
         9UxcNT8DLTrroANFs1QxseqjFECbMl0LtnLRAeqqMc8htFOQO4gJ1cuhLeELcS0OEn9K
         WjizM93SnsvcK05hgGHmp0kRRsgiYW1suDseT5jVJNLlynnOcmMA+SE4uXi5LWw3o4A9
         wKZ8HG2gbt+cxna+wMu8QyQczJyn5eXytzzDuQS7bpmXcPI1eKG7mHf0bp/DLwu3xuuf
         6uWD7PCg6gWt8+onXqyqp/nkbqvuyEoPbJL+FIsVfuE+nDVjqGxGft/rUU43C46wHeaG
         wYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc7J5VfqbkePBXIcgmZn1rBMkBEEP9PdPFeu+rapwn8=;
        b=BXYBtK1vWX/CWum7RQ95pzy5+hSzWgCQKSXJJ/ZaHaBgasbhUnmho68XeaxKbooagU
         a93GLaLxWR8cK47h2AWUplGjHs6/dTUbgouh2mwEUFj+QfIvi9zbMKQnx1Yfr4SWyymT
         AZKgQF23nhOcHM+sfEgrJjvz3MLC8wC9xr1xEkmJk+cKicz2m/b1LRmp5XSMVFafEVOm
         JIjHxIeCSaDEn5pNPDeZ9dUH6YPTzgLCl3S+KXwQBJ4QThH941ebkAq5jwWlDtJ5sJ96
         7CAfq4UxckCq5j0ldserO8NL7E2agCP17P0YX3r2l2Rk+JeKoPry2n/qb/JxatMgrrPF
         eSbQ==
X-Gm-Message-State: ANoB5pkv371oYM3Pa7Cmtf0a5IlMGDfJx/8P8AespTcF4SYfTmTDeNIO
        AgK3LlAWc5NPO4Gyg4xXZy8dfZzw0ezEFHeTftVCDfrWlltgu2AuRsANjuiUF4Xk3TSXnZBfICk
        T/BitFEYYAk9GI9y/8x57voDzup89VT6m/pbi/AehAV8e/yG1CQdKDm40ySVKrE0LSSupcfCNXi
        TNMn0=
X-Google-Smtp-Source: AA0mqf6Ke0aSrnZFVXgsgRCsUq8lS6wwvWXWBdddFjPYv0PtbWxFUg39zibns8tJtdRJcaoKNwDLQhOVfmPp
X-Received: from irogers.svl.corp.google.com ([2620:15c:2d4:203:de6d:aa93:7423:e679])
 (user=irogers job=sendgmr) by 2002:a05:6a00:10c9:b0:57a:9cfb:3490 with SMTP
 id d9-20020a056a0010c900b0057a9cfb3490mr586061pfu.86.1671129121304; Thu, 15
 Dec 2022 10:32:01 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:31:51 -0800
In-Reply-To: <20221215183151.2685460-1-irogers@google.com>
Message-Id: <20221215183151.2685460-2-irogers@google.com>
Mime-Version: 1.0
References: <20221215183151.2685460-1-irogers@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH v1 2/2] libtracefs: Fix compiler -Wmemsize-comparison warning
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixes the following clang warning:

utest/tracefs-utest.c:828:75: error: size argument in 'strncmp' call is a comparison [-Werror,-Wmemsize-comparison]
            (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
                                                              ~~~~~~~~~~~~~~~~~~~^~~~
utest/tracefs-utest.c:828:22: note: did you mean to compare the result of 'strncmp' instead?
            (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
                            ^                                                        ~
                                                                                )
utest/tracefs-utest.c:828:56: note: explicitly cast the argument to size_t to silence this warning
            (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
                                                              ^
                                                              (size_t)(              )

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 629cf2b..e0e3c07 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -825,7 +825,7 @@ static void test_mounting(void)
 		mount("debugfs", save_debug, "debugfs", 0, NULL);
 
 	if (save_tracing &&
-	    (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
+	    (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug)) != 0))
 		mount("tracefs", save_tracing, "tracefs", 0, NULL);
 
 	free(save_debug);
-- 
2.39.0.314.g84b9a713c41-goog

