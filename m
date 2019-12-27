Return-Path: <SRS0=1m8P=2R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F639C3F68F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 18:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E72F20828
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577470051;
	bh=QwCiPWsHROdyM6XfCtmVRetKjby4HK+y9x9ed/v9fuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=j/yKwKZTH8R7Je7kkfdKN8dvm4S9ojgb/IeaEVyXlvZwf5ng0B1M6Dm6WCLij7ql8
	 ++UhLEDVKzvybKPTWqYa/HIzjK67FmeDiH8sV298EwrFZ0VIS1S5dEIW5G+4iKO4aO
	 b0N9t8JO52045GmXmlOpG97/WXMiX2ASlC+6TD2I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfL0SH0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfL0SC3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FC42176D;
        Fri, 27 Dec 2019 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469749;
        bh=QwCiPWsHROdyM6XfCtmVRetKjby4HK+y9x9ed/v9fuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNFVA0gkok2ptmG6KfN+c8djHtZ6t+sI7Y8ZRW5FvZ5qhLnzeOoyRWT23syYgELa+
         UfzoT4tgTOTu+MMiPkb+1SfAmnIxh2/iwRYibnfV0Up4L0TcGyALrvIJsEMdkoVT7m
         W1J7JIx9SEQuc0c8gZSQXNMZ0o9pPwDLZkj2xkpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 05/57] libtraceevent: Fix lib installation with O=
Date:   Fri, 27 Dec 2019 13:01:30 -0500
Message-Id: <20191227180222.7076-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
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
index 8107f060fa84..a0ac01c647f5 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -115,6 +115,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.20.1

