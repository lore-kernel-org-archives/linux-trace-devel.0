Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370AEC00144
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 04:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiG2EBX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 00:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiG2EBU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 00:01:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F997AC28
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Jul 2022 21:01:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id os14so6398219ejb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Jul 2022 21:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IFNWBpJ6Fbjk06LN9pd/x3ksksJSxnvXz6CN6VoDPLM=;
        b=Bu6JFUSeB1nlPgvUuGmVGZAEuLzo7cYQULP6U3B9UcQiNXZYcT9mZSkfCZjPuIZR+m
         /JHvAYYZX1pN1FaOSNuhdT5XUsJx3oeYV3vCAhNWCXAt+mAMJG2oR3ab9WfGzoH2oWjc
         S9LZQv+gU52eRoHpnk1hIDgqh3yqNsEm/ZtGhtnxmmBN9jWcyrLIa85rAQfazTE1/22L
         pkWligz8BcUgfT27zIJps9wTH9xRLoq6h62YjoezuWWRyGhm2/kemUEQlCKe/XXcubQZ
         pLzQpopYWfCPpibSiCfDN1C7K1ZIOB7v45mgYYLvj7GDVmQqpVdTGlYN5TZW7xnH+WnX
         2rUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IFNWBpJ6Fbjk06LN9pd/x3ksksJSxnvXz6CN6VoDPLM=;
        b=WL0n1w9X9uif62bvwkakAQx5Oe2JqwF3Ma/ve4T/xjn/vNCLfjV4nkOaRmyUiXVNYG
         J6BlIz1W9JtxdNBXmVpHNNjbrPggoueMOhnH+LboaV6tfuJGyJFI+vEJZlmpHDleHJSP
         eu7DXG2fdrqd7tRp/cRtGXfNoxm5jE4S3PsSrAKkRPhH66+KsXqXFt7UdUrRCgnLvPdw
         HEhdIO2MelqA0KN2bFdBVzIDm3NTucHYuQJhEowcaTd3uBU6PeuGp0M/oYQN2I6PDrOE
         Z1AWyqlj1me2QFfO7C6ruTfWel0r8iQJhSTwn6KsUT3wegBNvAg8RopRhm3awJUBtYjJ
         NTrg==
X-Gm-Message-State: AJIora+GBnNp5/90EoTsxmzi043tXfRIbDp9sNF/sV7bg5k47QyYi7Q5
        nqiJGA9jPR5PwJHmTMpuilkBQldhd/A=
X-Google-Smtp-Source: AGRyM1t8jI70EnTbSk8Ru5v4Ta1iM5XvVfun73XBKp6mJwjv7Tp8gcu6ghoQk5pr6XSxTBFWnLCujQ==
X-Received: by 2002:a17:907:96a9:b0:72e:ddc3:279c with SMTP id hd41-20020a17090796a900b0072eddc3279cmr1429416ejc.138.1659067278359;
        Thu, 28 Jul 2022 21:01:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i21-20020a170906115500b00705cd37fd5asm1139304eja.72.2022.07.28.21.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 21:01:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, aahringo@redhat.com,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Do not use instance from trace context
Date:   Fri, 29 Jul 2022 07:01:16 +0300
Message-Id: <20220729040116.175015-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When trace-cmd initiates a connection to a trace agent over the network,
the logic in connect_to_agent() function incorrectly uses the last
instance saved in the trace context, instead of the actual instance
which is passed as input argument. This works if the remote agent is
set last on the command line, but causes a problem if there is more than
one agent or if there is a local buffer after the agent on the command
line.

Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2406489a..50039dad 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3934,15 +3934,15 @@ static void connect_to_agent(struct common_record_context *ctx,
 		use_fifos = nr_fifos > 0;
 	}
 
-	if (ctx->instance->result) {
+	if (instance->result) {
 		role = TRACECMD_TIME_SYNC_ROLE_CLIENT;
-		sd = connect_addr(ctx->instance->result);
+		sd = connect_addr(instance->result);
 		if (sd < 0)
 			die("Failed to connect to host %s:%u",
 			    instance->name, instance->port);
 	} else {
 		/* If connecting to a proxy, then this is the guest */
-		if (is_proxy(ctx->instance))
+		if (is_proxy(instance))
 			role = TRACECMD_TIME_SYNC_ROLE_GUEST;
 		else
 			role = TRACECMD_TIME_SYNC_ROLE_HOST;
-- 
2.35.3

