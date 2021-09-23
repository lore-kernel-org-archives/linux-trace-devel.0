Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909A6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E4261241
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhIWJrR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 05:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240219AbhIWJrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 05:47:01 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA2EC061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:30 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id u18so15422023wrg.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FmIEmhdPxFQQQ03wsULZxXHGQcxrcSYFmvjf4crbcYE=;
        b=QljlYHn/LJ5NX4LPQVfwz6qHfCl1B0cTP2ud7Netq/+Y8sSh1aLMYFC3iNoRCyo2pg
         381XFacrpmwcyy+Joi/IomsTfoaucYr7LhclYUQknf+zoBLCHflxft5JDJcEmGx5eL2J
         qx7E50l3bg1+NZvpzHD7CrTeZrOEf4m2rAoefPDHPA+6iY2hLsWrXi/ZYRGhHbmIKe/u
         SBtIKRqmQvWMvVKk+o4y9Zv/z6MUqnrqD8D+3yvDx5zbeRF8CH19m2hfqWV7RK/AZ7+L
         0wlVsXKcBJDHXsjI0Qf1wvHEGsYmJ/jvURwalRJQSP7G+waPeFB6++0WfM2P6mYHUIqp
         uwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FmIEmhdPxFQQQ03wsULZxXHGQcxrcSYFmvjf4crbcYE=;
        b=BNUWx8rMA1aDTKYMluXwnrCrMTuO9GWumZydH7qmuL1do4IkxR0qnDcYtKd/UZuviC
         cxjpsBjVFjLNmlpQstHV3yxXPrdeJVE6nKdwQf3LiGbQZriul4j5yWeI+V3Cp4cjOBDv
         W/kiLfhrp1ljpzLjBPbiOIzXt5jqXRici4I4ysfW9mlD6YIpqTu24R4g1YpjHV9oAS+e
         /5/SBDf5GPIwRESSoUKv2qjb60QblVKyF2Rk8Ecc1HwxQ4LQTa959cdmmBUhMvY1KC/a
         E+ur2X5rwkAG/EZ+xaas2tU/8OnlF7NfrzW+Ykk8KLz8OPnVPbwiiZOB/1Unn2ayBxJy
         Llmw==
X-Gm-Message-State: AOAM531tQ58snAe6VDimDnylPU+EtRActjIWO54LwGXomJP4cXL/+wuu
        KZUBBgwcwyf8tKgOc2gdNZTmSw73+OycdA==
X-Google-Smtp-Source: ABdhPJy+IP62Rg6L83QjZWstjvzs5qHa+0SYMY9PFc7301fWwDh2enNQmqVXt2nSioUgXVL15lmkZw==
X-Received: by 2002:adf:fc07:: with SMTP id i7mr3924580wrr.351.1632390328996;
        Thu, 23 Sep 2021 02:45:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm4969523wrh.13.2021.09.23.02.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 02:45:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: Align guest TSC calculation with the kernel
Date:   Thu, 23 Sep 2021 12:45:23 +0300
Message-Id: <20210923094526.765059-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The formula for calculating guest TSC clock, used in the kernel is:
 guest_tsc = tsc-offset + (host_tsc * tsc-scaling-ratio) >> tsc-scaling-ratio-frac-bits
Current trace-cmd implementation does not take into account fraction
bits, when calculating guest clock offset in case of a clock scaling.
Additional logic is added, to use the same formula in trace-cmd. The changes
are backward compatible with trace-cmd 2.9.

The changes are not tested with a kernel that has guest clock scaling enabled.
The goal of the patch set is to extend the time sync option, saved in the
guest trace.dat file, with all needed data used in the kernel for guest TSC
calculations.

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Extend host-guest time sync with fraction bits
  trace-cmd: Read and use fraction bits from TRACECMD_OPTION_TIME_SHIFT
  trace-cmd: Dump fraction bits from TRACECMD_OPTION_TIME_SHIFT

 .../include/private/trace-cmd-private.h       |   4 +-
 lib/trace-cmd/include/trace-tsync-local.h     |   7 +-
 lib/trace-cmd/trace-input.c                   |  79 +++++++-------
 lib/trace-cmd/trace-timesync-kvm.c            |  59 +++++++---
 lib/trace-cmd/trace-timesync-ptp.c            |   4 +-
 lib/trace-cmd/trace-timesync.c                |  49 +++++++--
 tracecmd/trace-dump.c                         | 102 +++++++++++++-----
 7 files changed, 205 insertions(+), 99 deletions(-)

-- 
2.31.1

