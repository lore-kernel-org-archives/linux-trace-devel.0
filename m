Return-Path: <SRS0=1m8P=2R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C62AC2D0DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5D32173E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469047;
	bh=rAMFqApMQxwITHsnu5Pg7D3xR8Q9/+Cve3z8RndOyT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n6rk840gmMRZ6Aahmce9Qa488wpfNYpPKvsHxA8rQwvB2q6srUsl583gNth9BP8Lg
	 1tvBzmk6mqD0xu5Psbi0sGrWKFTaTa2wu0lC1Nf+Ecmu41GZ0J8OS+SkvDCn/masQW
	 s6+e/ibmPYAkDHSP1+HoQTpiGHh3m4U36mFzOcVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfL0RoF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbfL0RoE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B3392464B;
        Fri, 27 Dec 2019 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468643;
        bh=rAMFqApMQxwITHsnu5Pg7D3xR8Q9/+Cve3z8RndOyT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VedrjPd2maYwbRJA+n0isgUEfHOa/hIiUK5j855qTtwc+FqEe6+kKAfZW2/p6HqpI
         h1HzVDg+mRm4mS4FB5oq5iQo0jiD6f4l3obz68cUWUT6gMHwwpB2R3SO28uZmBKHtV
         SZw0LXFIrg5tP+DgA2PiGa/E0WAVLB0ScS+uxy1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/84] libtraceevent: Fix lib installation with O=
Date:   Fri, 27 Dec 2019 12:42:37 -0500
Message-Id: <20191227174352.6264-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 587db8ebdac2c5eb3a8851e16b26f2e2711ab797 ]

When we use 'O=' with make to build libtraceevent in a separate folder
it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
error:

  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0

  cp: cannot stat 'libtraceevent.a': No such file or directory
  Makefile:225: recipe for target 'install_lib' failed
  make: *** [install_lib] Error 1

I used the command:

  make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install

It turns out libtraceevent Makefile, even though it builds in a separate
folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
source folder.

So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
the files in the correct place.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191115113610.21493-1-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index bca0c9e5452c..05f8a0f27121 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -115,6 +115,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.20.1

