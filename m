Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4862FC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 15:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiA0PEa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 10:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbiA0PEa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 10:04:30 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43223C061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 07:04:30 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s18so5322034wrv.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 07:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=woBFFNyWVDYlzlL6DYLd9KhQrZmXFVmzSS6deWwHhPs=;
        b=PiTyUMGs2wU2UXbn/PElcmMaiykvY/3nuCrTfTFlSX0vPP7OcrHAXxwPjgohTfzU1B
         2eWer0JkmB9EIpaDsf9WtKcgZOl3Rawduha4ZSJSruQEXP4qRSuzARkTFT+VbieT3Ebf
         8mjPoFdyUnWp+tlyB/ZEJ9CWqiPIupg5NingGeBVdGcNVCUsODjV8A2/0wn6yU2ZBzIX
         1p29B1lq3yWDe6jrjYeamKGdegh8WDM8+77P+cAhCFM73QtwfXy1ToV6GwXN4NOUo2FQ
         Ju4ymanmCZfp6JQ9qD1r0yW/TymjVuQEw7GVzIn/foyR1vNcoSlhG/Mt2AWmsIxIeh3f
         iBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=woBFFNyWVDYlzlL6DYLd9KhQrZmXFVmzSS6deWwHhPs=;
        b=pFrQH4p6cqWl4vpm8wIVs1yZKc2Ggd/YQY3UbULPksAJOAUbz67gij3Su+RrDQRyFA
         sLjIMjWiCE07lxbHvM2p14/mpoKj8PR3gxk/CKro/IUVdCNh75xg/+1r8ikFVZdQnisF
         5bIPg//+J9xJUA2RHV8xleJX1gtKr4NGedesKkl53QXfNNXE0kRdhxh29vNaCnkTIEm5
         Pse+Ext5psD9orgp0Y/elRqpsmHlcEI8taJl3nfG2ZABThx+wAH+1CAyVU8/I3L3wq+0
         ULryTzUw2hyoVwBNz33XA/29of5x8kgV8m6+yQ+JMhJJObf75t/ON6OwKlD/pk6oWzHR
         wdjg==
X-Gm-Message-State: AOAM533P43tuXzovV77iHHVjX+zC+KYHkP5ykxa4W2NTlxizKjug72df
        v3z1mFdP0pSnLrYuhPsXUf2k2mv7G9Y=
X-Google-Smtp-Source: ABdhPJxUPGXqpR1GfTNaYe/xHmvItjEZgeke+AXH3djGue36SdADuB9htIBUbjcru8mJD+JdoJDlYQ==
X-Received: by 2002:adf:e64a:: with SMTP id b10mr3453462wrn.680.1643295868723;
        Thu, 27 Jan 2022 07:04:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l10sm2352613wrz.20.2022.01.27.07.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:04:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cruncher: Update CONTRIBUTING doc with tests
Date:   Thu, 27 Jan 2022 17:04:26 +0200
Message-Id: <20220127150426.50756-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All trace-cruncher code should be covered by the unit tests. Added
instructions how to run the tests in CONTRIBUTING document.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 CONTRIBUTING.md | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 1f73807..0eb9f85 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -20,6 +20,15 @@ The preferred coding style for the project is the [Linux kernel coding style](ht
 The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
 as described by the Linux kernel.
 
+### Tests
+
+Make sure that all your changes are covered by the tests. Before submitting your patch, check if everything works at 100% by running the tests in **tracecruncher/tests**. Compile your changes and install trace-cruncher (`sudo make install`), to make sure that your code is used in the tests. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
+
+``` shell
+cd tracecruncher/tests
+sudo python3 -m unittest discover .
+```
+
 ## Reporting Bugs and Creating Issues
 For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
 
-- 
2.34.1

