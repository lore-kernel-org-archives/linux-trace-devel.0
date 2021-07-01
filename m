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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB14C11F67
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139B661452
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhGALRJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhGALRJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB63C061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u8so7678775wrq.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=J0Z43H3mxGk/NgHs44yCaNSZU6ri7xuza/MDRiu6D2LD6E+jrEPt1/1XS3v9NGtS6M
         HsT6k7CPI4NOeeGVUSViHi1qoq3Xa3o5raVThGoTY0hH2JCs8w0pvwetf0k2j+RGdfFk
         Wze0rD7CMqcyIwTxHvaXTjNfh5K2kF3tmoFnxMr/vk0WweuLf9OfOzJyStuiKRMVdB/o
         InBTHkvKd5XnudayVFs4zmWhuffNPwT0Yu2paqGh4XXc6a2qObeyGnff2IhOt7vqrgQX
         MGCvL0+VWftX69dNNo367zgvOHQhOzHkV/iwY+FN57kqKCxGjranDjYxS21NjCwLH78y
         5Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfVD1cAs6SPrMUthxOrkeBS15jFG91hD63W8UoUPYZM=;
        b=rlBHkGpXbffzqfDmSDewP29091L2CVnYLWGtIeWOW5R3JzVIz9GGkAMjI+eRWvByZP
         6aQS3HE403kk8+UdATVszSDWOyD6OH2nDXU7ADYejeivUGGfhQqLCieixsPluZEErZK8
         Sq3WP6SXm+eTQUY0Ccb6XmazKpM16EyQ0sGAnzbx4A8vllVNrSzF9/WuRv13r4T+LjDD
         iGU7c0HJqCahrAPTRD7sgbnMzDWLzT9fjFtyADTUKlP2nA++xzFjKfbQNX6B5ivb6yXK
         G3sXoIej4k6P0SIx0XHr2bjwZyy8K7bhFCEvshV80omIappxdJKobvz+GfsMAgwL7uef
         uhKg==
X-Gm-Message-State: AOAM5309Rc+stzufo0pvKfjtkK9n/e7Io1nztMtMcUFhU8Lb51ZyjjAY
        qblaVPqPiTeArRdt9IIVePVR2vbvsTc=
X-Google-Smtp-Source: ABdhPJzU1wHCnmcXKNGt8AYeopaXm5wvi8B3Tfim1UZyyB+QrKHr0XYGg1XIyEZe9rhEP73EAbo8hQ==
X-Received: by 2002:a5d:564c:: with SMTP id j12mr45815189wrw.37.1625138076765;
        Thu, 01 Jul 2021 04:14:36 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:36 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 07/11] trace-cruncher: Add Makefile
Date:   Thu,  1 Jul 2021 14:14:14 +0300
Message-Id: <20210701111418.18386-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
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

