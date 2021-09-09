Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B325C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A15261132
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 08:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhIIIIC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 04:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhIIIIA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 04:08:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34135C061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 01:06:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g8so1474596edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Sep 2021 01:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RANdumVnqkKxoHA2Z5Fo3kbiL3lBJyIRX15PR4H+QA=;
        b=LiHYB//H3q1QaJzknoSW0NqW/v1c5obAsxSjxPqJA9nH/hpzJP6jc+bq3fp5sDxSA0
         4dlTYGAwJvLjbdcPGi93b9gLzSpHmuqQxlWZI/PhZMmVMJHvQGiCUJl7+EDLGWup1Yhw
         46CPYMXx6XvC4dguz8K9mnRMvr5uFVyz2E3aSxK+uTFvZ2ctbXWAR9oezs9Rp7IEyu94
         wOajdM2/RLaN0D8evQLm88fBJe2hhKGO20bid2diOYWje6EhUFgfJO9qxqemvlSHL+OR
         xq2ikYHJMqVQoRcQzbc/1gpLwhvrD+Kk8OOANbXcAiJutT16m+b0cxYPvhNX99IPmpbW
         SGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RANdumVnqkKxoHA2Z5Fo3kbiL3lBJyIRX15PR4H+QA=;
        b=Q+7eHm9SLiEaKuWDaFrlOBPuuvXMz0TTr1v85dotEYPHQaiYmO0xuA5sJ2kIVrl0G+
         ZvBxwekMxouWmP/JXSk8+ok46IjEbCdNEwKBjbgxXFxpcHeK/KkQwcFuH7m/j38B0+1v
         bUu1sBS/ahjnBGyZBwKaah9OgN4LkDQdw9sGXiNUK8ri0+3AVmxIXtgIFsEbPuJvZ17H
         QfaJq2or+0v7yDQVNfVfTesJbBkSW+N0FFo2S7j6tzczmdWCix+SodQy8QUVbiBfy4Yt
         Mk2KY+2RpqWAeO9nhoseEabE+s4nTkyYHNOMpzRPoLrDtIL2DMY64M3YmzaCrRdA+54g
         9yFA==
X-Gm-Message-State: AOAM531+8SUq52NvUmdPgqULVnybdkNV6XV/qeWKC+IL+GChuTDhGxUx
        9j5CNkYJyti5ekc4cbdRcm0=
X-Google-Smtp-Source: ABdhPJzztMBFdjhLNUEh+WXpnFEJQzd49JwpDtDObJa/LfVqEQ50KUlaIfLGbH0biJiH9ETcPNTIng==
X-Received: by 2002:a50:c949:: with SMTP id p9mr1943868edh.326.1631174809849;
        Thu, 09 Sep 2021 01:06:49 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id l8sm491821ejn.103.2021.09.09.01.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 01:06:49 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 0/2] libtraceevent: Optimize the print of tep fields
Date:   Thu,  9 Sep 2021 11:06:36 +0300
Message-Id: <20210909080638.259024-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Provide new capabilities for printing the content of the individual
fields of the event.

Changes in v8:
 - In tep_record_print_selected_fields(), changing the argument
 'ignore_mask' to 'select_maks'.
 - Fixes in the documentation of the new APIs.

Changes in v7:
 - Proper naming (without 'tep' prefix) of the static methods defined
 in the patches.
 - Fixing the 'for' loop in print_selected_fields()
 - 'tep_print_selected_fields()' was renamed to 
 'tep_record_print_selected_fields()'. 'tep_record_print_fields()' was
 added.
 - Adding documentation for the new APIs.

Changes in v6:
 - Cleanup in [PATCH 1/5].
 - Protection against infinite loop in _tep_print_field()
 ([PATCH 4/5]).

Changes in v5:
 - The loop over the tokens in _tep_print_field() is made circular
 in order to support the corner case when the fields and the tokens
 are listed in different order.
 - _tep_print_field() and print_selected_fields() are made "inline"
 in order to help the compiler to optimize out the unused variables
 (suggested by Steven).

Changes in v4:
 - Directly applying the modification in tep_print_field() suggested
 by Steven.
 - Optimizing the loop over the tokens in tep_print_fields().

Yordan Karadzhov (VMware) (2):
  libtraceevent: Add APIs for printing the fields of a record
  libtraceevent: Add documentation for the new printing APIs

 Documentation/libtraceevent-field_print.txt | 11 ++++-
 Documentation/libtraceevent.txt             |  2 +
 src/event-parse.c                           | 51 +++++++++++++++++++--
 src/event-parse.h                           |  7 +++
 4 files changed, 66 insertions(+), 5 deletions(-)

-- 
2.30.2

