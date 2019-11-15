Return-Path: <SRS0=AXMx=ZH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053CAC432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E7D2072D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gW3jOIAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKOLgQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:36:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38067 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfKOLgQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 06:36:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so10047459wmk.3;
        Fri, 15 Nov 2019 03:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IHg1oRX6A603aWd0opYOY7UZw/XHim2gNlaLlwMXeIo=;
        b=gW3jOIAz5nyQ7JdZRrxRLsV7X23+HTXqldOrvQLfJHfEIABYUA9OcspuTCaZ382V1o
         vAQVA6I7blvmHQiYwbXPQKPjY2+xcSeoR7zGECYWMCUME7J5ThSIq8jAP1AmVOfmfbHR
         /IVH0j6F62MWEeu4IyMohiQtIurvYMq10l8HqAlWr1e3B0KqgIQ4hqw8F0vxG+MvhnZw
         wkl7vBaA87Yxv2KB/iDqAFNIJoIE+n/Q4L3gzxmhYM9fiwrtlO0R0Y9t6BJXIlLOe9FP
         6G48Cdqv7G9fzV4KmBLvoFkRLxGkrQ+nwRKDRPZe00TsP9MdxRg+nNpc/nHusR6Yl/WK
         inYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IHg1oRX6A603aWd0opYOY7UZw/XHim2gNlaLlwMXeIo=;
        b=YD0BbyEgYw2NAuWuXlXHirFjEXZNzlrtRxaiIORwxWOZD2sSkFMP/txNpKecuMBTrK
         53zGApZhmSEd2GFVtZmBIBSUXsyCOoDBmPvyu2mgp+iE2RcMtraT935rZE+ii+c0qMcD
         T1EylHjzBuMRqNYQeuDlY1pURnVckLl8PkR5NJzTbCWkmE/gcunhoCIOVD9KkKABAyeP
         W4YinAHrRA6jbbWZSVk0ASVZQh69RUXyAl899hhi5AMKPH/BikMDVoSUI+MHn8AeP7vg
         emg8I5vMOIkMSITX9J9xle5oWCbnIuatToVRQYMGir1Gu6g28Wb8FQOoYtIm8pjEUTGK
         FoEw==
X-Gm-Message-State: APjAAAVo9SJfBalAWWRu+KfOTL4YwMFpphg9Io38i4ZveGMix1c6VLGi
        NQ12NdVI89Xo8xELBv3bkOxka7IQ
X-Google-Smtp-Source: APXvYqydVfwXnuP4aYL1C+O9FmkRDGBRwttFJ5vzv0ZUYlQdQ7g5NcNWDIVNUdZ6USUjtOiooYY5GA==
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr13326083wmj.22.1573817774233;
        Fri, 15 Nov 2019 03:36:14 -0800 (PST)
Received: from debian.office.codethink.co.uk ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 17sm8756962wmg.19.2019.11.15.03.36.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 03:36:13 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 1/2] libtraceevent: fix lib installation
Date:   Fri, 15 Nov 2019 11:36:09 +0000
Message-Id: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/lib/traceevent/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index cbb429f55062..83446fe2cf01 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -97,6 +97,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.11.0

