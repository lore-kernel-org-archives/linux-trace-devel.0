Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9580FC10F0C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FAAF208E4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfCHNhC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36519 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfCHNhB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id o17so21410370wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHn3UWNZM7i1w8ucxIPLnxbQZGyZGc0g5+b1bKqN2XE=;
        b=DeGMgFzlPLQo875jMbABvAi1WGVlWe8ZyfXYC63rFHQt50c/gaSB5YMZ2GDRb9QKUU
         uPOrg5DDldjRquo6YZTxLtVny2pX0zAmangdS/he/tuSYOHCvLSiWkPFZdxx6lwC9gwZ
         kmFV94bn2iiemYi7aigBzlsjZH3fb8TUFjVn74gtm5ZT3+5J10V2gmddhLvaJnrUyjK4
         uK+DnBQMxbhnGrAzTFIkraHsmou/RifL5lBfWIcxKbbiROoGOEqlI5wcL3+RCKusjWpK
         owjs/QTviLvSiSmCpQ/U31msa3oQorRM6+U2oTciF5YwQ/fVfUXrF2ulxeoT3Acv4xsc
         40Rg==
X-Gm-Message-State: APjAAAXYQ3D/JZ6RzQQw1h0A8bq0/hOKlRsXbMwDMohQw2x0ehkTbQog
        VM6YW/J4fQEJsY2Or84NUrqEJTxU
X-Google-Smtp-Source: APXvYqxdD+aF/+mU+H5LtkxyxFrMY7kTc+0136zg06dx0O1AZRgK6rA8OoPpkYBP6LkiQ1GeIbjVWA==
X-Received: by 2002:adf:afe3:: with SMTP id y35mr10838839wrd.318.1552052220103;
        Fri, 08 Mar 2019 05:37:00 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.36.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:36:59 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/46] tools/lib/traceevent: Add support for man pages with multiple names
Date:   Fri,  8 Mar 2019 15:36:11 +0200
Message-Id: <20190308133654.21264-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch adds support for man pages with multiple names,
used to combine the description of several APIs into one page.

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

