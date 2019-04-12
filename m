Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88416C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D79218A3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 19:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="f52LcHqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfDLTvp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:51:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34668 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfDLTvo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 15:51:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id v12so5696208pgq.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 12:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ac51ttLoTfv8HeommH7JkMauHEnPD70UoRAXyzUxjGM=;
        b=f52LcHqgTtp6WVtNHlH83DiPrkhPwkO2GCCtYrmHADwJv3K2V5uFwlrao/KpGGbNlt
         JnF5HNHRYfD4/zm1HDAxDu6bv4ByLQ4pMF8EgbQVhHHU+MTRSYGdqIztke0Z1WVfBmxB
         VrwpNhKb2s0YI9TboHmOw3PRFFZYzx67/1ijg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ac51ttLoTfv8HeommH7JkMauHEnPD70UoRAXyzUxjGM=;
        b=h7wGezGQyBq+mN+ogw//Ur9Cy+Wtsle44s4Tt9c2BCVHTd2AgLA8imGhMmiWey5naO
         8/KDUxiU9mb1/EiErkYfcRRFzpFMD+jq9J1r+N/bfJmdK2/fdoyB7/oIWr+pLa7EUrHT
         Njpi1hevT754mgSlCIj7YMSZ9me4BW2SNdh5MnHsXJ/It9uj4+3d4EODG539vS/MppxL
         le65qMnuOsi/Vmxp2wMW4rHtzEvbWroNXzLfLpJM6VlNo+/XblpfWGzkH+R0AdCLgfsw
         EmMUGhe78bJ6fhPauDwbg1MQGKGY76X6FL5JH6SOVx5iiiLF6p0zSl0GdjkJQLwKWob8
         gedw==
X-Gm-Message-State: APjAAAVgzXs8MQSck6y5vm0SF2Jg9R83OdL0pZyw4xqe0UQJhQk4W6R/
        qp1Y7AFtV0fn6uw8kx5cF4ZrTg==
X-Google-Smtp-Source: APXvYqxy1kfmSNyOMeuOxauS+XcQsXd6oe1eixksQbNmowhBeOj93+EgWnJre65tLFIzAy++Z4qe6A==
X-Received: by 2002:a63:7943:: with SMTP id u64mr54795090pgc.91.1555098703514;
        Fri, 12 Apr 2019 12:51:43 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id e126sm106356796pfh.35.2019.04.12.12.51.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 12:51:42 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>, mhiramat@kernel.org,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: [PATCH v7 2/2] init/config: Do not select BUILD_BIN2C for IKCONFIG
Date:   Fri, 12 Apr 2019 15:51:25 -0400
Message-Id: <20190412195125.3891-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190412195125.3891-1-joel@joelfernandes.org>
References: <20190412195125.3891-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since commit 13610aa908dc ("kernel/configs: use .incbin directive to
embed config_data.gz"), IKCONFIG no longer uses BUILD_BIN2C so prevent
it from being selected in Kconfig.

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 init/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 47c0db6e63a5..26a364a95b57 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -562,7 +562,6 @@ config BUILD_BIN2C
 
 config IKCONFIG
 	tristate "Kernel .config support"
-	select BUILD_BIN2C
 	---help---
 	  This option enables the complete Linux kernel ".config" file
 	  contents to be saved in the kernel. It provides documentation
-- 
2.21.0.392.gf8f6787159e-goog

