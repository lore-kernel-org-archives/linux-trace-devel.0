Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D89C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE1E2465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhQFegha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgAVPAI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:08 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33677 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPAH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:07 -0500
Received: by mail-lf1-f46.google.com with SMTP id n25so5594004lfl.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SE3DfvKO49A7Z6WCJJoDt70nEryyw/EhvqeA7MqhkA=;
        b=DhQFeghaTyvUctAXZq1l7SLjojbf2/YMlBzIyuoUU38JU6Rvj5wASNE7RUNxLElz3C
         kyxLZLgRaf0RnSdZ7q7QHpE9r7ikPZmAgqF+r1YNyxjFsfyAsCUbp7HKCQnOADKLch9n
         my5mCRRLQynDM7NvOY5W0+A12e3wYyBSumYPU+UyG+dA1NiCI+ydu+gRpvsOok+TRLlo
         6zW6K4KQtl2MVqOcDdKTfJsN8u92KOOD+925xA8lEpZ6MLvoIv9QVa+7AwOSqbk50sdF
         3kxDx68w1rUhLPqQQ2Hb7K88BnTmva1xPa8oAHVviI8FjN+yJUM/TYwAUU3eFcRHQb7T
         WSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SE3DfvKO49A7Z6WCJJoDt70nEryyw/EhvqeA7MqhkA=;
        b=ZbbwrMRdXS+ALPp9XuGv1TfxEJEIFgcug11fPSkybkZljs+FurPdynkODnzlq2fXWT
         r3FaONnyDdpaxYQVFKNMnteLjnyB0rf+mF3Iap1kVUixa7F5ARdqTeoQacxH2en4c5N4
         tutUUN7vBb+FvolZIBPBdLlfLGLimJDTHtBxkiLzpTqfTlEfSPnUpYcApkxpNlAllBBh
         sfh3dA/fvEDStLjk1eJLYGCDKEx/1zQytn84X79VLaes6v+BAjyy1P1eyS+bUUyFzfBY
         0/Kga74bT3fnZ3kRuIrPsmEwku6k196gyfkrEQxxHWpCj94EUb5IM3gUtFMtWOnDg70x
         h2JQ==
X-Gm-Message-State: APjAAAVzk0NrOLwO0hjX4O2fRQAs3vVUAkjHZ7ILj2/H9HpqcGuCNJtE
        aeRdiozuIjCrADDDW99OrLtWdoFg
X-Google-Smtp-Source: APXvYqxzQJ3SHrJGrDisVCTfqjS/DBGx22XodwmPIjzSvTg8nKQTvnPqedHY3oIiJHpFO2pJX28cJw==
X-Received: by 2002:a19:844:: with SMTP id 65mr2070840lfi.20.1579705205673;
        Wed, 22 Jan 2020 07:00:05 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/7] trace-cmd,libtraceevent: Rework of plugin options APIs
Date:   Wed, 22 Jan 2020 16:59:55 +0200
Message-Id: <20200122150002.763233-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to simplify libtracevents APIs, logic related to plugins and
plugin options is reworked:
 - Complex and not used APIs are removed.
 - Logic for printing various information for plugins and plugin options
   is moved from the library to the application.
 - Additional checks are added when loading new plugins and options, to
   avoid duplications.

Tzvetomir Stoyanov (VMware) (7):
  trace-cmd,libtraceevent: Plugin options rework
  trace-cmd,libtraceevent: Remove TEP_PLUGIN_OPTIONS
  trace-cmd,libtraceevent: Check for plugin options duplication
  trace-cmd,libtraceevent: Check for plugin duplication
  trace-cmd,libtraceevent: Remove API for plugin options print
  trace-cmd,libtraceevent: Remove API for plugin print
  trace-cmd, kernelshark, libtraceevent: Changed tep_plugin_add_option()
    API

 include/traceevent/event-parse.h         |  50 +---
 kernel-shark/src/libkshark.c             |   4 +-
 lib/trace-cmd/trace-ftrace.c             |   4 +-
 lib/trace-cmd/trace-plugin.c             |   5 -
 lib/traceevent/event-plugin.c            | 279 ++++++++++-------------
 lib/traceevent/plugins/plugin_function.c |   6 +-
 tracecmd/trace-list.c                    |  55 ++++-
 tracecmd/trace-read.c                    |   2 +-
 8 files changed, 188 insertions(+), 217 deletions(-)

-- 
2.24.1

