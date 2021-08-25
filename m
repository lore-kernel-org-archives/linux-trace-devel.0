Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF725C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F0B6115A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhHYJpi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbhHYJph (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 05:45:37 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363C8C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:44:52 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n5so23083521wro.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S8qZl4LPNgf/JfYNO7U7SNMH3XMoCfcR8lRycUeE2ek=;
        b=DqrCxBuxNoCMxwrH/OweI4VBxf3/xBFxD8HuyNWKhNTAgoXsb62uAU5jRe7GnUc4Rk
         hcWuZS+CQVPdzu7bY2SGvua7YZkdHh9Jvdv6xrRmRTT+PYMfgVhr6ybZtM165MpCHIcH
         RcDBLjuAqDuFHRJ7rhJL5TDvgc6EVxBBfwhO4gmbVc4+shsCsdJP8htDn7NyKmZpn0dV
         gOVKscuGIl6tIo762qDpyN+QfxOcJUsBq8J0/Erz/bBOoZJPfafIFFEl29iZhOuNE3CD
         sd/CpYWeBuJeBeEUZuC2Cpurod6NhPlmJ2L1BCUC+xfeJr2BMbJqPfrxp1lmT4NMrOlX
         mprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S8qZl4LPNgf/JfYNO7U7SNMH3XMoCfcR8lRycUeE2ek=;
        b=Jzlw0VYzDmBvVjb4YilrIiwTK5UL7NMP8/90POpx0hON+sMcdNJjGa/5vaKPLIo0t7
         tnP+GwJlt/c3V1SBiOPHNCcRkUnENf35Nkq2tT35hfBKFMiTJ9/cFFPitJVtyjCHoZsi
         zAB3d2ipCIX+QTJ4PO2dfbMXckPmUYSrtmQQH3+DzBxg+oLQwxcuTCedXLOyHzr+rcdv
         F+Ofy2ZESETqZEApJ/y2FsxV8u+JjMBDdwyySTXLFC2C4L0rKPV4QwZHYWfbzG3IyDa2
         GkhoLzOu1uSMavp9AOdpWladKHdChv0tcdUQk8y1e2gyePZ6tEYJmDBdWmtmsr7g7hOs
         eEKg==
X-Gm-Message-State: AOAM533umUrPJEzIiZ2ViPwSzEsc7Y3CNhKoCk8u+I08IRVqLT7aBVMG
        N2JeYYHeiUkQiTOEeS1s62k3ZkXMpIA=
X-Google-Smtp-Source: ABdhPJz3linJhm/HbDpczC4DFD15iPyrSt0Z6EpxTdZmsOyxjtYDy1At/Y+Fp8jhIbkxl/6cLgzEtw==
X-Received: by 2002:adf:dd4f:: with SMTP id u15mr2908511wrm.237.1629884690584;
        Wed, 25 Aug 2021 02:44:50 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id u23sm4608794wmc.24.2021.08.25.02.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:44:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cruncher: Update CONTRIBUTING.md
Date:   Wed, 25 Aug 2021 12:44:34 +0300
Message-Id: <20210825094436.46958-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove the legacy content that came from the template file and make
it provide adequate instruction for contributors.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CONTRIBUTING.md | 72 +++++++------------------------------------------
 1 file changed, 10 insertions(+), 62 deletions(-)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 2f92264..27c7ccb 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -2,77 +2,25 @@
 
 # Contributing to trace-cruncher
 
-The trace-cruncher project team welcomes contributions from the community. Before you start working with trace-cruncher, please
-read our [Developer Certificate of Origin](https://cla.vmware.com/dco). All contributions to this repository must be
-signed as described on that page. Your signature certifies that you wrote the patch or have the right to pass it on
-as an open-source patch. For more detailed information, refer to [CONTRIBUTING.md](CONTRIBUTING.md).
+The trace-cruncher project team welcomes contributions from the community. All contributions to this repository must be
+signed. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch. 
 
-## Contribution Flow
+The development process of trace-cruncher is strongly coupled to the development of the Linux kernel tracing libraries [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/). Because of this reason we adopt and follow the development workflow established by those projects.
 
-This is a rough outline of what a contributor's workflow looks like:
+For contributions to development, please send patches to: linux-trace-devel@vger.kernel.org
 
-- Create a topic branch from where you want to base your work
-- Make commits of logical units
-- Make sure your commit messages are in the proper format (see below)
-- Push your changes to a topic branch in your fork of the repository
-- Submit a pull request
-
-Example:
-
-``` shell
-git remote add upstream https://github.com/vmware/trace-cruncher.git
-git checkout -b my-new-feature master
-git commit -a
-git push origin my-new-feature
-```
-
-### Staying In Sync With Upstream
-
-When your branch gets out of sync with the vmware/master branch, use the following to update:
-
-``` shell
-git checkout my-new-feature
-git fetch -a
-git pull --rebase upstream master
-git push --force-with-lease origin my-new-feature
-```
-
-### Updating pull requests
-
-If your PR fails to pass CI or needs changes based on code review, you'll most likely want to squash these changes into
-existing commits.
-
-If your pull request contains a single commit or your changes are related to the most recent commit, you can simply
-amend the commit.
-
-``` shell
-git add .
-git commit --amend
-git push --force-with-lease origin my-new-feature
-```
-
-If you need to squash changes into an earlier commit, you can use:
-
-``` shell
-git add .
-git commit --fixup <commit>
-git rebase -i --autosquash master
-git push --force-with-lease origin my-new-feature
-```
-
-Be sure to add a comment to the PR indicating your new changes are ready to review, as GitHub does not generate a
-notification when you git push.
+[Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
 
 ### Code Style
 
-### Formatting Commit Messages
+The preferred coding style for the project is the [Linux kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html#linux-kernel-coding-style)
 
-We follow the conventions on [How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/).
+### Formatting Commit Messages
 
-Be sure to include any related GitHub issue references in the commit message.  See
-[GFM syntax](https://guides.github.com/features/mastering-markdown/#GitHub-flavored-markdown) for referencing issues
-and commits.
+The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
+as described by the Linux kernel.
 
 ## Reporting Bugs and Creating Issues
+For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
 
 When opening a new issue, try to roughly follow the commit message format conventions above.
-- 
2.30.2

