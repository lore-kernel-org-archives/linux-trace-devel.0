Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0ECC46460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D1E206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfECJLZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39253 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id n25so5799739wmk.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ajjyB1oXnzRIg9g9v5mJwY6aetnydGPN6FUpkexlbTo=;
        b=f+DE+bmTUWx2CkBgw+nbf39xDTVmB28sKH1feCErGSMG9oRRx90Jq24Dx/+Z2OFOKD
         2dhkF/kbOEV31fUUJSVL2rEsd4qcP5t5irYF2Nys13CfCYqbrR+aGlXmaOwL+N18F0Bx
         /0D3cDyOv0fx6z1hp72yPzb9LckXanJAigIzmukSayaBicR5h97cr26MuV3dnbgKXMZM
         tjirKJPVEP7UrN3kbcYuYmtczthMwawr3gpgUDyVTb4E90Av3xRsSGvkekKjJ67tdx/4
         dWC/DjxkYTtOSCZ/fskB+IIWbCfUeP0gnXR/3Cvs2NK0+eoQzq9XL+IRhp6/fXA6mRTB
         NjKw==
X-Gm-Message-State: APjAAAVLIDvJ758zud6mMQwfmeOsaTwv/D+hpQDa498Sel9DhV1uBowb
        xPuBMGw6RDKsbsJzr2ssqz6zXslz
X-Google-Smtp-Source: APXvYqyn9qmQVKlxCt7JbaxJMmU9Dqq+h4ETKZcm7wwORQZcQSY97MOIC4SnBmHBWDibdfxqBnrn2w==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr5567910wmk.151.1556874683208;
        Fri, 03 May 2019 02:11:23 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:22 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 02/26] tools/lib/traceevent: Add support for man pages with multiple names
Date:   Fri,  3 May 2019 12:10:55 +0300
Message-Id: <20190503091119.23399-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added support for man pages with multiple names, used to combine
the description of several APIs into one page.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../traceevent/Documentation/asciidoc.conf    | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/traceevent/Documentation/asciidoc.conf
index 1b03c63fb73a..07595717f06e 100644
--- a/tools/lib/traceevent/Documentation/asciidoc.conf
+++ b/tools/lib/traceevent/Documentation/asciidoc.conf
@@ -74,12 +74,41 @@ template::[header-declarations]
 <refmeta>
 <refentrytitle>{mantitle}</refentrytitle>
 <manvolnum>{manvolnum}</manvolnum>
-<refmiscinfo class="source">trace-cmd</refmiscinfo>
+<refmiscinfo class="source">libtraceevent</refmiscinfo>
 <refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
-<refmiscinfo class="manual">trace-cmd Manual</refmiscinfo>
+<refmiscinfo class="manual">libtraceevent Manual</refmiscinfo>
 </refmeta>
 <refnamediv>
-  <refname>{manname}</refname>
+  <refname>{manname1}</refname>
+  <refname>{manname2}</refname>
+  <refname>{manname3}</refname>
+  <refname>{manname4}</refname>
+  <refname>{manname5}</refname>
+  <refname>{manname6}</refname>
+  <refname>{manname7}</refname>
+  <refname>{manname8}</refname>
+  <refname>{manname9}</refname>
+  <refname>{manname10}</refname>
+  <refname>{manname11}</refname>
+  <refname>{manname12}</refname>
+  <refname>{manname13}</refname>
+  <refname>{manname14}</refname>
+  <refname>{manname15}</refname>
+  <refname>{manname16}</refname>
+  <refname>{manname17}</refname>
+  <refname>{manname18}</refname>
+  <refname>{manname19}</refname>
+  <refname>{manname20}</refname>
+  <refname>{manname21}</refname>
+  <refname>{manname22}</refname>
+  <refname>{manname23}</refname>
+  <refname>{manname24}</refname>
+  <refname>{manname25}</refname>
+  <refname>{manname26}</refname>
+  <refname>{manname27}</refname>
+  <refname>{manname28}</refname>
+  <refname>{manname29}</refname>
+  <refname>{manname30}</refname>
   <refpurpose>{manpurpose}</refpurpose>
 </refnamediv>
 endif::backend-docbook[]
-- 
2.20.1

