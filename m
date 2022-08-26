Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D37ECAAD7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 14:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbiHZOZT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242852AbiHZOZR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 10:25:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7623C19C3D
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 07:25:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2DE1A1F912;
        Fri, 26 Aug 2022 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661523913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCan0Z4KXxMmCQX15xSA8FLnMoUTHaWgEyQY3K/htqI=;
        b=ODI4ZtNSg6H67Kspx6OVZA/5XGyj9xJ5UiSqh0+rjNgOx5LuhQnMT6GEMwtX7grgJjWPyg
        kJPN48YLvUMMuFrWYwqdINdni69KiSm0lrPfCqSRgoDMWuMZmjLxpNx3No9oHRHakvRD11
        TPum1W5oevGDGuXy9yt8A2+6BN3fhJY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F286913421;
        Fri, 26 Aug 2022 14:25:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2Do1OsjXCGOnQwAAMHmgww
        (envelope-from <alexandre.vicenzi@suse.com>); Fri, 26 Aug 2022 14:25:12 +0000
From:   Alexandre Vicenzi <alexandre.vicenzi@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Subject: [PATCH 3/3] libtracefs: Add test instructions for openSUSE
Date:   Fri, 26 Aug 2022 16:24:20 +0200
Message-Id: <20220826142420.29911-3-alexandre.vicenzi@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
References: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add CUnit setup instructions for openSUSE and SLE.
---
 utest/README | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utest/README b/utest/README
index ed92042..647e460 100644
--- a/utest/README
+++ b/utest/README
@@ -13,3 +13,6 @@ using a precompiled distro package:
 	libcunit1
 	libcunit1-doc
 	libcunit1-dev
+
+ openSUSE and SLE:
+	cunit-devel
-- 
2.34.1

