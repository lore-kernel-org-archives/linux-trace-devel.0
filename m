Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E0AC0650F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A342184E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5MCJrpP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfHHLhY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 07:37:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39084 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHHLhY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 07:37:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so4456717wra.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Aug 2019 04:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aHWmXFRdGcyk175oSXSIDeCgqp5ZLhsNp3/3NhbejDM=;
        b=g5MCJrpPz/RQWLLpHTB8yvCE2cyG2dZG6yjZXJGMxLwKLMV6agqUzA72q/YlyI8UfP
         ylwY7nLE10FxXX9Dgg91DJDj1p3Li120rWUmgv54DxeXvO1X8LAW9bcm8Pl1Vg5hhQsm
         +6UZQ3lwMT0Ru31VEHdBqAT+nePfQ8Ndbvqy98G0rPcBgNG7m008azPxExmQIs0KrO9G
         wAEMOaQcaNgDMkibdhdIIbkKswd+UX5By2c3qOaqUvFszCWMcGRkBM8l3jIYeVjq/BIG
         Qp88B6P/CbJwAuQUnlx5lZqLEtpg94w7s05Rrwt41FttVhAdlYhrjR1Jo6yHgk9sq+Ib
         6g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aHWmXFRdGcyk175oSXSIDeCgqp5ZLhsNp3/3NhbejDM=;
        b=ribwvY0hPEIgoHMdD21Kz23C7e7YnTx3PlXb3QlYeGhoe4P8QhhmG47lmBH8z1ndWt
         1pChWjOqUJ99K3ytZjJRVT8FsTEfe5I145RBJzyFoQ4pgCfYlvKcKgUvTyfSkHXzeS9F
         2U/O3KwagsFuiTSdFtE9e1VpGI124nqVxCYkU3cNBkgBko5jt0OnTSmwS0Z8H9KGuWXt
         9WB6i/zSxMluwDhJeAXddGGsu4ki5lM+DB/uGwWf25z0n7XVqP4+stZTiEJ57+vZfAXi
         JeqvRpNQaffNGoIKJpStw0vTIhM2bcNN9l2igVT3nyxOMTxHZkDtsx6hha1qXl7Zs8jS
         v6nQ==
X-Gm-Message-State: APjAAAXixAOIBMszWuwy5HwENnqkBOBWnJl1zkSNqxuXVMaHyxDzxPsV
        g2uvaibj5KTLE9UtePe14f8=
X-Google-Smtp-Source: APXvYqwGMHr0MQEHBwFeCoI4oMGtsj2qlMC41wefHvsqng1Zg3Shb6RyE5UDFOuN1HxWYuhtgPVvww==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr16802018wru.141.1565264243012;
        Thu, 08 Aug 2019 04:37:23 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t63sm1799793wmt.6.2019.08.08.04.37.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 04:37:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools/lib/traceevent: Add tep_get_event() in event-parse.h
Date:   Thu,  8 Aug 2019 14:37:21 +0300
Message-Id: <20190808113721.13539-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tep_get_event() function is an official libtracevent API, described
in the library man pages. However, it cannot be used by the library users because
it is not declared in the event-parse.h file, where all libtracevent APIs are.
The function declaration is added in event-parse.h file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index d438ee44289f..b77837f75a0d 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -441,6 +441,8 @@ int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr);
 bool tep_is_pid_registered(struct tep_handle *tep, int pid);
 
+struct tep_event *tep_get_event(struct tep_handle *tep, int index);
+
 #define TEP_PRINT_INFO		"INFO"
 #define TEP_PRINT_INFO_RAW	"INFO_RAW"
 #define TEP_PRINT_COMM		"COMM"
-- 
2.21.0

