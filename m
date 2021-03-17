Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1129CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED6364F64
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhCQLkJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhCQLjj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 07:39:39 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E46C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u4so1811029edv.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sBTVqEZldjZz4xrLRGynk18v10VLvduJUM0U9CiqRDM=;
        b=ggRXQxMHiUpnUACbCuHxslliHxxcQyEWicm/o6ZT0I63MDTSmtf/yekktPj6SCRXcJ
         EVxKX3OTMaBTjT0CARw3OepTw8YMSFXhIT5g7L3KapJO1NNOYKTgAZkbKGnm0OIPolFB
         W6+gaml9IJSEBw6B6xje71Mv8Q1NYj5DYq/E6D4mmCEaaxBGAdkiUTXoyukwN9Z7ZgJf
         qaCZcBhbNYMQzxO+pWnwPODRsKF+Oz5hXkrRZpXEF4o31Kwcf6Ee5Y5zauDYwT7Q9ZXi
         B9kGstfMsgKQsc7aqOdH4bb3qG7H7H1SIv6XbCkFaLzwFSQxLojvqpL98aVB/ID9yjaT
         2h7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sBTVqEZldjZz4xrLRGynk18v10VLvduJUM0U9CiqRDM=;
        b=V1N0PqY7jdHHX1/FnygrQhyq2cjL/CevPMG34yenFj9OImWFwuXGHPSFqeNO3VVBr1
         rxawnZquW2Qjf7OGH2P7Gulk7fubt6mDhsVxeUHtrySqMNZ9bNrOsgu2NiCNnP0g+dR5
         wBimzr+srJhMdV9WJCF9n8QAHc2idSgwwQF/Zxaim4ELcgrz/6Z8y9LlQpCOZqEEQnFy
         ckZlvB79F+cHXK5UURdEcE9ugTEUhK/z42qFkOFmKsmfrtStbudjmi8Ka0b+0o43nySP
         4RL8ro01as7Wu+7VN3ITq7aerF413fGRYi7NLjgFhqsOyhHRrFJ1tEZn07OcLmj18yYF
         P8yA==
X-Gm-Message-State: AOAM5318gNoza15E80nRjILrxp4Jj3w8P4QWBnj/v2w/+moCbrf0inMy
        +SXDifEqt/vY7ECNpyeeqUrXCU6X65k=
X-Google-Smtp-Source: ABdhPJz8PYKiKoGf8HG5NyQjMrLUAbwxbwhsYCdvPc7FXwJy1hEBD3iQ6aSK2XpqoH5GAXx87hvdVw==
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr41456194edw.89.1615981178100;
        Wed, 17 Mar 2021 04:39:38 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p3sm11124492ejd.7.2021.03.17.04.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:39:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Refactoring and improvements of time sync logic
Date:   Wed, 17 Mar 2021 13:39:34 +0200
Message-Id: <20210317113936.271143-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for host-guest time synchronization is moved from trace-cmd
application context to the trace-cmd library.
Additional logic is added, to ensure the first pass of the
synchronization is completed before starting the trace.

v2 changes:
 - Coding style and gramar fixes.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Move time sync logic in the trace-cmd library
  trace-cmd: Wait for first time sync before the trace

 lib/trace-cmd/Makefile                        |   2 -
 .../include/private/trace-cmd-private.h       |  33 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  16 +
 lib/trace-cmd/trace-timesync.c                | 515 ++++++++++++++++--
 tracecmd/Makefile                             |   3 -
 tracecmd/include/trace-local.h                |   5 +-
 tracecmd/trace-agent.c                        |  19 +-
 tracecmd/trace-record.c                       |  70 ++-
 tracecmd/trace-tsync.c                        | 294 ----------
 9 files changed, 576 insertions(+), 381 deletions(-)
 delete mode 100644 tracecmd/trace-tsync.c

-- 
2.29.2

