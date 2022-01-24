Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0D8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 10:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbiAXKxl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 05:53:41 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36054
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237018AbiAXKxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 05:53:41 -0500
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C87123F1B4
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 10:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643021619;
        bh=Oduc6i8xWFiMZVBeBvRMa1mGlU2wtA4p5e2uNbaYUL4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hnQ2lkfJRmZLtACSIO3/WtktbtvazSum/6gjglSYvuHYBD8L4Y4dAZsALydt0pGB2
         jGYdf+xC2eD103CLnP0jBbE3iNasySzeu2dXJOXYWvFaKa+nlQvQAmKx5WBe4CywJg
         8bdnO5Jp8YO0OWSck7SWhN3UN1sB8xIZUsMd067CHLAjku0svaunE4C+9Qc+bFamZp
         6QhaikO4K9Qi4TytabCDtgGoFBlYxtayQfQoL2siHSGznp9KE1VbA63SGt/1ZjZ5sS
         /PtNPOxWDstSAW6GmgNFbu29V0yYpYkl16MlLxFk1xOsm8v53EvoZFiZ+qfBxgUjeg
         l1EsM0LCc6t+g==
Received: by mail-ej1-f72.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so1908607ejw.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 02:53:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oduc6i8xWFiMZVBeBvRMa1mGlU2wtA4p5e2uNbaYUL4=;
        b=V2OcxS9rYurNTW/JQo5JA528J5xQPf+9QKzI69VugrfjuEATWak/vcqsrYo2po7mBe
         jRPJ84u3zKzQ0DfjK9pjWqZUoV05UyGoG3WM9BJwkIeM8zM7gcX555D3IzmuKMvVSgsd
         b5fLBQyqkLIsu38EUcBjS2vZo/lRYSByciD1eevoWNwoMlnDo7mzNZzePDMkmSrPQ9hV
         6VlbvsAtKDovD+5aqRxRBlj0ZgsFEMgTBkCUSRUZudGaINJ0pEtkEzXwfYzWMLHy5227
         PJEKpxDhNDHkClAWV6o8aU6VXm7ZBGdmqEWi6+sa17lZfXcgY6oJSZXTh/BNoCjzPKsr
         WmlQ==
X-Gm-Message-State: AOAM530+hJZ0p2nPrwZndbXvtQ2w6UoQAdF17ChqKyysBhc0u9uN7lW7
        XQs7r3RyDu9FBJerP6+1aOt9PcORbcRNalvFmqlneykvPl30+uBH78Y52ViL5V3VvLRRd9h1rDr
        LQkqCnxTJo3Hkk4aff29vzIbNEBo21I0nc0NHzFx6izxEnuL+
X-Received: by 2002:a17:907:970d:: with SMTP id jg13mr6232624ejc.573.1643021619298;
        Mon, 24 Jan 2022 02:53:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwQoaFQOf/oXOknz6a9efmCpTEMr1nH3cppKvGqI9ml6O7Wa2V5Cfs4dIF4kqcMVkog0WMuw==
X-Received: by 2002:a17:907:970d:: with SMTP id jg13mr6232613ejc.573.1643021618918;
        Mon, 24 Jan 2022 02:53:38 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id ee26sm4133724edb.53.2022.01.24.02.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 02:53:38 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 2/2] libtracefs: fix utest linking path
Date:   Mon, 24 Jan 2022 11:52:52 +0100
Message-Id: <20220124105252.64897-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
References: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Build libraries are now in lib/.  This fixes test error:

    /usr/bin/ld: cannot find ..libtracefs/lib/tracefs/libtracefs.a: No such file or directory

Fixes: fe21539dc846 ("libtracefs: Build in the same directories as the source")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index d168b01a328c..74bf7e60b91d 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	$(obj)/lib/tracefs/libtracefs.a
+	$(obj)/lib/libtracefs.a
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.32.0

