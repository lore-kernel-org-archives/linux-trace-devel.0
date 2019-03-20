Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2908C10F05
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 16:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F4DB20850
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 16:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hOBm3d0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfCTQbv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:31:51 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40277 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfCTQbu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 12:31:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id w20so6295441qka.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Mar 2019 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wdHEx/0MGPZcjYnM850Y8pJ0YyzAWC/cB9GIf0oOCMw=;
        b=hOBm3d0x8T/H3tshM3uHJssYTOR++ZKkN7smGwghLiy0m2+rzwHXOpmu4RHjEBM232
         G/DKOQ8E2xdCIdE+3++r5nSQ7HY0uq2fYSOdIusBxRRktrTmtO1MzmUybXDq5ZaGmSjL
         Jz+Acl0jWDkncIV0+oXYi+9CPj0LxGV6IWJwE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wdHEx/0MGPZcjYnM850Y8pJ0YyzAWC/cB9GIf0oOCMw=;
        b=i060G+qJKJHBXVtwgybJXT10+k32f8PMv2uFuR5bNVpEbuta8nth6XaeRphTjTQv28
         CTOCkhBksDNr0DHNKAmfqoEdHI/r2qJMs2/Mo5Q79llzPfEBUnRk2+RuDUW3vubobikf
         PG3FIZbVbWBt5H780BcnwmXnwv/wqWsepjTDrirxWeA3jHys3bqQBw3T0AM2eXmLIliq
         VpLJl3Xm3h2zK+2vOF6b1JqC/O1JWambg2DM86ZSwH+dfqtB/ID7TeAY8KV4FKeuFPfA
         TRSRArWDfseZ1wsn+ff2A/hpGCDVVYRSBc0Ozc/s9kqFPnsdNNcUAWBk+DJHbMckJKlB
         ck4w==
X-Gm-Message-State: APjAAAVmwbQtdpGOMAGFqfqnge2fENtU7aTQTJ9PqUH48cxUSRAPrTQa
        CcK7PhjjUanw+HUJ5O14UTYjyw==
X-Google-Smtp-Source: APXvYqzFdGH3wJA2D37ApIyVmy0Bntun4Q3zYfSUQ0I20LrS0RuWkPRwSFOXtD4jRU3Hb8yJL1IF1A==
X-Received: by 2002:a37:c9d9:: with SMTP id m86mr7066418qkl.174.1553099509560;
        Wed, 20 Mar 2019 09:31:49 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id h10sm2289721qta.3.2019.03.20.09.31.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 09:31:48 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, qais.yousef@arm.com, rdunlap@infradead.org,
        rostedt@goodmis.org, Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: [PATCH v5 2/3] Add selftests for module build using in-kernel headers
Date:   Wed, 20 Mar 2019 12:31:15 -0400
Message-Id: <20190320163116.39275-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
In-Reply-To: <20190320163116.39275-1-joel@joelfernandes.org>
References: <20190320163116.39275-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This test tries to build a module successfully using the in-kernel
headers found in /proc/kheaders.tar.xz.

Verified pass and fail scenarios by running:
make -C tools/testing/selftests TARGETS=kheaders run_tests

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 tools/testing/selftests/Makefile              |  1 +
 tools/testing/selftests/kheaders/Makefile     |  5 +++++
 tools/testing/selftests/kheaders/config       |  1 +
 .../kheaders/run_kheaders_modbuild.sh         | 18 +++++++++++++++++
 .../selftests/kheaders/testmod/Makefile       |  3 +++
 .../testing/selftests/kheaders/testmod/test.c | 20 +++++++++++++++++++
 6 files changed, 48 insertions(+)
 create mode 100644 tools/testing/selftests/kheaders/Makefile
 create mode 100644 tools/testing/selftests/kheaders/config
 create mode 100755 tools/testing/selftests/kheaders/run_kheaders_modbuild.sh
 create mode 100644 tools/testing/selftests/kheaders/testmod/Makefile
 create mode 100644 tools/testing/selftests/kheaders/testmod/test.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 971fc8428117..2446cfeae1c5 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -20,6 +20,7 @@ TARGETS += intel_pstate
 TARGETS += ipc
 TARGETS += ir
 TARGETS += kcmp
+TARGETS += kheaders
 TARGETS += kvm
 TARGETS += lib
 TARGETS += livepatch
diff --git a/tools/testing/selftests/kheaders/Makefile b/tools/testing/selftests/kheaders/Makefile
new file mode 100644
index 000000000000..51035ab0732b
--- /dev/null
+++ b/tools/testing/selftests/kheaders/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_PROGS := run_kheaders_modbuild.sh
+
+include ../lib.mk
diff --git a/tools/testing/selftests/kheaders/config b/tools/testing/selftests/kheaders/config
new file mode 100644
index 000000000000..5221f9fb5e79
--- /dev/null
+++ b/tools/testing/selftests/kheaders/config
@@ -0,0 +1 @@
+CONFIG_IKHEADERS_PROC=y
diff --git a/tools/testing/selftests/kheaders/run_kheaders_modbuild.sh b/tools/testing/selftests/kheaders/run_kheaders_modbuild.sh
new file mode 100755
index 000000000000..f001568e08b0
--- /dev/null
+++ b/tools/testing/selftests/kheaders/run_kheaders_modbuild.sh
@@ -0,0 +1,18 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+HEADERS_XZ=/proc/kheaders.tar.xz
+TMP_DIR_HEADERS=$(mktemp -d)
+TMP_DIR_MODULE=$(mktemp -d)
+SPATH="$(dirname "$(readlink -f "$0")")"
+
+tar -xvf $HEADERS_XZ -C $TMP_DIR_HEADERS > /dev/null
+
+cp -r $SPATH/testmod $TMP_DIR_MODULE/
+
+pushd $TMP_DIR_MODULE/testmod > /dev/null
+make -C $TMP_DIR_HEADERS M=$(pwd) modules
+popd > /dev/null
+
+rm -rf $TMP_DIR_HEADERS
+rm -rf $TMP_DIR_MODULE
diff --git a/tools/testing/selftests/kheaders/testmod/Makefile b/tools/testing/selftests/kheaders/testmod/Makefile
new file mode 100644
index 000000000000..7083e28706e8
--- /dev/null
+++ b/tools/testing/selftests/kheaders/testmod/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-m += test.o
diff --git a/tools/testing/selftests/kheaders/testmod/test.c b/tools/testing/selftests/kheaders/testmod/test.c
new file mode 100644
index 000000000000..6eb0b8492ffa
--- /dev/null
+++ b/tools/testing/selftests/kheaders/testmod/test.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+static int __init hello_init(void)
+{
+	printk(KERN_INFO "Hello, world\n");
+	return 0;
+}
+
+static void __exit hello_exit(void)
+{
+	printk(KERN_INFO "Goodbye, world\n");
+}
+
+module_init(hello_init);
+module_exit(hello_exit);
+MODULE_LICENSE("GPL v2");
-- 
2.21.0.225.g810b269d1ac-goog

