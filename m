Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD52C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C1D61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhKKSGN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 13:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234079AbhKKSGM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 13:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636653802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G6AKYEhepMhBQQ1lWSNSIn11Kka4LHGPhUcAoqxwYCM=;
        b=iSLsJEVHx/NLCleFEbpc7iYALnwWm/UyZ0Zn8W1EYay1FyOg0cdmmJhwdWJzGIU7EOkbBf
        FBs2VXSZvSvgl0hkoF0stwFS5RUHQADK1/U/iPjR682m8JwGiIMDZehUNcnQ2ZbPsJjbuq
        fMUgdMNLuhgYQpvK1AyWjoY8tPo/q8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-2GzjtRLoOVK6MOcMS-kxjA-1; Thu, 11 Nov 2021 13:03:21 -0500
X-MC-Unique: 2GzjtRLoOVK6MOcMS-kxjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF50B871254
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 18:03:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.43.17.220])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5A0A419729
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 18:03:19 +0000 (UTC)
Received: by localhost.localdomain (sSMTP sendmail emulation); Thu, 11 Nov 2021 19:03:18 +0100
From:   "Jerome Marchand" <jmarchan@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracecmd: don't ignore LDFLAGS when linking the shared libs
Date:   Thu, 11 Nov 2021 19:03:18 +0100
Message-Id: <20211111180318.499099-1-jmarchan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

do_compile_shared_library should't ignore LDFLAGS. That makes it
difficult for packager to follow their distribution packaging
guidelines.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 6865a746..53b2b074 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -72,7 +72,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LIBS))
+	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-- 
2.31.1

