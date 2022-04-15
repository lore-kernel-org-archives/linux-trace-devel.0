Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112F6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 13:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354056AbiDONkX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354070AbiDONkH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 09:40:07 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03066BD2DD
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 06:36:47 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-cTdwVJA1NMWEawwEVmXr8A-1; Fri, 15 Apr 2022 09:36:39 -0400
X-MC-Unique: cTdwVJA1NMWEawwEVmXr8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70A27185A794;
        Fri, 15 Apr 2022 13:36:39 +0000 (UTC)
Received: from f34.bristot.me (unknown [10.22.8.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5F669E78;
        Fri, 15 Apr 2022 13:36:38 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, lkml@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 0/3] rtla: v5.18-rc2 Fixes
Date:   Fri, 15 Apr 2022 15:36:27 +0200
Message-Id: <cover.1650029027.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven,

Here are some fixes for rtla.

I do not include "rtla/Makefile: Properly handle dependencies"
because I will make two changes to it:
        -  I need to check rst2man only in the make install phase
        -  I will remove procps-devel dependency on another patch

I will send a v2 of the "Properly handle dependencies" and the removal
of procps-devel dependencies next week. But these ones are already ready.

John Kacur (2):
  rtla: Don't overwrite existing directory mode
  rtla: Minor grammar fix for rtla README

Wan Jiabing (1):
  rtla: Avoid record NULL pointer dereference

 tools/tracing/rtla/Makefile            |  3 ++-
 tools/tracing/rtla/README.txt          | 12 +++++-------
 tools/tracing/rtla/src/osnoise_hist.c  |  5 +++--
 tools/tracing/rtla/src/osnoise_top.c   |  9 +++++----
 tools/tracing/rtla/src/timerlat_hist.c | 11 ++++++-----
 tools/tracing/rtla/src/timerlat_top.c  | 11 ++++++-----
 6 files changed, 27 insertions(+), 24 deletions(-)

-- 
2.35.1

