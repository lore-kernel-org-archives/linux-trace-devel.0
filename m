Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2417C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE9342223D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rP2ZJLqc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgFVHp7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgFVHp7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 03:45:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1256C061794
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:45:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w6so5669746ejq.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++QbfxU2LlPRUYLzlUM132/+eYc9/XLsvgJW/0uZYpI=;
        b=rP2ZJLqc8AQo3ZokzsMAaoFeZKSke1srDTSL4NyXoj2rLg7zsIsnWndt8NG0hoR5PQ
         ZyGtugnxjrhpADCuJ0L4nUiGdUf0+rsFLqNAvEIBQiXgWJZn5x9FFNn/e2hIYgdHHXx9
         8OFejiMRU/8aZcgzhQeMYHke94nFRCO3+t7CYfxcVC9pdtdFKxSWuqndMip6vddnquU8
         fVAg2L2WxAIRU6K41po7hhzsyejuoRnvCJ2b5Bx6TFgQaSEqoOq1rhs5VUfSDjKnpc7f
         5taboZcGgDOHr4YleTe8pJg1Z9mQTPmWz6oiY52TegWPwPcTeC2UfDe+G11ADrOW3jYp
         n8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++QbfxU2LlPRUYLzlUM132/+eYc9/XLsvgJW/0uZYpI=;
        b=JYbJx+JKho5SIuVpsJPuqYSOH2/r6HsRpeeOTe3tFV+SVqhp/W9tpwz2a2ca2rv2wH
         fJpS6gfLqZhawSbHPOVZtzjx49RaVKjNRUoIiKjhY5AO2Bib9y6t/LFsQ8cZmRQ9gFOf
         nkoXaibc3ZzJ5udvTswr959HQz+A67Tpag7QDPISmYS2jgqvjNBzJpa76nCoBQAVUkW9
         N4ih5B+D4MFmyLEOYPnfQerDQ8+RIX/iiUyU6WN8iIZFWp3XnisY1kXm/70JMQIu2fxE
         k/oJJVAypSLbTn2bNFq4OINDa65UNsa4wZMc2hLhj9rz1jnachzEnTjiy2yjmGVdzcKl
         KLgA==
X-Gm-Message-State: AOAM531bzjyXm6fe4wbHxbOgzbJxKhTQ6Pg8eXWjwdfXo7rXrLdtN9E7
        CydR2f5ZomZjupYnOxYFIO1xbmSM
X-Google-Smtp-Source: ABdhPJyk76Hx67tLMtdsKfystt/Tc/uc7sJ9RKBL8Fh6yKciqkM3yLbaZNL0PCD/iTAsIGn/8hXDBA==
X-Received: by 2002:a17:906:d791:: with SMTP id pj17mr14545160ejb.352.1592811957553;
        Mon, 22 Jun 2020 00:45:57 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.148])
        by smtp.gmail.com with ESMTPSA id k23sm11094048ejo.120.2020.06.22.00.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:45:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Synchronize libtraceevent with kernel tree
Date:   Mon, 22 Jun 2020 10:45:50 +0300
Message-Id: <20200622074554.151747-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Backported few traceevent library patches from kernel's tools/lib/traceevent

He Zhe (1):
  trace-cmd: traceevent: Take care of return value of asprintf

Hewenliang (1):
  trace-cmd traceevent: Fix memory leakage in filter_event

Paolo Bonzini (1):
  trace-cmd traceevent: update KVM plugin

Zou Wei (1):
  trace-cmd libtraceevent: Remove unneeded semicolon

 lib/traceevent/kbuffer-parse.c      |  2 +-
 lib/traceevent/parse-filter.c       | 33 +++++++++++++++++++----------
 lib/traceevent/plugins/plugin_kvm.c | 25 +++++++++++++++-------
 3 files changed, 40 insertions(+), 20 deletions(-)

-- 
2.26.2

