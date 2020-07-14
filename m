Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED417C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF4722203
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AXZSJuNR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgGNKad (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgGNKac (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:32 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C69C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id y10so20986439eje.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PZedAyn6yhOSL4Bhukw+F6cNF6L2VLWLfK1cXDB1sPc=;
        b=AXZSJuNRbnKB1E06Y7KW5tpmEDYXTtklMIGp50nDA/zb8g32DAwXGYrLA69G1eM/Q3
         9Kaw8XSm37xKeK8eUywGHPqHSBLPNiO+GAw4adnxExn1B/a/I4B0isz6wrdPCVc/rmxy
         2ShSXDo6JMKAvvzP/FHawNvOPxa6EyiBJA1wDzpQjQm7+NsnG/Mm6ACKzb3bZqu7eL9T
         BpsdK/ln8V/n0qd4q2BLVYZ0ObsMBPAJVLT9S3DLeVG0u+VRRxwI5zGM/QkWIjYlyw91
         PX5Jtpr3+uEb1BWo09dJLwZXEGQy/XwjLK1Zx3I37+hajvBnewsKNzS8wcT/zqR+l2jL
         +jbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PZedAyn6yhOSL4Bhukw+F6cNF6L2VLWLfK1cXDB1sPc=;
        b=QQPbJHmy37l95/8lpyol+jBdqpyzpAmkhmdPd+AIglwVbq4JgCPZos5STJfgBdC91g
         NBm5639fN+WnNlPB2Vmf3gPljRC0iAl6wFZF4HS9IO40Fx/8Ng9WX6oy9I4ne6hFKd88
         VI14dmPh7JNDzDQhbi9HSFAlWXI1ZCHA78O0Vg0Se/FyjPBJxtXU70cT18uYtN9ksoVS
         6SfJxudhW5jJsYwszy9jxyNnonbSXXRuByUQ14EfuwC3soM6cKBYK1CmYi+JHg1RPvhB
         y45F5nNhDBDqfFr+bUkcHALZ5nfcGuGxUHmOsw3Ernw4CtFwQ9ojYY0Kf0RilwZs8hh4
         Tvow==
X-Gm-Message-State: AOAM5320gR1MfyO+OrAdwmFtbmpxBdouXmTxgX+QrZCVYG9TEfGD/NP3
        eqMGWtapar0PFftNLmGEJmg=
X-Google-Smtp-Source: ABdhPJzSblltvqJpqgC6+hAlZbk3MfK8UpTlvpSpkN62CT1N3l9EEf9NilixgxY0cdSxE+ZgFQ144Q==
X-Received: by 2002:a17:906:280c:: with SMTP id r12mr1060797ejc.105.1594722630485;
        Tue, 14 Jul 2020 03:30:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 0/8] Few libtraceeevnt fixes, suggested Namhyung Kim
Date:   Tue, 14 Jul 2020 13:30:19 +0300
Message-Id: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd: Document tep_load_plugins_hook()
  trace-cmd: Handle strdup() error in parse_option_name()
  trace-cmd: Fix typo in tep_plugin_add_option() description
  trace-cmd: Improve error handling of tep_plugin_add_option() API
  trace-cmd: Fixed broken indentation in parse_ip4_print_args()
  trace-cmd: Fixed type in PRINT_FMT_STING
  trace-cmd: Fixed description of tep_add_plugin_path() API
  trace-cmd: Handle possible strdup() error in tep_add_plugin_path() API

 lib/traceevent/event-parse-local.h |  2 +-
 lib/traceevent/event-parse.c       | 10 +++---
 lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 19 deletions(-)

-- 
2.26.2

