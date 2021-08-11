Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB60EC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C6F60041
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhHKMMj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbhHKMMj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 08:12:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA00C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:15 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r7so2814149wrs.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTvbBgQsBTsE8EWtqkZJL+CkV6+AbhMSRr151fNPA1I=;
        b=arH0KDS52g5q9QXI2dCGRJNnfUs0sjg7z9A0uONNexN+PEz1nP42VJ+R0Prn4u91Xa
         9AX5A6Mhb6wVEVLLB7sSParTj+DXNI+aguXLcqN3qfZffdRBaQzRrRXIij2N8v0bKwfd
         tVEilgTfwU1YGgycse1KwsB+fhQMzHT6Uu/pJPOvp9SNjbFALGlzuH5vAzD/b73X4bai
         xZWfy5NLm/0PAoe2BHfiuV6UvRgaCb1xe2bt6zR7RoVUV6PNLRTBxAQa6F03aqaRvhmC
         lMqYIz2Akg30XQPuB57KJOAhHaP+Idc0RV0qcjisXZTCmuVs7lcUU4CblIn1zmABfIxS
         2VFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTvbBgQsBTsE8EWtqkZJL+CkV6+AbhMSRr151fNPA1I=;
        b=mKrHbN/MzpJxXNf4Rz2AQZ0Em267/IQIFnvxvGaqNFW/zJ52GhQRIVS8uFCIfL7Whl
         AF8vfRp8r0vt7pXtBrq2KixZKg9QY98yfmwBAF0Y4it+tuxQG1YLyMgO4bnmoZfLhJtV
         HhxE8EDq6iMdaSlFoH+zeiELD+jJbWORhdVBqfaibfSEphSXh/jqIi/Kya3a27fGhGyo
         2EkDdOZx6XZncN1/AXwOqPqOQmPnynS30ibl/IWQczrnpIEsuML1onyby7xhn1GzeoAT
         srs8A4yn1ilvfbpVR1JRtF06cpMlQKXnYmp0w+zBZ1VwhGEuLq98eTOw4hljQlToGbiC
         mRVg==
X-Gm-Message-State: AOAM531tt9Inl4NiMDMnmhgKKM6oo6adkrKt+srtuxBSDbnwY0zBsF/D
        Q1fxWGF2whqNBSg7UmiuXfA=
X-Google-Smtp-Source: ABdhPJxDRry6CpDMm2Sx2GPtwqwFs/6v1srq+Vg2fXfJBzY/lbMsRaIkmDaXARrIAWMIUbggNMiRDw==
X-Received: by 2002:a5d:4d0d:: with SMTP id z13mr35708364wrt.34.1628683934266;
        Wed, 11 Aug 2021 05:12:14 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id k1sm27104011wrz.61.2021.08.11.05.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:12:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 0/5] libtraceevent: Optimize the print of tep fields
Date:   Wed, 11 Aug 2021 15:11:58 +0300
Message-Id: <20210811121203.29123-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Provide new capabilities for printing the content of the individual
fields of the event.

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

Steven Rostedt (1):
  libtraceevent: Have all field args point to the field they represent

Yordan Karadzhov (VMware) (4):
  libtraceevent: Add dynamic_offset()
  libtraceevent: Improve tep_print_field()
  libtraceevent: Optimize tep_print_fields()
  libtraceevent: Add tep_print_selected_fields()

 src/event-parse.c | 297 +++++++++++++++++++++++++++++-----------------
 src/event-parse.h |   3 +
 2 files changed, 194 insertions(+), 106 deletions(-)

-- 
2.30.2

