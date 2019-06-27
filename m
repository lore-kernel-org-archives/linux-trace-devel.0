Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F71C48BD7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294BC216FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0RHf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfF0RHe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 13:07:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71BA205F4;
        Thu, 27 Jun 2019 17:07:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hgXrw-0004Ty-UP; Thu, 27 Jun 2019 13:07:32 -0400
Message-Id: <20190627170553.050679238@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 27 Jun 2019 13:05:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH v2 0/3] kernel-shark: Make some top level "make" changes and documention updates
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is built on top of the three patches from Yordan that can be
found here:

  https://patchwork.kernel.org/project/linux-trace-devel/list/?series=132531

It makes "make clean" remove cmake generated files (my build failed
and I couldn't figure out why. "make clean" should allow builds to
build again when CMake files change).

I also adde a "make BUILD_TYPE=foo" to pass to the cmake command to
change the CMAKE_BUILD_TYPE to allow an easy build by the package
maintainers to change how KernelShark is built.

It also updates the README with the current way to build KernelShark.

Changes from v1:

 - Added a patch to first change the README to the latest make process

 - Incorporated Yordan's suggestions about breaking up the build
   documentation into two sections, one explaining the "simple"
   method from the toplevel git repo, and the other explaining
   the "expert" method using cmake directly.

Steven Rostedt (VMware) (3):
      kernelshark: Update the README for changes to the make process
      kernel-shark: Have "make clean" run cmake-clean.sh
      kernel-shark: Add 'make BUILD_TYPE=X gui' to change how the gui is made

----
 Makefile                    |  6 ++++-
 kernel-shark/CMakeLists.txt |  2 +-
 kernel-shark/README         | 63 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 58 insertions(+), 13 deletions(-)
