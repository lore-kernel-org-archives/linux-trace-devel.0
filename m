Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BA4C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D941520693
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b/VPWZc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfDKWIz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:08:55 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52047 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfDKWIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:08:55 -0400
Received: by mail-it1-f196.google.com with SMTP id s3so12462677itk.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 15:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyJ3SQgUEevWT6/ml7l3Hcpb86zX/BNEKeFpP/RAuGw=;
        b=b/VPWZc2kAsOJL0ru0D8/p4zV8S60ggjk4n3VZ0KX/l3V+HOC4cUKkpIcZ8nBoiRRE
         Mg15Dkwy1TATm9ogU0Sy2sLo2xDO2VYdzRfs7PrI2uwVmtzOKP7R0l7Il2wH/7cCUZt4
         saPCAVGxThig+UsMyq3VBAo8GlXr4n02IBVAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyJ3SQgUEevWT6/ml7l3Hcpb86zX/BNEKeFpP/RAuGw=;
        b=WZzDrT3BoMWJ4+DJMzobWUhHPDCbye4G7j/anmEIBnk/X1sJtfuY5OP1zX5aC6IpPi
         kvpLjySjC+DvBFo/8A3sWJHUEm4OqTjIHyIBcXSVORFUwTrHLFB/qU+Vsho4p15dqsy0
         Bti904htxSnX2sl05eUWAXDV4JoD5t/QYFdRlv7rwi/ZypQ6Su1BKOVwezhmvDMJWIX4
         Eu6XIEB0D9lC9SRwFOXv0yKezqGpd9d13G7ks2S+2qrUV0+UtUHQMqs5FxxS4gyFetCd
         WeMqa4yNq+3OzXueYe28f3UdZQY8Bw+TBBUFnvICEzm2g/SuPwYx2jeaaHrReaDy0NTg
         bbrQ==
X-Gm-Message-State: APjAAAUPeAhlQqBRfVKoy+sRt8bRmAfOqm65qT9WRufdmvoHJWDe2pLS
        0ub72z0EbpTSaI7U/HY+yEvoTICTAr7Q8hfr
X-Google-Smtp-Source: APXvYqziRfFeOHT6Or2OviZL2iL1hBlA4OYOQFlelTMThhtkyXh2vGrXmZzqHdmH8GiwRsoMLB+Cag==
X-Received: by 2002:a02:4345:: with SMTP id s66mr25873617jab.46.1555020534682;
        Thu, 11 Apr 2019 15:08:54 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 1sm3365757ity.9.2019.04.11.15.08.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:08:53 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Liming Sun <lsun@mellanox.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ingo Molnar <mingo@redhat.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 0/4] Add tracing for SDHCI register access
Date:   Thu, 11 Apr 2019 16:08:18 -0600
Message-Id: <20190411220822.81845-1-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I was debugging a SDHC hardware bug and got tired of having to
translate the register values by hand. This patch set makes it so all
SDHC register read and write operations can be traced and easily read by
a human.

An example trace can be seen here: https://pastebin.com/x73d5cvL

I ended up defining a new tracing function `trace_print_register`. This
method takes a register definition and pretty prints it. It's a hybrid
of `trace_print_flags_seq` and `trace_print_symbols_seq`. It supports
printing bit fields, enum fields, and numeric fields. See the
documentation for usage.

I hope this makes someone else's life easier when debugging SDHC
hardware problems.

Raul E Rangel (4):
  trace_events: Add trace_print_register to print register fields
  mmc/sdhci: Rename sdhci.c to sdhci-core.c
  mmc/host/sdhci: Add register read and write trace events
  mmc/host/sdhci: Make sdhci_read/sdhci_write call trace functions

 drivers/mmc/host/Makefile                  |   4 +
 drivers/mmc/host/{sdhci.c => sdhci-core.c} | 136 +++++++++
 drivers/mmc/host/sdhci-trace.c             | 319 +++++++++++++++++++++
 drivers/mmc/host/sdhci-trace.h             |  93 ++++++
 drivers/mmc/host/sdhci.h                   |  89 +-----
 include/linux/trace_events.h               |   4 +
 include/linux/tracepoint-defs.h            |   6 +
 include/trace/trace_events.h               |   9 +
 kernel/trace/trace_output.c                | 121 ++++++++
 9 files changed, 698 insertions(+), 83 deletions(-)
 rename drivers/mmc/host/{sdhci.c => sdhci-core.c} (97%)
 create mode 100644 drivers/mmc/host/sdhci-trace.c
 create mode 100644 drivers/mmc/host/sdhci-trace.h

-- 
2.21.0.392.gf8f6787159e-goog

