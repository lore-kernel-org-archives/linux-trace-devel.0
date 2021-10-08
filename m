Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE503C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D41561073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhJHE3A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhJHE27 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:28:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A4C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so31820323edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXmVf3FY4toRYdgln0XlmhOOeiMGQhZn3eiNOEvWHLs=;
        b=Q64scSpCO3gHIxHLbqTvw1AhTPBfgFegwrP4ihyZmWvuFVb6eFrYuTaGoaGDHc9YQB
         PxdZU5/LRpqy7jKgx5pkhGowOOLU8Ydbx/mARuxNOpHK2y03gO3+P3k6Nf//02FFNuwd
         ywzftM0ceHCJCdHc4a0cTLO9ZomPcI4RSipV9tB8QzngGfKPRbG18ftGv9mEOS1X4SF5
         gXl9wwEEHW/l53oxZUUDwgWwzTwIvBhfsvzD90g5xXaOqfgslUFutNocpaI9xfok0eyI
         kJG7ufMJwg7abbpW1tQPcSEcJ/7qDekMEkn/mYbbDBjKLdQ8rZtQdGvK7dUBsXxNcOC8
         UoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXmVf3FY4toRYdgln0XlmhOOeiMGQhZn3eiNOEvWHLs=;
        b=L4eXg9u7A8gzoCMJVwjH4f9+jO/Tsr3YQSfzqdB2LNbAruqsTfH+9mZImyJ/gMw4VE
         +S+oB8OL09NSeoB5plA+KPhzC2RCsoCLsbmf4ypK6N6g2WoXF8hVxFtokGm/fO9vN13j
         gdvYQrH4Fdkc8vZTlFkkH0Fzwh96NBRA3qBG6klDqOj5QDNRXmPCq4XFCiEXbZSoQARb
         4iqrZqfbk7m5grEHUUTsBw9AerhaNPaNhHvRRqlLgcpq5Ejx+HCvfGSgpFRCXyv8FWSV
         yUVlLVz5J8fUVxYX9SGQeVhQCHtvBSfsA9cRT/euWjhoLPh4qcqjkqJrXc1fw7WDySHB
         cgHw==
X-Gm-Message-State: AOAM5307hMPZBWwhgJDaxeAZloNi5CZyO86KP+U/bK+SL2r9MmfKosQK
        Dif6dzkcnmDFIJMjKvZveqSH2jqHlcNbtg==
X-Google-Smtp-Source: ABdhPJwzq1zFPyUMvMRKXxb+kOXQVrHlOJavS6W/jHs29zIIhBzYshjO9LC+6143nmCYmMpXTl1yZg==
X-Received: by 2002:a50:d98d:: with SMTP id w13mr12048360edj.51.1633667223274;
        Thu, 07 Oct 2021 21:27:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/10] trace-cmd dump - v7 update
Date:   Fri,  8 Oct 2021 07:26:51 +0300
Message-Id: <20211008042701.979075-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on "[PATCH v3 0/8] trace-cmd convert",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20211008042510.978362-1-tz.stoyanov@gmail.com/

v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 458 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 413 insertions(+), 45 deletions(-)

-- 
2.31.1

