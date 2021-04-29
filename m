Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAE1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066F961185
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhD2Pp2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbhD2Pp1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 11:45:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3055FC06138B
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c22so15483889edn.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lg8dR48qEgHA9/bQ2E3t+oobJ5MaPHRFqNqCOrzHK34=;
        b=npFumJgy0WAeOGvG4yuzXowRm1H2e0KVk4pePvb09tEA+kgHGLVdvBmVzjVsE3y9oC
         91X/oIS2Z6NW00E9Zc2AiCeS5VTqB/BdyDicYTrHiqMXYqSSkHY1zvVH1QyT7kJsl/Cs
         JnuJgOzlKVH0DORqIqmWtgdfKp9pi11xRgF0dlqNnxvNWwwe1b5GCBLIWnxHgvvWyRU4
         ixgwAVvmQLUKbhDVznFWyXEFdOHc2jVrJLtI8+RS8wHF0wcWNbZjakZo8N7AK1n3iArc
         1j5qQ8w45VqPO72e3jJ5+om3tWkjBGWnqV0H0+Du4SFZmgsJLknZdmjUxnJZzlYcuUBa
         NviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lg8dR48qEgHA9/bQ2E3t+oobJ5MaPHRFqNqCOrzHK34=;
        b=k6kFodFhF7PzTNzSKAEug77RStcKquMYEUqkw5xseznGf8au7OFQJAxO8Jihq6MbPx
         6KjpbSWTej5eljFmAyezinmlkRo5Sb8ROHp5uaFLmPganYkq2EtgCuENIL69juIyGyyL
         TVMizTd60PwJn4+Wjmgytf4F+s+cqVWRuGdynaNUvkqCWPoQBYSyCT7k4GzpgwXpxEkv
         UNnQ7dfQjxEJPPNpbq10a3GP9tZ8ZkAmspM37wcwSIXy7zg/MN0XjvCrA8HjiscbEjov
         9+GiJzVTOj9K6CiSrIAM6ow2y9j9mp7GDF54DQkJDJH2qG5y6ko92urd9hPeY+MHFB2q
         WenA==
X-Gm-Message-State: AOAM533CVTse2bYFwHeb1SQpwXEieVnScYsHrqVBKbUql7yLU1eBgvfM
        LF8bclFx5DYMFnBwsxguD7o2OLTVmyc=
X-Google-Smtp-Source: ABdhPJwOUjRqDBLBW5pGDtIXLX5dxIU5qvWwfM7I9EgeUgGSM+zinBMXJaxLSYEIsts/CvKbxxJRDQ==
X-Received: by 2002:aa7:d14e:: with SMTP id r14mr189627edo.119.1619711078689;
        Thu, 29 Apr 2021 08:44:38 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id t15sm2650602edr.55.2021.04.29.08.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:44:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] New plugins for KS 2.0
Date:   Thu, 29 Apr 2021 18:44:19 +0300
Message-Id: <20210429154421.255872-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch applies on top of the
"(Not so) Minor fixes toward KS 2.0" v2 patch-set.

Yordan Karadzhov (VMware) (2):
  kernel-shark: Add EventFieldPlot plugin
  kernel-shark: Add LatencyPlot plugin

 src/plugins/CMakeLists.txt        |  10 +
 src/plugins/EventFieldDialog.cpp  | 183 ++++++++++++++++++
 src/plugins/EventFieldDialog.hpp  |  60 ++++++
 src/plugins/EventFieldPlot.cpp    | 109 +++++++++++
 src/plugins/LatencyPlot.cpp       | 305 ++++++++++++++++++++++++++++++
 src/plugins/LatencyPlotDialog.cpp | 184 ++++++++++++++++++
 src/plugins/LatencyPlotDialog.hpp |  59 ++++++
 src/plugins/event_field_plot.c    | 125 ++++++++++++
 src/plugins/event_field_plot.h    |  64 +++++++
 src/plugins/latency_plot.c        | 168 ++++++++++++++++
 src/plugins/latency_plot.h        |  62 ++++++
 tests/libkshark-gui-tests.cpp     |   2 +
 12 files changed, 1331 insertions(+)
 create mode 100644 src/plugins/EventFieldDialog.cpp
 create mode 100644 src/plugins/EventFieldDialog.hpp
 create mode 100644 src/plugins/EventFieldPlot.cpp
 create mode 100644 src/plugins/LatencyPlot.cpp
 create mode 100644 src/plugins/LatencyPlotDialog.cpp
 create mode 100644 src/plugins/LatencyPlotDialog.hpp
 create mode 100644 src/plugins/event_field_plot.c
 create mode 100644 src/plugins/event_field_plot.h
 create mode 100644 src/plugins/latency_plot.c
 create mode 100644 src/plugins/latency_plot.h

-- 
2.27.0

