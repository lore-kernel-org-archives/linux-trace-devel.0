Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A89C282CE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE98E2186A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BZwqLB4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfDKWJM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:09:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43503 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfDKWJL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:09:11 -0400
Received: by mail-io1-f68.google.com with SMTP id x3so6737159iol.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 15:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYO7yPGl77SlvK3Hnow38o1TOlaAvK5sTQp7oXwNnwc=;
        b=BZwqLB4gNsK3tTdafg4JARyz54TI2T1DyAzGfEzYaevFsK8VKqQFQtROrITaYsjkXg
         YtjSm7qFfsb/M+trycr4SSBMPPYSE86xrzACky8yZNbwV+RcIOGmErC4XgtIyHxbrqEW
         /DQcWZ4a8AhkkTpfUfunnYArFgcgdtAou5dlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYO7yPGl77SlvK3Hnow38o1TOlaAvK5sTQp7oXwNnwc=;
        b=niECtxOmX7o1lMzfJVhPh0Ijcljg2zlvsFk+dGg9+kQZ3kFYLHz9Lm/TmLKIwjIDxI
         vLK6lmOHBDf5EMfB+RTj7ePhqwekS/AztiBfh6551QQJOPWm2r2Io10xMQHuro5W/+VV
         NEVnFMs8HOqpTkk0W584zYuKUfswvFk5sfmU0uuqNk3q41Li/yAqmSGpJA7RoNURk0Qt
         KI5vBsYJ6m2aSvIUCyY5V8/7VVXuyOB8Bq6V6eX0i7eqGPb63PIf5BEQ2Np3xD7ZpTl/
         UdRTr/tu1F5aGKGp4eVZqb5Hg1Lw7YdyBbEaD2rih+ctp+DtoHi7dJvDqBWZasapFszY
         8eeQ==
X-Gm-Message-State: APjAAAUbub8lbxUisKzEBBFcA8gJSBc4xdtSLFhIfWj2ZMoH7il2sNdD
        A5PPBohv6w0/DrduwzQBxCMn/p9qpTIdTGso
X-Google-Smtp-Source: APXvYqxWU7ZztJqQGSd9ylhDY9md3BjC8EJOn6fQ3w2fl32XdRweFyIEcLUgIGJ9BfHvUUyc3haTQQ==
X-Received: by 2002:a6b:5006:: with SMTP id e6mr33428786iob.176.1555020550998;
        Thu, 11 Apr 2019 15:09:10 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id a196sm3347775ita.14.2019.04.11.15.09.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:09:10 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Liming Sun <lsun@mellanox.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 2/4] mmc/sdhci: Rename sdhci.c to sdhci-core.c
Date:   Thu, 11 Apr 2019 16:08:20 -0600
Message-Id: <20190411220822.81845-3-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190411220822.81845-1-rrangel@chromium.org>
References: <20190411220822.81845-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Preparing to add an sdhci-trace.o to the sdhci module.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/host/Makefile                  | 1 +
 drivers/mmc/host/{sdhci.c => sdhci-core.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/mmc/host/{sdhci.c => sdhci-core.c} (100%)

diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 73578718f119..11174945c116 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_MXS)		+= mxs-mmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
+sdhci-objs			+= sdhci-core.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 sdhci-pci-y			+= sdhci-pci-core.o sdhci-pci-o2micro.o sdhci-pci-arasan.o \
 				   sdhci-pci-dwc-mshc.o
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci-core.c
similarity index 100%
rename from drivers/mmc/host/sdhci.c
rename to drivers/mmc/host/sdhci-core.c
-- 
2.21.0.392.gf8f6787159e-goog

