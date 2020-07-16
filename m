Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9F0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60522206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPnwgCdl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgGPJUT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJUS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F992C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z17so4225059edr.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYocCSj+R8sDwKW/AA6NnTZvmkXRLf5UHEPEAgASkd0=;
        b=jPnwgCdl/ottDNclAWfZOBp1H4craok2d/etHr2XlLk8eRAwe02peH/KWO7Hyluqyo
         BGYcpTwgW7odJjoSebt1G72tC4AzSpk/iEhGESJA3lQZBSlOlCMJH+JyglaNua+vaxsz
         m5YO+FPhvS5gzot1DU6HrTG6/FY/ZVJ9DK3BRxz39Q/yru1h2iQ9h8SKSwlMYv7+tt5K
         Vv/YpFedntbWyydmQBIVImag5O82CWJq/3BYu8IELF2mDKFSCklbxLNzf7Rd/sV+iOIb
         1ldDEO3GjqvGoTVCyM7uGR7zMWukAniymAbag8iq+9zNGzeAuQbQMTkFEYWs865G17sx
         Ywrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYocCSj+R8sDwKW/AA6NnTZvmkXRLf5UHEPEAgASkd0=;
        b=DJnzDoP52HKdEaDwEterKdwDBpRNLFlTt2tYjKLt+RizgN6DertFbc8cquJ7CNhigz
         lRKUHGD1BKOQrNklyRHmFGh8EZANzTCthXyBpVLHj3Dq17kQv2IneMApr1nSf0XiR23I
         W9VmRnflhwAiOyk4dTZsLneANuFu1UaImRAyMLPAWrGOxfzYmF2F+ZmfkDCSp0cpBg1H
         Ikmiy3aPX6dVPlIi3S8HDteAiG4oG7Bv+Ongq9UZsXqo24wYHIKHpyHQNtJzXpoGcZ+m
         4en3BUfO6qASH4ArPCTD7noWhyhepL4miH7Z/9s2sfW3lvRWv52taYzmnp5SmznayLdX
         ZHaw==
X-Gm-Message-State: AOAM533Z+wC8AgBU8pD4CTdCD+zadv/+GBulbGIVg/XO85ZTZVUD1SUH
        vyGuUhRPoMeF92DOX3zlRLM=
X-Google-Smtp-Source: ABdhPJwuLXsl8q37Eq0ATOcEiLWuEtsCp6DKtJozxohVC4L6lwzLgiwngr1xRtCXQGN5D/oR84beXg==
X-Received: by 2002:a50:fd07:: with SMTP id i7mr3519618eds.221.1594891216937;
        Thu, 16 Jul 2020 02:20:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 0/8] Backported libtraceevent fixes, suggested by Namhyung Kim
Date:   Thu, 16 Jul 2020 12:20:06 +0300
Message-Id: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent fixes, backported from trace-cmd repository,
suggested by Namhyung Kim <namhyung@kernel.org>.
There is one additional enhancement over the original patch set:
a man page, describing tep_load_plugins_hook() API is added in
"tools lib traceevent: Document tep_load_plugins_hook()"

Tzvetomir Stoyanov (VMware) (8):
  tools lib traceevent: Document tep_load_plugins_hook()
  tools lib traceevent: Handle strdup() error in parse_option_name()
  tools lib traceevent: Fix typo in tep_plugin_add_option() description
  tools lib traceevent: Improve error handling of
    tep_plugin_add_option() API
  tools lib traceevent: Fixed broken indentation in
    parse_ip4_print_args()
  tools lib traceevent: Fixed type in PRINT_FMT_STING
  tools lib traceevent: Fixed description of tep_add_plugin_path() API
  tools lib traceevent: Handle possible strdup() error in
    tep_add_plugin_path() API

 .../Documentation/libtraceevent-plugins.txt   | 25 +++++++++-
 tools/lib/traceevent/event-parse-local.h      |  2 +-
 tools/lib/traceevent/event-parse.c            | 10 ++--
 tools/lib/traceevent/event-plugin.c           | 50 ++++++++++++++-----
 4 files changed, 67 insertions(+), 20 deletions(-)

-- 
2.26.2

