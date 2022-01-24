Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47908C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 10:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiAXKxo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 05:53:44 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48608
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237078AbiAXKxo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 05:53:44 -0500
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DB19A3F07D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643021622;
        bh=kREuygJ8jp38z41ZJJIIjnhjATzGRS6VepVabrYydQg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=KTvLjoem0lJiFrLIUgGh6gPruDWrXSj8U+H8Xp/E5vzU4x5qEnv+nLRMc3VfsXth8
         emEY6OmrM5bjg3Lk/s/HvY8Zy+VuxZp2qqqAa8BKdlxcKeVQhC+zVqDvn234Lx6NUd
         xFv5fPzMIqdv2OA1FBDSHdAJ+3tvlJN9EZhG1JK1Mf330JmscRn7N/6WLY/qL+DQjh
         +QMAmXZKeUwxF+2eQoN+MX6xHU6YrwrXqCc/XogbOjOeg4S+ge6uviDLotUh2hZwMy
         vhhe+a985C3tdSblBE8U3tzuNzd+v/WLvC1XSe3avC2gr1ullR85s2GFc3uPlJ85LX
         A2quIpr3rafRg==
Received: by mail-ej1-f69.google.com with SMTP id b12-20020a17090630cc00b006a7190bdfbaso1922540ejb.18
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 02:53:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kREuygJ8jp38z41ZJJIIjnhjATzGRS6VepVabrYydQg=;
        b=12h1m5v1OwNXVgAZLUcktsQgnG13R9HVnoX9jqLJGbtLCR4WV/WkzU5K7GzccPd1TF
         G/6HkUPwjad/nRtyNTHKK6IhgEV7ug0bcPKIxSKe++5PfuRRsZQ3+2cTBgXd/h+KAFJt
         o8+F0jqVuXU/m2k+86CgKaO7dZ2hHd7xtHkZbQNopfpur8+sBc/1HRBcP5L2y5Apccxs
         1WJS2xG6lMa+V786orpXZYFJfY9ck0oAM1eKHCdzHF7iflWXGaghFGAUAD/w0bSe4pMi
         Gzu/cNE1VxdFF8hR2/PKs0/0bLsRiBBoNKNugTYqoW+At3iW4SEGcTU2OpMQc+oMpx2b
         t7Ww==
X-Gm-Message-State: AOAM530dUXvUcrEO1RqoLSJE3uUK4IbPvoLm1pWBr8RNhLzmujb0uUje
        sQGXcFfJlwqQXrm5K4tswnWoKcVLBp221IVGweryjsjaDzmJF7W5A59rRbzrbpprzHYU5j6DXnQ
        YEFv+W77jeq6K9s7U1Ak/rsNHT46iQUESDWKZnqjJY/6lSgbq
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr1688986ejc.758.1643021618668;
        Mon, 24 Jan 2022 02:53:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuxMS2CWQOjKRaOqOP3i5n40GI5KVG5/bU2Z22/76PLbVsKnoynbY0ldOR8n9qzZUbew6mSg==
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr1688704ejc.758.1643021612151;
        Mon, 24 Jan 2022 02:53:32 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id ee26sm4133724edb.53.2022.01.24.02.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 02:53:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 1/2] libtracefs: clean also docs by default
Date:   Mon, 24 Jan 2022 11:52:51 +0100
Message-Id: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Logical is that `make clean` cleans everything done from build, not only
parts.  Leaving the documentation unclean requires additional step
when building for example Debian packages:

    $ dpkg-buildpackage -us -uc
    ...
    dpkg-source: info: local changes detected, the modified files are:

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 544684c1c37c..4650d15d64e9 100644
--- a/Makefile
+++ b/Makefile
@@ -375,6 +375,7 @@ samples: libtracefs.a force
 	$(Q)$(call descend,$(src)/samples,all)
 
 clean:
+	$(Q)$(call descend_clean,Documentation)
 	$(Q)$(call descend_clean,utest)
 	$(Q)$(call descend_clean,src)
 	$(Q)$(call descend_clean,samples)
-- 
2.32.0

