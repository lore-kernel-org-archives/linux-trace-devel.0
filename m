Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACC6CCA473
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 15:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiFOPQG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 11:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346721AbiFOPQE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 11:16:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B033D1C3
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 08:16:02 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bg6so24025724ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 08:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOwfB1s4deF1nZQ7tiTLx3T2qjobqVC8woeQ/XAnu1s=;
        b=U2LHvj6TexokjJdmRXSTdy1G5SEAfP6qrWta/9xwN9l185m3AX1TEfKoLQiKEOK7vu
         mFxH52zwH7XvgoVg6hGhd7b4dVde3NfTR0k4x2MyufJ6d+z/dn3h8a1/co4owJwuYEgL
         B7abGGRqXJP6rPfBr1hN2ICaSt5kOfGnlGTeTWsQR+s3D5Ai+SK4io/GHA8cDne8evv+
         6ZPty5hPij/V9D4OG/vZm2Z6csL5gANqob0HKml+66arJDi9XKTtaBxp7Omgq5mDJSfb
         gJMJdrF9uoRhNW8h5Jt7DPRuaW6KU4fpBuWvpRwPi2BWoYj9X9s8Tv+ruCxWpZin14zs
         OAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pOwfB1s4deF1nZQ7tiTLx3T2qjobqVC8woeQ/XAnu1s=;
        b=rMNclZWIrtvodv7tWYP4ZQyuyyKz9oH+CGy56IBtTfHX28zDw4X9G60f/0pxbJbqDJ
         ZMZlNvvwbaInvj8dWi5RMge+SUu74cPjdv0GotJ6+i3xg/ubVC8ZajegBKus/BkKCfcq
         jsuYeYWNlM8yzpiJe9xtRnjL99PRPX6Az+wz/tXN+Vkw4LvSwmU+J+TEcr+CqybIvJkl
         IXyxYn2tGF1tmQ7WIMZSLuNo6cf8rewDcfFTQkGO/JsYnEpJtrXkzsJ7EEp6goohl1j0
         H2QfX1f9Fnmzp3HXhyQfGSlfBh4Gsm0wQ5gQ6T6t25aMCU5EnyEMAdZBRSGD0eXZIlh0
         2EWQ==
X-Gm-Message-State: AJIora+YBIm9JoQa74cYnGBr33Al12Ors391XpmPggeUwsez8y3dXsWX
        notfFsHHcUmffM2CzkbMrdF/2K7jbeE=
X-Google-Smtp-Source: AGRyM1sLk78WJ5SbgbDOA9vlxg1JAq+2GoOaN6sVfze5V/pfOTr1KKnnUa2nX1F6ho1BAe8mnzSvFQ==
X-Received: by 2002:a17:906:7a56:b0:712:a26:8d71 with SMTP id i22-20020a1709067a5600b007120a268d71mr276314ejo.728.1655306160775;
        Wed, 15 Jun 2022 08:16:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090669c100b006fa84a0af2asm6523061ejs.16.2022.06.15.08.15.59
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:16:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cruncher: Enable Github development flow
Date:   Wed, 15 Jun 2022 18:15:58 +0300
Message-Id: <20220615151558.226641-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Github development flow is more popular among python developers. The
CONTRIBUTING file is updated to enable both mailing list based (current
one) and PR based (github) development flows. The main motivation for
this change in to attract more contributors.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 CONTRIBUTING.md | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 865fcc8..c22780b 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -5,21 +5,25 @@
 The trace-cruncher project team welcomes contributions from the community. All contributions to this repository must be
 signed. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch.
 
-The development process of trace-cruncher is strongly coupled to the development of the Linux kernel tracing libraries [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/). Because of this reason we adopt and follow the development workflow established by those projects.
+### Submitting patches
 
-For contributions to development, please send patches to: linux-trace-devel@vger.kernel.org
+Patches can be submitted by either:
+ 1. Using the regular [Github Flow](https://docs.github.com/en/get-started/quickstart/github-flow):
+    - The main branch is **tracecruncher**.
+    - Any changes must be on a feature branch or on a fork.
+    - Tests must pass before merging, and the pull request must be [reviewed](https://docs.github.com/en/github/collaborating-with-pull-requests/reviewing-changes-in-pull-requests) and approved.
+    - Break the complex Pull Requests into small self-contained patches.
 
-[Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
+ 2. Using the [Linux kernel](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html) development workflow:
+    - Add prefix "trace-cruncher:" to the patch subject.
+    - Break the changes into small self-contained patches and group them in a patch set.
+    - Send patches to linux-trace-devel@vger.kernel.org
+    - [Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
 
 ### Code Style
 
 The preferred coding style for the project is the [Linux kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html#linux-kernel-coding-style)
 
-### Formatting Commit Messages
-
-The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
-as described by the Linux kernel.
-
 ### Tests
 
 Make sure that all your changes are covered by the tests. Before submitting your patch, check if everything works at 100% by running the tests in **tracecruncher/tests**. Compile your changes and install trace-cruncher (`sudo make install`), to make sure that your code is used in the tests. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
@@ -30,6 +34,6 @@ sudo python3 -m unittest discover .
 ```
 
 ## Reporting Bugs and Creating Issues
-For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
-
-When opening a new issue, try to roughly follow the commit message format conventions above.
+Bug reports and issues can be submitted by either:
+1. Create a [Github issue](https://docs.github.com/es/issues/tracking-your-work-with-issues/creating-an-issue) in [trace-cruncher](https://github.com/vmware/trace-cruncher).
+2. Report them in [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---), **Tools and utilities** category, **Trace-cmd and kernelshark** component.
-- 
2.35.1

