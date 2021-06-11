Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76088C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBDA613FF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFKLmW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhFKLmW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:42:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88520C0613A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:40:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a20so5759294wrc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=iRG9LZJHu5HKHQao2uVw6ShoRLco1rzAFLwSfOIJNCkSgI4o4GMQYJdRM4ZC6PJeGM
         UaztGrMzmGLoQA+A9GaIIFii+OHu3lXUclGargXjB6sQEhT4UOwdKywX9AjhJIoP1S8O
         ++ha/pJWd4/vsBe1mULDbb0AXg21WwCyXcvTZ7aj+ukSMQ9EWNorWjmzbokGwrkIu6Ew
         QjWcMRs6gyonV+kJvFi1ZF9nCd1LJn0kAwCdfkRptW0CZP7o8oSjaYXsmhx+becfDi8x
         5SWI9aupQyntCoDtDq+n5oc1/6EfuLAPp+U5qbx1pc6fw/R+16ev58el8dRfxVf/0+uh
         iSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=rY08uSyFq5BmO+1A0a8hVeOYN/INQqniSY3lyv9uzlWgH2mJq/rCNuH6NnyeTQfvg8
         duHMm0qp/xx6yk2DKKBF0dBJDD2i72nouL1QDib+ah1YYJil+gTJI55CM91+l/dei39+
         uv54hMa2xLGZ4gaXWi7vq6GjC3jC13I7UtD0BBg/e5Hj9ABv11Oe/BY9G14Sh12QejKe
         Qibm/3pdo35X0tk7p+bcQv3dlFKndujkABXUazh5S2oiurbUztMsa+4pRLfWpS1rQeP2
         P61X5XCSxNZfEqaNHSmiSOYV41WgaJWRIRB7ArOUFAZbkMnBFtQTcwkao6OqfMxvk2Xd
         b7ew==
X-Gm-Message-State: AOAM533gMLon1Gz/OaHNpRkyjQYA+vIp+Y6AVGf4RC8UUU8erHx4KAKf
        oHgr5vrF7IjTKJBC5TQGHQVqhWpCWzs=
X-Google-Smtp-Source: ABdhPJx0PsL/HBD+IegsihgdbpMoMoRHGPiffjFy1JimidXFTTBDLpmk28sT9nqXNtNbCjYgK/jdCQ==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr3641643wrr.26.1623411613957;
        Fri, 11 Jun 2021 04:40:13 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/9] trace-cruncher: Add Makefile
Date:   Fri, 11 Jun 2021 14:39:54 +0300
Message-Id: <20210611113958.38142-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This will simplify the building procedure and will make it more intuitive.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Makefile

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..a509811
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,33 @@
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+#
+
+UID := $(shell id -u)
+
+CYAN	:= '\e[36m'
+PURPLE	:= '\e[35m'
+NC	:= '\e[0m'
+
+all:
+	@ echo ${CYAN}Buildinging trace-cruncher:${NC};
+	python3 setup.py build
+
+clean:
+	rm -f src/npdatawrapper.c
+	rm -rf build
+
+install:
+	@ echo ${CYAN}Installing trace-cruncher:${NC};
+	python3 setup.py install --record install_manifest.txt
+
+uninstall:
+	@ if [ $(UID) -ne 0 ]; then \
+	echo ${PURPLE}Permission denied${NC} 1>&2; \
+	else \
+	echo ${CYAN}Uninstalling trace-cruncher:${NC}; \
+	xargs rm -v < install_manifest.txt; \
+	rm -rfv dist tracecruncher.egg-info; \
+	rm -fv install_manifest.txt; \
+	fi
-- 
2.27.0

