Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26665C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Sep 2022 11:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiI3LWB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiI3LVV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 07:21:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8700C8672A
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 04:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664536207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=vulTo1zsrAgFxXc6gzYdYR/FNkWtEtyUBTvTpzVBCXg=;
        b=CtX0/57GTrHirVJA+aXPPZXnFrjVuEeBin8aRFPqc8/P43Sqno4x1+H9cGGJhxOM6IqH5B
        RB4oatCbjE5jLVuywZ0wR3HX42Dpgqm+NEfe6dHdJYrsW+65+HMzoHRcGTzQyguFIfYkvI
        mF/Ns7iwFoE91FdpAQkGKFXSTVJawCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-x67LUcYKPme0OXCdgNlq-w-1; Fri, 30 Sep 2022 07:10:06 -0400
X-MC-Unique: x67LUcYKPme0OXCdgNlq-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF533101245F;
        Fri, 30 Sep 2022 11:10:05 +0000 (UTC)
Received: from Diego.redhat.com (unknown [10.39.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA151C15BA4;
        Fri, 30 Sep 2022 11:10:04 +0000 (UTC)
From:   Michael Petlan <mpetlan@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH 0/3] Fix several Coverity andf Clang warnings in libtraceevent
Date:   Fri, 30 Sep 2022 13:09:59 +0200
Message-Id: <20220930111002.6107-1-mpetlan@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello.

When rebasing to libtraceevent-1.5.3 in RHEL, Coverity has found some
issues. I have tried to fix them. Could you please have a look at the
patches attached?

Thank you.

Michael

Michael Petlan (3):
  libtraceevent: Fix uninitialized has_0x compiler warning
  libtraceevent: Fix check-after-deref coverity flaw
  libtraceevent: Fix Branch condition garbage value compiler warning

 src/event-parse.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
2.18.4

