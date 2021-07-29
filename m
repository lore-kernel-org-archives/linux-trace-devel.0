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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF6EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6042E61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhG2FLd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhG2FL2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:28 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E78C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id x11so7519097ejj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=tyXkNNzPNq2tIoa0ZM3XQrhNSaeuNONmWk6cT5j2ojM5iHo/lwkQGJSQloLzY1FqDN
         giYV+xUKz4NRYCmzyz8WWzPfMVl6O7uf3TP11d9eothQH31G6EKzf2MKV6ZscMFkgo51
         7hphsc1nhl7bChCHCep158koWpS+w14JUMTodXLIRAykfrIbKD9+1CIQzo06U6PcHEQv
         sYq5UWbkya79PzyOHtBoDm0RCp5Ac0hvPwrwFdW0cKfNfXt7ACsUAWJqbJlBeuaapnfd
         5sLI+Ihjkw79J7SJC7KE4iDagt73bh7hDgxR+tBuG/cFMuvO5ZpqxowURcx6lWPUg7d/
         jlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=bXuLNzNsJpGv2yZwIgZRnxspXydzkzcbqikcN2ei3HFdZWnEjGzEu9+klz4oKHuMNh
         79+lxQtQ226W1og0o6HMx94Tz7auyRjS3pXrtI+ZpwBDWNyUeHnd4KRkHaqA52AQILUq
         nGAJ2DGY75kFdQ9h6dQV6MFxQk+lj9A4pCneJFbsDJZOCGFrZG8A9AdvothtOezH7TJC
         9gzNFHnYvrGZ/pAlxK1qlVzY5Id+X3LCD4DezjODP5A1nmspXOzieQAdI32No4bUGQ7a
         vMyKdrZSVXm5zi2VnpHphdkN6dm2NYbVxatY/6JkqdHMEIBV7SZBzSpzVsIxnL1GA6DA
         6pOw==
X-Gm-Message-State: AOAM531IogXnVb5Oxn8w7SDFR9P8/X8yRyX8UGNrwQ5mIDbBsmomrYai
        yS/knD55WL5BTpASuvh3Izo=
X-Google-Smtp-Source: ABdhPJzIQnC1rkOFIS0zQBIN0A1PDw4zL3aw7tnFtuUfvlEfeUgPyR5kZ/oLK6g45VfyniOj2lEibw==
X-Received: by 2002:a17:906:6d4e:: with SMTP id a14mr2853150ejt.328.1627535484332;
        Wed, 28 Jul 2021 22:11:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 86/87] tarce-cmd: Update record man page
Date:   Thu, 29 Jul 2021 08:09:58 +0300
Message-Id: <20210729050959.12263-87-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new arguments of the "trace-cmd record" subcommand:
 --compression
 --file-version

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 96c27108..b3620474 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -377,6 +377,19 @@ OPTIONS
 
       trace-cmd record --verbose=warning
 
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.31.1

