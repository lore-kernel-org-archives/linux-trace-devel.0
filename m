Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27711C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029C660F94
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhHJM1e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhHJM1d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26AC0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i6so29983552edu.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uP5rl5BPMZkmWjoJ5fyZyFCxz7CMxOlvpH0xh3VZKgU=;
        b=LX6JOeJwOMYBqMzIl9xtNuXLeQYYAdtHFFS27QtwSZbHgCtu7YdP/0szxE4Xj8mr2s
         NBSIzpqcBX3wvCq1Q4h1ugDrWG3W9LlBzmZ3QpTxGcEE5qciFS2YKynNgT88F6ufP2yQ
         9HjsolMLXuQGMXjkQU7SsmW9AJPgzR/FU8xKRnew4Zhg7QLRyDndQ6Od94vP6SRFdw0Z
         bPf8DGfr+If8rqvFDta080mM7S4xvGlu4AW/Sa0WITNR1+8KldGLK5b91HCcgF2HZlij
         Ajtt4sG9nACTew0bmmBTNra3m6WBiyuxFUKncHEkK3mfPOiDqKJO1pR1mjyIaIpPsJVY
         Qqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uP5rl5BPMZkmWjoJ5fyZyFCxz7CMxOlvpH0xh3VZKgU=;
        b=h83kao609cDCOlUpI2F/RFINxWMLeMRkMVfNUJwmqqSSxe3R9jE5oTqftskczzaoHS
         DwJAztc+tuo4jsSlIyh8EGKOn1vYYgURiiXVZ2E/IaYDywtPxdFF6r5yA2OlBh0+E9nS
         BzbE+kCFdS4I/jJZbY0T62yJM/tXJnedzs+Kq2czu2JuEGJHQnGtTEgvBMVddgiSQ7TS
         Q8mDQJrMgc1CbezJWlewg7FE4/UQxbCgDcjrAvb7fW+IRT6HsXHxZgSxfa3yB+t19EeW
         61vg+nETqCMxdoHF73yhHL392F3EwkoPoxcuM4/a31avudGqqzWvGCiPurBXi/uVa2PV
         NIew==
X-Gm-Message-State: AOAM533uimhqMfBkgsgGuxHQpynVDPQJxVBu0saBVTaXcFH4ZQ1ORgTN
        3MTSyChRMW3bIj+MrYiZDdHmq0nbAq8=
X-Google-Smtp-Source: ABdhPJyp578W/8q64AuhFW9sWdD4+kIPGNFZpA8hADdNMqd91gkk+RmuZ3QDX5jOyAXwEvTpz3/+bw==
X-Received: by 2002:a05:6402:184b:: with SMTP id v11mr4629450edy.267.1628598430558;
        Tue, 10 Aug 2021 05:27:10 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 0/5] libtraceevent: Optimize the print of tep fields
Date:   Tue, 10 Aug 2021 15:26:54 +0300
Message-Id: <20210810122659.145759-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Provide new capabilities for printing the content of the individual
fields of the event.

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

 src/event-parse.c | 288 +++++++++++++++++++++++++++++-----------------
 src/event-parse.h |   3 +
 2 files changed, 185 insertions(+), 106 deletions(-)

-- 
2.30.2

