Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70FDC43334
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 12:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiGHMRS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 08:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiGHMRR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 08:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5B931353;
        Fri,  8 Jul 2022 05:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C0C62625;
        Fri,  8 Jul 2022 12:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30747C341C6;
        Fri,  8 Jul 2022 12:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657282634;
        bh=p9vKsa0MBES9BHYWtvG2bBUilzPlNrzKMKZU8ndRQPA=;
        h=From:To:Cc:Subject:Date:From;
        b=Lr/tJ9mAgxSYo7EnJ0KNmbEJBw8JcD8wdQyMHn9V09fdMP+Zw6fQC7yG2qetpFFDD
         6GQn+54o0llZYYIMBNfBsZzeutUV7FHzsDUVuZ72FS25EFN4FPkMRIWWUKdIUuCD6e
         dhQgOZ3wTp/JQoZw+rYq74idqexLZ4j5tNjYmnyU7uvKCy+1vyr4TB83k3SlyKKQpE
         qo+iscxzCwVCtot7l9TDTSoFLx+Xtay2Jd8s5RG5q3MCRdMauL2QdQMiacPj4d6CSY
         /wb8PL61MDxwYImsyRF0y3rwwFnET4tP6HUGgwtAlwOLEzqGKsekUN7S+lXbCixcpi
         1ahK4PcoQW8dQ==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] rtla: Fix Makefile when called from -C tools/
Date:   Fri,  8 Jul 2022 14:17:10 +0200
Message-Id: <9154d66961804027b1bdc26f1ff08012bb7f9df8.1657269675.git.bristot@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sedat Dilek reported an error on rtla Makefile when running:

    $ make -C tools/
    [...]
    make[2]: Entering directory
    '/home/dileks/src/linux-kernel/git/tools/tracing/rtla'
    [...]
    '/home/dileks/src/linux-kernel/git/Documentation/tools/rtla'
    /bin/sh: 1: test: rtla-make[2]:: unexpected operator    <------ The problem
    rm: cannot remove '/home/dileks/src/linux-kernel/git': Is a directory
    make[2]: *** [Makefile:120: clean] Error 1
    make[2]: Leaving directory

This occurred because the rtla calls kernel's Makefile to get the
version in silence mode, e.g.,

    $ make -sC ../../.. kernelversion
    5.19.0-rc4

But the -s is being ignored when rtla's makefile is called from indirectly,
so the output looks like:

    $ make -C ../../.. kernelversion
    make: Entering directory '/root/linux'
    5.19.0-rc4
    make: Leaving directory '/root/linux'

'grep -v make' to avoid this problem, e.g.,

    $ make -C ../../.. kernelversion | grep -v make
    5.19.0-rc4

Cc: Steven Rostedt <rostedt@goodmis.org>
Fixes: 8619e32825fd ("rtla: Follow kernel version")
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 3822f4ea5f49..1bea2d16d4c1 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -1,6 +1,6 @@
 NAME	:=	rtla
 # Follow the kernel version
-VERSION :=	$(shell cat VERSION 2> /dev/null || make -sC ../../.. kernelversion)
+VERSION :=	$(shell cat VERSION 2> /dev/null || make -sC ../../.. kernelversion | grep -v make)
 
 # From libtracefs:
 # Makefiles suck: This macro sets a default value of $(2) for the
-- 
2.32.0

