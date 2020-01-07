Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF37C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9ED4208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlHmpz3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgAGRED (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:03 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42997 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGRED (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:03 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so232180lfl.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJWoVo2sQSjf51MOKxzhPK76Cudn7WqxaIqTk5lm5oM=;
        b=ZlHmpz3maKEmMQtiTMwOcW3HXZwhIXMa0jPcv6qjWnSV7ZS4/0dhgv3QkQt6Vb/jeE
         nszF2tr2lQ8VTIMTthOBuj+p4MqDompa9RZFVW9qSS5t+HotkEpKweiEoaotVGi8XfgY
         UuVVjyLk9CvUFfXmzNGOvfP4E7RM8+Lf/T93Xya0b0ku6jzBm7LjuiUhqoZi1f76R98I
         YqNcywBSi3V6o0Y8eY249ng0OBb1f86KcvP14FW1hnZ/iVapmsulHKYc4rd3zzgwSHLi
         ++gmDcEmfyqPp4FcIpvyOIS0cJYTIlWeug0al1FuPXeXpPnABNseM7+htS0B3LEeDH0g
         0IYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJWoVo2sQSjf51MOKxzhPK76Cudn7WqxaIqTk5lm5oM=;
        b=uN/woWoWnUNv/zTvnvt4+ov5RxjKjV1U/wys+vrCrKEvMdtigr/Azno2TjOl28508s
         pSZLzwZL3RYblRicxvlf0WsgBZnbOLiecSleIyuhVUfdlcRaAb+cfHyh9OCyQtl45w7l
         WXKI3HSiSSdAb/q64wxvddEWlyH7R1dbfXdpvaCiqyIM1dCuf4mnp0hPwCzZkwoZWcrS
         he5nPJNkfnj6sQalzlOrl9SPnybYsiwK4rFgDTVZihk0QYYYn9H2M3SaK0zERVMqh8L1
         rBqFIzJSP6iipVFU1KKXIns1F1viKnyyOWXZzNa3h+5dvefKAYUoZmjhQczAFHpFQK+K
         PIdg==
X-Gm-Message-State: APjAAAX1jTaGSJ+KbzBIlZraQbuqFcpyGfjkTgn8hLVVJMZWqEmXg2wo
        aXi/+wlPmmDCNCyq2w5t1nQkzJkM
X-Google-Smtp-Source: APXvYqy2GLzvGGI4dhk9WZhGtDkAjFz6PMEyafbpFUfPBpoAsMDaR7rrfS6QSOup8G7epINpG8z+Kg==
X-Received: by 2002:ac2:41c8:: with SMTP id d8mr253978lfi.65.1578416641193;
        Tue, 07 Jan 2020 09:04:01 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:00 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 06/12] trace-cruncher: Add Makefile
Date:   Tue,  7 Jan 2020 19:03:06 +0200
Message-Id: <20200107170312.27116-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This will simplify the building procedure and will make it more intuitive.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Makefile

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..735d43c
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,17 @@
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+#
+
+all:
+	python3 setup.py build
+
+clean:
+	rm -rf build src/datawrapper.c
+
+install:
+	python3 setup.py install --record install_manifest.txt
+
+uninstall:
+	xargs rm -v < install_manifest.txt
-- 
2.20.1

