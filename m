Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE94C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C5920729
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGRAec84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgGOCaP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgGOCaP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDB3C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id o18so548272eje.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGhFbQsBq4n/DKcnLNKGBEQlT7ak3d0/2J6BzAf6pUo=;
        b=ZGRAec84pVbIWbqMRxEiXX/K34r2vJyV9TaK4SQmr4J59C4FwqRFr+PJMOEbOxl9nc
         ogN2BXW/+WhkV6Nb/AAmdN9x/s+X0U2LWYj39LXhzmUGwV0Gk+NIdwX56KQX/0hU6E0K
         pF9nxNjzb6xNimAsoJ71M/wHWlRh2P7odE3GK4CxV5O4Drq+Pc/Fl6aY3BJqr69mmS5k
         iERKAwNRS0Z4Ouwq3kbP/Wpm2zp+PwIo9fzkmWFv/LMKwOSbmPnAZw1O7bxEIQ0kv/sq
         kFheIbUsbiEJ4nBemQq6IiaZ2qGRJmyI/s/pI7qkBXNwgGF6FCQqzVdWsU5Oyjt3NQcC
         Gd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGhFbQsBq4n/DKcnLNKGBEQlT7ak3d0/2J6BzAf6pUo=;
        b=lyIPHENCLVS5Rk2/HkwyKk5bhgb9FEMiU9ytmWjKdy7LqcaRKNkauPLSBKxxqPu/kV
         rR4wTFlhGYZYIg5+k2d8TEL3kPbEYVkijuGgKFArJBRcsvj0QD8iMjN/RngQfgov9060
         JFZvkdRV+bR2cQqe78qfryOHxtVp/HjqV8aHxo7SDjed7/HcfuD2+f6IyD109xshfwuV
         1Mi8bhPHuQkRgCs1tlJOub9O87v0tQ1rWD53U2FkO0obgARk2mVzEdlv2ntOwWljr8wL
         8B9Warn5mmqt5zGdhrodD2/Ua81GNHJN/WvQylVyrg7mQfkOWmaV/3+mco224y6m9tpm
         qoUA==
X-Gm-Message-State: AOAM531RzgIE0dzxrCLgZw/8pvP0Ub/0Lll99szHyPoFm7RlV85zRnyt
        EfLHOIeadRbmFTEwBjIOzCVV4KSAktI=
X-Google-Smtp-Source: ABdhPJy/LcIM+cGl2ya4AluXZoiPcP9gcfX1fDbkYXbUbtAKWOJ7kUohHqn2fBHgkWiMsl5MV9x+YA==
X-Received: by 2002:a17:906:fca4:: with SMTP id qw4mr6786195ejb.362.1594780212833;
        Tue, 14 Jul 2020 19:30:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 0/8]  Few libtraceeevnt fixes, suggested Namhyung Kim
Date:   Wed, 15 Jul 2020 05:30:01 +0300
Message-Id: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>

v2 changes:
 - Added "Link:" pointing to the message with Namhyung's suggestions.
 - Added "traceevent" in the subjects	

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd libtraceevent: Document tep_load_plugins_hook()
  trace-cmd libtraceevent: Handle strdup() error in parse_option_name()
  trace-cmd libtraceevent: Fix typo in tep_plugin_add_option()
    description
  trace-cmd libtraceevent: Improve error handling of
    tep_plugin_add_option() API
  trace-cmd libtraceevent: Fix broken indentation in
    parse_ip4_print_args()
  trace-cmd libtraceevent: Fix type in PRINT_FMT_STING
  trace-cmd libtraceevent: Fix description of tep_add_plugin_path() API
  trace-cmd libtraceevent: Handle possible strdup() error in
    tep_add_plugin_path() API

 lib/traceevent/event-parse-local.h |  2 +-
 lib/traceevent/event-parse.c       | 10 +++---
 lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
 3 files changed, 43 insertions(+), 19 deletions(-)

-- 
2.26.2

