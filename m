Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490B8C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11CB221874
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hOKH9wVP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfDHV30 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:29:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35082 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729445AbfDHV3Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 17:29:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id g8so8027649pgf.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 14:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GbB6gMbRWZnd3XGR++ZafZznSxQYOIqaHAc9TBmuW38=;
        b=hOKH9wVPW2ru+rMr8WZWSAkF5qWzyQgoxLfn37q1FmSeZZCibD4miqJyNwZWkRma0C
         S9Xnk3hC7IxfbKcyTJzjfp3aQAi0TG/3ULOggHzmW4YfG/0ZQuHNfeBs2aQJ7zhX7YPD
         naIJpr1XfiW+haJ5Pa3tSvR69YSsJmyZVM9YQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GbB6gMbRWZnd3XGR++ZafZznSxQYOIqaHAc9TBmuW38=;
        b=emMVt+ubaLtpqIn80BzF/f9CDp/m2lQj+bQF8cJmuYLP/PmZB2ullrINSF6g0SX9hP
         3ylr3rvVFoG0MmRQXdZFchWykTbO4f15ihzxmEITfe+iw+9XM0Npe0oSF8NKqpAtcze/
         5fJpCQAZcWLRu4vvio3MNWWLd9V9Rg4hN1XZjBDYBRVcCmFVAKZpMN9BJHg3qWSSkhYM
         UmjrgGIA+BE9ITkUX6/CrAhDXYvOGW8ipsSmZYSP1LTTp+vuqWNDq2v2dtMzJAzkWpzJ
         o36NLccCuXThYErSo7wtjphO4WqsFv70aB4bRJi4orzwu5uq57a7Z+GUWgFazQSGUufX
         jaVA==
X-Gm-Message-State: APjAAAVJiIpy3OvQRhsbi3NLe5ZlRcal3w7KxEUFY0RUYmpArzK9hnj4
        4flSi0KDy1ILDjDpkYBowr5QGg==
X-Google-Smtp-Source: APXvYqxCmxc7H/Y722GyFHvR0Y9Elc+ji0teoq3wduyN/AGQG9MEgBL7m5NJx1/Dh2hvpWv+xYb3rA==
X-Received: by 2002:a63:b811:: with SMTP id p17mr30735868pge.219.1554758964939;
        Mon, 08 Apr 2019 14:29:24 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id t12sm68073407pfl.59.2019.04.08.14.29.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 14:29:24 -0700 (PDT)
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
Subject: [PATCH v6 2/2] init/config: Do not select BUILD_BIN2C for IKCONFIG
Date:   Mon,  8 Apr 2019 17:28:55 -0400
Message-Id: <20190408212855.233198-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190408212855.233198-1-joel@joelfernandes.org>
References: <20190408212855.233198-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since commit 13610aa908dc ("kernel/configs: use .incbin directive to
embed config_data.gz"), IKCONFIG no longer uses BUILD_BIN2C so prevent
it from being selected in Kconfig.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 init/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index ea75bfbf7dfa..ffcb2f90543f 100644
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

