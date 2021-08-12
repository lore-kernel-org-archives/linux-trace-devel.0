Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2765FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A02261058
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhHLJAK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhHLJAJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF7C061765
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:44 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v4so89793wro.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8vrRxx9h3faZNlq0uYaZVhLYYonBKPDzMYHMZZOpK4E=;
        b=BbSCH9qqnzZD1r5F0oK2cwJRtzRzi4RcihmomTWK9vN1m+hi+LhGxW6+3heWRpAkTd
         gfFij04M2w1m58V1Hg2dIhOq6FVEcIkxgfQPkQ+iZMxy4MALkKdSdtcySTpvVK6B7l6W
         agXimcLN8ljTMx8Zy1ooh9n7RvMZEWTCTrS1rCvsKa1orO78gm03YhoA5KlC+xDB7BrY
         gjCkj2k7iStFCs+DtJuatRD+aubXxz8Lehk31CqX0JolCtiaJPA0nBsnDjk50G+RKsBb
         SVcQI94D+FICslxaZz5EOM5cL6Zw97ZnnzgpWOledeITwLUYJ2ZBOW4hHDoQ9nBWn393
         dYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8vrRxx9h3faZNlq0uYaZVhLYYonBKPDzMYHMZZOpK4E=;
        b=AqwkV5ybREwjNgwKGUJOgrB3k8gNsTc0NP+ouL1XqRUT3kkk1ulRjmLpHV4KCg5CTf
         YXOfAzj+JJP2XtLKaOHFGEONcsaKaE8nMvOaqfG5MDXr8vENSEjq86MCH368aQfUiyAg
         l5vT5GGko2HbdKIoaX3jBoS82rBU1DpsSsIVNaQvIEQ4hr9i9Zr1E9p9mJFIMWEqDhXL
         oLSH0/WQs5UZcrPild67ADl1yexj29hYQMvpNsGL6TNE4LWBCa1ys88bqcjD2iJUiXlh
         Qjx8T1LONcgSnWWsfBgeB0hilqM/x/5Mtmd52xnSMhbWf/peQO8vCM/IDzQQqZAYwzHn
         6NqQ==
X-Gm-Message-State: AOAM530CKCwrh258MZ6lVRMi1DH0I1PDGoGpug9FK964XX4XBy0Z97qy
        QHPx023umhpYiI/hqSX8EKRtvvGacK0=
X-Google-Smtp-Source: ABdhPJw2a1KBdLh+i3JWqWMnNTStRi9FW737yyxIByUz029S+LtjTYC6M2ndN/d4Ppyq0YJyW4+/2A==
X-Received: by 2002:a05:6000:184a:: with SMTP id c10mr2837684wri.26.1628758783230;
        Thu, 12 Aug 2021 01:59:43 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id m10sm936683wro.63.2021.08.12.01.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:59:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 0/5] libtraceevent: Optimize the print of tep fields
Date:   Thu, 12 Aug 2021 11:59:24 +0300
Message-Id: <20210812085929.54832-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Provide new capabilities for printing the content of the individual
fields of the event.

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

Steven Rostedt (1):
  libtraceevent: Have all field args point to the field they represent

Yordan Karadzhov (VMware) (4):
  libtraceevent: Add dynamic_offset()
  libtraceevent: Improve tep_print_field()
  libtraceevent: Optimize tep_print_fields()
  libtraceevent: Add tep_print_selected_fields()

 src/event-parse.c | 298 +++++++++++++++++++++++++++++-----------------
 src/event-parse.h |   3 +
 2 files changed, 195 insertions(+), 106 deletions(-)

-- 
2.30.2

