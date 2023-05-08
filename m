Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1355C77B7F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 May 2023 22:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjEHWl2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 May 2023 18:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjEHWl1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 May 2023 18:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E12D76BF
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 May 2023 15:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EB861DEC
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 May 2023 22:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0756C433D2;
        Mon,  8 May 2023 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683585686;
        bh=Oi8hl17L716yOSkw2go0DHYFIYpzpcrwGR3Kic+sdwg=;
        h=From:To:Cc:Subject:Date:From;
        b=PUbBJhOQtjrGP41FeyS4houa1QW45cBEVJ6IhjxFuMSILZtO6LtdF/OmAzCv6pn1Y
         UBPFGkS7cMc7OiW5f1Kp6edvszI0/6Jq58B74uypnXDtwFOGQzpMKGaDpAQitTXNAU
         QGJ+C8rrgt92WybSFf47xfOcNH8XpB6/HLnLgaI7iubPwaxmJyk9kMO54Hilzh8SKD
         436XGKeUvhU+mmESbPc8Xv7SskLP0KkfAbxeKuGJR8He1USFxfpUxxI0/UrjZOMFHI
         lxKpxDjA2JvayLwrutQ7RFIRyt0jiz33LYjyJgwJdxZmMK5rVpU/hp35Hul381HUI6
         tX3f2sI6JU0aA==
From:   David Ahern <dsahern@kernel.org>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH] libtraceevent: Handle %c
Date:   Mon,  8 May 2023 16:41:21 -0600
Message-Id: <20230508224121.12861-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use of %c in tracepoints is throwing off the argument order when printing
event data via perf. Handle '%c' in parse_arg_format.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 src/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index acf7fde4ead9..12c6f560019b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6486,6 +6486,7 @@ static int parse_arg_format(struct tep_print_parse **parse,
 			*arg = (*arg)->next;
 			ret++;
 			return ret;
+		case 'c':
 		case 'd':
 		case 'u':
 		case 'i':
-- 
2.25.1

