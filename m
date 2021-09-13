Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE2AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E0176101B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhIMMv7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMv6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:51:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9184C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:42 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso1364221wme.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PX9PExvI+Hnuvi4iMwj7wHc8ydbJ/DchcQqB041I/Eg=;
        b=HKOfYLY6qRzKg33QpoWuibiQa0qqL4hZfl1w7xO4dgEQdkDSzXMAWCner5GGgckvFE
         br9obSGv1KTmt6IwN+yCPCpQTfnbXBX89YXFyIa48vZBK/QsN9bny+Akzwbdu1jKUA3H
         I5A/Cf9NDm6HkoXbKdDD1jiVBG9QeEAb7StyPGzheMIKg0bQCZeilgSUeDku8N5MmxNq
         fDIbqNLwLBNWtlT5xM7ayj4IsKDA6kmYUqmI7Og799qgyCFHS4UnIf4SLQIlmP8Mlyk2
         TvFDv3QuTY13rna9csfTmUTfqujlcrOf65qpwnlEy4uuwy8hyp1MzMEmsGhawTSlv4CH
         04PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PX9PExvI+Hnuvi4iMwj7wHc8ydbJ/DchcQqB041I/Eg=;
        b=7Q3YM3buZ5unO05hXwYIwuRerjaZdL7f88XtLnr2EAozshH8KYd7/8lcV97LTARlvb
         1z9F24D5zsXE2tvtOmQ5mQyW2bmnYauRoq2zx+mR2w9g7zytcdKlGw0SsFQTK19QkZ36
         S+AMukwUEziRpacRCRMsEYH80iCvug/znTjLV1KrXhwIlEyASxx8HdFkifFh+y6g9C/2
         yz+Mcd87LSfu7Ef6GfCBto3d+d7wCimn+C0kBzDqoZ8l4pQ/RtU58R3wIbplH2xz/dl2
         XjFyeW6dl2HVq7ZoX3p+EtQH+JDc/fb5m6ui0xuJz6tnMZD494LzpdaMhWz4iwjxcGIU
         06IA==
X-Gm-Message-State: AOAM532b4uY3vEO3ZDU0QeByjPFkdgAeSboT/9hVVafiWORfJXxK3pQI
        zi55b0zUn3gQu3DTuKu6sy5qme7rRQI=
X-Google-Smtp-Source: ABdhPJyx+XhP4YIVLQ9CnnuRXAPxPVCNwoF5V894Mn1AHd2A0n01P+xSan4zihj00a8u8pzBZ54Lgg==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr11075653wmk.17.1631537441410;
        Mon, 13 Sep 2021 05:50:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/10] trace-cmd dump - v7 update
Date:   Mon, 13 Sep 2021 15:50:29 +0300
Message-Id: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on "[PATCH 0/8] trace-cmd convert",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20210913124754.3679916-1-tz.stoyanov@gmail.com/

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

